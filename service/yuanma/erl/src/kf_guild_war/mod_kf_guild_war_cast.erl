%%-----------------------------------------------------------------------------
%% @Module  :       mod_kf_guild_war_cast
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战cast模块
%%-----------------------------------------------------------------------------
-module(mod_kf_guild_war_cast).

-include("kf_guild_war.hrl").
-include("guild.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_goods.hrl").

-export([handle_cast/2]).

handle_cast({'msg_local2center', Msg}, State) ->
    NewState = lib_kf_guild_war_mod:handle_msg_local2center(Msg, State),
    {ok, NewState};

handle_cast({'send_act_info', Node, RoleId}, State) ->
    #kf_guild_war_state{
        status = ActStatus,
        etime = Etime,
        round = Round
    } = State,
    GameType = lib_kf_guild_war:get_game_type(),
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43701, [ActStatus, Round, GameType, Etime]),
    {ok, State};

handle_cast({'send_seas_overview_info', Node, RoleId, MergeSerIds}, State) ->
    #kf_guild_war_state{
        guild_map = GuildMap
    } = State,
    F = fun(T, Acc) ->
        case T of
            #guild_info{
                ser_id = SerId,
                island_id = IslandId
            } ->
                case lists:member(SerId, MergeSerIds) of
                    true -> [IslandId|Acc];
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], maps:values(GuildMap)),
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43702, [PackList]),
    {ok, State};

