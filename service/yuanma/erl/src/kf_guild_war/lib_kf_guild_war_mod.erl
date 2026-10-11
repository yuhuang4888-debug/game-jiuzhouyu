%%-----------------------------------------------------------------------------
%% @Module  :       lib_kf_guild_war_mod
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2018-06-24
%% @Description:    跨服公会战
%%-----------------------------------------------------------------------------
-module(lib_kf_guild_war_mod).

-include("kf_guild_war.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("def_module.hrl").

-export([
    init/1
    , confirm_group_in_init/2
    , handle_stage_close2appoint/1
    , handle_stage_appoint2confirm/1
    , sort_bid_list/1
    , sort_guild_list/1
    , start_score_ref/1
    , start_battle/3
    , send_declare_war_view_info/6
    , island_battle_end/7
    , battle_end/2
    , send_season_reward/2
    , reset_season/1
    ]).

-export([
    handle_msg_local2center/2
    ]).

init(State) ->
    List = db:get_all(io_lib:format(?sql_select_kf_gwar_guild_info, [])),
    List2 = db:get_all(io_lib:format(?sql_select_kf_gwar_bid_info, [])),
    IslandMap = init_island_map(data_kf_guild_war:get_island_ids(), #{}),
    {GuildMap, NewIslandMap} = init_guild_map(List, #{}, IslandMap),
    {LastIslandMap, BidIndexMap} = init_bid_info(List2, NewIslandMap, #{}),
    SortGuildList = sort_guild_list(maps:values(GuildMap)),
    NewGuildMap = maps:from_list(SortGuildList),
    State#kf_guild_war_state{guild_map = NewGuildMap, island_map = LastIslandMap, bid_index = BidIndexMap}.

init_island_map([], IslandMap) -> IslandMap;
init_island_map([IslandId|L], IslandMap) ->
    IslandInfo = #island_info{},
    NewMap = maps:put(IslandId, IslandInfo, IslandMap),
    init_island_map(L, NewMap).

init_guild_map([], GuildMap, IslandMap) -> {GuildMap, IslandMap};
init_guild_map([[GuildId, GuildName, SerId, SerName, IslandId, Score, ScoreUtime, IslandUtime]|L], GuildMap, IslandMap) ->
    GuildInfo = #guild_info{
        ser_id = SerId,
        ser_name = SerName,
        guild_id = GuildId,
        guild_name = GuildName,
        island_id = IslandId,
        score = Score,
        score_utime = ScoreUtime,
        island_utime = IslandUtime
    },
    NewGuildMap = maps:put(GuildId, GuildInfo, GuildMap),
    case IslandId > 0 of
        true ->
            IslandInfo = maps:get(IslandId, IslandMap, #island_info{}),
            NewIslandMap = maps:put(IslandId, IslandInfo#island_info{guild_id = GuildId}, IslandMap);
        _ ->
            NewIslandMap = IslandMap
    end,
    init_guild_map(L, NewGuildMap, NewIslandMap).

init_bid_info([], IslandMap, BidIndexMap) ->
    %% 对出价列表进行排序
    F = fun(_IslandId, IslandInfo) ->
        case IslandInfo of
            #island_info{
                bid_list = BidList
            } when BidList =/= [] ->
                SortBidList = sort_bid_list(BidList),
                IslandInfo#island_info{bid_list = SortBidList};
            _ -> IslandInfo
        end
    end,
    NewIslandMap = maps:map(F, IslandMap),
    {NewIslandMap, BidIndexMap};
init_bid_info([[GuildId, GuildName, SerId, SerName, IslandId, Cost, Time]|L], IslandMap, BidIndexMap) ->
    BidInfo = #bid_info{
        ser_id = SerId,
        ser_name = SerName,
        guild_id = GuildId,
        guild_name = GuildName,
        bid = Cost,
        time = Time
    },
    #island_info{bid_list = BidList} = IslandInfo = maps:get(IslandId, IslandMap, #island_info{}),
    NewIslandInfo = IslandInfo#island_info{bid_list = [BidInfo|BidList]},
    NewIslandMap = maps:put(IslandId, NewIslandInfo, IslandMap),
    NewBidIndexMap = maps:put(GuildId, IslandId, BidIndexMap),
    init_bid_info(L, NewIslandMap, NewBidIndexMap).

handle_msg_local2center({?MSG_TYPE_LOCAL_INIT, SerId}, State) ->
    #kf_guild_war_state{
        status = ActStatus,
        round = Round,
        etime = Etime
    } = State,
    Args = {{call_back, ?MSG_TYPE_LOCAL_INIT}, ActStatus, Round, Etime},
    mod_clusters_center:apply_cast(SerId, mod_kf_guild_war_local, msg_center2local, [Args]),
    State;
handle_msg_local2center(_Msg, State) ->
    ?ERR("handle_msg_local2center ignore:~p", [_Msg]),
    State.

confirm_group_in_init(State, _NowTime) ->
    #kf_guild_war_state{
        island_map = IslandMap
    } = State,
    F = fun(IslandInfo) ->
        case IslandInfo of
            #island_info{
                guild_id = OccupyGuildId,
                bid_list = BidList
            } ->
                BidListLen = length(BidList),
                not ((OccupyGuildId > 0 andalso BidListLen < 4) orelse (BidListLen < 5));
            _ -> false
        end
    end,
    IsNotConfirm = lists:any(F, maps:values(IslandMap)),
    case IsNotConfirm of
        true ->
            handle_stage_appoint2confirm(State);
        _ ->
            State
    end.

