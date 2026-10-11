%% ---------------------------------------------------------------------------
%% @doc mod_team_enlist
%% @author ming_up@foxmail.com
%% @since  2016-11-02
%% @deprecated  招募管理进程 %TODO
%% ---------------------------------------------------------------------------
-module(mod_team_enlist).
-behaviour(gen_server).

-export([
    start_link/0
    , cast_to_team_enlist/1
    , cast_to_team_enlist/2
    , add_team/8
    , delete_team/5
    , change_team/3
    , get_teams_num/2
    , clear_teams_reqlist_by_id/2
    , clear_role_match/1
    , match_teams/2
    , match_next/2
    , sync_zone_mod/1
    ]).
-export([init/1, handle_call/3, handle_cast/2, 
         handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("server.hrl").
-include("team.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("team_enlist.hrl").
-include("clusters.hrl").

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 添加组队平台信息
add_team(ClsType, TeamId, ActivityId, SubTypeId, SceneId, Num, LeaderFigure, Args) -> 
    cast_to_team_enlist(ClsType, {'add_team', TeamId, ActivityId, SubTypeId, SceneId, Num, LeaderFigure, Args}).

%% 移除组队平台信息
delete_team(ClsType, TeamId, ActivityId, SubTypeId, SceneId) -> 
    cast_to_team_enlist(ClsType, {'delete_team', TeamId, ActivityId, SubTypeId, SceneId}).

%% 更改队伍信息
change_team(ClsType, TeamId, KeyValues) -> 
    cast_to_team_enlist(ClsType, {'change_team', TeamId, KeyValues}).

%% 批量查看队伍人数
get_teams_num(Sid, TeamIds) -> 
    cast_to_team_enlist({'get_teams_num', Sid, TeamIds}).

%% 清理所有队伍申请列表里某个玩家
clear_teams_reqlist_by_id(RoleId, TeamIds) ->
    {ClsTeamIds, LocalTeamIds} = lists:partition(fun (Id) -> Id rem 2 == 0 end, TeamIds),
    case ClsTeamIds of
        [] -> ok;
        _ -> cast_to_team_enlist(?NODE_CENTER, {'clear_teams_reqlist_by_id', RoleId, TeamIds})
    end,
    case LocalTeamIds of
        [] -> ok;
        _ -> cast_to_team_enlist({'clear_teams_reqlist_by_id', RoleId, TeamIds})
    end.

%% 清理玩家匹配状态
clear_role_match(RoleId) ->
    cast_to_team_enlist({'clear_role_match', RoleId}).

%% 匹配队伍--zzy
match_teams(Mb, ActivityList)->
    cast_to_team_enlist({'match_teams', Mb, ActivityList}).

%% 匹配下一个队伍
match_next(Mb, [Node, Ref]) ->
    unode:apply(Node, mod_team_enlist, cast_to_team_enlist, [{'match_next', Mb, Ref}]).

%% 跨服调用
sync_zone_mod(ModuleZoneMap) ->
    gen_server:cast(?MODULE, {'sync_zone_mod', ModuleZoneMap}).

cast_to_team_enlist(Msg) ->
    gen_server:cast(?MODULE, Msg).

cast_to_team_enlist(ClsType, Msg) ->
    case config:get_cls_type() of
        ClsType ->
            gen_server:cast(?MODULE, Msg);
        ?NODE_GAME ->
            mod_clusters_node:apply_cast(mod_team_enlist, cast_to_team_enlist, [Msg]);
        _ -> %% 跨服节点不能去调用未知的游戏节点
            ok
    end.

init([]) ->
    {ok, #state{}}.

handle_call(_Event, _From, Status) ->
    {noreply, Status, Status}.

handle_cast({'sync_zone_mod', ModuleZoneMap}, State) ->
    F = fun({ZoneId, {_Servers, GroupInfo}}, AccMap) ->
        #zone_group_info{group_mod_servers = GroupModServers} = GroupInfo,
        F2 = fun(ModGroupData, AccSerModMap) ->
            #zone_mod_group_data{group_id = GroupId, mod = Mod, server_ids = ServerIds} = ModGroupData,
            Map = maps:from_list([{SerId, {Mod, GroupId}}||SerId<-ServerIds]),
            NewAccSerModMap = maps:merge(AccSerModMap, Map),
            NewAccSerModMap
        end,
        ServerModMap = lists:foldl(F2, #{}, GroupModServers),
        AccMap#{ZoneId => ServerModMap}
    end,
    ModuleGroupMapL = [{ModuleId, lists:foldl(F, #{}, InfoList)}||{ModuleId, InfoList}<-maps:to_list(ModuleZoneMap)],
    {noreply, State#state{module_group_map = maps:from_list(ModuleGroupMapL)}};

handle_cast({'get_all_team', ServerId, Sid, ActivityId, SubTypeId, SceneId, RoleLv}, State) ->
    #state{team_maps=TeamMaps, activity_maps=ActivityMaps, module_group_map = ModuleGroupMap} = State,
    TeamIds = maps:get({ActivityId, SubTypeId}, ActivityMaps, []),
    F = fun(TeamId, Result) ->
        case maps:get(TeamId, TeamMaps, false) of
            #team_enlist_info{num=Num, max_num = NumMax} when Num>=NumMax orelse Num < 1 -> Result;
            % #team_enlist_info{target_type = ?TARGET_TYPE_DUNGEON, matching = 0} -> Result;
            #team_enlist_info{lv_limit_max = LvMax, lv_limit_min = LvMin} when RoleLv < LvMin orelse RoleLv > LvMax -> Result;
            #team_enlist_info{dungeon_type = DungeonType} when DungeonType =/= 0 -> Result;
            #team_enlist_info{leader_id=LeaderId, num=Num, members = Members, join_con_value = JoinConValue} ->
                Leader = ulists:keyfind(LeaderId, #mb.id, Members, #mb{}),
                IsSatisfy = lib_team_match:filter_zone_mod_team(ModuleGroupMap, ActivityId, SubTypeId, ServerId, Leader),
                IsMember = lists:keymember(TeamId,1,Result),
                case IsSatisfy andalso IsMember == false of
                    true ->
                        FormatMembers =
                            [begin
                                 Position = lib_team:get_position(Mb, LeaderId),
                                 {_, JoinValue} = ulists:keyfind({ActivityId, SubTypeId}, 1, Mb#mb.join_value_list, {{ActivityId, SubTypeId}, 0}),
                                 {Mb#mb.id, Position, Mb#mb.figure, Mb#mb.help_type, Mb#mb.scene, Mb#mb.online, Mb#mb.server_id, Mb#mb.server_num, JoinValue, Mb#mb.power}
                             end || Mb <- Members],
                        [{TeamId, Num, JoinConValue, FormatMembers}|Result];
                    _ ->  Result
                end;
            _ -> Result
        end
    end,
    % ?MYLOG("hjhenlist", "match_teams ActivityId:~p, SubTypeId:~p TeamIds:~p ActivityMaps:~p TeamMaps:~p ~n",
    %     [ActivityId, SubTypeId, TeamIds, ActivityMaps, TeamMaps]),
    {ok, BinData} = pt_240:write(24012, [ActivityId, SubTypeId, SceneId, lists:foldl(F, [], TeamIds)]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

%%进出副本切换状态--zzy
handle_cast({'change_dungeon_type', TeamId, Type }, State) ->
    #state{team_maps=TeamMaps} = State, 
    case maps:get(TeamId, TeamMaps, false) of
        false ->
            NewState = State;
        #team_enlist_info{} = TeamInfo ->
            case Type =:= into of
                true->
                    NewTeamInfo = TeamInfo#team_enlist_info{ dungeon_type = 1 };
                false->
                    NewTeamInfo = TeamInfo#team_enlist_info{ dungeon_type = 0 }
            end,
            NewTeamMaps = maps:put(TeamId,NewTeamInfo, TeamMaps),
            NewState = State#state{team_maps = NewTeamMaps}
    end,
    {noreply, NewState};

handle_cast({'add_team', TeamId, ActivityId, SubTypeId, SceneId, Num, LeaderId, Args}, State) ->
    #state{team_maps=TeamMaps, activity_maps=ActivityMaps, match_roles_map = MatchRolesMap} = State, 
    MaxNum = lib_team:get_max_team_member_num(ActivityId, SubTypeId),
    TargetType = get_target_type(ActivityId, SubTypeId),
    Info0 = #team_enlist_info{team_id=TeamId, num=Num, leader_id=LeaderId, activity_id=ActivityId, scene_id=SceneId, subtype_id = SubTypeId, max_num = MaxNum, target_type = TargetType},
    Info = fill_team_info_args(Info0, Args),
    NewTeamMaps     = TeamMaps#{TeamId => Info},
    NewActivityMaps = ActivityMaps#{{ActivityId, SubTypeId} => [TeamId | maps:get({ActivityId, SubTypeId}, ActivityMaps, []) ]},
    NewMatchRolesMap = update_match_roles(Args, TeamId, NewTeamMaps, MatchRolesMap),

    {noreply, State#state{team_maps=NewTeamMaps, activity_maps=NewActivityMaps, match_roles_map = NewMatchRolesMap}};

handle_cast({'delete_team', TeamId, ActivityId, SubTypeId, _SceneId}, State) -> 
    #state{team_maps=TeamMaps, activity_maps=ActivityMaps} = State, 

    NewTeamMaps = maps:remove(TeamId, TeamMaps),
    NewActivityMaps = ActivityMaps#{{ActivityId, SubTypeId} => lists:delete(TeamId, maps:get({ActivityId, SubTypeId}, ActivityMaps, []))},

    {noreply, State#state{team_maps=NewTeamMaps, activity_maps=NewActivityMaps}};

handle_cast({'change_team', TeamId, KeyValues}, State) ->
    #state{team_maps=TeamMaps, activity_maps=ActivityMaps, match_roles_map = MatchRolesMap} = State,
    {NewTeamMaps, NewActivityMaps} = change_team(KeyValues, TeamId, TeamMaps, ActivityMaps),
    NewMatchRolesMap = update_match_roles(KeyValues, TeamId, NewTeamMaps, MatchRolesMap),
    {noreply, State#state{team_maps=NewTeamMaps, activity_maps=NewActivityMaps, match_roles_map = NewMatchRolesMap}};

%%handle_cast({'get_teams_num', Sid, TeamIds}, State) ->
%%    #state{team_maps=TeamMaps} = State,
%%    F = fun(TeamId, Result) ->
%%            case maps:get(TeamId, TeamMaps, false) of
%%                false -> Result;
%%                TeamInfo -> [{TeamInfo#team_enlist_info.leader_figure ,TeamId, TeamInfo#team_enlist_info.num, TeamInfo#team_enlist_info.activity_id, TeamInfo#team_enlist_info.subtype_id} | Result]
%%            end
%%    end,
%%    % ?INFO("~p~n",[lists:foldl(F, [], TeamIds)]),
%%    {ok, BinData} = pt_240:write(24032, [ lists:foldl(F, [], TeamIds) ]),
%%    lib_server_send:send_to_sid(Sid, BinData),
%%    {noreply, State};

%% 个人匹配队伍
handle_cast({'match_teams', Mb, ActivityList}, State) ->
    #state{team_maps = TeamMaps, activity_maps = ActivityMaps, match_roles_map = MatchRolesMap, module_group_map = ModuleGroupMap} = State,
    #mb{id = RoleId, figure = #figure{lv = Lv}, node = Node, join_value_list = JoinValueList} = Mb,
    MatchRole0 = maps:get(RoleId, MatchRolesMap, #matching_role{role_id = RoleId, node = Node}),
    F = fun({ActivityId,SubTypeId}, Acc)->
        TeamIds = maps:get({ActivityId,SubTypeId},ActivityMaps,[]),
        [TeamId || TeamId <- TeamIds,
            lib_team_match:check_available_team(ModuleGroupMap, ActivityId, SubTypeId, TeamId, Mb, TeamMaps)] ++ Acc
    end,
    NewAvailableList = lists:foldl(F, [], ActivityList),
    MatchEndRef = util:send_after(MatchRole0#matching_role.match_end_ref, ?TEAM_MATCH_END_TIME*1000, self(), {'role_match_end_ref', Node, RoleId}),
    MatchTime = utime:unixtime(),
    MatchRole1 = MatchRole0#matching_role{
        ref              = MatchRole0#matching_role.ref + 1,
        activity_list    = ActivityList,
        waiting_team_ids = NewAvailableList,
        match_time       = MatchTime,
        lv               = Lv,
        join_value_list  = JoinValueList,
        match_end_ref    = MatchEndRef
        },
    MatchRole = match_team_request(MatchRole1, Mb, TeamMaps),
    NewMatchRolesMap = MatchRolesMap#{RoleId => MatchRole},
    {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 1, MatchTime, 0, 0, RoleId]),
    lib_server_send:send_to_uid(Node, RoleId, BinData),
    {noreply, State#state{match_roles_map = NewMatchRolesMap}};

handle_cast({'near_teams_match', Sid, Mb, TeamList}, State) ->
    {ok, BinData} = pt_240:write(24044, [?SUCCESS]),
    lib_server_send:send_to_sid(Sid, BinData),
    #state{team_maps = TeamMaps, match_roles_map = MatchRolesMap} = State,
    #mb{id = RoleId, figure = #figure{lv = Lv}, node = Node, join_value_list = JoinValueList} = Mb,
    MatchRole0 = maps:get(RoleId, MatchRolesMap, #matching_role{role_id = RoleId}),
    F = fun(TeamId)-> 
        case maps:get(TeamId, TeamMaps, false) of
            #team_enlist_info{num=Num, matching = Matching, join_type = _JoinType, max_num = NumMax} when 
                    Num < NumMax andalso Matching == 1 -> 
                true;
            _ -> 
                % mod_team:cast_to_team(TeamId,  {'join_team_request', Mb})
                false
        end
    end,
    AvailableList = [TeamId || TeamId <- TeamList, F(TeamId)],
    MatchEndRef = util:send_after(MatchRole0#matching_role.match_end_ref, ?TEAM_MATCH_END_TIME*1000, self(), {'role_match_end_ref', Node, RoleId}),
    MatchRole1 = MatchRole0#matching_role{
        ref = MatchRole0#matching_role.ref + 1, 
        activity_list = [], 
        waiting_team_ids = AvailableList,
        match_time = utime:unixtime(), 
        lv = Lv,
        join_value_list = JoinValueList,
        match_end_ref = MatchEndRef
        },
    MatchRole = match_team_request(MatchRole1, Mb, TeamMaps),
    NewMatchRolesMap = MatchRolesMap#{RoleId => MatchRole},
    {noreply, State#state{match_roles_map = NewMatchRolesMap}};

%%handle_cast({'personal_find_team', ActivityId, SubTypeId, _SceneId, Mb}, #state{num_maps=NumMaps} = State) ->
%%    %% todo 取消匹配状态
%%    MaxNum = lib_team:get_max_team_member_num(ActivityId, SubTypeId),
%%    case MaxNum - 1 of
%%        NeedNum when NeedNum>0 andalso NeedNum<MaxNum ->
%%            case find_a_team(NeedNum, NumMaps) of
%%                false  -> {noreply, State};
%%                TeamId ->
%%                    mod_team:cast_to_team(TeamId, {'join_team_request', Mb, ActivityId, SubTypeId})
%%            end;
%%        _ ->
%%            {noreply, State}
%%    end;

handle_cast({'clear_teams_reqlist_by_id', RoleId, TeamIds}, State) ->
    #state{team_maps = TeamMaps} = State,
    F = fun(TeamId)-> 
        case maps:get(TeamId, TeamMaps, false) of
            false ->  skip;
            _ ->
                mod_team:cast_to_team(TeamId,  {'clear_teams_reqlist_by_id', RoleId})
        end
    end,
    lists:map(F,TeamIds),
    {noreply, State};

handle_cast({'clear_role_match', RoleId}, State) ->
    #state{match_roles_map = Map} = State,
    case maps:find(RoleId, Map) of
        {ok, #matching_role{match_end_ref = MatchEndRef}} ->
            util:cancel_timer(MatchEndRef),
            NewMap = maps:remove(RoleId, Map),
            {noreply, State#state{match_roles_map = NewMap}};
        _ ->
            {noreply, State}
    end;

handle_cast({'match_next', Mb, Ref}, State) ->
    #state{match_roles_map = Map, team_maps = TeamMaps} = State,
    case maps:find(Mb#mb.id, Map) of
        {ok, #matching_role{ref = Ref} = R} ->
            #mb{figure = #figure{lv = Lv}, join_value_list = JoinValueList} = Mb,
            NewMatchRole = match_team_request(R#matching_role{match_time = utime:unixtime(), lv = Lv, join_value_list = JoinValueList}, Mb, TeamMaps),
            NewMap = Map#{Mb#mb.id := NewMatchRole},
            {noreply, State#state{match_roles_map = NewMap}};
        _ ->
            {noreply, State}
    end;

handle_cast(_Event, Status) ->
    {noreply, Status}.

%% 匹配结束时间(没有次数的玩家匹配超时会取消匹配)
handle_info({'role_match_end_ref', Node, RoleId}, State) ->
    #state{match_roles_map = MatchRolesMap} = State,
    case maps:get(RoleId, MatchRolesMap, false) of
        false -> {noreply, State};
        #matching_role{match_end_ref = MatchEndRef} = MatchRole0 ->
            util:cancel_timer(MatchEndRef),
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, auto_cancel_role_match, []),
            MatchRole = MatchRole0#matching_role{match_end_ref = none},
            NewMatchRolesMap = MatchRolesMap#{RoleId => MatchRole},
            {noreply, State#state{match_roles_map = NewMatchRolesMap}}
    end;

handle_info(_Info, Status) ->
    {noreply, Status}.

terminate(_R, _State) ->
    ?ERR("~p is terminate:~p", [?MODULE, _R]),
    ok.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.

%% 根据已有人数找寻一个适合人数的队伍
%%find_a_team(MbsLen, _) when MbsLen < 1 -> false;
%%find_a_team(MbsLen, NumMaps) ->
%%    case maps:get(MbsLen, NumMaps, false) of
%%        []    -> find_a_team(MbsLen-1, NumMaps);
%%        false -> find_a_team(MbsLen-1, NumMaps);
%%        [H|_] -> H
%%    end.

change_team([{num, AddNum}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        #team_enlist_info{num=OldNum} = TeamEnlistInfo ->
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{num=max(0, OldNum+AddNum)}},
            change_team(T, TeamId, NewTeamMaps, ActivityMaps)
    end;
change_team([{leader, LeaderId}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        TeamEnlistInfo -> 
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{leader_id=LeaderId} },
            change_team(T, TeamId, NewTeamMaps, ActivityMaps)
    end;
change_team([{matching, V}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        TeamEnlistInfo ->
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{matching = V} },
            change_team(T, TeamId, NewTeamMaps, ActivityMaps)
    end;
change_team([{enlist, #team_enlist{activity_id=OldAcId, subtype_id=OldSubId}, #team_enlist{activity_id=AcId, subtype_id=SubId}}|T], TeamId, TeamMaps, ActivityMaps) ->
    OldActivityMaps = case maps:get({OldAcId, OldSubId}, ActivityMaps, []) of
        []   -> ActivityMaps;
        List -> ActivityMaps#{ {OldAcId, OldSubId} := lists:delete(TeamId, List) }
    end,
    NewActivityMaps = OldActivityMaps#{ {AcId, SubId} => [TeamId|lists:delete(TeamId, maps:get({AcId, SubId}, OldActivityMaps, []))] },
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, NewActivityMaps);
        TeamEnlistInfo -> 
            MaxNum = lib_team:get_max_team_member_num(AcId, SubId),
            TargetType = get_target_type(AcId, SubId),
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{activity_id=AcId, subtype_id = SubId, max_num = MaxNum, target_type = TargetType} },
            change_team(T, TeamId, NewTeamMaps, NewActivityMaps)
    end;
change_team([{lv, Min, Max}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        TeamEnlistInfo -> 
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{lv_limit_min = Min, lv_limit_max = Max} },
            change_team(T, TeamId, NewTeamMaps, ActivityMaps)
    end;
change_team([{mbs, Mbs}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        TeamEnlistInfo ->
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{members = Mbs} },
            change_team(T, TeamId, NewTeamMaps, ActivityMaps)
    end;
change_team([{join_type, JoinType}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        TeamEnlistInfo ->
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{join_type = JoinType} },
            change_team(T, TeamId, NewTeamMaps, ActivityMaps)
    end;
change_team([{join_con_value, JoinConValue}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        TeamEnlistInfo -> 
            NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{join_con_value = JoinConValue} },
            change_team(T, TeamId, NewTeamMaps, ActivityMaps)
    end;
change_team([{help_type, RoleId, HelpType}|T], TeamId, TeamMaps, ActivityMaps) ->
    case maps:get(TeamId, TeamMaps, 0) of
        0 -> change_team(T, TeamId, TeamMaps, ActivityMaps);
        TeamEnlistInfo -> 
            Mbs = TeamEnlistInfo#team_enlist_info.members,
            case lists:keyfind(RoleId, #mb.id, Mbs) of 
                false ->
                    change_team(T, TeamId, TeamMaps, ActivityMaps);
                OldMember ->
                    NewMember = OldMember#mb{help_type = HelpType},
                    NewMbs = lists:keyreplace(RoleId, #mb.id, Mbs, NewMember),
                    NewTeamMaps = TeamMaps#{TeamId := TeamEnlistInfo#team_enlist_info{members = NewMbs} },
                    change_team(T, TeamId, NewTeamMaps, ActivityMaps)
            end
    end;
change_team([], _TeamId, TeamMaps, ActivityMaps) -> {TeamMaps, ActivityMaps};
change_team([_|T], TeamId, TeamMaps, ActivityMaps) -> change_team(T, TeamId, TeamMaps, ActivityMaps).

match_team_request(MatchRole, Mb, TeamMaps) ->
    case MatchRole of
        #matching_role{waiting_team_ids = [TeamId|T], ref = Ref} ->
            case check_match(TeamId, TeamMaps, MatchRole) of
                true ->
                    mod_team:cast_to_team(Mb#mb.node, TeamId, {'match_team_request', Mb, Ref}),
                    MatchRole#matching_role{waiting_team_ids = T};
                _ ->
                    match_team_request(MatchRole#matching_role{waiting_team_ids = T}, Mb, TeamMaps)
            end;
        #matching_role{role_id = RoleId, node = Node, waiting_team_ids = [], activity_list = [{ActId, SubId}|_]} ->
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, handle_noteam_for_match, [ActId, SubId]),
            MatchRole;
        _ ->
            MatchRole
    end.

check_match(TeamId, TeamMaps, #matching_role{activity_list = ActivityList, lv = Lv, join_value_list = JoinValueList}) ->
    case maps:get(TeamId, TeamMaps, false) of
        #team_enlist_info{num=Num, matching = Matching, 
            activity_id = ActivityId, subtype_id = SubTypeId,
            lv_limit_min = LvMin, lv_limit_max = LvMax, join_con_value = JoinConValue,
            join_type = _JoinType,
            max_num = NumMax
        } when Num < NumMax andalso Matching == 1 ->
            if
                Lv < LvMin orelse Lv > LvMax ->
                    false;
                ActivityList =:= [] ->
                    true;
                true ->
                    case lists:member({ActivityId, SubTypeId}, ActivityList) of 
                        true ->
                            {_, JoinValue} = ulists:keyfind({ActivityId, SubTypeId}, 1, JoinValueList, {{ActivityId, SubTypeId}, 0}),
                            if
                                JoinConValue > 0 andalso JoinValue < JoinConValue ->
                                    false;
                                true ->
                                    true
                            end;
                        _ ->
                            false
                    end
            end;
        _ -> 
            % mod_team:cast_to_team(TeamId,  {'join_team_request', Mb})
            false
    end.

update_match_roles(KeyValues, TeamId, TeamMaps, MatchRolesMap) ->
    case is_need_update_match(KeyValues) of
        true ->
            F = fun
                (_, MatchRole) ->
                    do_update_match_role(MatchRole, TeamId, TeamMaps)
            end,
            maps:map(F, MatchRolesMap);
        _ ->
            MatchRolesMap
    end.

is_need_update_match([{enlist, _, _}|_]) ->
    true;

is_need_update_match([{lv, _, _}|_]) ->
    true;

is_need_update_match([{join_con_value, _}|_]) ->
    true;

is_need_update_match([{matching, 1}|_]) ->
    true;

is_need_update_match([{join_type, ?TEAM_JOIN_TYPE_AUTO}|_]) ->
    true;

is_need_update_match([_|T]) ->
    is_need_update_match(T);

is_need_update_match([]) -> false.


do_update_match_role(MatchRole, TeamId, TeamMaps) ->
    #matching_role{waiting_team_ids = WaitingIds, role_id = RoleId, ref = Ref, node = Node} = MatchRole,
    case lists:member(TeamId, WaitingIds) of
        false ->
            case check_match(TeamId, TeamMaps, MatchRole) of
                true ->
                    if
                        WaitingIds =:= [] ->
                            NewRef = Ref + 1, 
                            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, auto_match_team, [[node(), NewRef]]);
                        true ->
                            NewRef = Ref
                    end,
                    MatchRole#matching_role{waiting_team_ids = [TeamId|WaitingIds], ref = NewRef};
                _ ->
                    MatchRole
            end;
        _ ->
            MatchRole
    end.

fill_team_info_args(Info0, [{lv, Min, Max}|T]) ->
    Info = Info0#team_enlist_info{lv_limit_min = Min, lv_limit_max = Max},
    fill_team_info_args(Info, T);
fill_team_info_args(Info0, [{mbs, Mbs}|T]) ->
    Info = Info0#team_enlist_info{members = Mbs},
    fill_team_info_args(Info, T);
fill_team_info_args(Info0, [{join_type, JoinType}|T]) ->
    Info = Info0#team_enlist_info{join_type = JoinType},
    fill_team_info_args(Info, T);
fill_team_info_args(Info0, [{join_con_value, JoinConValue}|T]) ->
    Info = Info0#team_enlist_info{join_con_value = JoinConValue},
    fill_team_info_args(Info, T);
fill_team_info_args(Info, []) -> Info;
fill_team_info_args(Info, [_|T]) ->
    fill_team_info_args(Info, T).

get_target_type(AcId, SubId) ->
    case data_team_ui:get(AcId, SubId) of
        #team_enlist_cfg{dun_id = DunId} when DunId > 0 ->
            ?TARGET_TYPE_DUNGEON;
        _ ->
            ?TARGET_TYPE_NONE
    end.