% handle_cast({'send_seas_info', Node, RoleId, SeasType, SeasSubType, DailyRewardStatus}, State) ->
%     #kf_guild_war_state{
%         guild_map = GuildMap
%     } = State,
%     F = fun(T, Acc) ->
%         case T of
%             #guild_info{
%                 ser_name = SerName,
%                 guild_name = GuildName,
%                 island_id = IslandId
%             } ->
%                 IslandCfg = data_kf_guild_war:get_island_cfg(IslandId),
%                 if
%                     not is_record(IslandCfg, kf_gwar_island_cfg) -> Acc;
%                     SeasType == ?SEAS_TYPE_EDGE_SEA andalso
%                     ((IslandCfg#kf_gwar_island_cfg.seas_type == ?SEAS_TYPE_EDGE_SEA andalso IslandCfg#kf_gwar_island_cfg.seas_subtype == SeasSubType)
%                     orelse IslandCfg#kf_gwar_island_cfg.seas_type == ?SEAS_TYPE_OPEN_SEA) ->
%                         [{SerName, GuildName, IslandId}|Acc];
%                     SeasType == ?SEAS_TYPE_CENTER_SEA andalso IslandCfg#kf_gwar_island_cfg.seas_type =/= ?SEAS_TYPE_EDGE_SEA ->
%                         [{SerName, GuildName, IslandId}|Acc];
%                     true -> Acc
%                 end;
%             _ -> Acc
%         end
%     end,
%     PackList = lists:foldl(F, [], maps:values(GuildMap)),
%     lib_kf_guild_war:send_to_uid(Node, RoleId, 43703, [SeasType, SeasSubType, DailyRewardStatus, PackList]),
%     {ok, State};

handle_cast({'send_seas_info', Node, GuildId, RoleId, _SeasType, _SeasSubType, MergeSerIds, DailyRewardStatus}, State) ->
    #kf_guild_war_state{
        status = ActStatus,
        round = Round,
        island_map = IslandMap,
        guild_map = GuildMap
    } = State,
    GameType = lib_kf_guild_war:get_game_type(),
    #guild_info{
        island_id = IslandId
    } = maps:get(GuildId, GuildMap, #guild_info{}),
    put("entitled_island_id", 0),
    F = fun({OneIslandId, OneIslandInfo}, Acc) ->
        case OneIslandInfo of
            #island_info{
                guild_id = OneGuildId,
                bid_list = BidList
            } ->
                #guild_info{
                    ser_name = OneSerName,
                    guild_name = OneGuildName
                } = maps:get(OneGuildId, GuildMap, #guild_info{}),
                IslandCfg = data_kf_guild_war:get_island_cfg(OneIslandId),
                if
                    not is_record(IslandCfg, kf_gwar_island_cfg) -> skip;
                    true ->
                        #kf_gwar_island_cfg{seas_type = SeasType} = IslandCfg,
                        if
                            GameType == ?GAME_TYPE_OPEN_SEA andalso
                            (ActStatus == ?ACT_STATUS_APPOINT orelse ActStatus == ?ACT_STATUS_CONFIRM orelse (ActStatus == ?ACT_STATUS_BATTLE andalso Round == 1)) andalso
                            SeasType == ?SEAS_TYPE_EDGE_SEA ->
                                case lists:keyfind(GuildId, #bid_info.guild_id, BidList) of
                                    false -> skip;
                                    _ -> put("entitled_island_id", OneIslandId)
                                end;
                            GameType == ?GAME_TYPE_OPEN_SEA andalso ActStatus =/= ?ACT_STATUS_CLOSE andalso SeasType == ?SEAS_TYPE_OPEN_SEA ->
                                FilterIslandIds = data_kf_guild_war:get_island_ids_by_next_id(OneIslandId),
                                case lists:member(IslandId, [OneIslandId|FilterIslandIds]) of
                                    true -> put("entitled_island_id", OneIslandId);
                                    _ -> skip
                                end;
                            GameType == ?GAME_TYPE_INSEA andalso
                            (ActStatus == ?ACT_STATUS_APPOINT orelse ActStatus == ?ACT_STATUS_CONFIRM orelse (ActStatus == ?ACT_STATUS_BATTLE andalso Round == 1)) andalso
                            SeasType == ?SEAS_TYPE_INSEA ->
                                FilterIslandIds = data_kf_guild_war:get_island_ids_by_next_id(OneIslandId),
                                case lists:member(IslandId, [OneIslandId|FilterIslandIds]) of
                                    true -> put("entitled_island_id", OneIslandId);
                                    _ -> skip
                                end;
                            GameType == ?GAME_TYPE_INSEA andalso ActStatus =/= ?ACT_STATUS_CLOSE andalso SeasType == ?SEAS_TYPE_CENTER_SEA ->
                                FilterIslandIds = data_kf_guild_war:get_island_ids_by_next_id(OneIslandId),
                                case lists:member(IslandId, [OneIslandId|FilterIslandIds]) of
                                    true -> put("entitled_island_id", OneIslandId);
                                    _ -> skip
                                end;
                            true -> skip
                        end
                end,
                [{OneIslandId, OneSerName, OneGuildId, OneGuildName}|Acc];
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], maps:to_list(IslandMap)),
    EntitledIslandId = erase("entitled_island_id"),
    F1 = fun(T) ->
        case T of
            #guild_info{
                ser_id = OneSerId,
                island_id = OneIslandId
            } when OneIslandId > 0 -> lists:member(OneSerId, MergeSerIds);
            _ -> false
        end
    end,
    case DailyRewardStatus == 1 of
        true ->
            SelfSerHasIsland = lists:any(F1, maps:values(GuildMap)),
            case SelfSerHasIsland of
                true -> RealDailyRewardStatus = DailyRewardStatus;
                _ -> RealDailyRewardStatus = 0
            end;
        _ -> RealDailyRewardStatus = DailyRewardStatus
    end,
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43703, [RealDailyRewardStatus, EntitledIslandId, PackList]),
    {ok, State};

