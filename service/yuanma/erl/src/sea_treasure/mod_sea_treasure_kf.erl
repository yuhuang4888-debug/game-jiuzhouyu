%%-----------------------------------------------------------------------------
%% @Module  :       mod_sea_treasure_kf
%% @Author  :       xlh
%% @Email   :
%% @Created :       2020-06-28
%% @Description:    璀璨之海（挖矿）跨服数据管理进程
%%-----------------------------------------------------------------------------
-module(mod_sea_treasure_kf).

-behaviour(gen_server).

-include("common.hrl").
-include("def_fun.hrl").
-include("sea_treasure.hrl").
-include("predefine.hrl").
-include("errcode.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3]).

-export([
        init_after/3                    %% 分区管理进程获取所有服数据
        ,center_connected/2             %% 连接上跨服中心/合服处理
        ,zone_change/3                  %% 分区改变/划分分区
        ,local_init/2                   %% 本地进程连接跨服中心
        ,four_clock/0                   %% 4点划分对战分配
        ,midnight_update_info/2         %% 0点接收分区数据
        ,get_data_from_local/3          %% 本地数据接收
        ,get_other_server_data/2        %% 请求其他服数据
        ,do_after_battle/5              %% 战斗结果处理
        ,do_after_terminate/4           %% 战场进程关闭
        ,delete_helper_pid/2            %% 删除协助者战场pid
        ,start_battle_filed/7           %% 开启战场
        ,midnight_do/0                  %% 0点修复创建机器人定时器
        ,gm_create_robot/0              %% 秘籍创建机器人
        ,get_log_data_from_local/1      %% 掠夺记录相关数据获取
        ,get_log_data_from_local/2      %% 掠夺记录相关数据获取
        ,get_role_info_from_local/3     %% 玩家数据更新
        ,server_info_chage/2            %% 服相关数据秘籍更改
        ,rob_shipping_kf/6              %% 跨服掠夺
        ,calc_average/1                 %% 计算平均世界等级
        ,node_down/1                    %% 服务器关闭
        ,get_clear_data_from_local/2    %% 同步要清理的数据
    ]).

-export([cast_center/1, call_center/1, call_mgr/1, cast_mgr/1]).

%%=========================================================================
%% 接口函数
%%=========================================================================
%%本地->跨服中心
cast_center(Msg)->
    mod_clusters_node:apply_cast(?MODULE, cast_mgr, Msg).
call_center(Msg)->
    mod_clusters_node:apply_call(?MODULE, call_mgr, Msg).

local_init(ServerId, MergeSerIds) ->
    cast_center([{'local_init', ServerId, MergeSerIds}]).

get_data_from_local(ServerId, SendList, EnemyList) ->
    cast_center([{'get_data_from_local', ServerId, SendList, EnemyList}]).

get_log_data_from_local(LogdataList) ->
    cast_center([{'get_log_data_from_local', LogdataList}]).

get_log_data_from_local(RoberSerId, SendList) ->
    cast_center([{'get_log_data_from_local', RoberSerId, SendList}]).

get_clear_data_from_local(RoberSerId, SendList) ->
    cast_center([{'get_clear_data_from_local', RoberSerId, SendList}]).

get_role_info_from_local(FromServer, RoberSerId, SendList) ->
    cast_center([{'get_role_info_from_local', FromServer, RoberSerId, SendList}]).

get_other_server_data(ServerId, EnemyList) ->
    cast_center([{'get_other_server_data', ServerId, EnemyList}]).

do_after_battle(Arg, EnemySerId, SerId, RoleId, BeHelperId) ->
    cast_center([{'do_after_battle', Arg, EnemySerId, SerId, RoleId, BeHelperId}]).

do_after_terminate(FakeSerId, AutoId, RoleId, RName) ->
    cast_center([{'do_after_terminate', FakeSerId, AutoId, RoleId, RName}]).

delete_helper_pid(BeHelperId, HelperId) ->
    cast_center([{'delete_helper_pid', BeHelperId, HelperId}]).

start_battle_filed(BatType, BeHelperId, RoberSerId, HelperSerId, HelperId, StartArgs, ProtocolArg) ->
    cast_center([{'start_battle_filed', BatType, BeHelperId, RoberSerId, HelperSerId, HelperId, StartArgs, ProtocolArg}]).

gm_create_robot() ->
    cast_center([{'gm_create_robot'}]).

rob_shipping_kf(NewShip, SendBatList, BatType, ServerId, RoleId, Arg) ->
    cast_center([{'rob_shipping_kf', NewShip, SendBatList, BatType, ServerId, RoleId, Arg}]).

%%跨服中心分发到管理进程
call_mgr(Msg) ->
    gen_server:call(?MODULE, Msg).
cast_mgr(Msg) ->
    gen_server:cast(?MODULE, Msg).

init_after(ServerInfo, Z2SMap, _A) ->
    gen_server:cast(?MODULE, {'init_after', ServerInfo, Z2SMap, _A}).

center_connected(ServerId, MergeSerIds) ->
    gen_server:cast(?MODULE, {'center_connected', ServerId, MergeSerIds}).

zone_change(_ServerId, 0, _NewZone) -> skip;
zone_change(ServerId, OldZone, NewZone) ->
    gen_server:cast(?MODULE, {'zone_change', ServerId, OldZone, NewZone}).

midnight_do() ->
    gen_server:cast(?MODULE, {'midnight_do'}).

four_clock() ->
    gen_server:cast(?MODULE, {'four_clock'}).

midnight_update_info(ServerInfo, Z2SMap) ->
    gen_server:cast(?MODULE, {'midnight_update_info', ServerInfo, Z2SMap}).

server_info_chage(ServerId, Args) ->
    gen_server:cast(?MODULE, {'server_info_chage', ServerId, Args}).

node_down(SerIdList) ->
    gen_server:cast(?MODULE, {'node_down', SerIdList}).
%%=========================================================================
%% 回调函数
%%=========================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    mod_zone_mgr:common_get_info(?MODULE, init_after, []),
    State = do_init(),
    {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {reply, Resoult, NewState} ->
            {reply, Resoult, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Request, Res]]),
            {reply, ok, State}
    end.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Msg, Res]]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Res ->
            ?ERR("Error:~p~n", [[Info, Res]]),
            {noreply, State}
    end.

