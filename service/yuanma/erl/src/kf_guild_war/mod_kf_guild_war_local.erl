%%-----------------------------------------------------------------------------
%% @Module  :       lib_kf_guild_war_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战
%%-----------------------------------------------------------------------------
-module(mod_kf_guild_war_local).

-behavious(gen_server).

-include("kf_guild_war.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("guild.hrl").
-include("daily.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
    msg_center2local/1
    , connect_center/0
    ]).

-export([
    send_donate_view_info/1
    , send_exchange_props_view_info/2
    , send_props_view_info/2
    , send_bid_view_info/3
    , donate_resource/4
    , add_funds/2
    , declare_war/8
    , use_props/6
    , exchange_props/7
    , day_trigger/1
    , role_login/2
    ]).

-export([
    check_donate_resource/3
    , check_exchange_props/4
    , get_act_status/0
    ]).

-export([
    gm_confirm_kfgwar_join_guild/0
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

msg_center2local(Msg) ->
    case lib_kf_guild_war:is_kf_guild_war_server() of
        true ->
            gen_server:cast(?MODULE, {'msg_center2local', Msg});
        _ -> skip
    end.

connect_center() ->
    gen_server:cast(?MODULE, {'connect_center'}).

send_donate_view_info(RoleId) ->
    gen_server:cast(?MODULE, {'send_donate_view_info', RoleId}).

send_bid_view_info(GuildId, RoleId, IslandId) ->
    gen_server:cast(?MODULE, {'send_bid_view_info', GuildId, RoleId, IslandId}).

donate_resource(RoleId, GuildId, Type, Cost) ->
    gen_server:cast(?MODULE, {'donate_resource', RoleId, GuildId, Type, Cost}).

send_exchange_props_view_info(GuildId, RoleId) ->
    gen_server:cast(?MODULE, {'send_exchange_props_view_info', GuildId, RoleId}).

send_props_view_info(GuildId, RoleId) ->
    gen_server:cast(?MODULE, {'send_props_view_info', GuildId, RoleId}).

declare_war(SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid) ->
    gen_server:cast(?MODULE, {'declare_war', SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid}).

add_funds(GuildId, ReturnFunds) ->
    gen_server:cast(?MODULE, {'add_funds', GuildId, ReturnFunds}).

exchange_props(GuildId, GuildName, RoleId, PropsId, Num, CostNum, Type) ->
    gen_server:cast(?MODULE, {'exchange_props', GuildId, GuildName, RoleId, PropsId, Num, CostNum, Type}).

use_props(CopyId, GuildId, GuildName, RoleId, PropsId, ArgsMap) ->
    gen_server:cast(?MODULE, {'use_props', CopyId, GuildId, GuildName, RoleId, PropsId, ArgsMap}).

day_trigger(ClockType) ->
    gen_server:cast(?MODULE, {'day_trigger', ClockType}).

role_login(GuildId, RoleId) ->
    gen_server:cast(?MODULE, {'role_login', GuildId, RoleId}).

check_donate_resource(RoleId, GuildId, Type) ->
    gen_server:call(?MODULE, {'check_donate_resource', RoleId, GuildId, Type}, 500).

check_exchange_props(GuildId, PropsId, Num, ExchangeType) ->
    gen_server:call(?MODULE, {'check_exchange_props', GuildId, PropsId, Num, ExchangeType}, 500).

get_act_status() ->
    gen_server:call(?MODULE, {'get_act_status'}, 500).

%% -------------------- 秘籍 ------------------------------
gm_confirm_kfgwar_join_guild() ->
    gen_server:cast(?MODULE, {'gm_confirm_kfgwar_join_guild'}).
%% -------------------- 秘籍 ------------------------------

init([]) ->
    List = db:get_all(io_lib:format(?sql_select_kf_gwar_donate_info, [])),
    List1 = db:get_all(io_lib:format(?sql_select_kf_gwar_resource_info, [])),
    List2 = db:get_all(io_lib:format(?sql_select_kf_gwar_join_guild, [])),
    F = fun(T, Map) ->
        case T of
            [RoleId, GuildId, Type, Times] ->
                maps:put({RoleId, GuildId, Type}, Times, Map);
            _ -> Map
        end
    end,
    DonateMap = lists:foldl(F, #{}, List),
    F1 = fun(T, Map) ->
        case T of
            [GuildId, Resource, Funds, PropsList] ->
                ResourceInfo = #resource_info{num = Resource, funds = Funds, props_list = util:bitstring_to_term(PropsList)},
                maps:put(GuildId, ResourceInfo, Map);
            _ -> Map
        end
    end,
    ResourceMap = lists:foldl(F1, #{}, List1),
    put("confirm_time", 0),
    F2 = fun(T, Acc) ->
        case T of
            [GuildId, GuildName, Ranking, Time] ->
                put("confirm_time", Time),
                [{GuildId, GuildName, Ranking}|Acc];
            _ -> Acc
        end
    end,
    QualificationList = lists:foldl(F2, [], List2),
    ConfirmTime = erase("confirm_time"),
    case lib_kf_guild_war:is_kf_guild_war_server() of
        true ->
            SyncRef = erlang:send_after(60 * 1000, self(), {'request_sync_data_from_center'});
        _ ->
            SyncRef = []
    end,
    State = #kf_guild_war_local_state{
        sync_ref = SyncRef,
        donate_map = DonateMap,
        resource_map = ResourceMap,
        qualification_list = QualificationList,
        confirm_time = ConfirmTime
    },
    {ok, State}.

handle_cast(Msg, State) ->
    case catch do_handle_cast(Msg, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_cast Msg:~p error:~p~n", [Msg, Err]),
            {noreply, State}
    end.

do_handle_cast({'msg_center2local', {{call_back, ?MSG_TYPE_LOCAL_INIT}, ActStatus, _Round, Etime}}, State) ->
    #kf_guild_war_local_state{
        confirm_time = ConfirmTime
    } = State,
    case ActStatus of
        ?ACT_STATUS_APPOINT ->
            case lib_kf_guild_war:get_game_type() of
                ?GAME_TYPE_OPEN_SEA ->
                    Nowtime = utime:unixtime(),
                    case utime:is_same_day(ConfirmTime, Nowtime) of
                        false ->
                            NewState = confirm_join_guild(State, Nowtime);
                        _ ->
                            NewState = State
                    end;
                _ ->
                    NewState = State
            end;
        _ ->
            NewState = State
    end,
    LastState = NewState#kf_guild_war_local_state{
        sync = 1,
        status = ActStatus,
        etime = Etime
    },
    {ok, LastState};
do_handle_cast({'msg_center2local', {?MSG_TYPE_ACT_STATUS, ?ACT_STATUS_APPOINT = ActStatus, Round, Etime}}, State) ->
    Nowtime = utime:unixtime(),
    NewState = State#kf_guild_war_local_state{
        sync = 1,
        status = ActStatus,
        round = Round,
        etime = Etime
    },
    GameType = lib_kf_guild_war:get_game_type(),
    case GameType of
        ?GAME_TYPE_OPEN_SEA ->
            case utime:is_same_day(State#kf_guild_war_local_state.confirm_time, Nowtime) of
                false ->
                    LastState = confirm_join_guild(NewState, Nowtime);
                _ ->
                    LastState = NewState
            end,
            %% 通知相关玩家
            mod_guild:apply_cast(lib_kf_guild_war_api, send_tips, [1, LastState#kf_guild_war_local_state.qualification_list]);
        _ ->
            LastState = NewState
    end,
    broadcast_act_info(LastState),
    {ok, LastState};
do_handle_cast({'msg_center2local', {?MSG_TYPE_ACT_STATUS, ActStatus, Round, Etime}}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap
    } = State,
    %% 结算切换要把道具的使用次数信息清理掉
    F = fun(_GuildId, ResourceInfo) ->
        ResourceInfo#resource_info{times_map = #{}}
    end,
    NewResourceMap = maps:map(F, ResourceMap),
    NewState = State#kf_guild_war_local_state{
        status = ActStatus,
        round = Round,
        etime = Etime,
        resource_map = NewResourceMap
    },
    broadcast_act_info(NewState),
    {ok, NewState};
do_handle_cast({'msg_center2local', {?MSG_TYPE_EXCHANGE_SHIP_SUCCESS, RoleId, ShipId}}, State) ->
    lib_player:update_player_ship_info(RoleId, ShipId),
    {ok, BinData} = pt_437:write(43716, [?SUCCESS, ShipId]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};
do_handle_cast({'msg_center2local', _Msg}, State) ->
    ?ERR("handle_msg_center2local ignore:~p", [_Msg]),
    {ok, State};

do_handle_cast({'connect_center'}, State) ->
    %% 连上跨服中心之后向跨服中心请求同步数据
    Node = mod_disperse:get_clusters_node(),
    Args = {?MSG_TYPE_LOCAL_INIT, Node},
    mod_clusters_node:apply_cast(mod_kf_guild_war, msg_local2center, [Args]),
    {ok, State};

do_handle_cast({'send_donate_view_info', RoleId}, State) ->
    #kf_guild_war_local_state{
        qualification_list = QualificationList,
        resource_map = ResourceMap,
        donate_map = DonateMap
    } = State,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_donate_view_info, [Node, RoleId, QualificationList, ResourceMap, DonateMap]),
    {ok, State};

do_handle_cast({'donate_resource', RoleId, GuildId, Type, Cost}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap,
        donate_map = DonateMap
    } = State,
    case Type of
        ?DONATE_TYPE_PROPS ->
            TimesLim = data_kf_guild_war:get_cfg(?CFG_ID_NORMAL_DONATE_TIMES_LIM),
            AddResource = data_kf_guild_war:get_cfg(?CFG_ID_NORMAL_DONATE_ADD_RESOURCE),
            AddFunds = AddResource;
        ?DONATE_TYPE_GOLD ->
            TimesLim = data_kf_guild_war:get_cfg(?CFG_ID_GOLD_DONATE_TIMES_LIM),
            AddResource = data_kf_guild_war:get_cfg(?CFG_ID_GOLD_DONATE_ADD_RESOURCE),
            AddFunds = AddResource;
        _ ->
            TimesLim = 0,
            AddResource = 0,
            AddFunds = 0
    end,
    case maps:get({RoleId, GuildId, Type}, DonateMap, 0) of
        PreTimes when PreTimes < TimesLim ->
            NewTimes = PreTimes + 1,
            NewDonateMap = maps:put({RoleId, GuildId, Type}, NewTimes, DonateMap),
            #resource_info{
                num = PreResource,
                funds = PreFunds,
                props_list = PropsList
            } = ResourceInfo = maps:get(GuildId, ResourceMap, #resource_info{}),
            NewResource = PreResource + AddResource,
            NewFunds = PreFunds + AddFunds,
            NewResourceMap = maps:put(GuildId, ResourceInfo#resource_info{num = NewResource, funds = NewFunds}, ResourceMap),
            F = fun() ->
                db:execute(io_lib:format(?sql_update_kf_gwar_donate_list, [RoleId, GuildId, Type, NewTimes])),
                db:execute(io_lib:format(?sql_update_kf_gwar_resource, [GuildId, NewResource, NewFunds, util:term_to_string(PropsList)])),
                ok
            end,
            case catch db:transaction(F) of
                ok ->
                    %% 日志
                    lib_log_api:log_kf_guild_war_resource(GuildId, RoleId, 1, PreResource, NewResource, Cost, utime:unixtime()),
                    {ok, BinData} = pt_437:write(43709, [?SUCCESS]),
                    lib_server_send:send_to_uid(RoleId, BinData),
                    NewState = State#kf_guild_war_local_state{resource_map = NewResourceMap, donate_map = NewDonateMap},
                    {ok, NewState};
                Err ->
                    ?ERR("donate_resource err:~p", [Err]),
                    {ok, State}
            end;
        _ ->
            {ok, State}
    end;

do_handle_cast({'send_exchange_props_view_info', GuildId, RoleId}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap
    } = State,
    #resource_info{
        num = Resource,
        props_list = PropsList
    } = maps:get(GuildId, ResourceMap, #resource_info{}),
    F = fun(PropsId) ->
        case lists:keyfind(PropsId, 1, PropsList) of
            {PropsId, Num} -> skip;
            _ -> Num = 0
        end,
        {PropsId, Num}
    end,
    PackList = lists:map(F, data_kf_guild_war:get_all_props_ids()),
    {ok, BinData} = pt_437:write(43710, [Resource, PackList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'send_props_view_info', GuildId, RoleId}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap
    } = State,
    #resource_info{
        props_list = PropsList,
        times_map = UseTimesMap
    } = maps:get(GuildId, ResourceMap, #resource_info{}),
    F = fun(PropsId) ->
        case lists:keyfind(PropsId, 1, PropsList) of
            {PropsId, Num} -> skip;
            _ -> Num = 0
        end,
        UseTimes = maps:get(PropsId, UseTimesMap, 0),
        {PropsId, Num, UseTimes}
    end,
    PackList = lists:map(F, data_kf_guild_war:get_all_props_ids()),
    {ok, BinData} = pt_437:write(43717, [PackList]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, State};

do_handle_cast({'send_bid_view_info', GuildId, RoleId, IslandId}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap
    } = State,
    #resource_info{
        funds = Funds
    } = maps:get(GuildId, ResourceMap, #resource_info{}),
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_kf_guild_war, send_bid_view_info, [Node, RoleId, IslandId, Funds]),
    {ok, State};

do_handle_cast({'declare_war', SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid}, State) ->
    #kf_guild_war_local_state{
        status = ActStatus,
        resource_map = ResourceMap,
        qualification_list = QualificationList
    } = State,
    case lists:keyfind(GuildId, 1, QualificationList) of
        false ->
            NewState = State,
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_guild_lim_cant_declare_war));
        _ ->
            case data_kf_guild_war:get_island_cfg(IslandId) of
                #kf_gwar_island_cfg{min_bid = CfgMinBid} when ActStatus == ?ACT_STATUS_APPOINT ->
                    case Bid >= CfgMinBid of
                        true ->
                            #resource_info{
                                num = Resource,
                                funds = Funds,
                                props_list = PropsList
                            } = ResourceInfo = maps:get(GuildId, ResourceMap, #resource_info{}),
                            case Funds >= Bid of
                                true ->
                                    NewFunds = Funds - Bid,
                                    db:execute(io_lib:format(?sql_update_kf_gwar_resource, [GuildId, Resource, NewFunds, util:term_to_string(PropsList)])),
                                    NewResourceInfo = ResourceInfo#resource_info{funds = NewFunds},
                                    NewResourceMap = maps:put(GuildId, NewResourceInfo, ResourceMap),
                                    NewState = State#kf_guild_war_local_state{resource_map = NewResourceMap},
                                    Node = mod_disperse:get_clusters_node(),
                                    mod_clusters_node:apply_cast(mod_kf_guild_war, declare_war, [Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid]);
                                _ ->
                                    lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_not_enough_gfunds_to_declare_war)),
                                    NewState = State
                            end;
                        _ ->
                            NewState = State,
                            lib_kf_guild_war:send_error_code(RoleId, {?ERRCODE(err437_less_than_min_bid), [CfgMinBid]})
                    end;
                #kf_gwar_island_cfg{} ->
                    NewState = State,
                    lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_declare_war_stage_err));
                _ ->
                    NewState = State,
                    lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err_config))
            end
    end,
    {ok, NewState};

