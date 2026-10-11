%%%-----------------------------------
%%% @Module      : mod_local_guild_feast_topic
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 25. 五月 2020 16:15
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_kf_guild_feast_topic_mod).
-author("chenyiming").

-include("guild_feast.hrl").
-include("common.hrl").
-include("server_mod.hrl").
-include("clusters.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").

%% API
-export([]).

sync_zone_group(State, InfoList) ->
    % group_msg
	F = fun({ZoneId, {Servers, GroupInfo}}, AccL) ->
		#zone_group_info{server_group_map = ServerGroupMap, group_mod_servers = GroupModServers} = GroupInfo,
		ServerGroupList =
			[begin
				 F_num = fun(Id) ->
					 #zone_base{server_num = SerNum} = ulists:keyfind(Id, #zone_base.server_id, Servers, #zone_base{}) ,
					 SerNum
				 end,
				 ServerNums = [F_num(SerId)||SerId<-ServerIds],
				 #transport_group_msg{id = GroupId, mod = Mod, server_ids = ServerIds, server_num = ServerNums}
			 end||#zone_mod_group_data{mod = Mod, group_id = GroupId, server_ids = ServerIds}<-GroupModServers],
		Item = #transport_msg{zone_id = ZoneId, server_group_map = ServerGroupMap, server_group_list = ServerGroupList},
		[Item|AccL]
	end,
	GroupMsg = lists:foldl(F, [], InfoList),

    % zone_map
	ZoneMap = init_zone_map(GroupMsg),

	State#topic_status{group_msg = GroupMsg, zone_map = ZoneMap}.


act_start(ServerId, State) ->
	#topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
	TopicList = lib_guild_feast_mod:get_quiz(),
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
	case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
			case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
                #server_group{server_ids = ServerIds} = ServerGroup ->
                    ServerGroupNew = ServerGroup#server_group{topic_list = TopicList},
                    GroupListNew = lists:keystore(GroupId, #server_group.group_id, GroupList, ServerGroupNew),
                    NewZoneMap = maps:put(ZoneId, GroupListNew, ZoneMap),
                    [mod_clusters_center:apply_cast(SerId, mod_guild_feast_mgr, set_topic, [TopicList])
                        || SerId <- ServerIds];
                _ ->
                    NewZoneMap = ZoneMap
            end;
        _ ->
            NewZoneMap = ZoneMap
    end,
    State#topic_status{zone_map = NewZoneMap, status = 1}.

init_zone_map(GroupMsg) ->
    F1 = fun(#transport_msg{zone_id = ZoneId, server_group_list = ServerGroupList}, AccMap) ->
		F2 = fun(#transport_group_msg{id = GroupId, mod = Mod, server_ids = ServerIds, server_num = ServerNums}, AccGroupList) ->
			Group = #server_group{group_id = GroupId, mod = Mod,
				zone_id = ZoneId, server_ids = ServerIds, server_num = ServerNums, right_tid = []},
			[Group | AccGroupList]
		     end,
		ServerGroupListNew = lists:foldl(F2, [], ServerGroupList),
		AccMapNew = maps:put(ZoneId, ServerGroupListNew, AccMap),
		AccMapNew
	    end,
    lists:foldl(F1, #{}, GroupMsg).

%% 由mod_guild_feast_quiz判断玩家答对后调用,此处为算加分和跨服排名用
answer(ServerId, ServerNum, TopicNo, RoleId, RoleName, _RoleAnswer, _AnswerType, GuildId, _GuildName, State) ->
	#topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
			case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
				#server_group{right_tid = _RightTid, tmap = TMap,
					guild_point_list = _GuildPointList, guild_role_map = _RoleMap, server_ids = _ServerIds} = ServerGroup ->
                    RList = maps:get(TopicNo, TMap, []),
                    case lists:keyfind(RoleId, #gfeast_rank_role.role_id, RList) of
                        false ->
					        % 本题积分及排名
                            Rank = length(RList) + 1,
					        Point = data_guild_feast:get_question_point(Rank),
                            AnsInfo = #gfeast_rank_role{
                                role_id = RoleId, role_name = RoleName, guild_id = GuildId,
                                server_id = ServerId, server_num = ServerNum,
                                score = Point, rank = Rank, time = utime:unixtime()
                            },
                            mod_clusters_center:apply_cast(ServerId, lib_chat, send_TV, [{player, RoleId}, ?MOD_GUILD_ACT, 34, [Rank, Point]]),
                            RList1 = [AnsInfo | RList],
                            TMap1 = TMap#{TopicNo => RList1},
					        ServerGroupNew = ServerGroup#server_group{tmap = TMap1},
					        GroupListNew = lists:keystore(GroupId, #server_group.group_id, GroupList, ServerGroupNew),
					        NewZoneMap = maps:put(ZoneId, GroupListNew, ZoneMap),
					        State#topic_status{zone_map = NewZoneMap};
                        true ->
                            State
                    end;
				_ ->
					State
			end;
		_ ->
			State
	end.

refresh_quiz_rank(ServerId, TopicNo, RightAnswer, State) ->
    #topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
			case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
				#server_group{tmap = TMap, quiz_map = QuizMap, guild_role_map = RoleMap, server_ids = ServerIds} = ServerGroup ->
                    RList = maps:get(TopicNo, TMap, []),
                    F = fun(AnsInfo, RMap) ->
                        #gfeast_rank_role{
                            role_id = RoleId, role_name = RoleName, server_id = SerId, server_num = SerNum,
                            guild_id = GuildId, score = Point
                        } = AnsInfo,
                        NewRMap = add_role_point(RoleId, RoleName, GuildId, Point, RMap, SerId, SerNum),
                        NewRMap
                    end,
                    RoleMap1 = lists:foldl(F, RoleMap, RList),
                    TMap1 = TMap#{TopicNo => []},
                    QuizMap1 = QuizMap#{TopicNo => true},
                    ServerGroupNew = ServerGroup#server_group{tmap = TMap1, quiz_map = QuizMap1, guild_role_map = RoleMap1},
                    GroupListNew = lists:keystore(GroupId, #server_group.group_id, GroupList, ServerGroupNew),
					NewZoneMap = maps:put(ZoneId, GroupListNew, ZoneMap),

                    IsQuizFinish = maps:get(TopicNo, QuizMap, false), % 同一题结算会有多个公会消息传来，只处理第一个消息
                    case {RList, IsQuizFinish} of
                        {[], false} -> % 没人答对本题
                            TotalNum = data_guild_feast:get_cfg(choose_question_num) + data_guild_feast:get_cfg(short_answer_question_num),
                            CurNum = maps:keys(QuizMap1),
                            LanId = ?IF(length(CurNum) == TotalNum, ?no_one_right_answer_last, ?no_one_right_answer),
                            [mod_clusters_center:apply_cast(TempServerId, lib_chat, send_TV, [{all_guild}, ?MOD_GUILD_ACT, LanId, [RightAnswer]]) || TempServerId <- ServerIds];
                        {[], true} -> % 本题结算过
                            skip;
                        _ -> % 找出第一个答对的人
                            #gfeast_rank_role{role_name = RName, server_num = SerNum} = lists:keyfind(1, #gfeast_rank_role.rank, RList),
                            [mod_clusters_center:apply_cast(TempServerId, lib_chat, send_TV, [{all_guild}, ?MOD_GUILD_ACT, ?first_right_answer_kf, [RightAnswer, SerNum, RName]]) || TempServerId <- ServerIds]
                    end,

                    SceneId = data_guild_feast:get_cfg(scene_id),
                    RoleRankInfo0 = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
                    RoleRankInfo = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap1))),

                    F1 = fun({RoleId, _, _, _, _, SerId, _}) ->
                        Bin40220 = lib_guild_feast:pack_role_score_rank(RoleId, RoleRankInfo),
                        mod_clusters_center:apply_cast(SerId, lib_server_send, send_to_uid, [RoleId, Bin40220])
                    end,
                    lists:foreach(F1, RoleRankInfo -- RoleRankInfo0),

                    Bin40214 = lib_guild_feast:pack_role_rank_info(RoleRankInfo, 3),
                    [
                        mod_clusters_center:apply_cast(TempServerId, lib_server_send, send_to_scene, [SceneId, ?DEF_SCENE_PID, Bin40214])
                    || TempServerId <- ServerIds
                    ],

					State#topic_status{zone_map = NewZoneMap};
                _ ->
                    State
            end;
        _ ->
            State
    end.

add_guild_point(GuildId, GuildName, Point, GuildPointList, ServerId, ServerNum) ->
	case lists:keyfind(GuildId, 1, GuildPointList) of
		{_, _Name, OldPoint, _Time, ServerId} ->
			lists:keystore(GuildId, 1, GuildPointList, {GuildId, GuildName, Point + OldPoint, utime:unixtime(), ServerId, ServerNum});
		_ ->
			lists:keystore(GuildId, 1, GuildPointList, {GuildId, GuildName, Point, utime:unixtime(), ServerId, ServerNum})
	end.


add_role_point(RoleId, RoleName, GuildId, Point, RoleMap, ServerId, ServerNum) ->
	RoleList = maps:get(GuildId, RoleMap, []),
	case lists:keyfind(RoleId, 1, RoleList) of
		{_, _RoleName, OldPoint, _, _, _} ->
			RoleListNew = lists:keystore(RoleId, 1, RoleList, {RoleId, RoleName, Point + OldPoint, utime:unixtime(), ServerId, ServerNum});
		_ ->
			RoleListNew = lists:keystore(RoleId, 1, RoleList, {RoleId, RoleName, Point, utime:unixtime(), ServerId, ServerNum})
	end,
	maps:put(GuildId, RoleListNew, RoleMap).

end_act(State, GameType) ->
	#topic_status{zone_map = ZoneMap} = State,
    ZoneList = lists:flatten(maps:values(ZoneMap)),
    MaxRank = data_guild_feast:get_max_rank(),
    [
        begin
            case GameType of
                'quiz' ->
                    F = fun({_, _, _, _, Rank, _, _}) -> Rank =< MaxRank end,
                    RoleList = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
                    RoleList1 = lists:filter(F, RoleList),
                    F1 = fun({RoleId, _, _, _, Rank, ServerId, _}) ->
                        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_guild_feast, send_topic_reward_in_ps, [GameType, Rank]])
                    end,
                    lists:foreach(F1, RoleList1);
                'note_crash' ->
                    F = fun(#gfeast_rank_role{rank = Rank}) -> Rank =< MaxRank end,
                    RewardRoles = lists:filter(F, MiniGameRank),
                    F1 = fun(#gfeast_rank_role{role_id = RoleId, rank = Rank, server_id = ServerId}) ->
                        mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, [RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, lib_guild_feast, send_topic_reward_in_ps, [GameType, Rank]])
                    end,
                    lists:foreach(F1, RewardRoles)
            end
        end
     || #server_group{guild_role_map = RoleMap, mini_game_rank = MiniGameRank} <- ZoneList
    ].
	% ZoneList = maps:to_list(ZoneMap),
	% [[begin
	% 	  GuildListSort = sort_guild_by_point(GuildList),
	% 	  [   mod_clusters_center:apply_cast(ServerId, mod_guild, apply_cast,
	% 		  [lib_guild_feast, send_topic_reward_in_guild, [GuildId, Rank]])
	% 		  || {GuildId, _Guildname, _Point, _Time, Rank, ServerId, _ServerNum} <- GuildListSort]
	%   end || #server_group{guild_point_list = GuildList} <- GroupList] || {_ZoneId, GroupList} <- ZoneList].


%% 排序，返回   [{guildId,  name, point, Time,   Rank, ServerId, ServerNum}]
sort_guild_by_point(GuildList) ->
	F = fun({_GuildId, _GuildName, PointA, TimeA, _ServerId, _ServerNum}, {_, _, PointB, TimeB, _, _}) ->
		if
			PointA > PointB ->
				true;
			PointA < PointB ->
				false;
			true ->
				TimeA < TimeB
		end
	    end,
	SortGuildList = lists:sort(F, GuildList),
	sort_guild_point_set_rank(SortGuildList, 0, []).

sort_guild_point_set_rank([], _PreRank, AccList) ->
	lists:reverse(AccList);
sort_guild_point_set_rank([{GuildId, Name, Point, Time, ServerId, ServerNum} | SortGuildList], PreRank, AccList) ->
	sort_guild_point_set_rank(SortGuildList, PreRank + 1, [{GuildId, Name, Point, Time, PreRank + 1, ServerId, ServerNum} | AccList]).


add_guild_msg(ServerId, PackRoleListLast, GuildMsg, State) ->
	#topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
			case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
				#server_group{right_tid = _RightTid,
					guild_point_list = GuildPointList, guild_role_map = _RoleMap, server_ids = ServerIds} = ServerGroup ->
					{GuildId, GuildName, Point, _Time, ServerId, ServerNum} = GuildMsg,
					GuildPointListNew = add_guild_point(GuildId, GuildName, Point, GuildPointList, ServerId, ServerNum),
					%% 通知玩家信息
					send_rank_to_client(GuildPointListNew, PackRoleListLast, GuildId, ServerIds),
					ServerGroupNew = ServerGroup#server_group{guild_point_list = GuildPointListNew},
					GroupListNew = lists:keystore(GroupId, #server_group.group_id, GroupList, ServerGroupNew),
					NewZoneMap = maps:put(ZoneId, GroupListNew, ZoneMap),
					State#topic_status{zone_map = NewZoneMap};
				_ ->
					State
			end;
		_ ->
			State
	end.


%% 发送40214给客户端
send_rank_to_client(GuildPointList, PackRoleListLast, _GuildId, ServerIds) ->
	IsKf = 1,
	SortGuildList =
		if
			GuildPointList == [] ->
				[];
			true ->
				% 返回 [{guildId,  name, point, Time,   Rank, ServerId, ServerNum}]
				sort_guild_by_point(GuildPointList)
		end,
	PackGuildList = [{GuildId1, ServerNum1, Name1, Point1, Rank1} ||
		{GuildId1, Name1, Point1, _Time1, Rank1, _ServerId1, ServerNum1} <- SortGuildList],
	SceneId = data_guild_feast:get_cfg(scene_id),  %%场景id
	{ok, BinData} = pt_402:write(40214, [IsKf, PackGuildList, PackRoleListLast]),

	[mod_clusters_center:apply_cast(TempServerId, lib_server_send, send_to_scene, [SceneId, ?DEF_SCENE_PID, BinData])
		|| TempServerId<-ServerIds].


send_rank_to_client_role(GuildPointList, PackRoleListLast, _GuildId, ServerId, RoleId) ->
	IsKf = 1,
	SortGuildList =
		if
			GuildPointList == [] ->
				[];
			true ->
				% 返回 [{guildId,  name, point, Time,   Rank, ServerId, ServerNum}]
				sort_guild_by_point(GuildPointList)
		end,
	PackGuildList = [{GuildId1, ServerNum1, Name1, Point1, Rank1} ||
		{GuildId1, Name1, Point1, _Time1, Rank1, _ServerId1, ServerNum1} <- SortGuildList],
	{ok, BinData} = pt_402:write(40214, [IsKf, PackGuildList, PackRoleListLast]),
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]).