handle_cast({'send_occupy_reward_info', Node, RoleId, MergeSerIds, DailyRewardStatus}, State) ->
    #kf_guild_war_state{
        guild_map = GuildMap
    } = State,
    F = fun(T, Acc) ->
        case T of
            #guild_info{
                ser_id = SerId,
                ser_name = SerName,
                island_id = IslandId,
                guild_name = GuildName
            } ->
                case lists:member(SerId, MergeSerIds) of
                    true ->
                        IslandCfg = data_kf_guild_war:get_island_cfg(IslandId),
                        if
                            not is_record(IslandCfg, kf_gwar_island_cfg) -> Acc;
                            true ->
                                [{IslandCfg#kf_gwar_island_cfg.seas_type, IslandCfg#kf_gwar_island_cfg.seas_subtype, IslandId, SerName, GuildName}|Acc]
                        end;
                    _ -> Acc
                end;
            _ ->
                Acc
        end
    end,
    PackList = lists:foldl(F, [], maps:values(GuildMap)),
    case DailyRewardStatus == 1 of
        true ->
            case PackList =/= [] of
                true -> RealDailyRewardStatus = DailyRewardStatus;
                _ -> RealDailyRewardStatus = 0
            end;
        _ -> RealDailyRewardStatus = DailyRewardStatus
    end,
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43704, [RealDailyRewardStatus, PackList]),
    {ok, State};

handle_cast({'receive_daily_reward', Node, RoleId, GuildId, GuildPos, MergeSerIds}, State) ->
    #kf_guild_war_state{
        guild_map = GuildMap
    } = State,
    F = fun(T, Acc) ->
        case T of
            #guild_info{
                guild_id = OneGuildId,
                ser_id = OneSerId,
                island_id = OneIslandId
            } ->
                case lists:member(OneSerId, MergeSerIds) of
                    true ->
                        case data_kf_guild_war:get_island_cfg(OneIslandId) of
                            #kf_gwar_island_cfg{
                                chief_reward = ChiefReward,
                                member_reward = MemberReward,
                                normal_reward = NormalReward
                            } ->
                                if
                                    OneGuildId == GuildId andalso GuildPos == ?POS_CHIEF ->
                                        [ChiefReward|Acc];
                                    OneGuildId == GuildId ->
                                        [MemberReward|Acc];
                                    true ->
                                        [NormalReward|Acc]
                                end;
                            _ -> Acc
                        end;
                    _ -> Acc
                end;
            _ -> Acc
        end
    end,
    RewardList = lists:foldl(F, [], maps:values(GuildMap)),
    mod_clusters_center:apply_cast(Node, lib_kf_guild_war_api, send_daily_reward, [RoleId, RewardList]),
    {ok, State};

handle_cast({'send_season_reward_info', Node, RoleId}, State) ->
    #kf_guild_war_state{
        guild_map = GuildMap
    } = State,
    GuildList = maps:values(GuildMap),
    F = fun(Ranking, Acc) ->
        case data_kf_guild_war:get_season_reward(Ranking) of
            #kf_gwar_season_reward_cfg{
                reward = SeasonReward
            } when SeasonReward =/= [] ->
                case lists:keyfind(Ranking, #guild_info.ranking, GuildList) of
                    #guild_info{
                        ser_name = SerName,
                        guild_id = GuildId,
                        guild_name = GuildName,
                        score = Score,
                        ranking = Ranking
                    } ->
                        [{Ranking, SerName, GuildId, GuildName, Score, SeasonReward}|Acc];
                    _ ->
                        [{Ranking, <<>>, 0, <<>>, 0, SeasonReward}|Acc]
                end;
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], data_kf_guild_war:get_season_reward_ranking()),
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43706, [PackList]),
    {ok, State};

