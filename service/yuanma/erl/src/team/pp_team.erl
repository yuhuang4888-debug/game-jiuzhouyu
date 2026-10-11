%% ---------------------------------------------------------------------------
%% @doc pp_team
%% @author ming_up@foxmail.com
%% @since  2016-11-01
%% @deprecated 组队协议
%% ---------------------------------------------------------------------------
-module(pp_team).
-export([handle/3]).

-include("common.hrl").
-include("server.hrl").
-include("team.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").

%% 创建队伍(玩家自己组队只能组本服队伍)
handle(24000, Ps0, [ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue]) ->
    Ps = lib_team:silent_cancel_team_match(Ps0),
    case lib_team:create_team(Ps, ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue) of
        {ok, NewPS} ->
            {ok, NewPS};
        {false, ErrCode} ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrCode),
            {ok, BinData} = pt_240:write(24000, [ErrorCodeInt, ErrorCodeArgs]),
            lib_server_send:send_to_sid(Ps#player_status.sid, BinData),
            {ok, Ps}
    end;

%% 加入队伍
handle(24002, Ps, [TeamId, ActivityId, SubTypeId]) ->
    lib_team:ask_for_join_team(Ps, TeamId, ActivityId, SubTypeId);

%% 队长回应加入队伍请求
handle(24004, Status, [ResRequest]) ->
    #player_status{id = LeaderId,
        sid = Sid,
        team = #status_team{team_id=TeamId},
        change_scene_sign = IsChangeSceneSign} = Status,
    if
        IsChangeSceneSign /= 0 ->
            lib_server_send:send_to_sid(Sid, pt_240, 24004, [?ERRCODE(err240_changing_scene)]);
        TeamId > 0 ->
            case ResRequest of
                [{IsAgree, _SerId, RoleId}] -> %% 单人处理
                    mod_team:cast_to_team(TeamId, {'join_team_response', IsAgree, RoleId, LeaderId});
                [] ->
                    mod_team:cast_to_team(TeamId, {'join_team_response', LeaderId, reject_all});
                _ ->
                    lib_server_send:send_to_sid(Sid, pt_240, 24004, [?SUCCESS])
            end;
        true ->
            lib_server_send:send_to_sid(Sid, pt_240, 24004, [?ERRCODE(err240_no_team)])
    end;

%% 离开队伍
handle(24005, Status, []) ->
    #player_status{id = RoleId, team = #status_team{team_id=TeamId}} = Status,
    mod_team:cast_to_team(TeamId, {'quit_team', RoleId, 0}),
    ok;

% pt_24006_[1,0,0,1,500,[4294967358, 4294967303]]
%% 邀请别人加入队伍
handle(24006, Ps, [ActivityId, SubTypeId, SceneId, LvMin, LvMax, InviteList]) ->
    #player_status{
        id = InviterId,
        sid = Sid,
        scene = InviteScene,
        team = #status_team{team_id=TeamId}
      } = Ps,
    if
        [] == InviteList ->
            lib_server_send:send_to_sid(Sid, pt_240, 24006, [?ERRCODE(err240_34_no_invite_role)]);
        TeamId > 0 ->
            mod_team:cast_to_team(TeamId, {'invite_request', InviteList, InviterId, InviteScene, ActivityId, SubTypeId, 0});
        true ->
            case handle(24000, Ps, [ActivityId, SubTypeId, SceneId, LvMin, LvMax]) of
                {ok, #player_status{team = #status_team{team_id = NewTeamId}} = NewPS} when NewTeamId > 0 ->
                    mod_team:cast_to_team(NewTeamId, {'invite_request', InviteList, InviterId, InviteScene, ActivityId, SubTypeId, 0}),
                    {ok, NewPS};
                _ ->
                    ok
            end
    end;

%% 被邀请人回应邀请请求
handle(24008, Ps, [ResponseList]) ->
    #player_status{figure = #figure{lv = Lv}, sid=Sid, team=#status_team{team_id=MyTeamId}, scene=Scene, copy_id=CopyId, x=X, y=Y} = Ps,
    case ResponseList of
        [{TeamId, Res}] -> %% 单人处理
            MbInfo = lib_team_api:thing_to_mb(Ps),
            if
                Lv =< ?TEAM_NEED_LV ->
                    mod_team:cast_to_team(TeamId,  {'invite_response', 2, MbInfo, [Scene, CopyId, X, Y]}),
                    lib_server_send:send_to_sid(Sid, pt_240, 24008, [?ERRCODE(err240_not_enough_lv_to_join_team), []]);
                MyTeamId == 0 ->
                    case mod_team:cast_to_team(TeamId,  {'invite_response', Res, MbInfo, [Scene, CopyId, X, Y]}) of
                        false -> lib_server_send:send_to_sid(Sid, pt_240, 24008, [?ERRCODE(err240_team_disappear), []]);
                        _ -> ok
                    end;
                true ->
                    mod_team:cast_to_team(TeamId,  {'invite_response', 2, MbInfo, [Scene, CopyId, X, Y]}),
                    lib_server_send:send_to_sid(Sid, pt_240, 24008, [?ERRCODE(err240_in_team), []])
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_240, 24008, [?SUCCESS, []])
    end;