send_quiz_rank(ServerId, RoleId, _GuildId, _PackRoleListLast, State) ->
	#topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
			case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
				#server_group{guild_point_list = _GuildPointList, guild_role_map = RoleMap} ->
                    RoleRankInfo = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
                    BinData = lib_guild_feast:pack_role_rank_info(RoleRankInfo, 3),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
					% send_rank_to_client_role(GuildPointList, PackRoleListLast, GuildId, ServerId, RoleId);
				_ ->
					State
			end;
		_ ->
			State
	end.

send_role_score_rank(ServerId, RoleId, _GuildId, GameType, State) ->
    #topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
			case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
                #server_group{guild_point_list = _GuildPointList, guild_role_map = RoleMap, mini_game_rank = MiniGameRank} ->
                    send_role_score_rank2(GameType, RoleMap, MiniGameRank, ServerId, RoleId);
                _ ->
                    skip
            end;
        _ ->
            skip
    end.

send_role_score_rank2('quiz', RoleMap, _MiniGameRank, ServerId, RoleId) ->
    RoleList = lib_guild_feast:sort_role_by_point(lists:flatten(maps:values(RoleMap))),
    BinData = lib_guild_feast:pack_role_score_rank(RoleId, RoleList),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
send_role_score_rank2('note_crash', _RoleMap, MiniGameRank, 0, 0) ->
    % 更新所有有变化的玩家
    [
        begin
            #gfeast_rank_role{server_id = ServerId, role_id = RoleId, score = Score, rank = Rank} = Role,
            {ok, BinData} = pt_402:write(40220, [Rank, Score]),
            mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData])
        end
     || Role <- MiniGameRank
    ];