handle_cast({'send_seas_dominator_info', Node, RoleId}, State) ->
    #kf_guild_war_state{
        guild_map = GuildMap,
        island_map = IslandMap
    } = State,
    case data_kf_guild_war:get_island_ids_by_type(?SEAS_TYPE_CENTER_SEA) of
        [CodeIslandId|_] ->
            case maps:get(CodeIslandId, IslandMap, false) of
                #island_info{
                    guild_id = DominatorGuildId
                } when DominatorGuildId > 0 ->
                    #guild_info{
                        ser_id = SerId,
                        ser_name = DominatorSerName,
                        guild_name = DominatorGuildName,
                        island_utime = LastOccupyTime
                    } = maps:get(DominatorGuildId, GuildMap, #guild_info{}),
                    OccupationDays = utime:diff_days(utime:unixtime(), LastOccupyTime) + 1,
                    mod_clusters_center:apply_cast(SerId, mod_guild, send_seas_dominator_info, [Node, RoleId, DominatorGuildId]),
                    lib_kf_guild_war:send_to_uid(Node, RoleId, 43707, [DominatorSerName, DominatorGuildId, DominatorGuildName, OccupationDays]);
                _ ->
                    lib_kf_guild_war:send_to_uid(Node, RoleId, 43707, [<<>>, 0, <<>>, 0])
            end;
        _ ->
            lib_kf_guild_war:send_to_uid(Node, RoleId, 43707, [<<>>, 0, <<>>, 0])
    end,
    {ok, State};

handle_cast({'send_donate_view_info', Node, RoleId, QualificationList, ResourceMap, DonateMap}, State) ->
    #kf_guild_war_state{
        guild_map = GuildMap
    } = State,
    F = fun({GuildId, GuildName, Ranking}, Acc) ->
        #guild_info{island_id = IslandId} = maps:get(GuildId, GuildMap, #guild_info{}),
        #resource_info{num = ResourceNum, funds = Funds} = maps:get(GuildId, ResourceMap, #resource_info{}),
        F1 = fun(DonateType) ->
            case DonateType of
                ?DONATE_TYPE_PROPS ->
                    TimesLim = data_kf_guild_war:get_cfg(?CFG_ID_NORMAL_DONATE_TIMES_LIM);
                ?DONATE_TYPE_GOLD ->
                    TimesLim = data_kf_guild_war:get_cfg(?CFG_ID_GOLD_DONATE_TIMES_LIM);
                _ ->
                    TimesLim = 0
            end,
            UseTimes = maps:get({RoleId, GuildId, DonateType}, DonateMap, 0),
            {DonateType, max(0, TimesLim - UseTimes)}
        end,
        DonateList = lists:map(F1, ?DONATE_TYPE_LIST),
        [{GuildId, GuildName, Ranking, IslandId, ResourceNum, Funds, DonateList}|Acc]
    end,
    PackList = lists:foldl(F, [], QualificationList),
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43708, [PackList]),
    {ok, State};

handle_cast({'send_declare_war_view_info', Node, GuildId, RoleId, IslandId}, State) ->
    GameType = lib_kf_guild_war:get_game_type(),
    lib_kf_guild_war_mod:send_declare_war_view_info(Node, GuildId, RoleId, IslandId, GameType, State),
    {ok, State};

handle_cast({'send_bid_view_info', Node, RoleId, IslandId, GuildFunds}, State) ->
    case data_kf_guild_war:get_island_cfg(IslandId) of
        #kf_gwar_island_cfg{min_bid = MinBid} ->
            lib_kf_guild_war:send_to_uid(Node, RoleId, 43727, [MinBid, GuildFunds]);
        _ ->
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err_config))
    end,
    {ok, State};