handle_stage_close2appoint(State) ->
    #kf_guild_war_state{
        island_map = IslandMap
    } = State,
    db:execute(?sql_clear_kf_gwar_bid),
    F = fun({IslandId, IslandInfo}, Map) ->
        case is_record(IslandInfo, island_info) of
            true ->
                NewIslandInfo = IslandInfo#island_info{bid_list = [], battle_pid = []},
                maps:put(IslandId, NewIslandInfo, Map);
            _ -> Map
        end
    end,
    NewIslandMap = lists:foldl(F, #{}, maps:to_list(IslandMap)),
    State#kf_guild_war_state{
        island_map = NewIslandMap,
        room_index = #{},
        max_room_id = 1,
        round = 0,
        bid_index = #{}
    }.

handle_stage_appoint2confirm(State) ->
    #kf_guild_war_state{
        island_map = IslandMap
    } = State,
    case lib_kf_guild_war:get_game_type() of
        ?GAME_TYPE_OPEN_SEA ->
            F = fun(IslandId, {TmpIslandMap, Acc}) ->
                IslandInfo = maps:get(IslandId, TmpIslandMap, #island_info{}),
                #island_info{bid_list = BidList} = IslandInfo,
                case BidList =/= [] of
                    true ->
                        case IslandInfo of
                            #island_info{guild_id = OccupyGuildId} when OccupyGuildId > 0 ->
                                {ConfirmList, NeedReturnGfundsL} = ulists:sublist(BidList, 3);
                            _ ->
                                {ConfirmList, NeedReturnGfundsL} = ulists:sublist(BidList, 4)
                        end,
                        %% 发送相关通知邮件
                        spawn(fun() ->
                            send_confirm_group_mail(ConfirmList),
                            return_gfunds(NeedReturnGfundsL)
                        end),
                        NewIslandInfo = IslandInfo#island_info{
                            bid_list = ConfirmList
                        },
                        NewTmpIslandMap = maps:put(IslandId, NewIslandInfo, TmpIslandMap),
                        {NewTmpIslandMap, NeedReturnGfundsL ++ Acc};
                    _ -> {TmpIslandMap, []}
                end
            end,
            {NewIslandMap, DelList} = lists:foldl(F, {IslandMap, []}, data_kf_guild_war:get_island_ids_by_type(?SEAS_TYPE_EDGE_SEA)),
            %% 删除失去参赛资格的相关出价信息
            delete_bid_info_db(DelList),

            State#kf_guild_war_state{island_map = NewIslandMap};
        _ ->
            State
    end.