do_handle_cast({'add_funds', GuildId, ReturnFunds}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap
    } = State,
    #resource_info{
        num = Resource,
        funds = Funds,
        props_list = PropsList
    } = ResourceInfo = maps:get(GuildId, ResourceMap, #resource_info{}),
    NewFunds = Funds + ReturnFunds,
    db:execute(io_lib:format(?sql_update_kf_gwar_resource, [GuildId, Resource, NewFunds, util:term_to_string(PropsList)])),
    NewResourceInfo = ResourceInfo#resource_info{funds = NewFunds},
    NewResourceMap = maps:put(GuildId, NewResourceInfo, ResourceMap),
    NewState = State#kf_guild_war_local_state{resource_map = NewResourceMap},
    {ok, NewState};

do_handle_cast({'exchange_props', GuildId, GuildName, RoleId, PropsId, Num, CostNum, ExchangeType}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap
    } = State,
    #resource_info{
        num = Resource,
        funds = Funds,
        props_list = PropsList
    } = ResourceInfo = maps:get(GuildId, ResourceMap, #resource_info{}),
    case ExchangeType of
        ?EXCHANEG_TYPE_RESOURCE ->
            CostL = [{resource, CostNum}],
            NewResource = Resource - CostNum;
        _ ->
            CostL = [{?TYPE_BGOLD, 0, CostNum}],
            NewResource = Resource
    end,
    case lists:keyfind(PropsId, 1, PropsList) of
        {PropsId, PreNum} -> skip;
        _ -> PreNum = 0
    end,
    NewNum = PreNum + Num,
    NewPropsList = lists:keystore(PropsId, 1, PropsList, {PropsId, NewNum}),
    db:execute(io_lib:format(?sql_update_kf_gwar_resource, [GuildId, NewResource, Funds, util:term_to_string(NewPropsList)])),
    NewResourceInfo = ResourceInfo#resource_info{num = NewResource, props_list = NewPropsList},
    NewResourceMap = maps:put(GuildId, NewResourceInfo, ResourceMap),

    %% 日志
    Nowtime = utime:unixtime(),
    PropsName = lib_kf_guild_war:get_props_name(PropsId),
    lib_log_api:log_kf_guild_war_props(GuildId, GuildName, RoleId, 1, PropsName, PreNum, NewNum, CostL, Nowtime),
    case ExchangeType of
        ?EXCHANEG_TYPE_RESOURCE ->
            lib_log_api:log_kf_guild_war_resource(GuildId, RoleId, 2, Resource, NewResource, [], Nowtime);
        _ -> skip
    end,

    {ok, BinData} = pt_437:write(43711, [?SUCCESS]),
    lib_server_send:send_to_uid(RoleId, BinData),

    NewState = State#kf_guild_war_local_state{resource_map = NewResourceMap},
    {ok, NewState};

do_handle_cast({'use_props', CopyId, GuildId, GuildName, RoleId, PropsId, ArgsMap}, State) ->
    #kf_guild_war_local_state{
        resource_map = ResourceMap
    } = State,
    #resource_info{
        num = Resource,
        funds = Funds,
        props_list = PropsList,
        times_map = UseTimesMap
    } = ResourceInfo = maps:get(GuildId, ResourceMap, #resource_info{}),
    case lists:keyfind(PropsId, 1, PropsList) of
        {PropsId, Num} when Num > 0 ->
            UseTimes = maps:get(PropsId, UseTimesMap, 0),
            case data_kf_guild_war:get_props_cfg(PropsId) of
                #kf_gwar_props_cfg{
                    times_lim = TimesLim
                } when UseTimes < TimesLim ->
                    case Num == 1 of
                        true ->
                            NewPropsList = lists:keydelete(PropsId, 1, PropsList);
                        _ ->
                            NewPropsList = lists:keyreplace(PropsId, 1, PropsList, {PropsId, Num - 1})
                    end,
                    NewUseTimesMap = maps:put(PropsId, UseTimes + 1, UseTimesMap),
                    NewResourceInfo = ResourceInfo#resource_info{props_list = NewPropsList, times_map = NewUseTimesMap},
                    NewResourceMap = maps:put(GuildId, NewResourceInfo, ResourceMap),
                    db:execute(io_lib:format(?sql_update_kf_gwar_resource, [GuildId, Resource, Funds, util:term_to_string(NewPropsList)])),

                    %% 通知战斗场景使用道具
                    Node = mod_disperse:get_clusters_node(),
                    mod_clusters_node:apply_cast(mod_kf_guild_war_battle, use_props, [CopyId, Node, RoleId, PropsId, ArgsMap]),

                    %% 日志
                    PropsName = lib_kf_guild_war:get_props_name(PropsId),
                    lib_log_api:log_kf_guild_war_props(GuildId, GuildName, RoleId, 2, PropsName, Num, Num - 1, [], utime:unixtime()),

                    {ok, BinData} = pt_437:write(43718, [?SUCCESS]),
                    lib_server_send:send_to_uid(RoleId, BinData),

                    NewState = State#kf_guild_war_local_state{resource_map = NewResourceMap};
                _ ->
                    NewState = State,
                    lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_props_use_times_lim))
            end;
        _ ->
            NewState = State,
            lib_kf_guild_war:send_error_code(RoleId, ?ERRCODE(err437_props_num_not_enough))
    end,
    {ok, NewState};