%% 踢出队伍
handle(24009, Ps, [KickId]) ->
    #player_status{id = LeaderId, team=#status_team{team_id=TeamId}, sid = Sid} = Ps,
    if
        TeamId < 1 ->
            {ok, BinData} = pt_240:write(24009, [?ERRCODE(err240_no_team)]),
            lib_server_send:send_to_sid(Sid, BinData);
        LeaderId == KickId ->
            {ok, BinData} = pt_240:write(24009, [?ERRCODE(err240_kick_himself)]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            mod_team:cast_to_team(TeamId,  {'kick_out', KickId, LeaderId, 0})
    end;

%% 请求队伍信息
handle(24010, Ps, []) ->
    #player_status{team=#status_team{team_id=TeamId}, id = Id} = Ps,
    ?PRINT("get_team_info_bin TeamId:~p ~n", [TeamId]),
    if
        TeamId < 1 -> skip;
        true -> mod_team:cast_to_team(TeamId,  {'get_team_info', Id})
    end;

%% 委任队长
handle(24011, Ps, [NewLeaderId]) ->
    #player_status{id = OldLeaderId, team=#status_team{team_id=TeamId}} = Ps,
    if
        OldLeaderId == NewLeaderId -> skip;
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'change_leader', NewLeaderId, OldLeaderId});
        true -> skip
    end;

%% 查看队伍
handle(24012, Ps, [ActivityId, SubTypeId, SceneId]) ->
    #player_status{sid=Sid, figure = #figure{lv = Lv}, server_id = ServerId} = Ps,
    Msg = {'get_all_team', ServerId, Sid, ActivityId, SubTypeId, SceneId, Lv},
    case lib_team:is_cls_target(ActivityId, SubTypeId) of
        true ->
            mod_team_enlist:cast_to_team_enlist(?NODE_CENTER, Msg);
        _ ->
            mod_team_enlist:cast_to_team_enlist(Msg)
    end;

%% 申请入队（点击玩家），仅支持本服玩家
handle(24016, Ps, [PlayerId]) ->
    #player_status{
        figure = #figure{lv = Lv},
        team = #status_team{team_id=MyTeamId},
        change_scene_sign = IsChangeSceneSign} = Ps,
    IsOnDungeon = lib_dungeon:is_on_dungeon(Ps),
    Result = if
        Lv =< ?TEAM_NEED_LV -> {false, ?ERRCODE(err240_not_enough_lv_to_join_team)};
        MyTeamId /= 0 -> {false, ?ERRCODE(err240_in_team)};
        IsChangeSceneSign /= 0 -> {false, ?ERRCODE(err240_changing_scene)};
        IsOnDungeon -> {false, ?ERRCODE(err610_on_dungeon)};
        true ->
            case misc:get_player_process(PlayerId) of
                Pid when is_pid(Pid) ->
                    Mb = lib_team_api:thing_to_mb(Ps),
                    % ?PRINT("~p~n", [Mb#mb.help_type]),
                    lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, lib_team, join_player_team, [Mb]);
                _ -> {false, ?ERRCODE(err240_other_offline)}
            end
    end,
    case Result of
        {false, ErrCode} ->
            {ok, BinData} = pt_240:write(24016, [ErrCode]),
            lib_server_send:send_to_sid(Ps#player_status.sid, BinData);
        _ -> skip
    end;

%% 更改组队目标
handle(24017, Ps, [ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue]) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'change_team_enlist', RoleId, ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue});
        true -> skip
    end;