handle_cast({'declare_war', Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, Bid}, State) ->
    #kf_guild_war_state{
        status = ActStatus,
        island_map = IslandMap,
        guild_map = GuildMap,
        bid_index = BidIndexMap
    } = State,
    case data_kf_guild_war:get_island_cfg(IslandId) of
        #kf_gwar_island_cfg{seas_type = ?SEAS_TYPE_EDGE_SEA, name = IslandName, min_bid = CfgMinBid} when ActStatus == ?ACT_STATUS_APPOINT ->
            #island_info{guild_id = OccupyGuildId, bid_list = BidList} = IslandInfo = maps:get(IslandId, IslandMap, #island_info{}),
            case maps:get(GuildId, GuildMap, #guild_info{}) of
                #guild_info{
                    island_id = OccupyIslandId
                } when OccupyIslandId == 0 ->
                    case maps:get(GuildId, BidIndexMap, false) of
                        false ->
                            case Bid >= CfgMinBid of
                                true ->
                                    Result = ok,
                                    NowTime = utime:unixtime(),
                                    db:execute(io_lib:format(?sql_update_kf_gwar_bid, [GuildId, GuildName, SerId, SerName, IslandId, Bid, NowTime])),
                                    BidInfo = #bid_info{ser_id = SerId, ser_name = SerName, guild_id = GuildId, guild_name = GuildName, bid = Bid, time = NowTime},
                                    NewBidList = lib_kf_guild_war_mod:sort_bid_list([BidInfo|BidList]),
                                    NewIslandInfo = IslandInfo#island_info{bid_list = NewBidList},
                                    NewIslandMap = maps:put(IslandId, NewIslandInfo, IslandMap),

                                    NewBidIndexMap = maps:put(GuildId, IslandId, BidIndexMap),

                                    %% 失去宣战资格的要发邮件通知
                                    case OccupyGuildId > 0 of
                                        true ->
                                            NeedNotifyLen = 3;
                                        _ ->
                                            NeedNotifyLen = 4
                                    end,
                                    case length(BidList) >= NeedNotifyLen of
                                        true ->
                                            #bid_info{ser_id = NeedNotifySerId, guild_id = NeedNotifyGuildId, bid = NeedNotifyGuildBid} = lists:nth(NeedNotifyLen, BidList),
                                            case Bid > NeedNotifyGuildBid of
                                                true ->
                                                    mod_clusters_center:apply_cast(NeedNotifySerId, mod_guild, apply_cast, [lib_kf_guild_war_api, send_mail_to_chief, [NeedNotifyGuildId, utext:get(4370009), utext:get(4370010)]]);
                                                _ -> skip
                                            end;
                                        _ -> skip
                                    end,
                                    %% 日志
                                    lib_log_api:log_kf_guild_war_bid(SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, IslandName, 1, [{funds, Bid}], NowTime),

                                    lib_kf_guild_war:send_to_uid(Node, RoleId, 43728, [?SUCCESS, IslandId]),
                                    NewState = State#kf_guild_war_state{island_map = NewIslandMap, bid_index = NewBidIndexMap};
                                _ ->
                                    Result = fail,
                                    NewState = State,
                                    lib_kf_guild_war:send_error_code(Node, RoleId, {?ERRCODE(err437_less_than_min_bid), [CfgMinBid]})
                            end;
                        _ ->
                            Result = fail,
                            NewState = State,
                            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_already_bid_island))
                    end;
                _ ->
                    Result = fail,
                    NewState = State,
                    lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_cant_declare_war_cuz_has_island))
            end;
        #kf_gwar_island_cfg{} ->
            Result = fail,
            NewState = State,
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_declare_war_stage_err));
        _ ->
            Result = fail,
            NewState = State,
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err_config))
    end,
    case Result of
        fail ->
            mod_clusters_center:apply_cast(Node, lib_kf_guild_war_api, return_bid_gfunds, [GuildId, Bid, declare_war_return]);
        _ -> skip
    end,
    {ok, NewState};