do_handle_cast({'day_trigger', ?FOUR}, State) ->
    db:execute(?sql_clear_kf_gwar_donate_list),
    NewState = State#kf_guild_war_local_state{donate_map = #{}},
    {ok, NewState};

do_handle_cast({'role_login', GuildId, RoleId}, State) ->
    #kf_guild_war_local_state{
        status = Status
    } = State,
    case Status == ?ACT_STATUS_APPOINT orelse Status == ?ACT_STATUS_BATTLE of
        true ->
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_kf_guild_war, role_login, [Node, GuildId, RoleId]);
        _ -> skip
    end,
    {ok, State};

do_handle_cast({'request_sync_data_from_center'}, State) ->
    #kf_guild_war_local_state{
        sync = IsSync,
        sync_ref = OSyncRef
    } = State,
    util:cancel_timer(OSyncRef),
    case IsSync of
        1 -> NewState = State;
        _ ->
            Node = mod_disperse:get_clusters_node(),
            Args = {?MSG_TYPE_LOCAL_INIT, Node},
            mod_clusters_node:apply_cast(mod_kf_guild_war, msg_local2center, [Args]),
            NSyncRef = erlang:send_after(60 * 1000, self(), {'request_sync_data_from_center'}),
            NewState = State#kf_guild_war_local_state{sync_ref = NSyncRef}
    end,
    {ok, NewState};

