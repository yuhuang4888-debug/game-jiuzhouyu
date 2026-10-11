%%%--------------------------------------
%%% @Module  : mod_collect
%%% @Author  : huyihao
%%% @Created : 2018.04.25
%%% @Description:  我爱女神
%%%--------------------------------------
-module(mod_collect).

-include("server.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("language.hrl").
-include("custom_act.hrl").
-include("collect.hrl").
-include("mail.hrl").
-include("predefine.hrl").

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
    open_collect/2,
    collect_put/4,
    day_clear/1,
    day_clear/0,
    act_end/1,
    get_collect_status/0
    ]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

open_collect(SubType, RoleId) ->
    gen_server:cast(?MODULE, {open_collect, SubType, RoleId}).

collect_put(SubType, PutType, RoleId, Mark) ->
    gen_server:cast(?MODULE, {collect_put, SubType, PutType, RoleId, Mark}).

day_clear(_Time) ->
    util:rand_time_to_delay(1000, mod_collect, day_clear, []).

day_clear() ->
    gen_server:cast(?MODULE, {day_clear}).

act_end(SubType) ->
    gen_server:cast(?MODULE, {act_end, SubType}).

get_collect_status() ->
    gen_server:call(?MODULE, {get_collect_status}).

init([]) ->
    AllNumSqlList = db:get_all(?SelectCollectAllNumAllSql),
    PlayInfoSqlList = db:get_all(?SelectCollectPlayerInfoAllSql),
    F = fun(AllNumSqlInfo, {DeleteList1, SubTypeList1}) ->
        [SubType, AllNum, ExpEndTime, DropEndTime] = AllNumSqlInfo,
        case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_COLLECT, SubType) of
            false ->
                {[SubType|DeleteList1], SubTypeList1};
            true ->
                F1 = fun(PlayerSqlInfo, PlayerInfoList1) ->
                    [SubType1, RoleId, SelfPoint, SRewardIdlist] = PlayerSqlInfo,
                    case SubType1 of
                        SubType ->
                            RewardIdList = util:bitstring_to_term(SRewardIdlist),
                            PlayerInfo = #collect_player_info{
                                role_id = RoleId, 
                                player_point = SelfPoint,
                                get_reward_id_list = RewardIdList
                            },
                            [PlayerInfo|PlayerInfoList1];
                        _ ->
                            PlayerInfoList1
                    end
                end,
                PlayerInfoList = lists:foldl(F1, [], PlayInfoSqlList),
                CollectInfo = #collect_info{
                    subtype = SubType,
                    all_point = AllNum,
                    exp_end_time = ExpEndTime,
                    drop_end_time = DropEndTime,
                    player_list = PlayerInfoList
                },
                {DeleteList1, [CollectInfo|SubTypeList1]}
        end
    end,
    {DeleteList, SubTypeList} = lists:foldl(F, {[], []}, AllNumSqlList),
    case DeleteList of
        [] ->
            skip;
        _ ->
            DeleteListStr = ulists:list_to_string(DeleteList, ","),
            ReSql1 = io_lib:format(?DeleteCollectAllNumSql, [DeleteListStr]),
            ReSql2 = io_lib:format(?DeleteCollectPlayerInfoSql, [DeleteListStr]),
            db:execute(ReSql1),
            db:execute(ReSql2)
    end,
    State = #collect_state{
        subtype_list = SubTypeList
    },
    {ok, State}.

handle_call(Request, From, State) ->
    case catch do_handle_call(Request, From, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {reply, ok, State};
        Result ->
            Result
    end.

do_handle_call({get_collect_status}, _From, State) ->
    #collect_state{
        subtype_list = SubTypeList
    } = State,
    case SubTypeList of
        [] ->
            ExpEndTime = 0,
            DropEndTime = 0;
        [CollectInfo|_] ->
            #collect_info{
                exp_end_time = ExpEndTime,
                drop_end_time = DropEndTime
            } = CollectInfo
    end,
    CollectStatus = #collect_status{
        exp_end_time = ExpEndTime,
        drop_end_time = DropEndTime
    },
    {reply, CollectStatus, State};