handle_cast({'cancel_declare_war', Node, SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId}, #kf_guild_war_state{status = ?ACT_STATUS_APPOINT} = State) ->
    #kf_guild_war_state{
        island_map = IslandMap,
        bid_index = BidIndexMap
    } = State,
    #island_info{bid_list = BidList} = IslandInfo = maps:get(IslandId, IslandMap, #island_info{}),
    case lists:keyfind(GuildId, #bid_info.guild_id, BidList) of
        #bid_info{
            bid = Bid
        } ->
            db:execute(io_lib:format(?sql_delete_kf_gwar_bid, [GuildId])),
            NewBidList = lists:keydelete(GuildId, #bid_info.guild_id, BidList),
            LastBidList = lib_kf_guild_war_mod:sort_bid_list(NewBidList),
            NewIslandInfo = IslandInfo#island_info{bid_list = LastBidList},
            NewIslandMap = maps:put(IslandId, NewIslandInfo, IslandMap),

            NewBidIndexMap = maps:remove(GuildId, BidIndexMap),
            %% 日志
            IslandName = lib_kf_guild_war:get_island_name(IslandId),
            lib_log_api:log_kf_guild_war_bid(SerId, SerName, GuildId, GuildName, RoleId, RoleName, IslandId, IslandName, 2, [{funds, Bid}], utime:unixtime()),

            mod_clusters_center:apply_cast(Node, lib_kf_guild_war_api, return_bid_gfunds, [GuildId, Bid, cancel_declare_war]),

            lib_kf_guild_war:send_to_uid(Node, RoleId, 43729, [?SUCCESS, IslandId]),
            NewState = State#kf_guild_war_state{island_map = NewIslandMap, bid_index = NewBidIndexMap};
        _ ->
            NewState = State,
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_no_bid_this_island))
    end,
    {ok, NewState};

handle_cast({'enter_scene', Node, SerId, SerName, GuildId, RoleId, RoleName}, State) ->
    #kf_guild_war_state{
        status = ActStatus,
        room_index = RoomIndexMap
    } = State,
    case ActStatus of
        ?ACT_STATUS_BATTLE ->
            case maps:get(GuildId, RoomIndexMap, 0) of
                Pid when is_pid(Pid) ->
                    mod_kf_guild_war_battle:enter_scene(Pid, Node, SerId, SerName, GuildId, RoleId, RoleName);
                _ ->
                    lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_cant_enter_scene_no_qualifications))
            end;
        _ ->
            lib_kf_guild_war:send_error_code(Node, RoleId, ?ERRCODE(err437_cant_enter_scene_not_in_battle_stage))
    end,
    {ok, State};

handle_cast({'island_battle_end', IslandId, GuildList}, State) ->
    #kf_guild_war_state{
        round = Round,
        guild_map = GuildMap,
        island_map = IslandMap
    } = State,
    NowTime = utime:unixtime(),
    GameType = lib_kf_guild_war:get_game_type(),
    F = fun() ->
        lib_kf_guild_war_mod:island_battle_end(GuildList, GameType, Round, IslandId, NowTime, IslandMap, GuildMap)
    end,
    case catch db:transaction(F) of
        {NewIslandMap, NewGuildMap} ->
            SortGuildList = lib_kf_guild_war_mod:sort_guild_list(maps:values(NewGuildMap)),
            LastGuildMap = maps:from_list(SortGuildList),
            NewState = State#kf_guild_war_state{island_map = NewIslandMap, guild_map = LastGuildMap};
        _Err ->
            ?ERR("island_battle_end err:~p island_id:~p result_list:~p", [_Err, IslandId, GuildList]),
            NewState = State
    end,
    {ok, NewState};

handle_cast({'reset_season'}, #kf_guild_war_state{status = ?ACT_STATUS_CLOSE} = State) ->
    NewState = lib_kf_guild_war_mod:reset_season(State),
    {ok, NewState};

handle_cast({'role_login', Node, GuildId, RoleId}, State) ->
    #kf_guild_war_state{
        status = ActStatus,
        room_index = RoomIndexMap
    } = State,
    case maps:get(GuildId, RoomIndexMap, false) of
        false -> skip;
        _ ->
            case ActStatus of
                ?ACT_STATUS_APPOINT ->
                    lib_kf_guild_war:send_to_uid(Node, RoleId, 43735, [1]);
                ?ACT_STATUS_BATTLE ->
                    lib_kf_guild_war:send_to_uid(Node, RoleId, 43735, [2]);
                _ -> skip
            end
    end,
    {ok, State};

