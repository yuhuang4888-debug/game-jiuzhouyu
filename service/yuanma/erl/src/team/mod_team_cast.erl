%% ---------------------------------------------------------------------------
%% @doc mod_team_cast
%% @author ming_up@foxmail.com
%% @since  2016-10-24
%% @deprecated
%% ---------------------------------------------------------------------------
-module(mod_team_cast).
-export([handle_cast/2]).

-include("common.hrl").
-include("server.hrl").
-include("team.hrl").
-include("figure.hrl").
-include("predefine.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").
-include("def_daily.hrl").
-include("def_module.hrl").
-include("rec_onhook.hrl").
-include("skill.hrl").
-include("drop.hrl").
-include("attr.hrl").

-export([
        del_rela/3
    ]).

handle_cast({Node, {'match_team_request', Mb, Ref}}, State) ->
    #team{
        free_location = FreeLocation,
        member = MemberList,
        leader_id = LeaderId,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId},
        is_matching = IsMatching,
        join_type = _JoinType
        } = State,
    #mb{id = RoleId, online = OL} = Mb,
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    %% 有自己的匹配逻辑不能参与一般匹配
    SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
    if
        (IsMatching =/= 1) orelse SpecialMatchMod =/= undefined orelse
                IsOnDungeon orelse FreeLocation == [] ->
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, auto_match_team, [[node(), Ref]]),
            {noreply, State};
        true ->
            case lib_team_mod:common_check(State, Mb) of
                true ->
                    case lists:keyfind(RoleId, #mb.id, MemberList) of
                        false ->
                            case lists:keyfind(LeaderId, #mb.id, MemberList) of
                                #mb{online = OL} ->
                                    handle_cast({Node, {'join_team', Mb}}, State);
                                _A ->
                                    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, auto_match_team, [[node(), Ref]]),
                                    {noreply, State}
                            end;
                        _ ->
                            {noreply, State}
                    end;
                _CommonCheck ->
                    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, auto_match_team, [[node(), Ref]]),
                    {noreply, State}
            end
    end;