do_handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(Info, State) ->
    case catch do_handle_cast(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_cast({open_collect, SubType, RoleId}, State) ->
    #collect_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #collect_info.subtype, SubTypeList) of
        false ->
            AllPoint = 0,
            SelfPoint = 0,
            ExpEndTime = 0,
            DropEndTime = 0,
            GetRewardIdList = [];
        CollectInfo ->
            #collect_info{
                all_point = AllPoint,
                exp_end_time = ExpEndTime,
                drop_end_time = DropEndTime,
                player_list = PlayerList
            } = CollectInfo,
            case lists:keyfind(RoleId, #collect_player_info.role_id, PlayerList) of
                false ->
                    SelfPoint = 0,
                    GetRewardIdList = [];
                PlayerInfo ->
                    #collect_player_info{
                        player_point = SelfPoint,
                        get_reward_id_list = GetRewardIdList
                    } = PlayerInfo
            end
    end,
    {ok, Bin} = pt_331:write(33162, [?SUCCESS, SubType, AllPoint, SelfPoint, ExpEndTime, DropEndTime, GetRewardIdList]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, State};

do_handle_cast({open_collect_all, SubType}, State) ->
    #collect_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #collect_info.subtype, SubTypeList) of
        false ->
            {ok, Bin} = pt_331:write(33162, [?SUCCESS, SubType, 0, 0, 0, 0, []]),
            lib_server_send:send_to_all(Bin);
        CollectInfo ->
            #collect_info{
                all_point = AllPoint,
                exp_end_time = ExpEndTime,
                drop_end_time = DropEndTime,
                player_list = PlayerList
            } = CollectInfo,
            Data = ets:tab2list(?ETS_ONLINE),
            [begin
                RoleId = D#ets_online.id,
                case lists:keyfind(RoleId, #collect_player_info.role_id, PlayerList) of
                    false ->
                        SelfPoint = 0,
                        GetRewardIdList = [];
                    PlayerInfo ->
                        #collect_player_info{
                            player_point = SelfPoint,
                            get_reward_id_list = GetRewardIdList
                        } = PlayerInfo
                end,
                {ok, Bin} = pt_331:write(33162, [?SUCCESS, SubType, AllPoint, SelfPoint, ExpEndTime, DropEndTime, GetRewardIdList]),
                lib_server_send:send_to_uid(RoleId, Bin)
            end||D <- Data]
    end,
    {noreply, State};