% hand_dict(Msg) when is_tuple(Msg) ->
%     Key = element(1, Msg),
%     case get(Key) of
%         Num when is_integer(Num) ->
%             put(Key, Num+1);
%         _ ->
%             put(Key, 1)
%     end;
% hand_dict(_) -> skip.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_init() -> #sea_treasure_kf{}.

do_handle_cast({'midnight_update_info', ServerInfo, Z2SMap}, State) ->
    NewState = State#sea_treasure_kf{
        zone_map = Z2SMap,
        server_info = ServerInfo
    },
    {noreply, NewState};

do_handle_cast({'server_info_chage', ServerId, Args}, State) ->
    #sea_treasure_kf{
        server_info = ServerInfo
    } = State,
    Fun = fun({Key, Value}, Acc) ->
        if
            Key == world_lv ->
                case lists:keyfind(ServerId, 1, Acc) of
                    {ServerId, Optime, _, ServerNum, ServerName} ->
                        lists:keystore(ServerId, 1, Acc, {ServerId, Optime, Value, ServerNum, ServerName});
                    _ ->
                        Acc
                end;
            Key == open_time ->
                case lists:keyfind(ServerId, 1, Acc) of
                    {ServerId, _, WorldLv, ServerNum, ServerName} ->
                        lists:keystore(ServerId, 1, Acc, {ServerId, Value, WorldLv, ServerNum, ServerName});
                    _ ->
                        Acc
                end;
            true ->
                Acc
        end
    end,
    NewServerInfo = lists:foldl(Fun, ServerInfo, Args),
    NewState = State#sea_treasure_kf{server_info = NewServerInfo},
    do_handle_cast({'four_clock'}, NewState);

do_handle_cast({'init_after', ServerInfo, Z2SMap, _A}, State) ->
    ZoneList = maps:to_list(Z2SMap),
    Fun = fun({ZoneId, ServerIdList}, {BatMap, AccMap}) ->
        {SatisfyList, UnSatisfyList} = handle_server(ServerIdList, ServerInfo),
        {maps:put(ZoneId, SatisfyList, BatMap), maps:put(ZoneId, UnSatisfyList, AccMap)}
    end,
    {BattleMap, UnSatisfyMap} = lists:foldl(Fun, {#{}, #{}}, ZoneList),
    RobotRef = erlang:send_after(1200 * 1000, self(), {'create_robot'}), % 设为每20min创建一次
    % Nowtime = utime:unixtime(),
    % case lib_sea_treasure:calc_robot_refresh_time(Nowtime-120) of
    %     {true, NextRefreshT} ->
    %         RobotRef = util:send_after(undefined, max(NextRefreshT-Nowtime, 1)*1000, self(), {'create_robot'});
    %     _ -> RobotRef = undefined
    % end,
    NewState = State#sea_treasure_kf{
        zone_map = Z2SMap,
        server_info = ServerInfo,
        battle_map = BattleMap,
        unsatisfy_map = UnSatisfyMap,
        robot_ref = RobotRef
    },
    {noreply, NewState};

do_handle_cast({'node_down', SerIdList}, State) ->
    #sea_treasure_kf{connect_server = ConnSerIdL} = State,
    NewConnSerIdL = ConnSerIdL -- SerIdList, %% 当前连接上的服务器列表更新
    % ?PRINT("===== NewConnSerIdL:~p~n",[NewConnSerIdL]),
    NewState = State#sea_treasure_kf{connect_server = NewConnSerIdL},
    {noreply, NewState};

do_handle_cast({'center_connected', ServerId, MergeSerIds}, State) ->
    #sea_treasure_kf{
        zone_map = Z2SMap,
        server_info = ServerInfo,
        battle_map = BattleMap,
        unsatisfy_map = UnSatisfyMap
        ,shipping_map = ShippingMap
        ,kf_belog_map = KfbeLogMap
        ,connect_server = ConnSerIdL
    } = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    ServerIdList = maps:get(ZoneId, Z2SMap, []),
    Fun = fun
        (MergeSerId, Acc) when MergeSerId == ServerId -> Acc;
        (MergeSerId, {SerIdAcc, BatAccMap, UnSatAccMap, SerInfoAcc, ShipAccMap, BeLogAccMap}) ->
            NewSerIdAcc = lists:delete(MergeSerId, SerIdAcc),
            {NewBatAccMap, _} = handle_map_zone_change(MergeSerId, ZoneId, BatAccMap),
            {NewUnSatAccMap, _} = handle_map_zone_change(MergeSerId, ZoneId, UnSatAccMap),
            NShipAccMap = handle_map_zone_change_1(ServerId, MergeSerId, ShipAccMap),
            NBeLogAccMap = handle_map_zone_change_1(ServerId, MergeSerId, BeLogAccMap),
            NewSerInfoAcc = lists:keydelete(MergeSerId, 1, SerInfoAcc),
            {NewSerIdAcc, NewBatAccMap, NewUnSatAccMap, NewSerInfoAcc, NShipAccMap, NBeLogAccMap}
    end,
    {NewServerIdList, NewBattleMap, NewUnSatisfyMap, NewServerInfo, NewShippingMap, NewKfbeLogMap} =
        lists:foldl(Fun, {ServerIdList, BattleMap, UnSatisfyMap, ServerInfo, ShippingMap, KfbeLogMap}, MergeSerIds),
    NewZoneMap = maps:put(ZoneId, NewServerIdList, Z2SMap),

    SerIdFun = fun(SerId, Acc) ->
        case lists:member(SerId, Acc) of
            true -> Acc;
            _ -> [SerId|Acc]
        end
    end,
    NewConnSerIdL = lists:foldl(SerIdFun, ConnSerIdL, MergeSerIds),

    NewState = State#sea_treasure_kf{
        zone_map = NewZoneMap,
        server_info = NewServerInfo,
        battle_map = NewBattleMap,
        unsatisfy_map = NewUnSatisfyMap,
        shipping_map = NewShippingMap,
        kf_belog_map = NewKfbeLogMap
        ,connect_server = NewConnSerIdL
    },
    do_handle_cast({'local_init', ServerId, MergeSerIds}, NewState);