%% 申请加入队伍
handle_cast({Node, {'join_team_request', Mb, ActivityId, SubTypeId}}, State) ->
    #team{
        join_type = JoinType,
        free_location=FreeLocation, member=MemberList, leader_id=LeaderId,
        leader_node=LeaderNode, reqlist = ReqList, id = TeamId,
        enlist = #team_enlist{activity_id = ActivityId0, subtype_id = SubTypeId0},
        is_matching = IsMatching} = State,
    #mb{id=RoleId, server_num = MbServ, figure = Figure} = Mb,
    CommonCheck = lib_team_mod:common_check(State, Mb),
    SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    if
        ActivityId =/= ActivityId0 orelse SubTypeId =/= SubTypeId0 ->
            {ok, BinData} = pt_240:write(24002, [?ERRCODE(err240_team_target_changed), []]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        FreeLocation == [] ->
            {ok, BinData} = pt_240:write(24002, [?ERRCODE(err240_max_member), []]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        CommonCheck =/= true ->
            {false, _OtherErrorCode, MyErrorCode} = CommonCheck,
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(MyErrorCode),
            {ok, BinData} = pt_240:write(24002, [ErrorCodeInt, ErrorCodeArgs]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        IsMatching /= 0 andalso SpecialMatchMod =/= undefined ->
            {ok, BinData} = pt_240:write(24002, [?ERRCODE(err240_this_team_matching), []]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        IsOnDungeon ->
            {ok, BinData} = pt_240:write(24002, [?ERRCODE(err240_this_team_on_dungeon), []]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        true ->
            case lists:keyfind(RoleId, #mb.id, MemberList) of
                false when JoinType == ?TEAM_JOIN_TYPE_AUTO -> %% 自动加入
                    handle_cast({Node, {'join_team_af_response_agree', Mb}}, State);
                false ->
                    %%向队长发送进队申请
                    NewReqList = lists:keystore(RoleId, #mb.id, ReqList, Mb),
                    Data = [MbServ, RoleId, Figure],
                    {ok, BinData1} = pt_240:write(24003, Data),
                    lib_team:send_to_uid(LeaderNode, LeaderId, BinData1),
                    {ok, BinData2} = pt_240:write(24002, [?SUCCESS, []]),
                    lib_team:send_to_uid(Node, RoleId, BinData2),
                    %% lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_team, clear_role_reqlist, [])
                    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, set_req_team_id, [TeamId]),
                    {noreply, State#team{reqlist = NewReqList}};
                _ ->
                    {ok, BinData1} = pt_240:write(24002, [?ERRCODE(err240_in_team), []]),
                    lib_team:send_to_uid(Node, RoleId, BinData1),
                    {noreply, State}
            end
    end;

handle_cast({Node, {'get_target_for_join', Mb}}, State) ->
    #team{free_location=FreeLocation, id = TeamId,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId},
        is_matching = IsMatching} = State,
    #mb{id=RoleId} = Mb,
    CommonCheck = lib_team_mod:common_check(State, Mb),
    SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
    if
        CommonCheck =/= true ->
            {false, _OtherErrorCode, MyErrorCode} = CommonCheck,
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(MyErrorCode),
            {ok, BinData} = pt_240:write(24002, [ErrorCodeInt, ErrorCodeArgs]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        FreeLocation == [] ->
            {ok, BinData} = pt_240:write(24002, [?ERRCODE(err240_max_member), []]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        IsMatching /= 0 andalso SpecialMatchMod =/= undefined ->
            {ok, BinData} = pt_240:write(24002, [?ERRCODE(err240_this_team_matching), []]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        true ->
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, ask_for_join_team, [TeamId, ActivityId, SubTypeId]),
            {noreply, State}
    end;

handle_cast({Node, {'join_team_response', LeaderId, reject_all}}, #team{leader_id = LeaderId} = State) ->
    #team{cls_type=ClsType, reqlist = ReqList} = State,
    if
        ClsType == ?NODE_GAME ->
            {ok, BinData1} = pt_240:write(24002, [?ERRCODE(err240_leader_reject), []]),
            [lib_team:send_to_uid(MNode, Uid, BinData1) || #mb{id = Uid, node = MNode} <- ReqList];
        true ->
            ok
    end,
    {ok, BinData} = pt_240:write(24004, [?SUCCESS]),
    lib_team:send_to_uid(Node, LeaderId, BinData),
    {noreply, State#team{reqlist = []}};

%% 队长回应加入队伍申请
handle_cast({Node, {'join_team_response', Res, Uid, ResponseId}}, State) ->
    #team{
        id=TeamId, cls_type=ClsType, free_location=FreeLocation,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId},
        leader_id=LeaderId, reqlist = ReqList, is_matching = IsMatching
        } = State,
    SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
    ErrCode = if
        Res == 0 andalso ClsType == ?NODE_GAME ->
            {ok, BinData1} = pt_240:write(24002, [?ERRCODE(err240_leader_reject), []]),
            lib_team:send_to_uid(Node, Uid, BinData1),
            ?SUCCESS;
        Res == 0 -> ?SUCCESS;
        [] == FreeLocation -> ?ERRCODE(err240_max_member);
        LeaderId /= ResponseId -> ?ERRCODE(err240_not_leader);
        IsMatching /= 0 andalso SpecialMatchMod =/= undefined -> ?ERRCODE(err240_change_when_matching);
        ClsType == ?NODE_CENTER ->
            SerId = mod_player_create:get_serid_by_id(Uid),
            mod_team:cast_to_game(ClsType, SerId, lib_player, apply_cast,
                [Uid, ?APPLY_CAST_STATUS, lib_team, get_info_and_join_team, [Uid, TeamId]]),
            ?SUCCESS;
        true ->
            case lib_player:get_player_info(Uid, #player_status.team) of
                false ->
                    {ok, BinData1} = pt_240:write(24030, [?ERRCODE(err240_offline)]),
                    lib_team:send_to_uid(Node, LeaderId, BinData1);
                #status_team{team_id=OtherTeamId} when OtherTeamId > 0 ->
                    {ok, BinData1} = pt_240:write(24030, [?ERRCODE(err240_other_in_team)]),
                    lib_team:send_to_uid(Node, LeaderId, BinData1);
                _ ->
                    lib_player:apply_cast(Uid, ?APPLY_CAST_STATUS, lib_team, get_info_and_join_team, [Uid, TeamId])
            end,
            ?SUCCESS
    end,
    {ok, BinData} = pt_240:write(24004, [ErrCode]),
    lib_team:send_to_uid(Node, ResponseId, BinData),
    NewReqList = lists:keydelete(Uid, #mb.id, ReqList),
    {noreply, State#team{reqlist = NewReqList}};

handle_cast({Node, {'join_team_response_all'}}, State) ->
    #team{
        id=TeamId, cls_type=ClsType, free_location=FreeLocation,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId},
        leader_id=LeaderId, reqlist = ReqList, is_matching = IsMatching
    } = State,
    FA = fun(MbA, MbB) -> MbA#mb.power >= MbB#mb.power end,
    NewReqList = lists:sort(FA, ReqList),
    FB = fun(Mb) ->
        #mb{id = Uid} = Mb,
        SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
        ErrCode = if
                      length(FreeLocation) =:= 0 -> ?ERRCODE(err240_max_member);
                      IsMatching /= 0 andalso SpecialMatchMod =/= undefined -> ?ERRCODE(err240_change_when_matching);
                      ClsType == ?NODE_CENTER ->
                          SerId = mod_player_create:get_serid_by_id(Uid),
                          mod_team:cast_to_game(ClsType, SerId, lib_player, apply_cast,
                              [Uid, ?APPLY_CAST_STATUS, lib_team, get_info_and_join_team, [Uid, TeamId]]),
                          ?SUCCESS;
                      true ->
                          case lib_player:get_player_info(Uid, #player_status.team) of
                              false ->
                                  {ok, BinData1} = pt_240:write(24030, [?ERRCODE(err240_offline)]),
                                  lib_team:send_to_uid(Node, LeaderId, BinData1);
                              #status_team{team_id=OtherTeamId} when OtherTeamId > 0 ->
                                  {ok, BinData1} = pt_240:write(24030, [?ERRCODE(err240_other_in_team)]),
                                  lib_team:send_to_uid(Node, LeaderId, BinData1);
                              _ ->
                                  lib_player:apply_cast(Uid, ?APPLY_CAST_STATUS, lib_team, get_info_and_join_team, [Uid, TeamId])
                          end,
                          ?SUCCESS
                  end,
        {ok, BinData} = pt_240:write(24063, [ErrCode]),
        lib_team:send_to_uid(Node, LeaderId, BinData)
         end,
    lists:foreach(FB, NewReqList),
    {noreply, State#team{reqlist = []}};

handle_cast({Node, {'join_team_af_response_agree', Mb}}, State) ->
    #team{leader_id=LeaderId} = State,
    CommonCheck = lib_team_mod:common_check(State, Mb),
    if
        CommonCheck =/= true ->
            {false, OtherErrorCode, _MyErrorCode} = CommonCheck,
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(OtherErrorCode),
            {ok, BinData} = pt_240:write(24038, [ErrorCodeInt, ErrorCodeArgs]),
            lib_team:send_to_uid(Node, LeaderId, BinData),
            {noreply, State};
        true ->
            handle_cast({Node, {'join_team', Mb}}, State)
    end;

%% 系统获取信息并让玩家进入队伍
handle_cast({_Node, {'join_team', Mb}}, State) ->
    #team{free_location=FreeLocation} = State,
         %% , is_flagwar = IsFlagwar
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    if
        %% IsFlagwar == 1 -> {noreply, State};
        [] == FreeLocation -> {noreply, State};
        IsOnDungeon -> {noreply, State};
        true ->
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
            NewState = join_team(_Node, Mb, StateAfInterrupt),
            {noreply, NewState}
    end;

%% 退出队伍
handle_cast({Node, {'quit_team', RoleId, QuitType}}, State) ->
    #team{
        id=TeamId, cls_type=ClsType, member=MemberList, leader_id=LeaderId,
        free_location=FreeLocation, rela=OldRela} = State,
    % ?MYLOG("hjhteam", "quit_team Node:~p node():~p, RoleId:~p QuitType:~p ~n", [Node, node(), RoleId, QuitType]),
    MemberLen = length(MemberList),
    Mb = lists:keyfind(RoleId, #mb.id, MemberList),
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    %% IsTsmaps = lib_team_mod:is_dun_tsmaps(State),
    if
        Mb =:= false -> {noreply, State};
        %% 在副本中无法普通退出副本
        QuitType == 0 andalso IsOnDungeon andalso Mb#mb.dungeon_id > 0 ->
            {ok, BinData} = pt_240:write(24005, [?ERRCODE(err240_on_dungeon_not_to_do)]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        % LockType /= 0 -> {noreply, State};
        MemberLen < 2 ->
            quit_team(State, Mb),
            StateAfInterrupt0 = lib_team_mod:interrupt_special_match(State),
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(StateAfInterrupt0),
            {ok, BinData1} = pt_240:write(24030, [?ERRCODE(err240_self_out_team)]),
            lib_team:send_to_uid(Node, RoleId, BinData1),
            lib_team_mod:set_member_attr(StateAfInterrupt, Mb#mb.node, RoleId, 0, 0),
            mod_team:cast_to_game(ClsType, Mb#mb.node, lib_player, update_player_info, [RoleId, [{team_skill, {0, 0}}]]),
            {ok, BinData} = pt_240:write(24005, [?SUCCESS]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            %% ?IF(DunId/=0, mod_dungeon:quit_dungeon(DunPid, RoleId), skip),
            {stop, normal, StateAfInterrupt#team{member = []}};
        true ->
            quit_team(State, Mb),
            StateAfInterrupt0 = lib_team_mod:interrupt_special_match(State),
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(StateAfInterrupt0),
            %% 更新玩家进程和场景进程的数据，并告诉附近的玩家.
            lib_team_mod:set_member_attr(StateAfInterrupt, Mb#mb.node, RoleId, 0, 0),
            mod_team:cast_to_game(ClsType, Mb#mb.node, lib_player, update_player_info, [RoleId, [{team_skill, {0, 0}}]]),
            %% 重新设置空闲位置
            Free = lists:sort([Mb#mb.location | FreeLocation]),
            %% 处理跟随状态
            FollowState = lib_team:cancel_follow(StateAfInterrupt, RoleId),
            FollowsState = lib_team:cancel_follows(FollowState, RoleId),

            NewMembers = lists:keydelete(RoleId, #mb.id, FollowsState#team.member),
            Rela = del_rela(OldRela, RoleId, []),
            %% 技能更新
            NewTeamSkill = set_member_team_skill(ClsType, NewMembers),
            NewState = FollowsState#team{member = NewMembers, free_location = Free, rela=Rela, team_skill = NewTeamSkill},
            mod_team_enlist:change_team(ClsType, TeamId, [{num, -1}, {mbs, NewMembers}]),
            {ok, BinData} = pt_240:write(24014, [RoleId]),
            lib_team:send_team(NewState, BinData),
            {ok, BinData2} = pt_240:write(24005, [?SUCCESS]),
            lib_team:send_to_uid(Node, RoleId, BinData2),
            lib_team:notify_team_change(Node, ?ERRCODE(err240_self_out_team), ?ERRCODE(err240_out_team), 5, Mb, NewState),
            %% ?IF(DunId/=0, mod_dungeon:quit_dungeon(DunPid, RoleId), skip),
            NewState0
            = if
                LeaderId =:= RoleId ->
                    %% util:cancel_timer(Mb#mb.onhook_ref),
                    delegate_leader(NewState);
                true ->
                    NewState
            end,
            NewState1 = lib_team_mod:delay_notify_teammates_update(NewState0),
            {noreply, NewState1}
    end;

%% 退出队伍
handle_cast({Node, {'batch_quit_team', RoleIdList, QuitType, Args}}, State) ->
    %% common check
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    if
        IsOnDungeon ->
            Code = ?ERRCODE(err240_on_dungeon_not_to_do),
            Return = {noreply, State};
        true ->
            Code = ?SUCCESS,
            F = fun(RoleId, {IsStop, StopReason, TmpState}) ->
                case handle_cast({Node, {'quit_team', RoleId, QuitType}}, TmpState) of
                    {noreply, NewTmpState} -> {IsStop, StopReason, NewTmpState};
                    {stop, Reason, NewTmpState} -> {true, Reason, NewTmpState}
                end
            end,
            {IsStop, StopReason, NewState} = lists:foldl(F, {false, normal, State}, RoleIdList),
            Return = ?IF(IsStop, {stop, StopReason, NewState}, {noreply, NewState})
    end,
    case lists:keyfind(mfa, 1, Args) of
        {mfa, {Mod, Fun, A}} ->
            apply(Mod, Fun, [Code|A]);
        _ -> skip
    end,
    Return;

handle_cast({Node, {already_joined_in_another, RoleId}}, State) ->
    #team{id=TeamId, cls_type=ClsType, member=MemberList, leader_id=LeaderId,
          free_location=FreeLocation, rela=OldRela} = State,
    MemberLen = length(MemberList),
    Mb = lists:keyfind(RoleId, #mb.id, MemberList),
    %% IsTsmaps = lib_team_mod:is_dun_tsmaps(State),
    if
        Mb =:= false -> {noreply, State};
        MemberLen < 2 ->
            StateAfInterrupt0 = lib_team_mod:interrupt_special_match(State),
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(StateAfInterrupt0),
            {stop, normal, StateAfInterrupt#team{member = []}};
        true ->
            StateAfInterrupt0 = lib_team_mod:interrupt_special_match(State),
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(StateAfInterrupt0),
            %% 更新玩家进程和场景进程的数据，并告诉附近的玩家.
            lib_team_mod:set_member_attr(StateAfInterrupt, Mb#mb.node, RoleId, 0, 0),
            mod_team:cast_to_game(ClsType, Mb#mb.node, lib_player, update_player_info, [RoleId, [{team_skill, {0, 0}}]]),
            %% 重新设置空闲位置
            Free = lists:sort([Mb#mb.location | FreeLocation]),
            %% 处理跟随状态
            FollowState = lib_team:cancel_follow(StateAfInterrupt, RoleId),
            FollowsState = lib_team:cancel_follows(FollowState, RoleId),

            NewMembers = lists:keydelete(RoleId, #mb.id, FollowsState#team.member),
            Rela = del_rela(OldRela, RoleId, []),
            %% 技能更新
            NewTeamSkill = set_member_team_skill(ClsType, NewMembers),
            NewState = FollowsState#team{member = NewMembers, free_location = Free, rela=Rela, team_skill = NewTeamSkill},
            mod_team_enlist:change_team(ClsType, TeamId, [{num, -1},{mbs, NewMembers}]),
            {ok, BinData} = pt_240:write(24014, [RoleId]),
            lib_team:send_team(NewState, BinData, RoleId),
            lib_team:notify_team_change(Node, ?ERRCODE(err240_self_out_team), ?ERRCODE(err240_out_team), 5, Mb#mb{is_fake = 1}, NewState),
            %% ?IF(DunId/=0, mod_dungeon:quit_dungeon(DunPid, RoleId), skip),
            NewState1 = lib_team_mod:delay_notify_teammates_update(NewState),
            NewState2 = if
                LeaderId =:= RoleId ->
                    delegate_leader(NewState1);
                true ->
                    NewState1
            end,
            {noreply, NewState2}
    end;

%% 邀请加入组队 Type 0 普通邀请 1 退出副本后继续邀请
handle_cast({Node, {'invite_request', _InviteList, RoleId, _InviteScene, ActivityId, SubTypeId, _Type}} = Msg,
        #team{enlist = #team_enlist{activity_id=ActivityId0, subtype_id=SubTypeId0}} = State) when ActivityId =/= ActivityId0 orelse SubTypeId =/= SubTypeId0 ->
    #team{
        is_matching = IsMatching,
        free_location = FreeLocation, leader_id = LeaderId
    } = State,
    SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
    if
        [] == FreeLocation ->
            {ok, BinData} = pt_240:write(24006, [?ERRCODE(err240_max_member)]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        IsMatching /= 0 andalso SpecialMatchMod =/= undefined ->
            {ok, BinData} = pt_240:write(24006, [?ERRCODE(err240_change_when_matching)]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        LeaderId =/= RoleId ->
            {ok, BinData} = pt_240:write(24006, [?ERRCODE(err240_invite_diff_target_error)]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            {noreply, State};
        true ->
            #team_enlist_cfg{default_lv_min = LvMin, default_lv_max = LvMax} = data_team_ui:get(ActivityId, SubTypeId),
            case lib_team_mod:check_change_team_enlist(State, RoleId, ActivityId, SubTypeId, LvMin, LvMax) of
                {true, Cfg} ->
                    %% 先改目标
                    ChangedState = lib_team_mod:change_team_enlist(State, Cfg, 0, LvMin, LvMax, 0),
                    {ok, BinData} = pt_240:write(24017, [?SUCCESS, ActivityId, SubTypeId, 0, LvMin, LvMax, 0]),
                    lib_team:send_team(ChangedState, BinData),
                    handle_cast(Msg, ChangedState);
                {false, Code} ->
                    {ok, BinData} = pt_240:write(24006, [Code]),
                    lib_team:send_to_uid(Node, RoleId, BinData),
                    {noreply, State};
                {take_over, TargetClsType} ->
                    TakeOverInfo = [{lv, [LvMin, LvMax]}, {take_over, [self(), {invite_request, Msg}, invite_request]}],
                    FailReturn = {invite_request, Node, RoleId},
                    TmpState = take_over(ActivityId, SubTypeId, 0, TakeOverInfo, FailReturn, Node, TargetClsType, State),
                    {noreply, TmpState}
            end
    end;

handle_cast({Node, {'invite_request', InviteList, InviterId, InviteScene, ActivityId, SubTypeId, Type}}, State) ->
    #team{
        id = TeamId, is_matching = IsMatching,
        enlist = #team_enlist{activity_id=ActivityId, subtype_id=SubTypeId, scene_id=SceneId},
        member = MemberList, cls_type = ClsType,
        free_location = FreeLocation} = State,
    MbInfo = lists:keyfind(InviterId, #mb.id, MemberList),
    MbLen = length(MemberList),
    SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
    Res = if
        [] == FreeLocation -> ?ERRCODE(err240_max_member);
        IsMatching /= 0 andalso SpecialMatchMod =/= undefined ->
            ?ERRCODE(err240_change_when_matching);
        MbInfo == false -> ?FAIL;
        true ->
            Data = [TeamId, MbLen, ActivityId, SubTypeId, SceneId, InviterId, MbInfo#mb.figure, InviteScene, Type],
            F = fun
                ({SerId, ToId}) when ClsType =:= ?NODE_CENTER ->
                    case lists:keyfind(ToId, #mb.id, MemberList) of
                        false ->
                            mod_clusters_center:apply_cast(SerId, lib_team, invite_player, [Node, InviterId, ToId, Data]);
                        _ -> skip
                    end;
                (ToId) when ClsType =:= ?NODE_CENTER ->
                    case lists:keyfind(ToId, #mb.id, MemberList) of
                        false ->
                            mod_clusters_center:apply_cast(Node, lib_team, invite_player, [Node, InviterId, ToId, Data]);
                        _ -> skip
                    end;
                ({_SerId, ToId}) ->
                    case lists:keyfind(ToId, #mb.id, MemberList) of
                        false ->
                            lib_team:invite_player(Node, InviterId, ToId, Data);
                        _ -> skip
                    end;
                (ToId) ->
                    case lists:keyfind(ToId, #mb.id, MemberList) of
                        false ->
                            lib_team:invite_player(Node, InviterId, ToId, Data);
                        _ -> skip
                    end
            end,
            [F(EId) || EId <- InviteList],
            ok
    end,
    %% ?PRINT("invite_request ~p~n", [{MbLen, MbInfo, Res, FreeLocation}]),
    if
        Res =/= ok ->
            {ok, BinData1} = pt_240:write(24006, [Res]),
            lib_team:send_to_uid(Node, InviterId, BinData1);
        true ->
            {ok, BinData} = pt_240:write(24006, [?SUCCESS]),
            lib_team:send_to_uid(Node, InviterId, BinData)
    end,
    {noreply, State};

handle_cast({Node, {'invite_request', InviteList, InviterId, InviteScene, Type}}, State) ->
    #team{enlist = #team_enlist{activity_id=ActivityId, subtype_id=SubTypeId}} = State,
    handle_cast({Node, {'invite_request', InviteList, InviterId, InviteScene, ActivityId, SubTypeId, Type}}, State);

%% 被邀请人回应加入队伍请求
%% @param Res 0:拒绝 1:答应 2:不满足
handle_cast({Node, {'invite_response', Res, MbInfo, _Args}}, State) ->
    #team{
        free_location=FreeLocation, member=MemberList, is_matching = IsMatching,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId},
        leader_id = LeaderId, leader_node = LeaderNode
    } = State,
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    InTeam = lists:keymember(MbInfo#mb.id, #mb.id, MemberList),
    CommonCheck = lib_team_mod:common_check(State, MbInfo),
    SpecialMatchMod = lib_team_match:get_special_api_mod(ActivityId, SubTypeId, 0, 0),
    ErrCode = if
        InTeam -> ?ERRCODE(err240_in_team);
        Res =/= 1 ->
            #mb{figure = #figure{name = Name}} = MbInfo,
            {ok, BinData1} = pt_240:write(24038, [?ERRCODE(err240_arbitrate_refuse), [Name]]),
            lib_server_send:send_to_uid(LeaderNode, LeaderId, BinData1),
            ?IF(Res == 0, ?SUCCESS, skip);
        [] == FreeLocation -> ?ERRCODE(err240_max_member);
        IsMatching /= 0 andalso SpecialMatchMod =/= undefined ->
            ?ERRCODE(err240_this_team_matching);
        CommonCheck =/= true ->
            {false, _OtherErrorCode, MyErrorCode} = CommonCheck,
            MyErrorCode;
        IsOnDungeon ->
            ?ERRCODE(err240_this_team_on_dungeon);
        %% case check_dun(MbInfo#mb.id, PreNumFull, DunId, HisTeammate, DunPid, Args) of
        %%     true ->
        %%         StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
        %%         {ok, join_team(Node, MbInfo, StateAfInterrupt)};
        %%     {false, ErrCod} ->
        %%         ErrCod
        %%     end;
        true ->
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
            {ok, join_team(Node, MbInfo, StateAfInterrupt)}
    end,
    case ErrCode of
        {ok, NewState} ->
            {ok, BinData} = pt_240:write(24008, [?SUCCESS, []]),
            lib_team:send_to_uid(Node, MbInfo#mb.id, BinData),
            Code = ?SUCCESS;
        skip ->
            NewState = State,
            Code = ?FAIL;
        _ ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrCode),
            % ?PRINT("invite_response ~p~n", [[ErrCode, {ErrorCodeInt, ErrorCodeArgs}]]),
            {ok, BinData} = pt_240:write(24008, [ErrorCodeInt, ErrorCodeArgs]),
            lib_team:send_to_uid(Node, MbInfo#mb.id, BinData),
            NewState = State,
            Code = ErrorCodeInt
    end,
    case lists:keyfind(mfa, 1, _Args) of
        {mfa, {M, F, A}} ->
            apply(M, F, [Code|A]);
        _ -> skip
    end,
    {noreply, NewState};

%% 请求队伍信息
handle_cast({Node, {'get_team_info', Id}}, State) ->
    lib_team:send_to_uid(Node, Id, lib_team:get_team_info_bin(State)),
    {noreply, State};

%% 踢出队伍
%% @param _Type 0 正常 1 队伍切换目标踢人
handle_cast({Node, {'kick_out', KickId, RoleId, Type}}, State) ->
    #team{cls_type=ClsType, id=TeamId, leader_id = LeaderId, member = Members,
          free_location = FreeLocation, rela=OldRela} = State,
    %% is_flagwar = IsFlagwar
    Mb = lists:keyfind(KickId, #mb.id, Members),
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    {Result, RNewState} = if
        %% IsFlagwar == 1 -> {?ERRCODE(err240_41_in_flagwar), State};
        KickId == LeaderId -> {?ERRCODE(err240_not_kick_leader), State};
                        % 在副本无法踢人
        IsOnDungeon andalso Type == 0 -> {?ERRCODE(err240_on_dungeon_not_to_do), State};
        LeaderId /= RoleId -> {?ERRCODE(err240_not_leader), State};
        Mb == false -> {?FAIL, State};
        true ->
            StateAfInterrupt0 = lib_team_mod:interrupt_special_match(State),
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(StateAfInterrupt0),
            %% 更新玩家进程
            case lib_team:is_fake_mb(Mb) of
                false ->
                    lib_team_mod:set_member_attr(StateAfInterrupt, Mb#mb.node, KickId, 0, 0);
                _ ->
                    ok
            end,
            Free = lists:sort([Mb#mb.location | FreeLocation]),
            FollowState = lib_team:cancel_follow(StateAfInterrupt, KickId),
            FollowsState = lib_team:cancel_follows(FollowState, KickId),

            NewMembers = lists:keydelete(KickId, #mb.id, Members),
            lib_team_mod:share_skill_list(NewMembers),
            mod_scene_agent:update_skill_passive_share(Mb#mb.scene, Mb#mb.scene_pool_id, Mb#mb.node, Mb#mb.id, Mb#mb.share_skill_list, []),
            Rela = del_rela(OldRela, KickId, []),
            %% 技能更新
            NewTeamSkill = set_member_team_skill(ClsType, NewMembers),
            NewState = FollowsState#team{member = NewMembers, free_location = Free, rela=Rela, team_skill = NewTeamSkill},

            mod_team_enlist:change_team(ClsType, TeamId, [{num, -1}, {mbs, NewMembers}]),
            %% 发送离开队员id
            {ok, BinData} = pt_240:write(24014, [KickId]),
            lib_team:send_team(State, BinData),
            %% BonfireState = lib_team:handle_barbecue_buff(NewState, 2),
            lib_team:notify_team_change(Node, ?ERRCODE(err240_self_shot_of_team), ?ERRCODE(err240_shot_of_team), 6, Mb, NewState),
            NewState1 = lib_team_mod:delay_notify_teammates_update(NewState),
            {?SUCCESS, NewState1}
    end,
    if
        Type == 0 ->
            {ok, BinData2} = pt_240:write(24009, [Result]),
            lib_team:send_to_uid(Node, RoleId, BinData2);
        true ->
            ok
    end,
    {noreply, RNewState};

%% 委任队长
handle_cast({Node, {'change_leader', RoleId, LeaderId}}, State) ->
    #team{id=TeamId, cls_type=ClsType, leader_id = OldLeaderId, member = MemberList} = State,
    NewLeaderInfo = lists:keyfind(RoleId, #mb.id, MemberList),
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    {Code, RNewState} = if
        %% IsFlagwar == 1 -> {?ERRCODE(err240_41_in_flagwar), State};
        LeaderId =/= OldLeaderId -> {?ERRCODE(err240_not_leader), State};
        % 在副本无法委任队长
        IsOnDungeon -> {?ERRCODE(err240_on_dungeon_not_to_do), State};
        NewLeaderInfo == false -> {?FAIL, State};
        true ->
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
            OldLearderMb = lists:keyfind(OldLeaderId, #mb.id, MemberList),

            %% 设置属性
            lib_team_mod:set_member_attr(StateAfInterrupt, OldLearderMb#mb.node, OldLeaderId, ?TEAM_MEMBER, TeamId),
            lib_team_mod:set_member_attr(StateAfInterrupt, NewLeaderInfo#mb.node, RoleId, ?TEAM_LEADER, TeamId),

            #mb{id = NewLeaderId, node=NewLeaderNode} = NewLeaderInfo,
            NewState = StateAfInterrupt#team{leader_id = NewLeaderId, leader_node=NewLeaderNode},
            %% 发送队长变更信息
            {ok, BinData1} = pt_240:write(24015, [NewLeaderId]),
            lib_team:send_team(NewState, BinData1),

            mod_team_enlist:change_team(ClsType, TeamId, [{leader, NewLeaderId}]),
            {?SUCCESS, NewState}
    end,
    {ok, BinData} = pt_240:write(24011, [Code]),
    lib_team:send_to_uid(Node, LeaderId, BinData),
    {noreply, RNewState};

%% 更改队伍目标
handle_cast({Node, {'change_team_enlist', RoleId, ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue}}, State) ->
    % ?PRINT(" change_team_enlist ~p~n", [[ActivityId, SubTypeId]]),
    #team{is_matching = IsMatching} = State,
    if
        IsMatching =/= 0 ->
            {_, TmpState0} = handle_cast({Node, {'set_matching_state', RoleId, 0}}, State);
        true ->
            TmpState0 = State
    end,
    SuccessCode = ?SUCCESS,
    {Code, NewState} = case lib_team_mod:check_change_team_enlist(TmpState0, RoleId, ActivityId, SubTypeId, LvMin, LvMax) of
        {true, Cfg} ->
            TmpState = lib_team_mod:change_team_enlist(TmpState0, Cfg, SceneId, LvMin, LvMax, JoinConValue),
            {SuccessCode, TmpState};
        {false, ErrCode} ->
            {ErrCode, State};
        {take_over, TargetClsType} ->
            PtArgs = [ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue],
            TakeOverInfo = [{lv, [LvMin, LvMax]}, {join_con_value, JoinConValue}, {take_over, [self(), {change_team_enlist, PtArgs}, change_team_enlist]}],
            FailReturn = {change_team_enlist, Node, RoleId, PtArgs},
            TmpState = take_over(ActivityId, SubTypeId, SceneId, TakeOverInfo, FailReturn, Node, TargetClsType, TmpState0),
            {take_over, TmpState}
    end,
    case Code of
        SuccessCode ->
            {ok, BinData} = pt_240:write(24017, [Code, ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue]),
            lib_team:send_team(NewState, BinData);
        take_over ->
          ok;
        _ ->
            {ok, BinData} = pt_240:write(24017, [Code, ActivityId, SubTypeId, SceneId, LvMin, LvMax, JoinConValue]),
            lib_team:send_to_uid(Node, RoleId, BinData)
    end,
    {noreply, NewState};

%% 更改申请自动进入类型
handle_cast({Node, {'change_join_type', RoleId, JoinType}}, State) ->
    #team{id = TeamId, leader_id=LeaderId, cls_type = ClsType} = State,
    IsJoinType = lists:member(JoinType, ?TEAM_JOIN_TYPE_TYPE_LIST),
    {Code, StateAfCode} = if
        RoleId =/= LeaderId -> {?ERRCODE(err240_not_leader), State};
        IsJoinType == false -> {?ERRCODE(err240_not_join_type), State};
        true ->
            NewState = State#team{join_type = JoinType},
            mod_team_enlist:change_team(ClsType, TeamId, [{join_type, JoinType}]),
            {?SUCCESS, NewState}
    end,
    {ok, BinData} = pt_240:write(24018, [Code, JoinType]),
    lib_team:send_to_uid(Node, RoleId, BinData),
    {noreply, StateAfCode};

%% 申请仲裁准备处理
handle_cast({Node, {'arbitrate_req_ready', RoleId, ActivityId, SubTypeId}}, State) ->
    #team{is_matching = IsMatching, leader_id = LeaderId} = State,
    ?PRINT("arbitrate_req IsMatching:~p~n", [IsMatching]),
    if
        IsMatching =/= 0 ->
            {_, TmpState} = handle_cast({Node, {'set_matching_state', LeaderId, 0}}, State);
        true ->
            TmpState = State
    end,
    % {ok, NewState} = lib_team_mod:arbitrate_req(TmpState, RoleId, Node, ActivityId, SubTypeId, Data),
    lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, arbitrate_req, [ActivityId, SubTypeId]),
    {noreply, TmpState};

%% 申请仲裁
handle_cast({Node, {'arbitrate_req', RoleId, ActivityId, SubTypeId, Data}}, State) ->
    #team{is_matching = IsMatching, leader_id = LeaderId} = State,
    if
        IsMatching =/= 0 ->
            {_, TmpState} = handle_cast({Node, {'set_matching_state', LeaderId, 0}}, State);
        true ->
            TmpState = State
    end,
    {ok, NewState} = lib_team_mod:arbitrate_req(TmpState, RoleId, Node, ActivityId, SubTypeId, Data),
    {noreply, NewState};

%% 回应仲裁
handle_cast({Node, {'arbitrate_res', RoleId, ArbitrateId, Res}}, State) ->
    {ok, NewState} = lib_team_mod:arbitrate_res(State, RoleId, ArbitrateId, Res, Node),
    {noreply, NewState};

% %% 登录马上归队 %%暂时没用了
% handle_cast({'login_back_to_team', MbInfo}, State) ->
%     #mb{id = RoleId} = MbInfo,
%     #team{member = Members, cls_type = ClsType, free_location = FreeLocation} = State,
%     case lists:keyfind(RoleId, #mb.id, Members) of
%         false ->
%             %% case lists:any(fun
%             %%     (#mb{online = Online}) ->
%             %%         Online =:= 1
%             %% end, Members) of
%             %%     true -> %% 有人在线
%             [Use | Free] = FreeLocation,
%             NewMemberList = State#team.member ++ [MbInfo#mb{location = Use}],
%             %% 技能更新
%             NewTeamSkill = set_member_team_skill(ClsType, NewMemberList),
%             NewState = State#team{member = NewMemberList, free_location = Free, team_skill = NewTeamSkill},
%             %% NewState2 = lib_team:extand_exp(RoleId ,NewState),
%             %% 更新域外战场分享概率
%             NewState2 = lib_team:extand_share_ratio(NewState),
%             %% 设置队伍的好友亲密度buff
%             lib_relationship:deal_intimacy_buff_in_team(Members, NewMemberList),
%             NewState3 = delay_notify_teammates_update(NewState2),
%             %%  _ ->
%             %%         case lists:keytake(?TEAM_LEADER, #mb.positon, Members) of
%             %%             {value, OldLearderMb, OtherMb} ->

%             %%         end
%             %% end,

%             {noreply, NewState3};
%         _ ->
%             {noreply, State}
%     end;

%% 上线归队
% handle_cast({'back_to_team', MbInfo}, State) ->
%     #mb{id = RoleId, pid = RolePid, figure=#figure{name=Name}} = MbInfo,
%     #team{member = Members, leader_id = LeaderId, max_num = MaxMemberNum} = State,
%     case lists:keyfind(RoleId, #mb.id, Members) of
%         false ->
%             {ok, BinData} = pt_110:write(11020, data_team_text:get_team_msg(13)),
%             lib_server_send:send_to_uid(RoleId, BinData),
%             {noreply, State};
%         _ ->
%             case length(Members) > MaxMemberNum of
%                 false ->
%                     %% 3.更新玩家进程和场景进程的数据，并告诉附近的玩家.
%                     case LeaderId =:= RoleId of
%                         true ->
%                             gen_server:cast(RolePid, {'set_team', self(), 1, LeaderId});
%                         false ->
%                             gen_server:cast(RolePid, {'set_team', self(), 2, LeaderId})
%                     end,
%                     %% 4.对其他队员进行队伍信息广播.
%                     lib_team:send_team_info(State),
%                     %% 5.发送通知：归队了.
%                     {ok, BinData1} = pt_110:write(11020, lists:concat([Name, data_team_text:get_team_msg(7)])),
%                     lib_team:send_team(State, BinData1),
%                     %% 6.发送通知：你成功进入离线前的队伍.
%                     {ok, BinData2} = pt_110:write(11020, data_team_text:get_team_msg(8)),
%                     lib_chat:rpc_send_msg_one(RoleId, BinData2),
%                     {noreply, State};
%                 true ->
%                     {noreply, State}
%             end
%     end;

handle_cast({_Node, {'send_to_team', Bin}}, State) ->
    lib_team:send_team(State, Bin),
    {noreply, State};

handle_cast({_Node, {'send_to_team', SceneId, ScenePoolId, CopyId, Bin}}, State) ->
    lib_team:send_team(State, SceneId, ScenePoolId, CopyId, Bin),
    {noreply, State};

handle_cast({_Node, {'alloc_drop', MonStatus, Alloc, PList}}, State) ->
    case catch lib_goods_drop:alloc_drop_in_team(State, MonStatus, Alloc, PList) of
        {'EXIT', Reason} -> ?ERR("alloc_drop error MonStatus=~p,~nAlloc=~p~n Reason: ~p", [ MonStatus, Alloc, Reason]);
        _ -> skip
    end,
    {noreply, State};

handle_cast({_Node, {'alloc_hunting_award', Color}}, State) ->
    #team{leader_id=LeaderId, member=MemberList} = State,
    case catch lib_hunting_mod:alloc_hunting_award_in_team(Color, LeaderId, MemberList) of
        {'EXIT', Reason} -> ?ERR("alloc_hunting_award error Color=~p~n Reason: ~p", [Color, Reason]);
        _ -> skip
    end,
    {noreply, State};

%% 调用队员lib_player:update_player_info/2函数
handle_cast({_Node, {'update_mb_info', Args}}, State) ->
    F = fun({bonfire_exp, _}, L) -> L;
           (T, L) -> [T|L]
        end,
    [begin
         %% 所有助战都没有篝火加成
         case Mb#mb.help_type == ?HELP_TYPE_YES of
             true -> NewArgs = lists:reverse(lists:foldl(F, [], Args));
             false -> NewArgs = Args
         end,
         %% ?PRINT("update_mb_info ID:~p NewArgs:~p", [Mb#mb.id, NewArgs]),
         lib_team:update_mb_info(State#team.cls_type, Mb, NewArgs)
     end|| Mb <- State#team.member],
    {noreply, State};

%% 更改队员场景
handle_cast({_Node, {'change_my_position', Id, Scene, ScenePoolId, CopyId}}, State) ->
    #team{id = TeamId, member = Mbs, leader_id = LeaderId, cls_type = ClsType, after_check = AfterCheck}=State,
    case lists:keyfind(Id, #mb.id, Mbs) of
        false -> {noreply, State};
        #mb{scene = OldScene} = Mb ->
            F = fun(M) ->
                case M#mb.id =:= Id orelse (Id =:= LeaderId andalso lib_team:is_fake_mb(M))  of
                    true -> M#mb{scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId};
                    _ -> M
                end
            end,
            NewMbs = [F(M) || M <- Mbs],
            mod_team_enlist:change_team(ClsType, TeamId, [{mbs, NewMbs}]),
            %% 玩家切换场景通知技能buff修改
            if
                OldScene == Scene ->
                    NewAfterCheck = AfterCheck;
                true ->
                    case lib_scene:is_in_normal_and_outside(Scene) of
                        false ->
                            NewAfterCheck = undefined;
                        _ ->
                            NewAfterCheck = AfterCheck
                    end,
                    set_member_team_skill(ClsType, NewMbs)
            end,
            %% 是否跟之前的场景一致,一致不处理
            case Mb of
                #mb{scene = Scene, scene_pool_id = ScenePoolId, copy_id = CopyId} -> skip;
                _ -> lib_team_mod:share_skill_list(NewMbs)
            end,
            NewState = State#team{member = NewMbs, after_check = NewAfterCheck},
            {ok, BinData} = pt_240:write(24051, [Id, Scene]),
            lib_team:send_team(NewState, BinData),
            NewState2 = lib_team_mod:delay_notify_teammates_update(NewState),
            {noreply, NewState2}
    end;

%% 队员完成切场景
handle_cast({_Node, {'fin_change_scene'}}, State) ->
    #team{member = Mbs}=State,
    lib_team_mod:share_skill_list(Mbs),
    {noreply, State};

%% 获取队员场景信息
handle_cast({_Node, {'get_mb_scene', Id, InfoId}}, State) ->
    #team{cls_type=ClsType, member = Mbs} = State,
    case ClsType of
        ?NODE_CENTER -> {noreply, State};
        _ ->
            case lists:keyfind(InfoId, #mb.id, Mbs) of
                false -> {noreply, State};
                #mb{node = MNode} ->
                    IsFollow = case lists:keyfind(Id, #mb.id, Mbs) of
                        #mb{follow_id=InfoId} -> 1;
                        _ -> 0
                    end,
                    lib_player:apply_cast(MNode, InfoId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, get_mb_scene, [Id, IsFollow]),
                    {noreply, State}
            end
    end;

%% 跟战
handle_cast({_Node, {'follow_someone', Type, Id, FollowId}}, State) ->
    #team{cls_type=ClsType, member = Mbs} = State,
    case ClsType of
        ?NODE_CENTER -> {noreply, State};
        _ ->
            case Type == 1 of
                true ->
                    case lists:keyfind(FollowId, #mb.id, Mbs) of
                        false -> {noreply, State};
                        Mb ->
                            NewMbs = case lists:keyfind(Id, #mb.id, Mbs) of
                                false -> Mbs;
                                MyMb  -> lists:keyreplace(Id, #mb.id, Mbs, MyMb#mb{follow_id=FollowId})
                            end,

                            {ok, BinData} = pt_240:write(24024, [1, FollowId]),
                            lib_server_send:send_to_uid(Id, BinData),

                            Follows = [Id | lists:delete(Id, Mb#mb.follows)],
                            lib_player:update_player_info(FollowId, [{follows, Follows}]),
                            NewMbs1 = lists:keyreplace(FollowId, #mb.id, NewMbs, Mb#mb{follows=Follows}),

                            {noreply, State#team{member=NewMbs1}}
                    end;
                false ->
                    NewState = lib_team:cancel_follow(State, Id),
                    {noreply, NewState}
            end
    end;

%% 取消别人跟战
handle_cast({_Node, {'cancel_other_follow', RoleId}}, State) ->
    #team{cls_type=ClsType, member = Mbs} = State,
    case ClsType of
        ?NODE_CENTER -> {noreply, State};
        _ ->
            F = fun(#mb{id = Id, follow_id = FollowId}, {Num,TempState})->
                        case FollowId =:= RoleId of
                            true ->
                                NewState = lib_team:cancel_follow(TempState, Id),
                                {Num+1, NewState};
                            false ->
                                {Num, TempState}
                        end
                end,
            {Result,LastState} = lists:foldl(F, {0,State}, Mbs),
            case Result == 0 of
                true->
                    {ok, BinData} = pt_240:write(24039, [?ERRCODE(err240_no_member_follow)]),
                    lib_team:send_to_uid(_Node, RoleId, BinData);
                false->
                    {ok, BinData} = pt_240:write(24039, [?ERRCODE(err240_cancel_follow_success)]),
                    lib_team:send_to_uid(_Node, RoleId, BinData)
            end,
            {noreply, LastState}
    end;

%% 获取跟随着的玩家id
handle_cast({_Node, {'get_follow_id', Id}}, State) ->
    #team{cls_type=ClsType, member = Mbs} = State,
    case ClsType of
        ?NODE_CENTER -> {noreply, State};
        _ ->
            case lists:keyfind(Id, #mb.id, Mbs) of
                false -> {noreply, State};
                Mb    ->
                    % ?PRINT("follow_id ~p~n", [Mb#mb.follow_id]),
                    {ok, BinData} = pt_240:write(24026, [Mb#mb.follow_id]),
                    lib_server_send:send_to_uid(Id, BinData),
                    {noreply, State}
            end
    end;

%% 助战
handle_cast({_Node, {'set_help_type', RoleId, DunId, HelpType}}, State) ->
    #team{id = TeamId, cls_type = ClsType, member = Mbs, enlist = #team_enlist{dun_id = DunId0}} = State,
    %% 众生之门副本特殊处理（进入前不会确定副本ID）
    IsSameDun = lists:member(DunId0, lib_dungeon_util:list_special_share_dungeon(DunId)),
    case lists:keyfind(RoleId, #mb.id, Mbs) of
        false -> {noreply, State};
        Mb when IsSameDun ->
            IsOnDungeon = lib_team_mod:is_on_dungeon(State),
            if
                IsOnDungeon ->
                    {noreply, State};
                true ->
                    Data = Mb#mb.target_start_data,
                    NewData = ?IF(is_record(Data, dungeon_role), Data#dungeon_role{help_type = HelpType}, Data),
                    NewMbs = lists:keyreplace(RoleId, #mb.id, Mbs, Mb#mb{help_type = HelpType, target_start_data = NewData}),
                    NewState = State#team{member = NewMbs},
                    {ok, BinData2} = pt_240:write(24034, [[{RoleId, HelpType}]]),
                    lib_team:send_team(NewState, BinData2),
                    mod_team_enlist:change_team(ClsType, TeamId, [{help_type, RoleId, HelpType}]),
                    {noreply, NewState}
            end;
        _ ->
            {noreply, State}
    end;

%% 与赏金怪物对话
handle_cast({_Node, {'talk_to_mon', Scene, ScenePoolId, RoleId, MonId}}, State) ->
    #team{member=MemberList} = State,
    MemberIdList = [Id||#mb{id = Id} <- MemberList],
    MemberLen = length(MemberIdList),
    NeedNum   = lib_hunting_api:get_need_member_num(),
    if
        MemberLen>=NeedNum ->
            mod_scene_agent:apply_cast(Scene, ScenePoolId, lib_battle, talk_to_mon, [RoleId, MemberIdList, MonId]);
        true ->
            lib_server_send:send_to_uid(RoleId, pt_200, 20011, [4])
    end,
    {noreply, State};

%% 处理升级回调事件
handle_cast({_Node, {'event_lv_up', PlayerId, Lv} }, State) ->
    #team{member=Mbs}=State,
    case lists:keyfind(PlayerId, #mb.id, Mbs) of
        false -> {noreply, State};
        Mb    ->
            Figure = Mb#mb.figure,
            NewMbs = lists:keyreplace(PlayerId, #mb.id, Mbs, Mb#mb{figure = Figure#figure{lv = Lv}}),
            NewState = State#team{member = NewMbs},
            {noreply, NewState}
    end;

%% 处理角色改名回调事件
handle_cast({_Node, {'event_rename', PlayerId, Name} }, State) ->
    #team{member=Mbs}=State,
    case lists:keyfind(PlayerId, #mb.id, Mbs) of
        false -> {noreply, State};
        Mb    ->
            Figure = Mb#mb.figure,
            NewMbs = lists:keyreplace(PlayerId, #mb.id, Mbs, Mb#mb{figure = Figure#figure{name = Name}}),
            NewState = State#team{member = NewMbs},
            lib_team:send_team_info(NewState),
            {noreply, NewState}
    end;

%% 更新数据
handle_cast({_Node, {'update_team_mb', RoleId, AttrList} }, State) ->
    {ok, NewState} = lib_team_mod:update_team_mb(State, RoleId, AttrList),
    {noreply, NewState};

%% 更新玩家的在线状态
handle_cast({_Node, {'online_flag', RoleId, Online}}, State) ->
    #team{id = TeamId, leader_id = LeaderId, member = Mbs, is_matching = IsMatching, cls_type = ClsType}=State,
    case lists:keyfind(RoleId, #mb.id, Mbs) of
        false -> {noreply, State};
        #mb{online = Online} -> {noreply, State};
        #mb{figure = #figure{name = Name}} = Mb ->
            NewMbs = lists:keyreplace(RoleId, #mb.id, Mbs, Mb#mb{online = Online}),
            mod_team_enlist:change_team(ClsType, TeamId, [{mbs, NewMbs}]),
            CheckInterrputArb = lib_team_mod:check_auto_interrput_arbitrate(State),
            if
                RoleId == LeaderId andalso IsMatching == 1 ->
                    MatchingState = 0,
                    {_Code, NewState} = lib_team_mod:set_team_matching_state(State, MatchingState),
                    #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}} = NewState,
                    {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, MatchingState, 0, ActivityId, SubTypeId, RoleId]),
                    lib_team:send_team(NewState, BinData),
                    {CodeInt2, CodeArgs2} = util:parse_error_code({?ERRCODE(err240_teammates_offline_to_cancel_match), [Name]}),
                    {ok, BinData2} = pt_240:write(24038, [CodeInt2, CodeArgs2]),
                    lib_team:send_team(NewState, BinData2, RoleId);
                IsMatching == 1 ->
                    MatchingState = 0,
                    {_Code, NewState} = lib_team_mod:set_team_matching_state(State, MatchingState),
                    #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}} = NewState,
                    {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, MatchingState, 0, ActivityId, SubTypeId, RoleId]),
                    lib_team:send_team(NewState, BinData),
                    {CodeInt2, CodeArgs2} = util:parse_error_code({?ERRCODE(err240_teammates_offline_to_cancel_match), [Name]}),
                    {ok, BinData2} = pt_240:write(24038, [CodeInt2, CodeArgs2]),
                    lib_team:send_team(NewState, BinData2, RoleId);
                CheckInterrputArb == true ->
                    StateAfInterruptArb = lib_team_mod:auto_interrupt_arbitrate(State),
                    {CodeInt, CodeArgs} = util:parse_error_code({?ERRCODE(err240_teammates_offline_to_cancel_arbitrate), [Name]}),
                    {ok, BinData} = pt_240:write(24038, [CodeInt, CodeArgs]),
                    lib_team:send_team(StateAfInterruptArb, BinData, RoleId),
                    NewState = StateAfInterruptArb;
                true ->
                    NewState = State
            end,
            NewState1 = lib_team_mod:delay_notify_teammates_update(NewState#team{member = NewMbs}),
            {ok, Bin} = pt_240:write(24052, [RoleId, Online]),
            lib_team:send_team(NewState1, Bin, RoleId),
            {noreply, NewState1}
    end;

%% socket重新连接
%% handle_cast({_Node, {'inerrupt_follow', Id}}, State) ->
%%     #team{member=Mbs}=State,
%%     case lists:keyfind(Id, #mb.id, Mbs) of
%%         false -> {noreply, State};
%%         _Mb ->
%%             NewState = lib_team:cancel_follow(State, Id),
%%             {noreply, NewState}
%%     end;

%% 跟踪目标返回移动数据
handle_cast({_Node, {'change_location', Id, SceneId, ScenePoolId, CopyId, X, Y, BX, BY}}, State) ->
    #team{cls_type=ClsType, member = Mbs} = State,
    case ClsType of
        ?NODE_CENTER ->
            %% set_member_team_skill(ClsType, Mbs),
            {noreply, State};
        _ ->
            case lists:keyfind(Id, #mb.id, Mbs) of
                false ->
                    {noreply, State};
                Mb ->
                    [lib_player:update_player_info(EId, [{change_location, [SceneId, ScenePoolId, CopyId, X, Y, BX, BY]}])||EId <- Mb#mb.follows],
                    %% set_member_team_skill(ClsType, Mbs),
                    {noreply, State}
            end
    end;

%% 副本直接退出
handle_cast({_Node, {'dungeon_direct_end', DunPid}}, State) ->
    #team{dungeon = #team_dungeon{dun_id = DunId, dun_pid = TeamDunPid} = Dun, member = Mbs} = State,
    case DunPid == TeamDunPid of
        true ->
            case data_dungeon:get(DunId) of
                #dungeon{type = Type} ->
                    Type =/= ?DUNGEON_TYPE_BEINGS_GATE andalso [erlang:send_after(urand:rand(5000, 10000), self(), {fake_mb_leave, RoleId}) || #mb{id = RoleId, join_time = JoinTime} = M <- Mbs, lib_team:is_fake_mb(M) andalso JoinTime + ?FAKE_LEAVE_TIME/1000 =< utime:unixtime()];
                _ ->  [erlang:send_after(urand:rand(5000, 10000), self(), {fake_mb_leave, RoleId}) || #mb{id = RoleId, join_time = JoinTime} = M <- Mbs, lib_team:is_fake_mb(M) andalso JoinTime + ?FAKE_LEAVE_TIME/1000 =< utime:unixtime()]
            end,
            NewState = State#team{dungeon = Dun#team_dungeon{dun_pid = 0}},
            %% NewState2 = lib_team_mod:auto_trans_help_type(NewState, ?HELP_TYPE_TRANS_NOT_ENOUGH),
            %% HelpTypeList = [{TmpRoleId, HelpType}||#mb{id=TmpRoleId, help_type=HelpType}<-NewState#team.member],
            %% {ok, BinData2} = pt_240:write(24034, [HelpTypeList]),
            %% lib_team:send_team(NewState, BinData2),
            {noreply, NewState};
        false ->
            {noreply, State}
    end;

%% 分享队员经验
handle_cast({_Node, {'share_mon_exp', FromId, Exp, SceneId, ScenePoolId, CopyId}}, State) ->
    #team{rela = Rela, member=Members} = State,
    F = fun(Mb) ->
                case Mb of
                    #mb{id=TmpId, scene=SceneId, scene_pool_id=ScenePoolId, copy_id=CopyId, node = MNode} ->
                        Args = case find_intimacy(Rela, FromId, TmpId) of
                                   0 -> [];
                                   Intimacy -> [{intimacy, Intimacy}]
                               end,
                        lib_player:apply_cast(MNode, TmpId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_player, add_exp, [Exp, ?ADD_EXP_TEAM_MON, Args]);
                    _ -> skip
                end
        end,
    lists:foreach(F, Members),
    {noreply, State};

%% 分享队员经验
handle_cast({_Node, {'kill_mon', SceneId, Mid, MonLv}}, #team{cls_type = ?NODE_GAME} = State) ->
    #team{member=Members} = State,
    [lib_task_api:kill_mon(Mb#mb.id, SceneId, Mid, MonLv)||Mb<-Members, not lib_team:is_fake_mb(Mb)],
    {noreply, State};

%% 跨服的
handle_cast({Node, {'kill_mon', SceneId, Mid, MonLv}}, State) ->
    #team{member=Members} = State,
    [unode:apply(Node, lib_task_api, kill_mon, [Mb#mb.id, SceneId, Mid, MonLv])||Mb<-Members, Mb#mb.node =:= Node],
    {noreply, State};

%% 广播野外修炼
handle_cast({_Node, {'outdoor_training', SceneId, MonId, X, Y}}, State) ->
    {ok, BinData} = pt_240:write(24043, [SceneId, MonId, X, Y]),
    lib_team:send_team(State, BinData),
    {noreply, State};

%% 队伍是否处于夺旗战
%% handle_cast({_Node, {'is_flagwar', Type}}, State) ->
%%     {noreply, State#team{is_flagwar = Type}};

% handle_cast({_Node, {'lock_team', Type, Time}}, State) ->
%     #team{id = TeamId, lock_ref = OldRef, member = MemberList} = State,
%     %% ?INFO("Info:~p ~n", [{Type, Time}]),
%     case Type /= 0 of
%         true ->
%             mod_team_lock:cast_to_team_lock(set_lock, [TeamId, 1]),
%             [?IF(misc:is_process_alive(misc:get_player_process(RoleId)), skip, mod_team_lock:cast_to_team_lock(logout, [RoleId, TeamId]))||#mb{id=RoleId}<-MemberList],
%             Ref = util:send_after(OldRef, Time*1000, self(), 'cancel_lock');
%         false ->
%             mod_team_lock:cast_to_team_lock(set_lock, [TeamId, 0]),
%             Ref = util:cancel_timer(OldRef)
%     end,
%     {noreply, State#team{lock_type = Type, lock_ref = Ref}};


% handle_cast({Node, {'lock_login', RoleId}}, State) ->
%     #team{id = TeamId, leader_id = LeaderId, lock_type = LockType, member = MemberList} = State,
%     Mb = lists:keyfind(RoleId, #mb.id, MemberList),
%     if
%         LockType == 0 -> {noreply, State};
%         Mb == false -> {noreply, State};
%         true ->
%             Position = ?IF(LeaderId==RoleId, ?TEAM_LEADER, ?TEAM_MEMBER),
%             lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_SAVE, ?NOT_HAND_OFFLINE, lib_team, lock_login, [TeamId, Position]),
%             {noreply, State}
%     end;

handle_cast({Node, {'get_reqlist', RoleId}}, State) ->
    #team{leader_id = LeaderId, reqlist = ReqList} = State,
    if
        RoleId =:= LeaderId ->
            Data = [{MbSerId, MbId, Figure, Power, MbSerNum} || #mb{id = MbId, server_id = MbSerId, server_num = MbSerNum, figure = Figure, power = Power} <- ReqList],
            {ok, BinData} = pt_240:write(24047, [Data]),
            lib_team:send_to_uid(Node, RoleId, BinData);
        true ->
            skip
    end,
    {noreply, State};

handle_cast({_Node, {'clear_teams_reqlist_by_id', RoleId}}, State) ->
    #team{reqlist = ReqList} = State,
    case lists:keyfind(RoleId, #mb.id, ReqList) of
        false ->
            {noreply, State};
        _ ->
            NewReqList = lists:keydelete(RoleId, #mb.id, ReqList),
            {noreply, State#team{reqlist = NewReqList}}
    end;

handle_cast({_Node, {'set_matching_state', RoleId, MatchingState}}, State) when
        MatchingState =:= 1 orelse MatchingState =:= 0 ->
    case lib_team_mod:check_team_matching_state(State, RoleId, MatchingState) of
        true ->
            if
                State#team.is_matching =/= MatchingState ->
                    {Code, NewState} = lib_team_mod:set_team_matching_state(State, MatchingState);
                true ->
                    Code = ?SUCCESS, NewState = State
            end;
        after_check ->
            Code = skip,
            NewState = lib_team_mod:check_members_before_dosth(State, set_matching_state, []);
        {false, Code} ->
            NewState = State
    end,
    if
        Code =:= skip ->
            skip;
        true ->
            #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}, match_st = MatchSt} = NewState,
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, MatchingState, MatchSt, ActivityId, SubTypeId, RoleId]),
            lib_team:send_team(NewState, BinData)
    end,
    {noreply, NewState};

handle_cast({Node, {'set_matching', RoleId, ActivityId, SubTypeId}}, #team{is_matching = 0} = State) ->
    #team{enlist = EnList} = State,
    case EnList of
        #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId} ->
            handle_cast({Node, {'set_matching_state', RoleId, 1}}, State);
        _ ->
            CheckState = State#team{enlist = EnList#team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}},
            case lib_team_mod:check_team_matching_state(CheckState, RoleId, 1) of
                true ->
                    #team_enlist_cfg{default_lv_min = LvMin, default_lv_max = LvMax} = data_team_ui:get(ActivityId, SubTypeId),
                    case lib_team_mod:check_change_team_enlist(State, RoleId, ActivityId, SubTypeId, LvMin, LvMax) of
                        {true, Cfg} ->
                            %% 先改目标
                            ChangedState = lib_team_mod:change_team_enlist(State, Cfg, 0, LvMin, LvMax, 0),
                            {ok, BinData} = pt_240:write(24017, [?SUCCESS, ActivityId, SubTypeId, 0, LvMin, LvMax, 0]),
                            lib_team:send_team(ChangedState, BinData),
                            %% 设置匹配
                            {Code, NewState} = lib_team_mod:set_team_matching_state(ChangedState, 1),
                            if
                                Code =:= skip ->
                                    skip;
                                true ->
                                    #team{match_st = MatchSt} = NewState,
                                    {CodeInt, CodeArgs} = util:parse_error_code(Code),
                                    {ok, BinData1} = pt_240:write(24048, [CodeInt, CodeArgs, 1, MatchSt, ActivityId, SubTypeId, RoleId]),
                                    lib_team:send_team(NewState, BinData1)
                            end,
                            {noreply, NewState};
                        {false, Code} ->
                            {CodeInt, CodeArgs} = util:parse_error_code(Code),
                            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 1, 0, ActivityId, SubTypeId, RoleId]),
                            lib_team:send_to_uid(Node, RoleId, BinData),
                            {noreply, State};
                        {take_over, TargetClsType} ->
                            PtArgs = [1, ActivityId, SubTypeId, RoleId],
                            TakeOverInfo = [{lv, [LvMin, LvMax]}, {take_over, [self(), {set_matching, PtArgs}, set_matching]}],
                            FailReturn = {set_matching, Node, RoleId, PtArgs},
                            TmpState = take_over(ActivityId, SubTypeId, 0, TakeOverInfo, FailReturn, Node, TargetClsType, State),
                            {noreply, TmpState}
                    end;
                after_check ->
                    #team_enlist_cfg{default_lv_min = LvMin, default_lv_max = LvMax} = data_team_ui:get(ActivityId, SubTypeId),
                    case lib_team_mod:check_change_team_enlist(State, RoleId, ActivityId, SubTypeId, LvMin, LvMax) of
                        {true, Cfg} ->
                            %% 先改目标
                            ChangedState = lib_team_mod:change_team_enlist(State, Cfg, 0, LvMin, LvMax, 0),
                            {ok, BinData} = pt_240:write(24017, [?SUCCESS, ActivityId, SubTypeId, 0, LvMin, LvMax, 0]),
                            lib_team:send_team(ChangedState, BinData),
                            %% 设置匹配
                            NewState = lib_team_mod:check_members_before_dosth(CheckState, set_matching_state, []),
                            {noreply, NewState};
                        {false, Code} ->
                            {CodeInt, CodeArgs} = util:parse_error_code(Code),
                            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 1, 0, ActivityId, SubTypeId, RoleId]),
                            lib_team:send_to_uid(Node, RoleId, BinData),
                            {noreply, State};
                        {take_over, TargetClsType} ->
                            PtArgs = [1, ActivityId, SubTypeId, RoleId],
                            TakeOverInfo = [{lv, [LvMin, LvMax]}, {take_over, [self(), {check_matching, PtArgs}, check_matching]}],
                            FailReturn = {check_matching, Node, RoleId, PtArgs},
                            TmpState = take_over(ActivityId, SubTypeId, 0, TakeOverInfo, FailReturn, Node, TargetClsType, State),
                            {noreply, TmpState}
                    end;
                {false, Code} ->
                    {CodeInt, CodeArgs} = util:parse_error_code(Code),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 1, 0, ActivityId, SubTypeId, RoleId]),
                    lib_team:send_to_uid(Node, RoleId, BinData),
                    {noreply, State}
            end
    end;

handle_cast({Node, {'quit_dungeon', RoleId, ResultType}}, State) ->
    #team{member = Mbs} = State,
    DunLeaderId = get(dungeon_leader_id),
    case lists:keyfind(RoleId, #mb.id, Mbs) of
        #mb{dungeon_id = DunId} = Mb when DunId > 0 ->
            NewMbs = lists:keystore(RoleId, #mb.id, Mbs, Mb#mb{dungeon_id = 0}),
            NewState = State#team{member = NewMbs},
            if
                ResultType == ?DUN_RESULT_TYPE_NO orelse DunLeaderId =/= RoleId ->
                    handle_cast({Node, {'quit_team', RoleId, 0}}, NewState);
                true ->
                    {noreply, NewState}
            end;
        _ ->
            {noreply, State}
    end;

handle_cast({_Node, {'quit_dungeon_no_team', RoleId, _ResultType}}, State) ->
    #team{member = Mbs} = State,
    case lists:keyfind(RoleId, #mb.id, Mbs) of
        #mb{dungeon_id = DunId} = Mb when DunId > 0 ->
            NewMbs = lists:keystore(RoleId, #mb.id, Mbs, Mb#mb{dungeon_id = 0}),
            NewState = State#team{member = NewMbs},
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

handle_cast({_Node, {'enter_dungeon', RoleId, DunId}}, State) ->
    #team{member = Mbs} = State,
    case lists:keyfind(RoleId, #mb.id, Mbs) of
        Mb when is_record(Mb, mb) ->
            NewMbs = lists:keystore(RoleId, #mb.id, Mbs, Mb#mb{dungeon_id = DunId}),
            {noreply, State#team{member = NewMbs, after_check = undefined}};
        _ ->
            {noreply, State}
    end;

handle_cast({_Node, {'someone_enter_dungeon', RoleIdList, DunId}}, State) ->
    #team{id = TeamId, member = Mbs, enlist = #team_enlist{dun_id = _EnDunId}, cls_type = ClsType, leader_id = LeaderId} = State,
    NewMbs = [begin
                  case lists:member(Mb#mb.id, RoleIdList) of
                      true ->
                          Mb#mb{dungeon_id = DunId};
                      _ ->
                          Mb
                  end
              end || Mb <- Mbs],
    %% if
    %%     EnDunId =:= DunId ->
    %%         mod_team_enlist:cast_to_team_enlist({'change_dungeon_type', TeamId, into});
    %%     true ->
    %%         ok
    %% end,
    put(dungeon_leader_id, LeaderId),
    mod_team_enlist:cast_to_team_enlist(ClsType, {'change_dungeon_type', TeamId, into}),
    {noreply, State#team{member = NewMbs, after_check = undefined}};

%%%% 队长离线挂机进入自动匹配队列
%%handle_cast({_Node, {'onhook_team_to_match', RoleId}}, State) ->
%%    #team{id = TeamId, cls_type=ClsType, member = Members, target_enlist = Target, max_num = MaxMemberNum} = State,
%%    case lists:keyfind(RoleId, #mb.id, Members) of
%%        false -> {noreply, State};
%%        #mb{scene = SceneId} = _Mb ->
%%            {NewTarget, LvMin, LvMax} = lib_team:get_onhook_target_type(SceneId),
%%            #team_enlist{ activity_id = ActId, subtype_id = SubTypeId} = NewTarget,
%%            mod_team_enlist:change_team(ClsType, TeamId, [{enlist, Target, NewTarget}, {lv, LvMin, LvMax}]),
%%            {ok, BinData} = pt_240:write(24017, [1, ActId, SubTypeId, SceneId, LvMin, LvMax]),
%%            lib_team:send_team(State, BinData),
%%            case length(Members) >= MaxMemberNum of
%%                true ->
%%                    {noreply, State#team{enlist = NewTarget, target_enlist = NewTarget, lv_limit_min = LvMin, lv_limit_max = LvMax}};
%%                false ->
%%                    NewState = State#team{enlist = NewTarget, target_enlist = NewTarget, lv_limit_min = LvMin, lv_limit_max = LvMax},
%%                    handle_cast({_Node, {'set_matching_state', RoleId, 1}}, NewState)
%%            end
%%    end;

handle_cast({_Node, {'ready_for_match', RoleId, Data}}, State) ->
    #team{member = Mbs, is_matching = MatchingState, enlist = EnList} = State,
    if
        MatchingState > 255 ->
            case lists:keyfind(RoleId, #mb.id, Mbs) of
                Mb when is_record(Mb, mb) ->
                    NewMbs = lists:keystore(RoleId, #mb.id, Mbs, Mb#mb{match_ok = 1, target_start_data = Data}),
                    NewState = State#team{member = NewMbs},
                    case lists:all(fun (#mb{match_ok = Ok}) -> Ok =:= 1 end, NewMbs) of
                        true ->
                            #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId} = EnList,
                            {ok, BinData} = pt_240:write(24023, [?SUCCESS, ActivityId, SubTypeId]),
                            lib_team:send_team(NewState, BinData),
                            case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, all_ready_for_match, 1) of
                                undefined ->
                                    {noreply, NewState};
                                Mod ->
                                    NewState1 = Mod:all_ready_for_match(NewState),
                                    {noreply, NewState1}
                            end;
                        _ ->
                            {noreply, NewState}
                    end;
                _ ->
                    {noreply, State}
            end;
        true ->
            {noreply, State}
    end;

handle_cast({_Node, {'fail_for_match', RoleId, OtherErrorCode}}, State) ->
    #team{member = Mbs, is_matching = MatchingState} = State,
    if
        MatchingState > 255 ->
            case lists:keyfind(RoleId, #mb.id, Mbs) of
                Mb when is_record(Mb, mb) ->
                    NewMbs = [M#mb{match_ok = 0, target_start_data = []} || M <- Mbs],
                    NewState = State#team{member = NewMbs, is_matching = 0},
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(OtherErrorCode),
                    {ok, BinData} = pt_240:write(24038, [ErrorCodeInt, ErrorCodeArgs]),
                    lib_team:send_team(NewState, BinData),
                    {noreply, NewState};
                _ ->
                    {noreply, State}
            end;
        true ->
            {noreply, State}
    end;

handle_cast({_Node, {enter_dungeon_from_outside, DunId, Pid}}, State) ->
    #team{dungeon = TeamDungeon, id = TeamId, cls_type = ClsType, enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}, leader_id = LeaderId} = State,
    NewTeamDungeon = TeamDungeon#team_dungeon{dun_id = DunId, dun_pid = Pid},
    {CodeInt, CodeArgs} = util:parse_error_code(?SUCCESS),
    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 2, 0, ActivityId, SubTypeId, LeaderId]),
    mod_team_enlist:change_team(ClsType, TeamId, [{matching, 0}]),
    lib_team:send_team(State, BinData),
    {noreply, State#team{dungeon = NewTeamDungeon, is_matching = 0}};

handle_cast({_Node, {dummy_data_for_fake_mb, BattleAttr, SkillList}}, State) ->
    #team{dungeon = #team_dungeon{dun_pid = DunPid, dun_id = DunId}, member = Mbs, id = TeamId} = State,
    case [{M#mb.server_id, M#mb.server_num, M#mb.figure, M#mb.location} || M <- Mbs, lib_team:is_fake_mb(M)] of
        [_|_] = Figures when is_pid(DunPid) ->
            R = lib_dungeon_team:get_dummy_attr_ratio(DunId),
            BattleAttr1 = lib_dummy_api:change_battle_attr(BattleAttr, [{attr_r, R}]),
            % ?MYLOG("hjhdummy", "BattleAttr Hp:~p Att:~p DummyHp:~p DummyAtt:~p~n",
            %     [BattleAttr#battle_attr.hp, BattleAttr#battle_attr.attr,
            %         BattleAttr1#battle_attr.hp, BattleAttr1#battle_attr.attr]),
            mod_dungeon:apply(DunPid, lib_team_dungeon_mod, create_dummy, {Figures, BattleAttr1, SkillList, TeamId});
        _ ->
            skip
    end,
    NewMbs = [
        case lib_team:is_fake_mb(M) of
            true ->
                M#mb{dungeon_id = DunId};
            _ ->
                M
        end ||
    M <- Mbs],
    {noreply, State#team{member = NewMbs}};

%% 检查操作返回
handle_cast({_Node, {check_sth_respond, RoleId, CheckId, Res}}, State) ->
    case State#team.after_check of
        #after_check{id = CheckId} ->
            NewState = lib_team_mod:handle_check_sth_respond(State, RoleId, Res),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end ;

handle_cast({Node, {send_invite_tv, RoleId}}, State) ->
    #team{after_check = AfterCheck, lv_limit_min = LvMin, lv_limit_max = LvMax} = State,
    case AfterCheck of
        #after_check{pass = 1} ->
            lib_team_mod:send_invite_tv(State, Node, RoleId, LvMin, LvMax),
            {noreply, State};
        _ ->
            NewState = lib_team_mod:check_members_before_dosth(State, send_invite_tv, [Node, RoleId, LvMin, LvMax]),
            {noreply, NewState}
    end;

handle_cast({_Node, {'set_auto_start', RoleId, 1}}, #team{leader_id = RoleId} = State) ->
    #team{auto_type = AutoType} = State,
    {ok, BinData} = pt_240:write(24059, [1]),
    lib_team:send_team(State, BinData),
    if
        AutoType == 1 ->
            {noreply, State};
        true ->
            #team{free_location = FreeLocation} = State,
            if
                FreeLocation == [] ->
                    NewState = lib_team_mod:try_auto_start(State#team{auto_type = 1}),
                    {noreply, NewState};
                true ->
                    {noreply, State#team{auto_type = 1}}
            end
    end;


handle_cast({_Node, {'set_auto_start', RoleId, 0}}, #team{leader_id = RoleId} = State) ->
    {ok, BinData} = pt_240:write(24059, [0]),
    lib_team:send_team(State, BinData),
    {noreply, State#team{auto_type = 0}};

handle_cast({Node, {check, RoleId}}, State) ->
    case lists:keyfind(RoleId, #mb.id, State#team.member) of
        false ->
            ok;
        _ ->
            lib_player:apply_cast(Node, RoleId, ?APPLY_CAST, ?NOT_HAND_OFFLINE, lib_team, check_team_success, [State#team.id])
    end,
    {noreply, State};

%% 同步队伍的伤害归属
handle_cast({_Node, {'sync_team_boss_bl_whos', Aid, SceneId, ScenePoolId, CopyId, ObjectX, ObjectY, TracingDistance, RoleIdL}}, State) ->
    #team{member = Members} = State,
    case [RoleId||#mb{id = RoleId}<-Members, not lists:member(RoleId, RoleIdL)] of
        [] -> skip;
        NoRoleIdL ->
            mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, get_scene_boss_hurt_user_with_id_list,
                [Aid, CopyId, ObjectX, ObjectY, TracingDistance, NoRoleIdL])
    end,
    {noreply, State};

%% 催促开启活动
handle_cast({_Node, {'ugre_open_act', Name}}, State) ->
    #team{leader_id = LeaderId, leader_node = LeaderNode} = State,
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code({?ERRCODE(err240_ugre_open_act), [Name]}),
    {ok, BinData} = pt_240:write(24038, [ErrorCodeInt, ErrorCodeArgs]),
    lib_team:send_to_uid(LeaderNode, LeaderId, BinData),
    {noreply, State};

%% 进入众生之门玩法
handle_cast({_Node, {'enter_beings_gate', RoleId}}, State) ->
    {ok, BinData} = pt_241:write(24108, [?SUCCESS]),
    lib_team:send_team(State, BinData, RoleId),
    {noreply, State};

%% apply
handle_cast({_Node, {'apply_cast', Mod, Fun, Args}}, State) ->
    NewState = apply(Mod, Fun, [State|Args]),
    {noreply, NewState};

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_R, State) ->
    ?DEBUG("mod_team:handle_cast not match: ~p", [_R]),
    {noreply, State}.

%% 设置玩家的被动技能
set_member_team_skill(ClsType, MemberList)->
    Fun = fun(#mb{id = RoleId, skill = SkillId}, TSkills) ->
                  ?IF(SkillId == 0, TSkills, [{RoleId, SkillId}|TSkills])
          end,
    case lists:foldl(Fun, [], MemberList) of
        [] -> [];
        TeamSkills ->
            %% 计算跟自己的通场景的玩家，有技能的玩家
            F = fun(#mb{id = RoleId, node = Node} = Mb) ->
                        case lib_team:is_fake_mb(Mb) of
                            true -> skip;
                            false ->
                                %% 计算自己同场景的玩家
                                {SetSkillId, SkillBuffNum} = calc_team_skill_buff_num(MemberList, Mb, 0, 0),
                                mod_team:cast_to_game(ClsType, Node, lib_player, update_player_info, [RoleId, [{team_skill, {SetSkillId, SkillBuffNum}}]])
                        end
                end,
            [F(M) || M <- MemberList],
            TeamSkills
    end.

%% 计算同场景的玩家数据
calc_team_skill_buff_num([], _Mb, SkillId, BuffNum) -> {SkillId, BuffNum};
calc_team_skill_buff_num([H|T], Mb, TSkillId, BuffNum)->
    #mb{id = HRoleId, skill = HSkillId, scene = HScene, scene_pool_id = HPoolId, copy_id = HCopyId} = H,
    #mb{id = RoleId, skill = SkillId, scene = Scene, scene_pool_id = PoolId, copy_id = CopyId} = Mb,
        if
            HRoleId == RoleId orelse HSkillId == 0 -> %% 排除自己
                calc_team_skill_buff_num(T, Mb, TSkillId, BuffNum);
            HScene =/= Scene orelse HPoolId /= PoolId orelse HCopyId /= CopyId -> %% 排除不再统一场景的
                calc_team_skill_buff_num(T, Mb, TSkillId, BuffNum);
            SkillId == 0 -> %% 玩家自己的判断,别人有技能 BuffNum+1
                calc_team_skill_buff_num(T, Mb, HSkillId, BuffNum+1);
            true ->  %% 自己有技能，别人也有技能 BuffNum+1
                calc_team_skill_buff_num(T, Mb, TSkillId, BuffNum+1)
        end.

%% 加入队伍
join_team(Node, MbInfo, State) ->
    #team{id=TeamId, cls_type=ClsType, free_location=FreeLoaction, member=MemberList, rela=OldRela, pre_num_full=OldPreNumFull, his_teammate=HisTeammate, enlist = EnList,is_matching = IsMatching} = State,
    #mb{id=RoleId, help_type = HelpType, node = MNode} = MbInfo,
    lib_team:notify_team_change(Node, ?ERRCODE(err240_join_team), ?ERRCODE(err240_new_member), 4, MbInfo, State),
    [Free|T] = FreeLoaction,
    lib_team_mod:set_member_attr(State, MbInfo#mb.node, MbInfo#mb.id, ?TEAM_MEMBER, TeamId),
    %% MbInfoAfHelp = lib_team_mod:auto_trans_help_type_by_mb(MbInfo, EnList, ?HELP_TYPE_TRANS_ANY),
    NewMemberList=[MbInfo#mb{location=Free}|MemberList],
    PreNumFull=get_pre_num_full(OldPreNumFull, NewMemberList),
    Rela = ?IF(ClsType =:= ?NODE_GAME, handle_rela(MbInfo, MemberList, OldRela), OldRela),
    TeamSkills = set_member_team_skill(ClsType, NewMemberList),
    %% ?PRINT("OLDRELA ~p Rela ~p~n", [OldRela, Rela]),
    NewState1 = lib_team_mod:delay_notify_teammates_update(State),

    NewState0 = NewState1#team{free_location=T, member=NewMemberList, rela=Rela, team_skill = TeamSkills,
        pre_num_full=PreNumFull, his_teammate=lists:usort([MbInfo#mb.id|HisTeammate])},

    %% lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_team, send_ac_left_time, [EnList#team_enlist.activity_id]),
    lib_player:apply_cast(MNode, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, join_team_success, [[TeamId, self(), EnList, HelpType, IsMatching]]),
    mod_team_enlist:change_team(ClsType, TeamId, [{num, 1}, {mbs, NewMemberList}]),
    if
        T =:= [] ->
            NewState = lib_team_mod:handle_team_member_full(NewState0);
        true ->
            NewState = NewState0
    end,

    lib_team:send_team_info(NewState),
    lib_team_mod:share_skill_list(NewMemberList),
    StateAfJoin = lib_team_event:join_team(NewState, MbInfo),
    %% lib_team:handle_barbecue_buff(NewState, 2).
    StateAfJoin.

%% 退出队伍
%% @param State 还没移除#mb{}
quit_team(State, Mb) ->
    #team{member = Mbs} = State,
    NewMbs = lists:keydelete(Mb#mb.id, #mb.id, Mbs),
    lib_team_mod:share_skill_list(NewMbs),
    #mb{id = RoleId, scene = SceneId, scene_pool_id = PoolId, node = Node, share_skill_list = MyShareSkillL} = Mb,
    % mod_scene_agent:update(SceneId, PoolId, RoleId, [{skill_passive_share, []}]),
    mod_scene_agent:update_skill_passive_share(SceneId, PoolId, Node, RoleId, MyShareSkillL, []),
    ok.

%% 加入亲密度
handle_rela(MbInfo, OldMembers, OldIntimacyL) ->
    RelaList = lib_relationship_api:get_rela_and_intimacy(MbInfo#mb.id, [Mb#mb.id|| Mb <- OldMembers]),
    F = fun({Id, _, Intimacy}, TmpIntimacyL) ->
                case Intimacy > 0 of
                    true -> [{MbInfo#mb.id, Id, Intimacy}|TmpIntimacyL];
                    _ -> TmpIntimacyL
                end
        end,
    lists:foldl(F, OldIntimacyL, RelaList).

%% 移除亲密度记录
del_rela([{IdA, IdB, _}|T], Id, Result) when IdA==Id orelse IdB==Id ->
    del_rela(T, Id, Result);
del_rela([H|T], Id, Result) ->
    del_rela(T, Id, [H|Result]);
del_rela([], _Id, Result) -> %?PRINT("DEL RELA ======= ~p~n", [Result]),
    Result.

%% 查找亲密度
find_intimacy([{IdA, IdB, Intimacy}|_], FromId, ToId) when (IdA==FromId andalso IdB==ToId) orelse (IdA==ToId andalso IdB==FromId) ->
    Intimacy;
find_intimacy([_|T], FromId, ToId) -> find_intimacy(T, FromId, ToId);
find_intimacy([], _, _) -> 0.

%% 判断能否进入藏宝图副本
%% check_dun(RoleId, PreNumFull, DunId, HisTeammate, DunPid, [Scene, CopyId, X, Y]) ->
%%     case data_dungeon:get(DunId) of
%%         % #dungeon{type = ?DUNGEON_TYPE_TSMAP} ->
%%         %     CheckList = [scene, his, full, num, level],
%%         %     lib_tsmap_util:do_check_dun(RoleId, PreNumFull, HisTeammate, DunPid, Scene, CopyId, X, Y, CheckList);
%%         _ ->
%%             {false, ?ERRCODE(err240_this_team_on_dungeon)}
%%     end.

%% 队伍首次满4人之后不让再加人进入队伍
get_pre_num_full(OldPreNumFull, NewMemberList) ->
    case OldPreNumFull == 1 of
        true -> 1;
        _ ->
            case length(NewMemberList)>=4 of
                true -> 1;
                _ -> 0
            end
    end.

%% 托管队伍
take_over(ActivityId, SubTypeId, SceneId, TakeOverInfo, FailReturn, LocalNode, ClsType, State) ->
    #team{name = TeamName, member = Mbs, leader_id = LeaderId, id = TeamId, join_type = JoinType} = State,
    RoleList
        = case Mbs of
              [#mb{id = LeaderId} = Leader|Others] ->
                  Mbs;
              _ ->
                  {value, Leader, Others} = lists:keytake(LeaderId, #mb.id, Mbs),
                  [Leader|Others]
          end,
    % JoinType = ?TEAM_JOIN_TYPE_NO,
    if
        ClsType =:= ?NODE_GAME -> %% 跨服转本服
            {State1, LocalMbs} = lists:foldl(
                fun
                    (#mb{node = N} = R, {S, LMbs}) when N =:= LocalNode ->
                        {S, [R|LMbs]};
                    (#mb{id = Id}, {S, LMbs}) ->
                    {noreply, S1} = handle_cast({LocalNode, {'kick_out', Id, LeaderId, 1}}, S),
                    {S1, LMbs}
                end, {State, []}, Others),
            Args = [{?CREATE_TYPE_TAKE_OVER, TeamId}, ActivityId, SubTypeId, SceneId, TeamName, JoinType, 0, [Leader|LocalMbs], TakeOverInfo],
            TargetNode = LocalNode;
        true -> %% 本服转跨服
            State1 = State,
            Args = [{?CREATE_TYPE_TAKE_OVER, TeamId}, ActivityId, SubTypeId, SceneId, TeamName, JoinType, 0, RoleList, TakeOverInfo],
            TargetNode = mod_disperse:get_center_node()
    end,
    From = self(),
    % ?PRINT("create_for_take_over ~p~n", [Args]),
    unode:apply(TargetNode, mod_team_create, create_for_take_over, [Args, From, FailReturn]),
    WaitingStatus = #waiting_status{time = utime:unixtime(), info = take_over},
    State1#team{waiting_status = WaitingStatus}.

fake_mb_leave(Mbs, 0) ->
  [
    self() ! {fake_mb_leave, RoleId} || #mb{id = RoleId} = M <- Mbs, lib_team:is_fake_mb(M)
  ];

fake_mb_leave(_Mbs, _) -> ok.

delegate_leader(State) ->
    #team{id = TeamId, member = Mbs, cls_type = ClsType} = State,
    case lists:keysort(#mb.join_time, [M || M <- Mbs, lib_team:is_fake_mb(M) =:= false]) of
        [NewLeaderInfo | _OtherMb] ->%% 新队长数据
            #mb{id = NewLeaderId, node = NewLeaderNode} = NewLeaderInfo,
            NewState = State#team{leader_id = NewLeaderId, leader_node = NewLeaderNode},
            lib_team_mod:set_member_attr(NewState, NewLeaderInfo#mb.node, NewLeaderId, ?TEAM_LEADER, TeamId),
            mod_team_enlist:change_team(ClsType, TeamId, [{leader, NewLeaderId}]),
            %% 发送队长变更信息
            {ok, BinData1} = pt_240:write(24015, [NewLeaderId]),
            lib_team:send_team(NewState, BinData1);
        _ ->
            NewState = State#team{leader_id = 0, leader_node = undefined}
    end,
    fake_mb_leave(NewState#team.member, NewState#team.leader_id),
    NewState.