%% -------------------------- 秘籍 ------------------------------
handle_cast({'gm_next'}, #kf_guild_war_state{status = ?ACT_STATUS_CLOSE} = State) ->
    #kf_guild_war_state{ref = ORef} = State,
    util:cancel_timer(ORef),
    NRef = erlang:send_after(1 * 1000, self(), {'appoint'}),
    NewState = State#kf_guild_war_state{ref = NRef},
    {ok, NewState};
handle_cast({'gm_next'}, #kf_guild_war_state{status = ?ACT_STATUS_APPOINT} = State) ->
    #kf_guild_war_state{ref = ORef} = State,
    util:cancel_timer(ORef),
    NRef = erlang:send_after(1 * 1000, self(), {'confirm'}),
    NewState = State#kf_guild_war_state{ref = NRef},
    {ok, NewState};
handle_cast({'gm_next'}, #kf_guild_war_state{status = ?ACT_STATUS_CONFIRM} = State) ->
    #kf_guild_war_state{ref = ORef} = State,
    util:cancel_timer(ORef),
    NRef = erlang:send_after(1 * 1000, self(), {'battle'}),
    NewState = State#kf_guild_war_state{ref = NRef},
    {ok, NewState};
handle_cast({'gm_next'}, #kf_guild_war_state{status = ?ACT_STATUS_BATTLE} = State) ->
    #kf_guild_war_state{ref = ORef, round = Round} = State,
    util:cancel_timer(ORef),
    case Round of
        1 ->
            NRef = erlang:send_after(1 * 1000, self(), {'rest'});
        _ ->
            NRef = erlang:send_after(1 * 1000, self(), {'act_end'})
    end,
    NewState = State#kf_guild_war_state{ref = NRef},
    {ok, NewState};
handle_cast({'gm_next'}, #kf_guild_war_state{status = ?ACT_STATUS_REST} = State) ->
    #kf_guild_war_state{ref = ORef} = State,
    util:cancel_timer(ORef),
    NRef = erlang:send_after(1 * 1000, self(), {'battle'}),
    NewState = State#kf_guild_war_state{ref = NRef},
    {ok, NewState};

handle_cast({'recheck_stage'}, #kf_guild_war_state{status = ?ACT_STATUS_CLOSE} = State) ->
    #kf_guild_war_state{ref = ORef} = State,
    util:cancel_timer(ORef),
    NRef = erlang:send_after(1 * 1000, self(), {'check_stage'}),
    NewState = State#kf_guild_war_state{ref = NRef},
    {ok, NewState};

handle_cast({'clear_guild_info', GuildId}, #kf_guild_war_state{status = ?ACT_STATUS_CLOSE} = State) ->
    #kf_guild_war_state{
        guild_map = GuildMap,
        island_map = IslandMap
    } = State,
    db:execute(io_lib:format(<<"delete from kf_guild_war_guild where guild_id = ~p">>, [GuildId])),
    F = fun({IslandId, IslandInfo}, Map) ->
        case IslandInfo of
            #island_info{
                guild_id = GuildId
            } ->
                NewIslandInfo = IslandInfo#island_info{guild_id = 0},
                maps:put(IslandId, NewIslandInfo, Map);
            _ ->
                maps:put(IslandId, IslandInfo, Map)
        end
    end,
    NewIslandMap = lists:foldl(F, #{}, maps:to_list(IslandMap)),
    NewState = State#kf_guild_war_state{
        guild_map = maps:remove(GuildId, GuildMap),
        island_map = NewIslandMap
    },
    {ok, NewState};

handle_cast(_Msg, State) ->
    ?ERR("ignore info:~p State:~p", [_Msg, State]),
    {ok, State}.