do_handle_cast({'zone_change', ServerId, OldZone, _NewZone}, State) ->
    #sea_treasure_kf{
        zone_map = Z2SMap,
        server_info = ServerInfo,
        battle_map = BattleMap,
        unsatisfy_map = UnSatisfyMap
    } = State,
    ServerIdList = maps:get(OldZone, Z2SMap, []),
    %% 删除旧分区服数据
    NewServerList = lists:delete(ServerId, ServerIdList),
    %% 删除对应的对战数据以及初次划分对战数据
    {NewBattleMap, SendBattleL} = handle_map_zone_change(ServerId, OldZone, BattleMap),
    {NewUnSatisfyMap, SendUnSatisfyL} = handle_map_zone_change(ServerId, OldZone, UnSatisfyMap),

    NewZoneMap = maps:put(OldZone, NewServerList, Z2SMap),
    NewServerInfo = lists:keydelete(ServerId, 1, ServerInfo),

    update_local_data(battle_list, SendBattleL),
    update_local_data(unsatisfy_list, SendUnSatisfyL),
    %% 更新2个分区所有服的数据
    NewState = State#sea_treasure_kf{
        zone_map = NewZoneMap,
        server_info = NewServerInfo,
        battle_map = NewBattleMap,
        unsatisfy_map = NewUnSatisfyMap
    },
    {noreply, NewState};

do_handle_cast({'local_init', ServerId, MergeSerIds}, State) ->
    #sea_treasure_kf{
        server_info = ServerInfo,
        battle_map = BattleMap,
        unsatisfy_map = UnSatisfyMap,
        connect_server = ConnSerIdL
    } = State,
    Fun = fun(MergeSerId, Acc) ->
        case lists:member(MergeSerId, Acc) of
            false -> [MergeSerId|Acc];
            _ -> Acc
        end
    end,%% 当前连接上的服务器列表更新
    NewConnSerIdL = lists:foldl(Fun, ConnSerIdL, MergeSerIds),
    local_init_core(ServerId, BattleMap, UnSatisfyMap, ServerInfo),
    {noreply, State#sea_treasure_kf{connect_server = NewConnSerIdL}};

do_handle_cast({'midnight_do'}, State) ->
    % #sea_treasure_kf{
    %     robot_ref = OldRef
    % } = State,
    % NowTime = utime:unixtime(),
    % case lib_sea_treasure:calc_robot_refresh_time(NowTime+61) of
    %     {true, NextRefreshT} ->
    %         RobotRef = util:send_after(OldRef, max(NextRefreshT-NowTime, 1)*1000, self(), {'create_robot'});
    %     _ ->
    %         RobotRef = undefined
    % end,
    {noreply, State};

do_handle_cast({'four_clock'}, State) ->
    #sea_treasure_kf{
        zone_map = Z2SMap,
        server_info = ServerInfo
    } = State,
    ZoneList = maps:to_list(Z2SMap),
    Fun = fun({ZoneId, ServerIdList}, {BatMap, AccMap}) ->
        {SatisfyList, UnSatisfyList} = handle_server(ServerIdList, ServerInfo),
        {maps:put(ZoneId, SatisfyList, BatMap), maps:put(ZoneId, UnSatisfyList, AccMap)}
    end,
    {BattleMap, UnSatisfyMap} = lists:foldl(Fun, {#{}, #{}}, ZoneList),

    ValueList = maps:values(BattleMap),
    Fun1 = fun({_, Tem}, Acc) -> Tem++Acc end,
    SerIdL = lists:foldl(Fun1, [], lists:flatten(ValueList)), %% [[1,2],[3,4],[4,5, 6],[7,8,9]]
    NeedUpSerIdL = lists:flatten(SerIdL),
    Fun2 = fun(ServerId) ->
        local_init_core(ServerId, BattleMap, UnSatisfyMap, ServerInfo)
    end,
    lists:foreach(Fun2, NeedUpSerIdL),

    NewState = State#sea_treasure_kf{
        battle_map = BattleMap,
        unsatisfy_map = UnSatisfyMap
    },
    {noreply, NewState};

do_handle_cast({'get_data_from_local', ServerId, SendList, EnemyList}, State) ->
    #sea_treasure_kf{
        shipping_map = ShippingMap
    } = State,
    NewMap = lib_sea_treasure:calc_new_shipping_map(ServerId, ShippingMap, SendList),
    % ?PRINT("================ EnemyList:~p~n",[EnemyList]),
    [mod_clusters_center:apply_cast(SerId, mod_sea_treasure_local,
        get_data_from_cluster, [ServerId, SendList]) || SerId <- EnemyList, SerId =/= ServerId],
    NewState = State#sea_treasure_kf{
        shipping_map = NewMap
    },
    {noreply, NewState};

do_handle_cast({'get_log_data_from_local', LogdataList}, State) ->
    #sea_treasure_kf{
        kf_belog_map = BeLogMap, connect_server = ConnSerIdL
    } = State,
    Fun = fun({RoberSerId, SendList}, AccMap) ->
        do_handle_log_data(AccMap, RoberSerId, SendList, ConnSerIdL)
    end,
    NewMap = lists:foldl(Fun, BeLogMap, LogdataList),
    NewState = State#sea_treasure_kf{
        kf_belog_map = NewMap
    },
    {noreply, NewState};

do_handle_cast({'get_log_data_from_local', RoberSerId, SendList}, State) ->
    #sea_treasure_kf{
        kf_belog_map = BeLogMap, connect_server = ConnSerIdL
    } = State,
    NewMap = do_handle_log_data(BeLogMap, RoberSerId, SendList, ConnSerIdL),
    NewState = State#sea_treasure_kf{
        kf_belog_map = NewMap
    },
    {noreply, NewState};

do_handle_cast({'get_clear_data_from_local', RoberSerId, SendList}, State) ->
    mod_clusters_center:apply_cast(RoberSerId, mod_sea_treasure_local, get_clear_data_from_cluster, [SendList]),
    {noreply, State};

do_handle_cast({'get_role_info_from_local', FromServer, SerId, SendList}, State) ->
    mod_clusters_center:apply_cast(SerId, mod_sea_treasure_local, get_role_info_from_cluster, [FromServer, SendList]),
    {noreply, State};

do_handle_cast({'get_other_server_data', ServerId, EnemyList}, State) ->
    #sea_treasure_kf{
        shipping_map = ShippingMap
        ,kf_belog_map = BeLogMap
    } = State,
    Fun = fun
        (SerId, Acc) when SerId =/= ServerId ->
            GetList = maps:get(SerId, ShippingMap, []),
            lists:keystore(SerId, 1, Acc, {SerId, GetList});
        (_SerId, Acc) -> Acc
    end,
    NeedUpList = lists:foldl(Fun, [], EnemyList),
    %%
    LogdataList = maps:get(ServerId, BeLogMap, []),
    NewMap = maps:remove(ServerId, BeLogMap),
    %% 开启进程发送
    spawn(fun() -> handle_log_data_for_send(ServerId, LogdataList) end),
    handle_data_for_send(ServerId, NeedUpList),
    NewState = State#sea_treasure_kf{
        kf_belog_map = NewMap
    },
    {noreply, NewState};