do_handle_cast({'gm_confirm_kfgwar_join_guild'}, State) ->
    Node = mod_disperse:get_clusters_node(),
    Args = {?MSG_TYPE_LOCAL_INIT, Node},
    mod_clusters_node:apply_cast(mod_kf_guild_war, msg_local2center, [Args]),
    {ok, State};

do_handle_cast(_Msg, State) -> {ok, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {ok, NewState} ->
            {noreply, NewState};
        Err ->
            ?ERR("handle_info Info:~p error:~p~n", [Info, Err]),
            {noreply, State}
    end.

do_handle_info(_Info, State) -> {ok, State}.

handle_call(Request, _From, State) ->
    case catch do_handle_call(Request, State) of
        {ok, Reply} ->
            {reply, Reply, State};
        {ok, Reply, NewState} ->
            {reply, Reply, NewState};
        Err ->
            ?ERR("handle_call Request:~p error:~p~n", [Request, Err]),
            {noreply, State}
    end.

do_handle_call({'check_donate_resource', RoleId, GuildId, Type}, State) ->
    #kf_guild_war_local_state{
        status = Status,
        etime = Etime,
        donate_map = DonateMap
    } = State,
    Nowtime = utime:unixtime(),
    case Status > ?ACT_STATUS_CLOSE andalso Nowtime < Etime of
        true ->
            case Type of
                ?DONATE_TYPE_PROPS ->
                    TimesLim = data_kf_guild_war:get_cfg(?CFG_ID_NORMAL_DONATE_TIMES_LIM),
                    Cost = data_kf_guild_war:get_cfg(?CFG_ID_NORMAL_DONATE_COST);
                ?DONATE_TYPE_GOLD ->
                    TimesLim = data_kf_guild_war:get_cfg(?CFG_ID_GOLD_DONATE_TIMES_LIM),
                    Cost = data_kf_guild_war:get_cfg(?CFG_ID_GOLD_DONATE_COST);
                _ ->
                    TimesLim = 0,
                    Cost = []
            end,
            case maps:get({RoleId, GuildId, Type}, DonateMap, 0) of
                PreTimes when PreTimes < TimesLim ->
                    {ok, {ok, Cost}, State};
                _ ->
                    {ok, {false, ?ERRCODE(err437_donate_times_lim)}, State}
            end;
        _ ->
            {ok, {false, ?ERRCODE(err437_cant_donate_in_err_stage)}, State}
    end;