send_role_score_rank2('note_crash', _RoleMap, {MiniGameRank1, MiniGameRank2}, -1, -1) ->
    [
        begin
            #gfeast_rank_role{server_id = ServerId, role_id = RoleId, score = Score} = Role,
            {ok, BinData} = pt_402:write(40220, [0, Score]),
            not lists:keymember(RoleId, #gfeast_rank_role.role_id, MiniGameRank2) andalso mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData])
        end
     || Role <- MiniGameRank1 -- MiniGameRank2
    ];
send_role_score_rank2('note_crash', _RoleMap, MiniGameRank, ServerId, RoleId) ->
    #gfeast_rank_role{score = Score, rank = Rank} = ulists:keyfind(RoleId, #gfeast_rank_role.role_id, MiniGameRank, #gfeast_rank_role{}),
    {ok, BinData} = pt_402:write(40220, [Rank, Score]),
    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
send_role_score_rank2(_, _, _, _, _) ->
    skip.



%% 更新小游戏玩家排名
update_rank_role(State, RankRole) ->
    #topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
    #gfeast_rank_role{role_id = _RoleId, guild_id = _GuildId, server_id = ServerId} = RankRole,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),

    case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
            case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
                #server_group{mini_game_rank = RankList} = ServerGroup ->
                    RankList1 = lib_guild_feast_mod:update_rank_list(RankList, RankRole),
                    ServerGroup1 = ServerGroup#server_group{mini_game_rank = RankList1},
                    GroupList1 = lists:keystore(GroupId, #server_group.group_id, GroupList, ServerGroup1),
					ZoneMap1 = maps:put(ZoneId, GroupList1, ZoneMap),
					NewState = State#topic_status{zone_map = ZoneMap1},

                    send_role_score_rank2('note_crash', #{}, RankList1 -- RankList, 0, 0), % 更新所有有变化的上榜玩家
                    send_role_score_rank2('note_crash', #{}, {RankList, RankList1}, -1, -1), % 更新落榜玩家

                    NewState;
                _ ->
                    State
            end;
        _ ->
            State
    end.

%% 请求小游戏排名信息
send_game_rank_list(State, ServerId, GameType, RoleId, _GuildId) ->
    #topic_status{zone_map = ZoneMap, group_msg = TranSportMsgList} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),

    case lists:keyfind(ZoneId, #transport_msg.zone_id, TranSportMsgList) of
		#transport_msg{server_group_map = ServerMap} ->
			GroupId = maps:get(ServerId, ServerMap, 0),
			GroupList = maps:get(ZoneId, ZoneMap, []),
            case lists:keyfind(GroupId, #server_group.group_id, GroupList) of
                #server_group{mini_game_rank = RankList} ->
                    BinData = lib_guild_feast_mod:pack_role_rank_info(GameType, ?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY, RankList, 3),
                    mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]);
                _ ->
                    skip
            end;
        _ ->
            skip
    end,
    State.