delete_bid_info_db([]) -> skip;
delete_bid_info_db(BidList) ->
    DelIds = [GuildId || #bid_info{guild_id = GuildId} <- BidList],
    db:execute(io_lib:format(?sql_delete_kf_gwar_bid_more, [util:link_list(DelIds)])).

sort_bid_list(BidList) ->
    F = fun(A, B) ->
        if
            A#bid_info.bid == B#bid_info.bid ->
                A#bid_info.time < B#bid_info.time;
            true ->
                A#bid_info.bid > B#bid_info.bid
        end
    end,
    lists:sort(F, BidList).

sort_guild_list(GuildList) ->
    F = fun(A, B) ->
        if
            A#guild_info.score == B#guild_info.score ->
                A#guild_info.score_utime < B#guild_info.score_utime;
            true ->
                A#guild_info.score > B#guild_info.score
        end
    end,
    SortList = lists:sort(F, GuildList),
    F1 = fun(T, {Ranking, Acc}) ->
        NewT = T#guild_info{ranking = Ranking},
        {Ranking + 1, [{T#guild_info.guild_id, NewT}|Acc]}
    end,
    {_, RankL} = lists:foldl(F1, {1, []}, SortList),
    RankL.

send_declare_war_view_info(Node, GuildId, RoleId, IslandId, ?GAME_TYPE_OPEN_SEA, #kf_guild_war_state{status = ActStatus, round = Round} = State)
    when ActStatus == ?ACT_STATUS_APPOINT orelse ActStatus == ?ACT_STATUS_CONFIRM orelse (ActStatus == ?ACT_STATUS_BATTLE andalso Round == 1) ->
    #kf_guild_war_state{
        status = ActStatus,
        island_map = IslandMap,
        guild_map = GuildMap
    } = State,
    #island_info{
        guild_id = OccupyGuildId,
        bid_list = BidList
    } = maps:get(IslandId, IslandMap, #island_info{}),
    case maps:get(OccupyGuildId, GuildMap, #guild_info{}) of
        #guild_info{
            guild_name = OccupyGuildName
        } -> skip;
        _ -> OccupyGuildName = <<>>
    end,
    F = fun(BidInfo, {Tag, Acc}) ->
        case BidInfo of
            #bid_info{
                ser_name = OneSerName,
                guild_id = OneGuilId,
                guild_name = OneGuildName,
                bid = OneBid,
                time = OneTime
            } ->
                case OneGuilId == GuildId of
                    true -> NewTag = 1;
                    _ -> NewTag = Tag
                end,
                {NewTag, [{OneSerName, OneGuildName, OneBid, OneTime}|Acc]};
            _ ->
                {Tag, Acc}
        end
    end,
    {IsBid, PackList} = lists:foldl(F, {0, []}, lists:reverse(BidList)),
    ListLen = data_kf_guild_war:get_cfg(?CFG_ID_BID_LIST_LEN),
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43726, [IslandId, OccupyGuildId, OccupyGuildName, ActStatus, IsBid, lists:sublist(PackList, ListLen)]);
send_declare_war_view_info(Node, _GuildId, RoleId, IslandId, _GameType, State) ->
    #kf_guild_war_state{
        status = ActStatus,
        guild_map = GuildMap,
        island_map = IslandMap
    } = State,
    #island_info{guild_id = OccupyGuildId} = maps:get(IslandId, IslandMap, #island_info{}),
    case maps:get(OccupyGuildId, GuildMap, #guild_info{}) of
        #guild_info{
            guild_name = OccupyGuildName
        } -> skip;
        _ -> OccupyGuildName = <<>>
    end,
    IslandIds = data_kf_guild_war:get_island_ids_by_next_id(IslandId),
    F = fun(OneIslandId, Acc) ->
        case maps:get(OneIslandId, IslandMap, false) of
            #island_info{
                guild_id = OneOccupyGuildId
            } when OneOccupyGuildId > 0 ->
                case maps:get(OneOccupyGuildId, GuildMap, false) of
                    #guild_info{
                        ser_name = OneSerName,
                        guild_name = OneGuildName
                    } ->
                        [{OneSerName, OneGuildName, 0, 0}|Acc];
                    _ ->
                        Acc
                end;
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], IslandIds),
    lib_kf_guild_war:send_to_uid(Node, RoleId, 43726, [IslandId, OccupyGuildId, OccupyGuildName, ActStatus, 0, PackList]).

start_battle(GameType, State, NowTime) ->
    NewState = confirm_group(GameType, State, NowTime),
    #kf_guild_war_state{room_index = RoomIndex} = NewState,
    mod_clusters_center:apply_to_all_node(mod_guild, apply_cast, [lib_kf_guild_war_api, send_tips, [2, maps:keys(RoomIndex)]]),
    NewState.