%% 走到这里一定是掠夺失败的情况
do_handle_cast({'do_after_terminate', EnemySerId, AutoId, RoleId, RName}, State) ->
    #sea_treasure_kf{
        shipping_map = ShippingMap
        ,battle_map = BattleMap
    } = State,
    if
        EnemySerId =/= 0 ->
            %% 更新数据
            mod_clusters_center:apply_cast(EnemySerId, mod_sea_treasure_local,
                do_after_terminate, [EnemySerId, AutoId, RoleId, RName]),
            ZoneId = lib_clusters_center_api:get_zone(EnemySerId),
            BattleList = maps:get(ZoneId, BattleMap, []),
            {_, SendBatList} = get_server_battle_info(BattleList, EnemySerId),
            ShippingList = maps:get(EnemySerId, ShippingMap, []),
            case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
                #shipping_info{} = OldShip ->
                    %% 更新为可被掠夺状态
                    NewShip = OldShip#shipping_info{rob_times = ?CAN_ROB},
                    NewShippingMap = lib_sea_treasure:save_to_map([{EnemySerId, NewShip}], ShippingMap),
                    %% 更新到各个服
                    SendShipL = [{AutoId, {#shipping_info.rob_times, ?CAN_ROB}}],
                    [mod_clusters_center:apply_cast(TemSerId, mod_sea_treasure_local, get_data_from_cluster,
                        [EnemySerId, SendShipL]) || TemSerId <- SendBatList, TemSerId =/= EnemySerId];
                _ -> %% 巡航已结束不处理/服务器id出错
                    NewShippingMap = ShippingMap
            end;
        true ->
            ShippingList = lists:flatten(maps:values(ShippingMap)),
            case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
                #shipping_info{ser_id = SerId} = OldShip ->
                    ZoneId = lib_clusters_center_api:get_zone(SerId),
                    BattleList = maps:get(ZoneId, BattleMap, []),
                    {_, SendBatList} = get_server_battle_info(BattleList, SerId),
                    %% 更新为可被掠夺状态
                    NewShip = OldShip#shipping_info{rob_times = ?CAN_ROB},
                    NewShippingMap = lib_sea_treasure:save_to_map([{SerId, NewShip}], ShippingMap),
                    %% 更新到各个服
                    SendShipL = [{AutoId, {#shipping_info.rob_times, ?CAN_ROB}}],
                    mod_clusters_center:apply_cast(SerId, mod_sea_treasure_local,
                        do_after_terminate, [SerId, AutoId, RoleId, RName]),
                    [mod_clusters_center:apply_cast(TemSerId, mod_sea_treasure_local, get_data_from_cluster,
                        [SerId, SendShipL]) || TemSerId <- SendBatList, TemSerId =/= SerId];
                _ -> %% 巡航已结束不处理/服务器id出错
                    NewShippingMap = ShippingMap
            end
    end,
    NewState = State#sea_treasure_kf{
        shipping_map = NewShippingMap
    },
    {noreply, NewState};

do_handle_cast({'do_after_battle', Arg, EnemySerId, SerId, RoleId, BeHelperId}, State) ->
    #sea_treasure_kf{
        battle_field = FieldMap, battle_map = BattleMap, shipping_map = ShippingMap
    } = State,
    ZoneId = lib_clusters_center_api:get_zone(EnemySerId),
    BattleList = maps:get(ZoneId, BattleMap, []),
    {_, SendBatList} = get_server_battle_info(BattleList, EnemySerId),
    [Res, _BGoldNum, BatType, ShippingType, AutoId, _RHpPer, _MHpPer, RoberInfo, RoberGuild, Enemy, EnemyGuild] = Arg,
    Nowtime = utime:unixtime(),
    case BatType of
        ?BATTLE_TYPE_ROBER ->  %% 跨服掠夺
            #role_info{
                ser_num = RoberSerNum, role_name = RoberRName, power = _RoberPower
            } = RoberInfo,
            if
                Res == 1 -> %% 掠夺成功
                    {EnemyGuildId, EnemyGuildName} = EnemyGuild,
                    {RoberGuildId, RoberGuildName} = RoberGuild,
                    #fake_info{
                        ser_num = EnemySerNum, role_id = EnemyId, role_name = EnemyName, power = _EnemyPower
                    } = Enemy,
                    RoberReward = lib_sea_treasure:get_rober_reward(ShippingType),
                    %% 掠夺者记录处理  0掠夺 1被掠夺
                    NewRoberLog = lib_sea_treasure:make_record(treasure_log, [
                        ShippingType, RoleId, AutoId, 0, EnemySerId, EnemySerNum, EnemyGuildId,
                        EnemyGuildName, EnemyId, EnemyName, _EnemyPower, RoberReward, 0, [], [], 0, Nowtime
                    ]),
                    ProtocolArg = lib_sea_treasure:construct_data_for_18907(Res, BatType,
                            ShippingType, AutoId, RoberInfo, Enemy, BeHelperId, RoberReward),
                    mod_clusters_center:apply_cast(SerId, mod_sea_treasure_local, do_after_robber_success,
                        [SerId, RoleId, EnemySerId, NewRoberLog, ProtocolArg, RoberReward]),

                    ShippingList = maps:get(EnemySerId, ShippingMap, []),
                    case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
                        #shipping_info{} = OldShip ->
                            %% 更新为不可被掠夺状态
                            NewShip = OldShip#shipping_info{rob_times = ?CANT_ROB},
                            NewShippingMap = lib_sea_treasure:save_to_map([{EnemySerId, NewShip}], ShippingMap),
                            %% 更新到各个服
                            SendShipL = [{AutoId, {#shipping_info.rob_times, ?CANT_ROB}}],
                            [mod_clusters_center:apply_cast(TemSerId, mod_sea_treasure_local, get_data_from_cluster,
                                [EnemySerId, SendShipL]) || TemSerId <- SendBatList, TemSerId =/= EnemySerId];
                        _ ->
                            NewShippingMap = ShippingMap
                    end,

                    %% 被掠夺者记录
                    NewBeRoberLog = lib_sea_treasure:make_record(treasure_log, [
                        ShippingType, EnemyId, AutoId, 1, SerId, RoberSerNum, RoberGuildId,
                        RoberGuildName, RoleId, RoberRName, _RoberPower, RoberReward, 0, [], [], 0, Nowtime
                    ]),
                    mod_clusters_center:apply_cast(EnemySerId, mod_sea_treasure_local, do_after_robber_success,
                        [EnemySerId, EnemyId, SerId, NewBeRoberLog, [], []]);
                true ->
                    %% 战斗结果通知
                    NewShippingMap = ShippingMap,
                    ProtocolArg = lib_sea_treasure:construct_data_for_18907(Res, BatType,
                            ShippingType, AutoId, RoberInfo, Enemy, BeHelperId, []),
                    mod_clusters_center:apply_cast(SerId, pp_sea_treasure, send_error,
                        [RoleId, ProtocolArg, 18907])
            end;
        _ ->  %% 协助
            NewShippingMap = ShippingMap,
            mod_clusters_center:apply_cast(SerId, mod_sea_treasure_local,
                do_after_rob_back, [Arg, RoleId, BeHelperId, RoberInfo]),
            if
                Res == 1 ->
                    %% 清理所有这条协助的所有玩家，关闭对应战场进程
                    PidList = maps:get(BeHelperId, FieldMap, []),
                    lib_sea_treasure_battle:stop_all(lists:keydelete(RoleId, 1, PidList));
                true ->
                    skip
            end
    end,
    {noreply, State#sea_treasure_kf{shipping_map = NewShippingMap}};

do_handle_cast({'delete_helper_pid', BeHelperId, HelperId}, State) ->
    #sea_treasure_kf{
        battle_field = FieldPidMap
    } = State,
    PidList = maps:get(BeHelperId, FieldPidMap, []),
    case PidList of
        [{HelperId, _}] ->
            NewMap = maps:remove(BeHelperId, FieldPidMap);
        _ ->
            NewList = lists:keydelete(HelperId, 1, PidList),
            NewMap = maps:put(BeHelperId, NewList, FieldPidMap)
    end,
    {noreply, State#sea_treasure_kf{battle_field = NewMap}};

do_handle_cast({'start_battle_filed', BatType, BeHelperId, RoberSerId, HelperSerId, HelperId, StartArgs, ProtocolArg}, State) ->
    #sea_treasure_kf{
        battle_field = FieldPidMap, connect_server = ConnSerIdL
    } = State,
    % ?PRINT("===== ConnSerIdL:~p~n",[ConnSerIdL]),
    case lists:member(RoberSerId, ConnSerIdL) of
        true ->
            if
                BatType == ?BATTLE_TYPE_ROBER ->
                    ScenePoolId = urand:rand(1,10);
                true ->
                    ScenePoolId = HelperId
            end,
            [ShipRoleId, AutoId, ShippingType, TreasureMod, BatType, BackTimes, RoleA, RoleB, Scene] = StartArgs,
            NewStartArgs = [ShipRoleId, AutoId, ShippingType, TreasureMod, BatType, BackTimes, RoleA, RoleB, Scene, ScenePoolId],
            Pid = mod_battle_field:start(lib_sea_treasure_battle, NewStartArgs), %% 掠夺不保存pid
            %% 更新玩家身上战斗进程pid
            mod_clusters_center:apply_cast(HelperSerId, lib_player,
                apply_cast, [HelperId, ?APPLY_CAST_SAVE, lib_sea_treasure, rob_shipping_kf, [Pid, [?SUCCESS|ProtocolArg]]]),
            if
                BatType == ?BATTLE_TYPE_ROBER ->
                    NewMap = FieldPidMap;
                true ->
                    PidList = maps:get(BeHelperId, FieldPidMap, []),
                    NewList = lists:keystore(HelperId, 1, PidList, {HelperId, Pid}),
                    NewMap = maps:put(BeHelperId, NewList, FieldPidMap)
            end;
        _ ->
            NewPro = [?ERRCODE(err189_server_has_down)|ProtocolArg],
            mod_clusters_center:apply_cast(HelperSerId, lib_player,
                apply_cast, [HelperId, ?APPLY_CAST_SAVE, lib_sea_treasure, rob_shipping_kf, [NewPro]]),
            NewMap = FieldPidMap
    end,
    {noreply, State#sea_treasure_kf{battle_field = NewMap}};

do_handle_cast({'rob_shipping_kf', SendShipInfo, EnemyList, BatType, RoberSerId, RoberId, StartArgs}, State) ->
    #sea_treasure_kf{
        shipping_map = ShippingMap, connect_server = ConnSerIdL
    } = State,
    [AutoId, ShipSerId, RoberTimes, ShipRoleId] = SendShipInfo,
    ShippingList = maps:get(ShipSerId, ShippingMap, []),
    % ?PRINT("=====ShipSerId:~p ConnSerIdL:~p~n",[ShipSerId,ConnSerIdL]),
    case lists:member(ShipSerId, ConnSerIdL) of
        true ->
            case lists:keyfind(AutoId, #shipping_info.auto_id, ShippingList) of
                #shipping_info{rob_times = ?CAN_ROB} = Ship ->
                    case lib_sea_treasure:check_before_rober(Ship, RoberId) of
                        true ->
                            Pid = mod_battle_field:start(lib_sea_treasure_battle, StartArgs), %% 掠夺不保存pid
                            %% 更新玩家身上数据
                            ProtocolArg = [?SUCCESS, AutoId, ShipSerId, ShipRoleId, BatType],
                            mod_clusters_center:apply_cast(RoberSerId, lib_player,
                                apply_cast, [RoberId, ?APPLY_CAST_SAVE, lib_sea_treasure, rob_shipping_kf, [Pid, ProtocolArg]]),
                            % pp_sea_treasure:send_error(RoleId, [?SUCCESS, AutoId, ShipSerId, ShipRoleId, BatType], 18905),
                            NewShip = Ship#shipping_info{rob_times = RoberTimes},
                            NewMap = lib_sea_treasure:calc_new_shipping_map(ShipSerId, ShippingMap, [NewShip]),
                            % ?PRINT("================ EnemyList:~p~n",[EnemyList]),
                            SendShipL = [{AutoId, {#shipping_info.rob_times, RoberTimes}}],
                            [mod_clusters_center:apply_cast(SerId, mod_sea_treasure_local,
                                get_data_from_cluster, [ShipSerId, SendShipL]) || SerId <- EnemyList];
                        {false, Code} ->
                            ProtocolArg = [Code, AutoId, ShipSerId, ShipRoleId, BatType],
                            mod_clusters_center:apply_cast(RoberSerId, lib_player,
                                apply_cast, [RoberId, ?APPLY_CAST_SAVE, lib_sea_treasure, rob_shipping_kf, [ProtocolArg]]),
                            NewMap = ShippingMap
                    end;
                #shipping_info{} ->
                    ProtocolArg = [?ERRCODE(err189_be_robbing), AutoId, ShipSerId, ShipRoleId, BatType],
                    mod_clusters_center:apply_cast(RoberSerId, lib_player,
                        apply_cast, [RoberId, ?APPLY_CAST_SAVE, lib_sea_treasure, rob_shipping_kf, [ProtocolArg]]),
                    NewMap = ShippingMap;
                _ ->
                    ProtocolArg = [?ERRCODE(err189_ship_end), AutoId, ShipSerId, ShipRoleId, BatType],
                    mod_clusters_center:apply_cast(RoberSerId, lib_player,
                        apply_cast, [RoberId, ?APPLY_CAST_SAVE, lib_sea_treasure, rob_shipping_kf, [ProtocolArg]]),
                    NewMap = ShippingMap
            end;
        _ ->
            ProtocolArg = [?ERRCODE(err189_server_has_down), AutoId, ShipSerId, ShipRoleId, BatType],
            mod_clusters_center:apply_cast(RoberSerId, lib_player,
                apply_cast, [RoberId, ?APPLY_CAST_SAVE, lib_sea_treasure, rob_shipping_kf, [ProtocolArg]]),
            NewMap = ShippingMap
    end,
    {noreply, State#sea_treasure_kf{shipping_map = NewMap}};

do_handle_cast({'gm_create_robot'}, State) ->
    #sea_treasure_kf{battle_map = BattleMap, shipping_map = ShippingMap} = State,
    BattleList = maps:to_list(BattleMap),
    Fun = fun({_ZoneId, BatList}) ->
        F1 = fun({TreasureMod, List}) -> %% [[1,2],[3,4]]
            Num = lib_sea_treasure:calc_robot_num(TreasureMod),
            [begin
                TemList = calc_robot_server_id(Num, Val, []),
                [mod_clusters_center:apply_cast(TSerId, mod_sea_treasure_local, create_robot_kf, [N])|| {TSerId, N} <- TemList]
             end|| Val <- List]
        end,
        lists:foreach(F1, BatList)
    end,
    spawn(fun() -> lists:foreach(Fun, BattleList) end),
    Nowtime = utime:unixtime(),
    MapF = fun(_, ShippingList) -> [ Ship ||#shipping_info{end_time = Endtime} = Ship <- ShippingList, Nowtime < Endtime] end,
    NewShippingMap = maps:map(MapF, ShippingMap),
    RobotRef = erlang:send_after(1200 * 1000, self(), {'create_robot'}),
    % case lib_sea_treasure:calc_robot_refresh_time(Nowtime+61) of
    %     {true, NextRefreshT} ->
    %         RobotRef = util:send_after(OldRef, max(NextRefreshT-Nowtime, 1)*1000, self(), {'create_robot'});
    %     _ ->
    %         RobotRef = undefined
    % end,
    {noreply, State#sea_treasure_kf{robot_ref = RobotRef, shipping_map = NewShippingMap}};

do_handle_cast(_Msg, State) ->
    {noreply, State}.

do_handle_call(_, State) ->
    {reply, ok, State}.

do_handle_info({'create_robot'}, State) ->
    #sea_treasure_kf{robot_ref = OldRef, battle_map = BattleMap, shipping_map = ShippingMap} = State,
    BattleList = maps:to_list(BattleMap),
    Fun = fun({_ZoneId, BatList}) ->
        F1 = fun({TreasureMod, List}) -> %% [[1,2],[3,4]]
            Num = lib_sea_treasure:calc_robot_num(TreasureMod),
            [begin
                TemList = calc_robot_server_id(Num, Val, []),
                [mod_clusters_center:apply_cast(TSerId, mod_sea_treasure_local, create_robot_kf, [N])|| {TSerId, N} <- TemList]
             end|| Val <- List]
        end,
        lists:foreach(F1, BatList)
    end,
    spawn(fun() -> lists:foreach(Fun, BattleList) end),
    Nowtime = utime:unixtime(),
    %% 定期删除过期数据
    MapF = fun(_, ShippingList) -> [ Ship ||#shipping_info{end_time = Endtime} = Ship <- ShippingList, Nowtime < Endtime] end,
    NewShippingMap = maps:map(MapF, ShippingMap),
    RobotRef = util:send_after(OldRef, 1200 * 1000, self(), {'create_robot'}),
    % case lib_sea_treasure:calc_robot_refresh_time(Nowtime+61) of
    %     {true, NextRefreshT} ->
    %         RobotRef = util:send_after(OldRef, max(NextRefreshT-Nowtime, 1)*1000, self(), {'create_robot'});
    %     _ ->
    %         util:cancel_timer(OldRef),
    %         RobotRef = undefined
    % end,
    {noreply, State#sea_treasure_kf{robot_ref = RobotRef, shipping_map = NewShippingMap}};

do_handle_info(_Msg, State) ->
    {noreply, State}.

%% =======================================================
%% 更新各个服数据开始
%% =======================================================
update_local_data(_Type, []) -> skip;
update_local_data(Type, SendBattleL) ->
    Fun = fun(ServerIdList) ->
        F = fun(ServerId) ->
            case lib_clusters_center:get_node(ServerId) of
                undefined -> skip;
                Node ->
                    mod_clusters_center:apply_cast(Node, mod_sea_treasure_local, update_state, [Type, ServerIdList])
            end
        end,
        lists:foreach(F, ServerIdList)
    end,
    lists:foreach(Fun, SendBattleL).

%% =======================================================
%% 更新各个服数据结束
%% =======================================================

%% =======================================================
%% 划分对战服务器开始  返回格式[{Type, [[1,2], [3,4]]}, 。。。]
%% 当前服务器分区内,满足开服天数限制的相邻X个(读服数字段)服务器
%% 的平均世界等级达到要求时,切换跨服模式
%% =======================================================
handle_server(ServerIdList, ServerInfo) ->
    Fun = fun(ServerId, Acc) ->
        case lists:keyfind(ServerId, 1, ServerInfo) of
            {_, Optime, WorldLv, _, _} ->
                case lib_sea_treasure:get_server_treasure_type_before(Optime) of
                    {Type, OpenDay} ->
                        {_, OldList} = ulists:keyfind(Type, 1, Acc, {Type, []}),
                        NewList = [{ServerId, OpenDay, WorldLv, Type}|OldList],
                        lists:keystore(Type, 1, Acc, {Type, NewList});
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    AllList = data_sea_treasure:get_all_treasure_mod(),
    SaveList = [{Type, []}||Type <- AllList],
    %% 先依据开服天数大致生成对战列表
    QuicklySortList = lists:foldl(Fun, SaveList, ServerIdList),
    SortList = lists:reverse(lists:keysort(1, QuicklySortList)),
    %% 从模式id大的开始排查，剔除不满足当前模式世界等级的服，放到下一模式再计算
    handle_server_core(SortList, [], [], []).


handle_server_core([], Acc, Acc1, _RestList) -> {Acc, Acc1};
handle_server_core([{Type, SerInfoL}|T], Acc, Acc1, RestList) ->
    #base_sea_treasure_mod{ser_num = Num, wlv_min = WlvMin, wlv_max = WlvMax} = data_sea_treasure:get_mod_info(Type),
    {TemAcc, TemAcc1, TemRestList} = hand_reset_list(Type, Num, WlvMin, WlvMax, Acc, Acc1, RestList),
    % SortList = hand_reset_list(Type, RestList, SerInfoL),
    SortList = lists:reverse(lists:keysort(2, SerInfoL)),
    %% 按开服天数排序，优先计算开服天数大的服务器
    {NewAcc, NewAcc1, NewRestList} = handle_server_helper(0, Type, Num, WlvMin, WlvMax, SortList, TemAcc, TemAcc1, TemRestList),
    handle_server_core(T, NewAcc, NewAcc1, NewRestList).

handle_server_helper(_, _, _, _, _, [], Acc, Acc1, LeftList) -> {Acc, Acc1, LeftList};
handle_server_helper(BeforeType, Type, Num, WlvMin, WlvMax, SerInfoL, Acc, Acc1, LeftList) ->
    if
        length(SerInfoL) >= Num ->
            {SubList, RestList} = lists:split(Num, SerInfoL);
        true ->
            SubList = SerInfoL, RestList = []
    end,
    {Average, List} = calc_average(SubList),
    if
        Average >= WlvMin ->
            NewAcc = save_into_list(Type, Acc, List),
            case data_sea_treasure:get_mod_info(BeforeType) of
                #base_sea_treasure_mod{ser_num = BeforeNum} ->
                    NewAcc1 = save_into_list(BeforeType, BeforeNum, Acc1, SerInfoL);
                _ ->
                    NewAcc1 = Acc1
            end,
            NewLeftList = lists:keydelete(BeforeType, 1, LeftList),
            handle_server_helper(BeforeType, Type, Num, WlvMin, WlvMax, RestList, NewAcc, NewAcc1, NewLeftList);
        true ->
            %% 平均世界等级不满足，一起放到下一模式处理
            case lists:keyfind(Type, 1, LeftList) of
                {_, OldList} -> NewList = SubList++OldList;
                _ -> NewList = SubList
            end,
            NewLeftList = lists:keystore(Type, 1, LeftList, {Type, NewList}),
            NewLeftList1 = lists:keydelete(BeforeType, 1, NewLeftList),
            handle_server_helper(BeforeType, Type, Num, WlvMin, WlvMax, RestList, Acc, Acc1, NewLeftList1)
    end.

% %% 将不满足上一模式的服与当前模式待划分的服放到一起去计算
% hand_reset_list(Type, RestList, SerInfoL) ->
%     case lists:keyfind(Type+1, 1, RestList) of
%         {_, RestSerInfoL} ->
%             lists:reverse(lists:keysort(1, RestSerInfoL++SerInfoL));
%         _ ->
%             lists:reverse(lists:keysort(1, SerInfoL))
%     end.

%% 不满足上一模式的放到一起去重新划分
hand_reset_list(Type, Num, WlvMin, WlvMax, Acc, Acc1, RestList) ->
    case lists:keyfind(Type+1, 1, RestList) of
        {_, SerInfoL} ->
            SortList = lists:reverse(lists:keysort(1, SerInfoL)),
            handle_server_helper(Type+1, Type, Num, WlvMin, WlvMax, SortList, Acc, Acc1, RestList);
        _ ->
            {Acc, Acc1, RestList}
    end.

save_into_list(_, Acc, []) -> Acc;
save_into_list(0, Acc, _) -> Acc;
save_into_list(Type, Acc, List) ->
    case lists:keyfind(Type, 1, Acc) of
        {_, OldList} -> NewList = [List|OldList];
        _ -> NewList = [List]
    end,
    lists:keystore(Type, 1, Acc, {Type, NewList}).

save_into_list(_BeforeType, _BeforeNum, NewAcc1, []) -> NewAcc1;
save_into_list(BeforeType, BeforeNum, Acc1, SerInfoL) ->
    if
        length(SerInfoL) >= BeforeNum ->
            {SubList, ResSerInfoL} = lists:split(BeforeNum, SerInfoL);
        true ->
            SubList = SerInfoL, ResSerInfoL = []
    end,
    {_, List} = calc_average(SubList),

    case lists:keyfind(BeforeType, 1, Acc1) of
        {_, OldList} ->
            SaveList = List -- lists:flatten(OldList),
            if
                SaveList == [] ->
                    NewList = OldList;
                true ->
                    NewList = [SaveList|OldList]
            end;
        _ -> NewList = [List]
    end,
    NewAcc1 = lists:keystore(BeforeType, 1, Acc1, {BeforeType, NewList}),
    save_into_list(BeforeType, BeforeNum, NewAcc1, ResSerInfoL).


%% 计算平均世界等级
calc_average(List) ->
    Fun = fun
        ({SerId, _, WorldLv, _Type}, {Tem, Counter, Acc}) ->
            {WorldLv + Tem, Counter+1, [SerId|Acc]};
        (_, Acc) -> Acc
    end,
    {Sum, Num, NewList} = lists:foldl(Fun, {0, 0, []}, List),
    Average =
    if
        Num > 0 ->
            Sum div Num;
        true ->
            0
    end,
    {Average, NewList}.
%% =======================================================
%% 划分对战服务器结束
%% =======================================================

handle_map_zone_change_1(ServerId, MergeSerId, Map) ->
    List = maps:get(MergeSerId, Map, []),
    List1 = maps:get(ServerId, Map, []),
    maps:put(ServerId, List++List1, Map).

%% 分区更改处理对战及初次对战数据
handle_map_zone_change(ServerId, OldZone, BattleMap) ->
    BattleList = maps:get(OldZone, BattleMap, []),
    Fun = fun({Type, SerList}, {Acc, {OutType, OutList}}) ->
        F = fun(SerIdL, {Acc1, Acc2}) ->
            case lists:member(ServerId, SerIdL) of
                true -> {[lists:delete(ServerId, SerIdL)|Acc1], [lists:delete(ServerId, SerIdL)|Acc2]};
                _ -> {[SerIdL|Acc1], Acc2}
            end
        end,
        {NewSerList, SendList} = lists:foldl(F, {[], []}, SerList),
        {lists:keystore(Type, 1, Acc, {Type, NewSerList}),
        ?IF(OutType > Type, {OutType, OutList}, {Type, SendList})}
    end,
    {NewBattleList, {_, SendL}} = lists:foldl(Fun, {[], {0, []}}, BattleList),
    {maps:put(OldZone, NewBattleList, BattleMap), SendL}.

%% 获取服的对战数据
get_server_battle_info([], _ServerId) -> {0, []};
get_server_battle_info([{Type, SerList}|T], ServerId) ->
    F = fun(SerIdL, Acc) ->
        case lists:member(ServerId, SerIdL) of
            true -> get_server_battle_core(SerIdL, Acc);
            _ -> Acc
        end
    end,
    SendList = lists:foldl(F, [], SerList),
    case SendList of
        [] -> get_server_battle_info(T, ServerId);
        _ -> {Type, SendList}
    end.

get_server_battle_core([], Acc) -> Acc;
get_server_battle_core([SerId|SerIdL], Acc) ->
    get_server_battle_core(SerIdL, [SerId|Acc]).


%% 获取服详细数据
get_send_server_info(SerIdL, ServerInfo) ->
    Fun = fun(SerId, Acc) ->
        case lists:keyfind(SerId, 1, ServerInfo) of
            {_, _, _, _, _} = Val -> [Val|Acc];
            _ -> Acc
        end
    end,
    lists:foldl(Fun, [], SerIdL).

local_init_core(ServerId, BattleMap, UnSatisfyMap, ServerInfo) ->
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    BattleList = maps:get(ZoneId, BattleMap, []),
    UnSatisfyList = maps:get(ZoneId, UnSatisfyMap, []),
    {Type, SendBatList} = get_server_battle_info(BattleList, ServerId),
    % ?PRINT("UnSatisfyMap:~p~n, BattleMap:~p~n",[UnSatisfyMap, BattleMap]),
    {UnSatisfyType, SendUnSatisfyList} = get_server_battle_info(lists:reverse(lists:keysort(1, UnSatisfyList)), ServerId),
    ServerIdList = SendBatList ++ SendUnSatisfyList,
    RmvSerIdL = ulists:removal_duplicate(ServerIdList),
    SendServerInfo = get_send_server_info(RmvSerIdL, ServerInfo),
    mod_clusters_center:apply_cast(ServerId, mod_sea_treasure_local,
        init_after, [Type, SendBatList, UnSatisfyType, SendUnSatisfyList, SendServerInfo, []]).

handle_log_data_for_send(_, []) -> skip;
handle_log_data_for_send(ServerId, LogdataList) ->
    case lists:sublist(LogdataList, 1, ?SEND_DATA_LENGTH) of
        [] -> skip;
        SendList ->
            mod_clusters_center:apply_cast(ServerId, mod_sea_treasure_local,
                get_log_data_from_cluster, [SendList]),
            timer:sleep(1000),
            handle_log_data_for_send(ServerId, LogdataList--SendList)
    end.


handle_data_for_send(ServerId, NeedUpList) ->
    Fun = fun({SerId, List}) ->
        handle_data_for_send_helper(ServerId, 1, SerId, List)
    end,
    spawn(fun() -> lists:foreach(Fun, NeedUpList) end),
    ok.

handle_data_for_send_helper(_, _, _, []) -> skip;
handle_data_for_send_helper(ServerId, StartPos, SerId, List) ->
    case lists:sublist(List, StartPos, ?SEND_DATA_LENGTH) of
        [] -> skip;
        SendList ->
            mod_clusters_center:apply_cast(ServerId, mod_sea_treasure_local,
                get_data_from_cluster, [SerId, SendList]),
            timer:sleep(1000),
            handle_data_for_send_helper(ServerId, StartPos, SerId, List--SendList)
    end.

calc_robot_server_id(0, _List, Acc) -> Acc;
calc_robot_server_id(Num, List, Acc) ->
    SerId = urand:list_rand(List),
    case lists:keyfind(SerId, 1, Acc) of
        {SerId, N} -> NewN = N + 1;
        _ -> NewN = 1
    end,
    NewAcc = lists:keystore(SerId, 1, Acc, {SerId, NewN}),
    calc_robot_server_id(Num - 1, List, NewAcc).


do_handle_log_data(BeLogMap, RoberSerId, SendList, ConnSerIdL) ->
    List = maps:get(RoberSerId, BeLogMap, []),
    %% 暂时先保存数据，请求一次后删掉
    Fun = fun
        ({AutoId, RoleId, BeLogSerId, RoberId}, Acc) ->
            [{AutoId, RoleId, BeLogSerId, RoberId}|Acc];
        (AutoId, Acc) when is_integer(AutoId) ->
            [AutoId|Acc];
        (_, Acc) -> Acc
    end,
    NewList = lists:foldl(Fun, List, SendList),

    %% 连接上跨服中心没必要保存数据直接发给对应的服
    case lists:member(RoberSerId, ConnSerIdL) of
        true when List =/= [] -> % 第一次发送开进程发，防止数据过多
            spawn(fun() -> handle_log_data_for_send(RoberSerId, NewList) end),
            NewMap = maps:remove(RoberSerId, BeLogMap);
        true ->
            mod_clusters_center:apply_cast(RoberSerId, mod_sea_treasure_local, get_log_data_from_cluster, [SendList]),
            NewMap = BeLogMap;
        _ ->
            NewMap = maps:put(RoberSerId, NewList, BeLogMap)
    end,
    NewMap.