do_handle_call({'check_exchange_props', GuildId, PropsId, Num, ExchangeType}, State) ->
    #kf_guild_war_local_state{
        status = Status,
        etime = Etime,
        qualification_list = QualificationList,
        resource_map = ResourceMap
    } = State,
    Nowtime = utime:unixtime(),
    case data_kf_guild_war:get_props_cfg(PropsId) of
        #kf_gwar_props_cfg{
            cost_score = CostScore,
            cost_gold = CostGold
        } ->
            case Status > ?ACT_STATUS_CLOSE andalso Nowtime < Etime of
                true -> %% 对战当天才能购买道具
                    case lists:keyfind(GuildId, 1, QualificationList) of
                        false ->
                            {ok, {false, ?ERRCODE(err437_guild_lim_cant_exchange_props)}, State};
                        _ ->
                            case ExchangeType of
                                ?EXCHANEG_TYPE_RESOURCE ->
                                    #resource_info{num = Resource} = maps:get(GuildId, ResourceMap, #resource_info{}),
                                    case Resource >= CostScore * Num of
                                        true ->
                                            {ok, {ok, CostScore * Num}, State};
                                        _ ->
                                            {ok, {false, ?ERRCODE(err437_score_lim_cant_exchange_props)}, State}
                                    end;
                                ?EXCHANGE_TYPE_GOLD ->
                                    {ok, {ok, CostGold * Num}, State};
                                _ ->
                                    {ok, {false, ?FAIL}, State}
                            end
                    end;
                _ ->
                    {ok, {false, ?ERRCODE(err437_date_lim_cant_exchange_props)}, State}
            end;
        _ ->
            {ok, {false, ?ERRCODE(err_config)}, State}
    end;