confirm_group(?GAME_TYPE_OPEN_SEA, #kf_guild_war_state{round = Round} = State, NowTime) when Round == 1 ->
    #kf_guild_war_state{
        max_room_id = MaxRoomId,
        guild_map = GuildMap,
        island_map = IslandMap,
        etime = Etime
    } = State,
    ForbidPkEtime = NowTime + ?FORBID_PK_DURATION,
    F = fun(IslandId, {TmpMaxRoomId, TmpIslandMap, TmpAccL}) ->
        IslandInfo = maps:get(IslandId, TmpIslandMap, #island_info{}),
        #island_info{guild_id = OccupyGuildId, bid_list = BidList} = IslandInfo,
        case OccupyGuildId > 0 of
            true ->
                DefaultBuildingGroup = 1,
                QualificationBidL = lists:sublist(BidList, 3),
                QualificationL = [{OneSerId, OneSerName, OneGuildId, OneGuildName} || #bid_info{ser_id = OneSerId, ser_name = OneSerName, guild_id = OneGuildId, guild_name = OneGuildName} <- QualificationBidL],
                #guild_info{
                    ser_id = OccupySerId,
                    ser_name = OccupySerName,
                    guild_name = OccupyGuildName
                } = maps:get(OccupyGuildId, GuildMap, #guild_info{}),
                RealQualificationL = [{OccupySerId, OccupySerName, OccupyGuildId, OccupyGuildName}|QualificationL];
            _ ->
                DefaultBuildingGroup = 0,
                QualificationBidL = lists:sublist(BidList, 4),
                RealQualificationL = [{OneSerId, OneSerName, OneGuildId, OneGuildName} || #bid_info{ser_id = OneSerId, ser_name = OneSerName, guild_id = OneGuildId, guild_name = OneGuildName} <- QualificationBidL]
        end,
        %% 第一天的第一轮比赛固定出价最高或者岛屿的占领者在守方出生点
        case RealQualificationL of
            [DefBornPointOwner] ->
                OneGroupMap = do_confirm_group_core([DefBornPointOwner], DefaultBuildingGroup);
            [DefBornPointOwner|L] ->
                OtherPointOwnerL = ulists:list_shuffle(L),
                OneGroupMap = do_confirm_group_core([DefBornPointOwner|OtherPointOwnerL], DefaultBuildingGroup);
            _ ->
                OneGroupMap = skip
        end,
        case is_map(OneGroupMap) of
            true ->
                %% 开启房间进程
                {ok, Pid} = mod_kf_guild_war_battle:start([OneGroupMap, DefaultBuildingGroup, OccupyGuildId, TmpMaxRoomId, Round, IslandId, NowTime, ForbidPkEtime, Etime]),
                NewIslandInfo = IslandInfo#island_info{bid_list = QualificationBidL, battle_pid = Pid},
                NewTmpIslandMap = maps:put(IslandId, NewIslandInfo, TmpIslandMap),
                NewTmpAccL = [{GuildBattleInfo#guild_battle_info.guild_id, Pid} || GuildBattleInfo <- maps:values(OneGroupMap)] ++ TmpAccL,
                {TmpMaxRoomId + 1, NewTmpIslandMap, NewTmpAccL};
            _ ->
                {TmpMaxRoomId, TmpIslandMap, TmpAccL}
        end
    end,
    {NewMaxRoomId, NewIslandMap, NewRoomIndexL} = lists:foldl(F, {MaxRoomId, IslandMap, []}, data_kf_guild_war:get_island_ids_by_type(?SEAS_TYPE_EDGE_SEA)),
    State#kf_guild_war_state{max_room_id = NewMaxRoomId, island_map = NewIslandMap, room_index = maps:from_list(NewRoomIndexL)};
confirm_group(?GAME_TYPE_OPEN_SEA, #kf_guild_war_state{round = Round} = State, NowTime) when Round == 2 ->
    NeedToDeclareWarIslandIds = data_kf_guild_war:get_island_next_ids_by_type(?SEAS_TYPE_EDGE_SEA),
    auto_confirm_group(NeedToDeclareWarIslandIds, NowTime, State);
confirm_group(?GAME_TYPE_INSEA, #kf_guild_war_state{round = Round} = State, NowTime) when Round == 1 ->
    NeedToDeclareWarIslandIds = data_kf_guild_war:get_island_next_ids_by_type(?SEAS_TYPE_OPEN_SEA),
    auto_confirm_group(NeedToDeclareWarIslandIds, NowTime, State);
confirm_group(?GAME_TYPE_INSEA, #kf_guild_war_state{round = Round} = State, NowTime) when Round == 2 ->
    NeedToDeclareWarIslandIds = data_kf_guild_war:get_island_next_ids_by_type(?SEAS_TYPE_INSEA),
    auto_confirm_group(NeedToDeclareWarIslandIds, NowTime, State).

%% 自动宣战的时候确认分组
auto_confirm_group(NeedToDeclareWarIslandIds, NowTime, State) ->
    #kf_guild_war_state{
        round = Round,
        max_room_id = MaxRoomId,
        guild_map = GuildMap,
        island_map = IslandMap,
        etime = Etime
    } = State,
    ForbidPkEtime = NowTime + ?FORBID_PK_DURATION,
    F = fun(AutoDeclareWarIslandId, {TmpMaxRoomId, TmpIslandMap, TmpAccL}) ->
        #island_info{
            guild_id = OccupyGuildId
        } = IslandInfo = maps:get(AutoDeclareWarIslandId, TmpIslandMap, #island_info{}),
        #guild_info{
            ser_id = OccupySerId,
            ser_name = OccupySerName,
            guild_name = OccupyGuildName
        } = maps:get(OccupyGuildId, GuildMap, #guild_info{}),
        IslandIds = data_kf_guild_war:get_island_ids_by_next_id(AutoDeclareWarIslandId),
        F1 = fun(IslandId, Acc) ->
            case maps:get(IslandId, TmpIslandMap, false) of
                #island_info{
                    guild_id = OneGuildId
                } when OneGuildId > 0 -> %% 有公会占领的岛屿自动宣战
                    case maps:get(OneGuildId, GuildMap, false) of
                        #guild_info{
                            ser_id = OneSerId,
                            ser_name = OneSerName,
                            guild_name = OneGuildName
                        } ->
                            [{OneSerId, OneSerName, OneGuildId, OneGuildName}|Acc];
                        _ -> Acc
                    end;
                _ -> Acc
            end
        end,
        QualificationL = lists:foldl(F1, [], IslandIds),
        OtherPointOwnerL = ulists:list_shuffle(QualificationL),
        case OccupyGuildId > 0 of
            true ->
                DefaultBuildingGroup = 1;
            _ ->
                DefaultBuildingGroup = 0
        end,
        OneGroupMap = do_confirm_group_core([{OccupySerId, OccupySerName, OccupyGuildId, OccupyGuildName}|OtherPointOwnerL], DefaultBuildingGroup),
        case maps:size(OneGroupMap) > 0 of
            true ->
                %% 开启房间进程
                {ok, Pid} = mod_kf_guild_war_battle:start([OneGroupMap, DefaultBuildingGroup, OccupyGuildId, TmpMaxRoomId, Round, AutoDeclareWarIslandId, NowTime, ForbidPkEtime, Etime]),
                NewIslandInfo = IslandInfo#island_info{battle_pid = Pid},
                NewTmpIslandMap = maps:put(AutoDeclareWarIslandId, NewIslandInfo, TmpIslandMap),
                NewTmpAccL = [{GuildBattleInfo#guild_battle_info.guild_id, Pid} || GuildBattleInfo <- maps:values(OneGroupMap)] ++ TmpAccL;
            _ ->
                NewTmpIslandMap = TmpIslandMap,
                NewTmpAccL = TmpAccL
        end,

        {TmpMaxRoomId + 1, NewTmpIslandMap, NewTmpAccL}
    end,
    {NewMaxRoomId, NewIslandMap, NewRoomIndexL} = lists:foldl(F, {MaxRoomId, IslandMap, []}, NeedToDeclareWarIslandIds),
    State#kf_guild_war_state{max_room_id = NewMaxRoomId, island_map = NewIslandMap, room_index = maps:from_list(NewRoomIndexL)}.

%% 注意: 分配给守方的阵营固定为1
do_confirm_group_core(QualificationL, DefalutBuildindGroup) ->
    AttackerBornPointsL = data_kf_guild_war:get_cfg(?CFG_ID_ATTACKER_BORN_POINTS),
    DefenderBornPoint = data_kf_guild_war:get_cfg(?CFG_ID_DEFENDER_BORN_POINTS),
    BornPointsL = [DefenderBornPoint|AttackerBornPointsL],
    F = fun(T, {TmpGroupId, TmpBornPointsL, Map}) ->
        {OneSerId, OneSerName, OneGuildId, OneGuildName} = T,
        case TmpBornPointsL of
            [{X, Y}|L] -> skip;
            _ -> L = [], X = 1484, Y = 669
        end,
        case OneGuildId > 0 of
            true ->
                %% 分配防守方的时候如果建筑归属防守方要初始化
                case TmpGroupId == 1 of
                    true ->
                        case DefalutBuildindGroup == 1 of
                            true ->
                                Tag = 2,
                                BuildingNum = length(data_kf_guild_war:get_all_building_ids());
                            _ ->
                                Tag = 1,
                                BuildingNum = 0
                        end;
                    _ ->
                        Tag = 1,
                        BuildingNum = 0
                end,
                GuildInfo = #guild_battle_info{
                    ser_id = OneSerId,
                    ser_name = OneSerName,
                    guild_id = OneGuildId,
                    guild_name = OneGuildName,
                    tag = Tag,
                    group = TmpGroupId,
                    born_point = {X, Y},
                    building_num = BuildingNum
                },
                NewMap = maps:put(OneGuildId, GuildInfo, Map);
            _ -> NewMap = Map
        end,
        {TmpGroupId + 1, L, NewMap}
    end,
    {_, _, GroupMap} = lists:foldl(F, {1, BornPointsL, #{}}, QualificationL),
    GroupMap.

%% 开启定时器定时增加积分
start_score_ref(ORef) ->
    util:cancel_timer(ORef),
    Time = data_kf_guild_war:get_cfg(?CFG_ID_BUILDING_SCORE_PLUS_CD),
    erlang:send_after(max(1, Time) * 1000, self(), {'auto_add_score'}).

%% 战斗结束
battle_end(State, _Round) ->
    #kf_guild_war_state{
        island_map = IslandMap
    } = State,
    F = fun(IslandInfo) ->
        case IslandInfo of
            #island_info{
                battle_pid = BattlePid
            } when is_pid(BattlePid) ->
                mod_kf_guild_war_battle:battle_end(BattlePid);
            _ -> skip
        end
    end,
    lists:foreach(F, maps:values(IslandMap)),
    State.

%% 比赛结束后根据排名增加公会的赛季积分
island_battle_end([], _GameType, _Round, IslandId, _NowTime, IslandMap, GuildMap) ->
    case maps:get(IslandId, IslandMap, false) of
        IslandInfo when is_record(IslandInfo, island_info) ->
            NewIslandMap = maps:put(IslandId, IslandInfo#island_info{battle_pid = []}, IslandMap);
        _ -> NewIslandMap = IslandMap
    end,
    {NewIslandMap, GuildMap};
island_battle_end([GuildBattleInfo|L], GameType, Round, IslandId, NowTime, IslandMap, GuildMap) ->
    case GuildBattleInfo of
        #guild_battle_info{
            ser_id = SerId,
            ser_name = SerName,
            guild_id = GuildId,
            guild_name = GuildName,
            tag = Tag,
            ranking = Ranking
        } ->
            case data_kf_guild_war:get_ranking_reward(Ranking) of
                #kf_gwar_ranking_reward_cfg{
                    score_plus = ScorePlus
                } -> skip;
                _ -> ScorePlus = 0
            end,
            GuildInfo = maps:get(GuildId, GuildMap, #guild_info{}),
            if
                Ranking == 1 -> %% 获胜公会拥有岛屿的占领权
                    if
                        GameType == ?GAME_TYPE_INSEA andalso Round == 2 ->
                            mod_clusters_center:apply_to_all_node(lib_chat, send_TV, [{all_lv, 0, 65535}, ?MOD_KF_GUILD_WAR, 2, [SerName, GuildName]]);
                        true -> skip
                    end,
                    NewIslandId = IslandId,
                    %% 如果这个公会之前就是这个岛屿的占领者则不更新占领时间
                    case GuildInfo#guild_info.island_id == IslandId of
                        true ->
                            LastIslandMap = IslandMap,
                            NewIslandUtime = GuildInfo#guild_info.island_utime;
                        _ ->
                            NewIslandMap = update_island_ownership(IslandMap, IslandId, GuildId),
                            LastIslandMap = update_island_ownership(NewIslandMap, GuildInfo#guild_info.island_id, 0),
                            NewIslandUtime = NowTime
                    end;
                true ->
                    LastIslandMap = IslandMap,
                    %% 之前占领这个岛屿的公会要移除占领权
                    case GuildInfo#guild_info.island_id == IslandId of
                        true ->
                            NewIslandId = 0,
                            NewIslandUtime = NowTime;
                        _ ->
                            NewIslandId = GuildInfo#guild_info.island_id,
                            NewIslandUtime = GuildInfo#guild_info.island_utime
                    end
            end,
            NewGuildInfo = GuildInfo#guild_info{
                ser_id = SerId,
                ser_name = SerName,
                guild_id = GuildId,
                guild_name = GuildName,
                score = GuildInfo#guild_info.score + ScorePlus,
                score_utime = NowTime,
                island_id = NewIslandId,
                island_utime = NewIslandUtime
            },
            Args = [NewGuildInfo#guild_info.guild_id, NewGuildInfo#guild_info.guild_name,
                    NewGuildInfo#guild_info.ser_id, NewGuildInfo#guild_info.ser_name,
                    NewGuildInfo#guild_info.island_id, NewGuildInfo#guild_info.score, NowTime, NowTime],
            db:execute(io_lib:format(?sql_update_kf_gwar_guild_info, Args)),

            %% 日志
            IslandName = lib_kf_guild_war:get_island_name(IslandId),
            lib_log_api:log_kf_guild_war_battle(SerId, SerName, GuildId, GuildName, Tag, IslandId, IslandName, Ranking, GuildInfo#guild_info.island_id, NewIslandId, NowTime),

            NewGuildMap = maps:put(GuildId, NewGuildInfo, GuildMap),
            island_battle_end(L, GameType, Round, IslandId, NowTime, LastIslandMap, NewGuildMap);
        _ ->
            island_battle_end(L, GameType, Round, IslandId, NowTime, IslandMap, GuildMap)
    end.

update_island_ownership(IslandMap, IslandId, GuildId) ->
    case maps:get(IslandId, IslandMap, false) of
        IslandInfo when is_record(IslandInfo, island_info) ->
            maps:put(IslandId, IslandInfo#island_info{guild_id = GuildId}, IslandMap);
        _ -> IslandMap
    end.

send_season_reward([], _NowTime) -> ok;
send_season_reward([{GuildId, GuildInfo}|L], NowTime) ->
    #guild_info{
        ser_id = SerId,
        ser_name = SerName,
        guild_id = GuildId,
        guild_name = GuildName,
        score = Score,
        ranking = Ranking
    } = GuildInfo,
    case data_kf_guild_war:get_season_reward(Ranking) of
        #kf_gwar_season_reward_cfg{
            reward = Reward
        } ->
            %% 日志
            lib_log_api:log_kf_guild_war_season_reward(SerId, SerName, GuildId, GuildName, Score, Ranking, Reward, NowTime),
            case Reward =/= [] of
                true ->
                    mod_clusters_center:apply_cast(SerId, mod_guild, apply_cast, [lib_kf_guild_war_api, send_season_reward, [GuildId, Ranking, Reward]]),
                    timer:sleep(100);
                _ -> skip
            end;
        _ -> skip
    end,
    send_season_reward(L, NowTime).

send_confirm_group_mail([]) -> ok;
send_confirm_group_mail([BidInfo|L]) ->
    case BidInfo of
        #bid_info{
            ser_id = SerId,
            guild_id = GuildId
        } ->
            mod_clusters_center:apply_cast(SerId, mod_guild, send_guild_mail_by_guild_id, [GuildId, utext:get(4370003), utext:get(4370004), [], []]);
        _ -> skip
    end,
    send_confirm_group_mail(L).

return_gfunds([]) -> ok;
return_gfunds([BidInfo|L]) ->
    case BidInfo of
        #bid_info{
            ser_id = SerId,
            guild_id = GuildId,
            bid = Bid
        } ->
            mod_clusters_center:apply_cast(SerId, lib_kf_guild_war_api, return_bid_gfunds, [GuildId, Bid, kf_gwar_return_gfunds_in_confirm]);
        _ ->
            skip
    end,
    return_gfunds(L).

reset_season(State) ->
    #kf_guild_war_state{
        guild_map = GuildMap
    } = State,
    db:execute(?sql_clear_kf_gwar_guild),
    SortGuildList = sort_guild_list(maps:values(GuildMap)),
    spawn(fun() ->
        NowTime = utime:unixtime(),
        send_season_reward(SortGuildList, NowTime)
    end),
    State#kf_guild_war_state{
        guild_map = #{},
        island_map = init_island_map(data_kf_guild_war:get_island_ids(), #{})
    }.