do_handle_cast({collect_put, SubType, PutType, RoleId, Mark}, State) ->
    #collect_state{
        subtype_list = SubTypeList
    } = State,
    case lists:keyfind(SubType, #collect_info.subtype, SubTypeList) of
        false ->
            NewSelfPoint = 1,
            NewAllPoint1 = 1,
            OldPlayerList = [],
            OldRewardIdList = [],
            OldPlayerInfo = #collect_player_info{
                role_id = RoleId
            },
            OldCollectInfo = #collect_info{
                subtype = SubType
            };
        OldCollectInfo ->
            #collect_info{
                all_point = OldAllPoint,
                player_list = OldPlayerList
            } = OldCollectInfo,
            NewAllPoint1 = OldAllPoint + 1,
            case lists:keyfind(RoleId, #collect_player_info.role_id, OldPlayerList) of
                false ->
                    NewSelfPoint = 1,
                    OldRewardIdList = [],
                    OldPlayerInfo = #collect_player_info{
                        role_id = RoleId
                    };
                OldPlayerInfo ->
                    #collect_player_info{
                        player_point = OldSelfPoint,
                        get_reward_id_list = OldRewardIdList
                    } = OldPlayerInfo,
                    NewSelfPoint = OldSelfPoint + 1
            end
    end,
    case Mark of
        1 ->
            NewAllPoint = NewAllPoint1 - 1;
        _ ->
            NewAllPoint = NewAllPoint1
    end,
    PointStageList = data_collect:get_collect_self_stage_list(SubType, ?TypeSelfSpecial),
    case lists:member(NewSelfPoint, PointStageList) of
        false ->
            RewardType = ?TypeSelfNormal,
            WeightList = data_collect:get_collect_self_weight_list(SubType, RewardType);
        true ->
            RewardType = ?TypeSelfSpecial,
            WeightList1 = data_collect:get_collect_self_weight_list(SubType, RewardType),
            Fweight = fun({Weight, RewardIdWeight}, UseWeightList) ->
                case lists:member(RewardIdWeight, OldRewardIdList) of
                    false ->
                        [{Weight, RewardIdWeight}|UseWeightList];
                    true ->
                        UseWeightList
                end
            end,
            WeightList = lists:foldl(Fweight, [], WeightList1)
    end,
    RewardId = urand:rand_with_weight(WeightList),
    SelfRewardCon = data_collect:get_collect_self_reward_con(SubType, RewardType, RewardId),
    #collect_self_reward_con{
        goods_list = RewardList
    } = SelfRewardCon,
    case RewardType of
        ?TypeSelfNormal ->
            RewardIdList = OldRewardIdList,
            lib_goods_api:send_reward_by_id(RewardList, collect_put_n, SubType, RoleId);
        _ ->
            RewardIdList = [RewardId|OldRewardIdList],
            lib_goods_api:send_reward_by_id(RewardList, collect_put_s, SubType, RoleId)
    end,
    NewPlayerInfo = OldPlayerInfo#collect_player_info{
        player_point = NewSelfPoint,
        get_reward_id_list = RewardIdList
    },
    SRewardIdlist = util:term_to_string(RewardIdList),
    ReSql1 = io_lib:format(?ReplaceCollectPlayerInfoSql, [SubType, RoleId, NewSelfPoint, SRewardIdlist]),
    db:execute(ReSql1),
    NewPlayerList = lists:keystore(RoleId, #collect_player_info.role_id, OldPlayerList, NewPlayerInfo),
    NewCollectInfo1 = OldCollectInfo#collect_info{
        all_point = NewAllPoint,
        player_list = NewPlayerList
    },
    AllRewardPointList = data_collect:get_collect_all_reward_point_list(SubType),
    case lists:keyfind(NewAllPoint, 1, AllRewardPointList) of
        false ->
            AllRewardId = 0,
            Type = 0,
            NewCollectInfo = NewCollectInfo1;
        {_, AllRewardId} ->
            AllRewardCon = data_collect:get_collect_all_reward_con(SubType, AllRewardId),
            #collect_all_reward_con{
                type = Type,
                time = Time,
                goods_list = GoodsList
            } = AllRewardCon,
            NowTime = utime:unixtime(),
            {put_goods_list, CostList} = lib_custom_act_util:keyfind_act_condition(?CUSTOM_ACT_TYPE_COLLECT, SubType, put_goods_list),
            [{_GoodsType, GoodsId, _GoodsNum}|_] = CostList,
            Data = ets:tab2list(?ETS_ONLINE),
            case Type of
                ?TypeDoubleExp ->
                    case NowTime + Time > NewCollectInfo1#collect_info.exp_end_time of
                        false ->
                            NewCollectInfo = NewCollectInfo1;
                        true ->
                            NewCollectInfo = NewCollectInfo1#collect_info{
                                exp_end_time = NowTime + Time
                            },
                            [lib_player:apply_cast(D#ets_online.pid, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_collect, update_collect_status, [NewCollectInfo#collect_info.exp_end_time, NewCollectInfo#collect_info.drop_end_time]) || D <- Data]
                    end,
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 11, [GoodsId, NewAllPoint]),
                    gen_server:cast(self(), {open_collect_all, SubType});
                ?TypeDoubleDungeon ->
                    case NowTime + Time > NewCollectInfo1#collect_info.drop_end_time of
                        false ->
                            NewCollectInfo = NewCollectInfo1;
                        true ->
                            NewCollectInfo = NewCollectInfo1#collect_info{
                                drop_end_time = NowTime + Time
                            },
                            [lib_player:apply_cast(D#ets_online.pid, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_collect, update_collect_status, [NewCollectInfo#collect_info.exp_end_time, NewCollectInfo#collect_info.drop_end_time]) || D <- Data]
                    end,
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 12, [GoodsId, NewAllPoint]),
                    gen_server:cast(self(), {open_collect_all, SubType});
                ?TypeBossReset ->
                    NewCollectInfo = NewCollectInfo1,
                    mod_boss:refresh_killed_boss(),
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 13, [GoodsId, NewAllPoint]),
                    gen_server:cast(self(), {open_collect_all, SubType});
                ?TypeAllReward ->
                    OpenLv = lib_module:get_open_lv(?MOD_AC_CUSTOM, ?CUSTOM_ACT_TYPE_COLLECT),
                    ActName = lib_custom_act_util:get_act_name(?CUSTOM_ACT_TYPE_COLLECT, SubType),
                    Title = utext:get(?LAN_TITLE_COLLECT_ALL_REWARD, [ActName]),
                    Content = utext:get(?LAN_CONTENT_COLLECT_ALL_REWARD, [GoodsId, NewAllPoint]),
                    SGoodsList = util:term_to_string(GoodsList),
                    lib_mail_api:send_sys_mail_to_all(Title, Content, SGoodsList, [], OpenLv, ?SEND_LOG_TYPE_YES),
                    NewCollectInfo = NewCollectInfo1,
                    lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 14, [GoodsId, NewAllPoint]),
                    gen_server:cast(self(), {open_collect_all, SubType});
                _ ->
                    NewCollectInfo = NewCollectInfo1
            end
    end,
    ReSql2 = io_lib:format(?ReplaceCollectAllNumSql, [SubType, NewAllPoint, NewCollectInfo#collect_info.exp_end_time, NewCollectInfo#collect_info.drop_end_time]),
    db:execute(ReSql2),
    NewSubTypeList = lists:keystore(SubType, #collect_info.subtype, SubTypeList, NewCollectInfo),
    NewState = State#collect_state{
        subtype_list = NewSubTypeList
    },
    lib_log_api:log_collect_put(SubType, AllRewardId, Type, NewAllPoint, RoleId, PutType, RewardId, RewardType, NewSelfPoint),
    {ok, Bin} = pt_331:write(33163, [?SUCCESS, SubType, PutType, RewardType, RewardId]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {noreply, NewState};

do_handle_cast({day_clear}, State) ->
    #collect_state{
        subtype_list = SubTypeList
    } = State,
    NewSubTypeList = [begin
        CollectInfo#collect_info{
            all_point = 0
        }
    end||CollectInfo <- SubTypeList],
    db:execute(?DeleteCollectAllNumAllSql),
    NewState = State#collect_state{
        subtype_list = NewSubTypeList
    },
    {noreply, NewState};

do_handle_cast({act_end, SubType}, State) ->
    #collect_state{
        subtype_list = SubTypeList
    } = State,
    NewSubTypeList = lists:keydelete(SubType, #collect_info.subtype, SubTypeList),
    DeleteListStr = ulists:list_to_string([SubType], ","),
    ReSql1 = io_lib:format(?DeleteCollectAllNumSql, [DeleteListStr]),
    ReSql2 = io_lib:format(?DeleteCollectPlayerInfoSql, [DeleteListStr]),
    db:execute(ReSql1),
    db:execute(ReSql2),
    NewState = State#collect_state{
        subtype_list = NewSubTypeList
    },
    {noreply, NewState};

do_handle_cast(_Info, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {'EXIT', _Reason} ->
            ?ERR("~p ~p _Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        Res ->
            Res
    end.

do_handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.