do_handle_call({'get_act_status'}, State) ->
    #kf_guild_war_local_state{
        status = Status
    } = State,
    {ok, Status, State};

do_handle_call(_Request, _State) -> {ok, ok}.

terminate(_Reason, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

confirm_join_guild(State, Nowtime) ->
    case catch mod_guild:get_some_top_ranking_guild(?JOIN_GUILD_NUM) of
        GuildList when is_list(GuildList) ->
            F = fun() ->
                db:execute(?sql_clear_kf_gwar_join_guild),
                F1 = fun(GuildInfo, {Ranking, Acc}) ->
                    db:execute(io_lib:format(?sql_insert_kf_gwar_join_guild, [GuildInfo#guild.id, GuildInfo#guild.name, Ranking, Nowtime])),
                    {Ranking + 1, [{GuildInfo#guild.id, GuildInfo#guild.name, Ranking}|Acc]}
                end,
                lists:foldl(F1, {1, []}, GuildList)
            end,
            case catch db:transaction(F) of
                {_, QualificationList} ->
                    ?ERR("confirm join guild result:~p", [QualificationList]),
                    NewState = State#kf_guild_war_local_state{qualification_list = QualificationList};
                Err ->
                    ?ERR("confirm join guild err:~p", [Err]),
                    NewState = State
            end;
        Err ->
            ?ERR("confirm join guild err:~p", [Err]),
            NewState = State
    end,
    NewState.

broadcast_act_info(State) ->
    #kf_guild_war_local_state{status = Status, round = Round, etime = Etime} = State,
    GameType = lib_kf_guild_war:get_game_type(),
    {ok, BinData} = pt_437:write(43701, [Status, Round, GameType, Etime]),
    OpenLv = data_kf_guild_war:get_cfg(?CFG_ID_OPEN_LV),
    lib_server_send:send_to_all(all_lv, {OpenLv, 65535}, BinData).