%% 更改组队目标
handle(24018, Ps, [JoinType]) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'change_join_type', RoleId, JoinType});
        true -> skip
    end;

%% 发起投票
handle(24020, Ps, [ActivityId, SubTypeId]) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId, positon = Postion}, sid = Sid} = Ps,
    if
        TeamId =:= 0 ->
            {ok, BinData} = pt_240:write(24020, [?ERRCODE(err240_not_on_team), "", ActivityId, SubTypeId, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        Postion =/= ?TEAM_LEADER ->
            {ok, BinData} = pt_240:write(24020, [?ERRCODE(err240_not_leader_to_arbitrate_req), "", ActivityId, SubTypeId, 0, 0]),
            lib_server_send:send_to_sid(Sid, BinData);
        true -> 
            mod_team:cast_to_team(TeamId, {'arbitrate_req_ready', RoleId, ActivityId, SubTypeId})
            % case lib_team:check_start_team_target(Ps, ActivityId, SubTypeId) of
            %     {ok, Data} ->
            %         mod_team:cast_to_team(TeamId, {'arbitrate_req', RoleId, ActivityId, SubTypeId, Data});
            %     {false, Code} ->
            %         {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(Code),
            %         {ok, BinData} = pt_240:write(24020, [ErrorCodeInt, ErrorCodeArgs, ActivityId, SubTypeId, 0, 0]),
            %         lib_server_send:send_to_sid(Sid, BinData);
            %     {false, _, Code} ->
            %         {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(Code),
            %         {ok, BinData} = pt_240:write(24020, [ErrorCodeInt, ErrorCodeArgs, ActivityId, SubTypeId, 0, 0]),
            %         lib_server_send:send_to_sid(Sid, BinData)
            % end
    end;

%% 队员投票
handle(24021, Ps, [ArbitrateId, Res]) ->
    #player_status{id = RoleId, team = StatusTeam} = Ps,
    case StatusTeam of
        #status_team{team_id=TeamId, arbitrate_info = [ActivityId, SubTypeId, ArbitrateId]} when TeamId > 0 ->
            if
                Res =:= 1 ->
                    case lib_team:check_start_team_target(Ps, ActivityId, SubTypeId) of
                        {ok, Data} ->
                            mod_team:cast_to_team(TeamId, {'arbitrate_res', RoleId, ArbitrateId, {1, {ok, Data}}}),
                            {ok, lib_player:soft_action_lock(Ps, ?ERRCODE(err240_in_arbitrate), 15)};
                        {false, Code} ->
                            OtherErrorCode = lib_team:my_code_to_other_code(Ps#player_status.figure#figure.name, Code),
                            Error = {false, OtherErrorCode, Code},
                            mod_team:cast_to_team(TeamId, {'arbitrate_res', RoleId, ArbitrateId, {0, Error}});
                        {false, _Code, _MyErrorCode} = Error ->
                            mod_team:cast_to_team(TeamId, {'arbitrate_res', RoleId, ArbitrateId, {0, Error}})
                    end;
                true ->
                    mod_team:cast_to_team(TeamId, {'arbitrate_res', RoleId, ArbitrateId, {Res, {ok, []}}})
            end;
        _ ->
            skip
    end;

%% 匹配队伍--zzy
handle(24023, Ps, [ActivityId, SubTypeId]) ->
    #player_status{figure = #figure{lv = Lv}, sid=Sid, team = StatusTeam} = Ps,
    Result = lib_player_check:check_list(Ps, [action_free]),
    if 
        Lv =< ?TEAM_NEED_LV -> skip;
        StatusTeam#status_team.team_id > 0 -> skip;
        ActivityId =:= ?ACTIVITY_ID_NO -> 
            {ok, BinData} = pt_240:write(24023, [?ERRCODE(err240_choose_target_first), ActivityId, SubTypeId]),
            lib_server_send:send_to_sid(Sid, BinData);
        Result =/= true ->
            {false, Code} = Result,
            {ok, BinData} = pt_240:write(24023, [Code, ActivityId, SubTypeId]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            case StatusTeam#status_team.match_info of
                [] ->
                    ActivityList = [{ActivityId, SubTypeId}],
                    case lib_team:check_start_team_target(Ps, ActivityId, SubTypeId) of
                        {ok, _} ->
                            NewPS = Ps#player_status{team = StatusTeam#status_team{match_info = ActivityList}},
                            case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, match_teams, 3) of
                                undefined ->
                                    Mb = lib_team_api:thing_to_mb(Ps),
                                    case lib_team:is_cls_target(ActivityId, SubTypeId) of
                                        true ->
                                            mod_clusters_node:apply_cast(mod_team_enlist, match_teams, [Mb, ActivityList]);
                                        false ->
                                            mod_team_enlist:match_teams(Mb, ActivityList)
                                    end,
                                    {ok, BinData} = pt_240:write(24023, [?SUCCESS, ActivityId, SubTypeId]),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    LockPS = lib_player:setup_action_lock(NewPS, ?ERRCODE(err240_change_when_matching)),
                                    {ok, LockPS};
                                Mod ->
                                    Mod:match_teams(NewPS, ActivityId, SubTypeId)
                            end;
                        {false, _OtherErrorCode, MyErrorCode} ->
                            if
                                is_integer(MyErrorCode) ->
                                    {ok, BinData} = pt_240:write(24023, [MyErrorCode, ActivityId, SubTypeId]);
                                true ->
                                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(MyErrorCode),
                                    {ok, BinData} = pt_240:write(24038, [ErrorCodeInt, ErrorCodeArgs])
                            end,
                            lib_server_send:send_to_sid(Sid, BinData);
                        {false, MyErrorCode} ->
                            if
                                is_integer(MyErrorCode) ->
                                    {ok, BinData} = pt_240:write(24023, [MyErrorCode, ActivityId, SubTypeId]);
                                true ->
                                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(MyErrorCode),
                                    {ok, BinData} = pt_240:write(24038, [ErrorCodeInt, ErrorCodeArgs])
                            end,
                            lib_server_send:send_to_sid(Sid, BinData)
                    end;
                _ ->
                    {ok, BinData} = pt_240:write(24023, [?ERRCODE(err240_change_when_matching), ActivityId, SubTypeId]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end;

% handle(24023, Ps, [ActivityList]) ->
%     % ?PRINT("24023 >>> 2 ~p~n", [ActivityList]),
%     #player_status{figure = #figure{lv = Lv}, sid=Sid, team = StatusTeam} = Ps,
%     case Lv =< ?TEAM_NEED_LV of
%         true -> skip;
%         false ->
%             F = fun
%                 ({ActivityId, SubTypeId}) ->
%                     case lib_team_match:get_match_mod(ActivityId, SubTypeId) of
%                         undefined ->
%                             lib_team:common_check(Ps, ActivityId, SubTypeId) =:= true;
%                         _ ->
%                             false
%                     end
%             end,
%             case [X || X <- ActivityList, F(X)] of
%                 [] ->
%                     skip;
%                 AvailableList ->
%                     Mb = lib_team_api:thing_to_mb(Ps),
%                     mod_team_enlist:match_teams(Mb, Sid, AvailableList),
%                     {ok, Ps#player_status{team = StatusTeam#status_team{match_info = AvailableList}}}
%             end
%     end;


%% 跟战
handle(24024, Ps, [Type, FollowId]) ->
    #player_status{id=Id, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'follow_someone', Type, Id, FollowId});
        true -> skip
    end,
    ok;

%% 查看队员场景信息
handle(24025, Ps, [InfoId]) ->
    #player_status{id=Id, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'get_mb_scene', Id, InfoId});
        true -> skip
    end,
    ok;

%% 查询跟战状态
handle(24026, Ps, []) ->
    #player_status{id=Id, sid=Sid, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'get_follow_id', Id});
        true ->
            {ok, BinData} = pt_240:write(24026, [0]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    ok;

%% 批量查看队伍人数
%%handle(24032, Ps, [TeamIds]) ->
%%    mod_team_enlist:get_teams_num(Ps#player_status.sid, TeamIds),
%%    ok;

%% 助战
handle(24033, Ps, [DunId, HelpType]) when HelpType == ?HELP_TYPE_NO; HelpType == ?HELP_TYPE_YES ->
    IsOnDungeon = lib_dungeon:is_on_dungeon(Ps),
    IsAssistDun = lib_guild_assist:is_assist_dungeon(Ps, DunId),
    if
        IsOnDungeon ->
            ok;
        IsAssistDun ->
            ok;
        true ->
            case lib_dungeon_team:check_help_type_setup(DunId) of
                true ->
                    lib_team:set_help_type(Ps, DunId, HelpType);
                _ ->
                    {ok, BinData} = pt_240:write(24038, [?ERRCODE(err240_help_type_setup_limit), []]),
                    lib_server_send:send_to_sid(Ps#player_status.sid, BinData),
                    ok
            end
    end;

%% 取消别人跟战
handle(24039, Ps, [ ]) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'cancel_other_follow', RoleId});
        true -> skip
    end;


%% 获取活动剩余次数--zzy
handle(24042, Ps, [ActivityId])->
    % ?PRINT("24042~p~n",[ActivityId]),
    #player_status{id = _RoleId, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 ->
            lib_team:send_ac_left_time(Ps,ActivityId);
        true -> skip
    end;

%% 广播队伍野外修炼
handle(24043, Ps, [SceneId, MonId, X, Y]) ->
    #player_status{team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 -> mod_team:cast_to_team(TeamId, {'outdoor_training', SceneId, MonId, X, Y});
        true -> skip
    end;

%% 附近队伍匹配
handle(24044, Ps, [TeamIds]) ->
    #player_status{sid = Sid, team=#status_team{team_id=TeamId, match_info = MatchInfo} = StatusTeam} = Ps,
    if
        TeamId > 0 -> skip;
        TeamIds =:= [] -> 
            {ok, BinData} = pt_240:write(24044, [?ERRCODE(err240_no_teams_for_match)]),
            lib_server_send:send_to_sid(Sid, BinData);
        MatchInfo =:= [] ->
            Mb = lib_team_api:thing_to_mb(Ps),
            {ClsIds, LocalIds} = lists:partition(fun(Id) -> Id rem 2 == 0 end, TeamIds),
            case ClsIds of
                [] ->
                    ok;
                _ ->
                    mod_clusters_node:apply_cast(mod_team_enlist, cast_to_team_enlist, {'near_teams_match', Sid, Mb, ClsIds})
            end,
            case LocalIds of
                [] ->
                    ok;
                _ ->
                    mod_team_enlist:cast_to_team_enlist({'near_teams_match', Sid, Mb, TeamIds})
            end,
            {ok, Ps#player_status{team = StatusTeam#status_team{match_info = TeamIds}}};
        true ->
            {ok, BinData} = pt_240:write(24044, [?ERRCODE(err240_change_when_matching)]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 查询申请列表
handle(24047, Ps, []) ->
    #player_status{team=#status_team{team_id=TeamId, positon = Pos}, id = RoleId} = Ps,
    if
        TeamId > 0 andalso Pos =:= ?TEAM_LEADER ->
            mod_team:cast_to_team(TeamId, {'get_reqlist', RoleId});
        true -> skip
    end;

%% 设置自动匹配状态
handle(24048, Ps, [State]) ->
    #player_status{team=#status_team{team_id=TeamId, positon = Pos}, id = RoleId, sid = Sid} = Ps,
    if
        TeamId > 0 ->
            if
                Pos =:= ?TEAM_LEADER orelse State =:= 0  ->
                    if
                        State == 0 ->
                            mod_team:cast_to_team(TeamId, {'set_matching_state', RoleId, State});
                        true ->
                            case lib_player_check:check_all(Ps) of
                                true ->
                                    mod_team:cast_to_team(TeamId, {'set_matching_state', RoleId, State});
                                {false, Code} when is_integer(Code) ->
                                    {CodeInt, CodeArgs} = util:parse_error_code(Code),
                                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, State, 0, 0, 0, RoleId]),
                                    lib_server_send:send_to_sid(Sid, BinData);
                                {false, Code} ->
                                    {CodeInt, CodeArgs} = util:parse_error_code(Code),
                                    {ok, BinData} = pt_240:write(24038, [CodeInt, CodeArgs]),
                                    lib_server_send:send_to_sid(Sid, BinData)
                            end
                    end ;
                true ->
                    {CodeInt, CodeArgs} = util:parse_error_code(?ERRCODE(err240_not_leader)),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, State, 0, 0, 0, RoleId]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        TeamId =:= 0 andalso State =:= 0 ->
            lib_team:cancel_role_match(Ps);
        true -> skip
    end;

%% 获取我的助战状态
handle(24049, Ps, [DunId]) ->
    #player_status{sid = Sid, help_type_setting = HMap} = Ps,
    case maps:find(DunId, HMap) of
        {ok, {default, HelpType}} ->
            {ok, BinData} = pt_240:write(24049, [DunId, HelpType]),
            lib_server_send:send_to_sid(Sid, BinData);
        {ok, HelpType} ->
            {ok, BinData} = pt_240:write(24049, [DunId, HelpType]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            HelpType = lib_dungeon_team:get_default_help_type(Ps, DunId),
            {ok, BinData} = pt_240:write(24049, [DunId, HelpType]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, Ps#player_status{help_type_setting = HMap#{DunId => {default, HelpType}}}}
    end;

handle(24050, PS, []) ->
    #player_status{team = #status_team{exp_scale = ExpScale}, sid = Sid} = PS,
    {ok, BinData} = pt_240:write(24050, [ExpScale]),
    lib_server_send:send_to_sid(Sid, BinData);

handle(24053, PS, [SceneId]) ->
    #player_status{id = RoleId, copy_id = CopyId, scene_pool_id = ScenePoolId} = PS,
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_team, send_scene_users_without_team, [CopyId, node(), RoleId, SceneId]);

handle(24054, Ps, [ActivityId, SubTypeId]) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId, positon = Postion}, sid = Sid} = Ps,
    if
        TeamId =:= 0 ->
            {ok, BinData} = pt_240:write(24054, [?ERRCODE(err240_not_on_team)]),
            lib_server_send:send_to_sid(Sid, BinData);
        Postion =/= ?TEAM_LEADER ->
            {ok, BinData} = pt_240:write(24054, [?ERRCODE(err240_not_leader)]),
            lib_server_send:send_to_sid(Sid, BinData);
        true ->
            mod_team:cast_to_team(TeamId, {'set_matching', RoleId, ActivityId, SubTypeId})
    end;

handle(24055, Ps, []) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId}} = Ps,
    if
        TeamId > 0 ->
            mod_team:cast_to_team(TeamId, {send_invite_tv, RoleId});
        true ->
            ok
    end;

handle(24057, Ps, [InviteList]) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId}, scene = InviteScene} = Ps,
    if
        TeamId > 0 ->
            mod_team:cast_to_team(TeamId, {'invite_request', InviteList, RoleId, InviteScene, 1});
        true ->
            ok
    end;

%% 人满自动开始
handle(24059, Ps, [Auto]) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId, positon = Position}, sid = Sid} = Ps,
    if
        TeamId > 0 andalso Position =:= ?TEAM_LEADER ->
            mod_team:cast_to_team(TeamId, {'set_auto_start', RoleId, Auto});
        true ->
            {ok, BinData} = pt_240:write(24030, [?ERRCODE(err240_not_leader)]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;

%% 招募列表
handle(24060, Ps, [Type, DunId]) ->
    lib_team:send_recruit_list(Ps, Type, DunId);

%% 队员招募列表
handle(24061, Ps, [Type]) ->
    lib_team:send_recruit_list(Ps, Type);

%% 催促开启活动
handle(24062, Ps, []) ->
    #player_status{id = RoleId, team=#status_team{team_id=TeamId, positon = Position}, figure = #figure{name = Name} = Figure} = Ps,
    if
        TeamId > 0 andalso Position =/= ?TEAM_LEADER ->
            mod_team:cast_to_team(TeamId, {'ugre_open_act', Name}),
            lib_chat:send_TV({team, TeamId}, RoleId, Figure, ?MOD_TEAM, 10, []);
        true ->
            skip
    end;

%% 一键同意入队
handle(24063, PS, []) ->
    #player_status{
        sid               = Sid,
        change_scene_sign = IsChangeSceneSign,
        team = #status_team{team_id = TeamId, positon = Position}
    } = PS,
    if
        IsChangeSceneSign =/= 0 -> lib_server_send:send_to_sid(Sid, pt_240, 24063, [?ERRCODE(err240_changing_scene)]);
        Position =/= ?TEAM_LEADER -> lib_server_send:send_to_sid(Sid, pt_240, 24063, [?ERRCODE(err240_not_leader)]);
        TeamId =< 0 -> lib_server_send:send_to_sid(Sid, pt_240, 24063, [?ERRCODE(err240_no_team)]);
        true -> mod_team:cast_to_team(TeamId, {'join_team_response_all'})
    end;

handle(_Cmd, _Status, _Data) ->
    ?DEBUG("pp_team no match", []),
    {error, "pp_team no match"}.
