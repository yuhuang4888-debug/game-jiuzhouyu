%% ---------------------------------------------------------------------------
%% @doc mod_team_info
%% @author ming_up@foxmail.com
%% @since  2016-11-01
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(mod_team_info).
-export([handle_info/2]).
-include("common.hrl").
-include("team.hrl").
-include("predefine.hrl").
-include("rec_onhook.hrl").
-include("errcode.hrl").

%% 仲裁
handle_info({'arbitrate_result'}, State) ->
    ArbitrateState = lib_team_mod:arbitrate_result(State, timeout),
    {noreply, ArbitrateState};

handle_info({'arbitrate_result_op_timeout'}, State) ->
    ArbitrateState = lib_team_mod:arbitrate_result_op_timeout(State),
    {noreply, ArbitrateState};

% handle_info('cancel_lock', State) ->
%     #team{id = TeamId, lock_ref = OldRef, lock_type = LockType} = State,
%     util:cancel_timer(OldRef),
%     case LockType/=0 of
%         true ->
%             mod_team_lock:cast_to_team_lock(set_lock, [TeamId, 0]);
%         _ ->
%             skip
%     end,
%     State#team{lock_ref = none, lock_type = 0};

handle_info('notify_teammates_update', State) ->
    #team{id = TeamId, member = Mbs, enlist = EnList, cls_type = ClsType} = State,
    MbInfos = [#slim_mb{id = MId, scene = S, online = Online} || #mb{id = MId, scene = S, online = Online} <- Mbs],
    lib_team:members_apply_cast(ClsType, Mbs, ?APPLY_CAST_STATUS, lib_team, change_teammate_in_team, [TeamId, EnList#team_enlist.activity_id, EnList#team_enlist.subtype_id, MbInfos]),
    {noreply, State#team{delay_update_ref = undefined}};

handle_info({take_over_team_done, NewTeamPid, _BackArgs}, State) ->
    #team{waiting_status = WaitingStatus} = State,
    case WaitingStatus of
        #waiting_status{msg_list = MsgList} ->
            AvailableList = lists:foldl(fun
                (Msg, Acc) ->
                    case Msg of
                        {_, {_, Info}} when element(1, Info) =:= 'quit_team' ->
                            [Msg|Acc];
                        _ ->
                            Acc
                    end
            end, [], MsgList),
            if
                AvailableList =/= [] ->
                    NewTeamPid ! {thanks_take_over, AvailableList};
                true ->
                    ok
            end;
        _ ->
            ok
    end,
    {stop, normal, State#team{member = [], waiting_status = []}};

handle_info({take_over_team_fail, FailReturn}, State) ->
    #team{waiting_status = WaitingStatus} = State,
    case WaitingStatus of
        #waiting_status{info = take_over} ->
            case FailReturn of
                {change_team_enlist, Node, RoleId, Args} ->
                    {ok, BinData} = pt_240:write(24017, [?FAIL|Args]),
                    lib_team:send_to_uid(Node, RoleId, BinData);
                {set_matching, Node, RoleId, [MatchingState, ActivityId, SubTypeId, RoleId]} ->
                    {CodeInt, CodeArgs} = util:parse_error_code(?FAIL),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, MatchingState, 0, ActivityId, SubTypeId, RoleId]),
                    lib_team:send_to_uid(Node, RoleId, BinData);
                {check_matching, Node, RoleId, [MatchingState, ActivityId, SubTypeId, RoleId]} ->
                    {CodeInt, CodeArgs} = util:parse_error_code(?FAIL),
                    {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, MatchingState, 0, ActivityId, SubTypeId, RoleId]),
                    lib_team:send_to_uid(Node, RoleId, BinData);
                {invite_request, Node, RoleId} ->
                    {ok, BinData} = pt_240:write(24006, [?FAIL]),
                    lib_team:send_to_uid(Node, RoleId, BinData);
                _ ->
                    ok
            end,
            {noreply, State#team{waiting_status = []}};
        _ ->
            {noreply, State}
    end;

handle_info({thanks_take_over, MsgList}, State) ->
    lib_team:handle_message(State, MsgList);

handle_info(try_match_fake_mb, State) ->
    if
        State#team.is_matching == 1 andalso State#team.free_location =/= []->
            #team{leader_id = LeaderId, member = Mbs, enlist = #team_enlist{dun_id = DunId}} = State,
            case lists:keyfind(LeaderId, #mb.id, Mbs) of
                Mb when is_record(Mb, mb) ->
                    FMb = lib_team:make_fake_mb(Mb, DunId),
                    NewState = fake_join_team(FMb, State),
                    {noreply, NewState};
                _ ->
                    {noreply, State#team{fake_mb_ref = undefined}}
            end;
        true ->
            {noreply, State#team{fake_mb_ref = undefined}}
    end;

handle_info({fake_mb_leave, RoleId}, State) ->
    #team{id=TeamId, cls_type=ClsType, member=MemberList, leader_id=LeaderId,
          free_location=FreeLocation} = State,
    MemberLen = length(MemberList),
    Mb = lists:keyfind(RoleId, #mb.id, MemberList),
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    %% IsTsmaps = lib_team_mod:is_dun_tsmaps(State),
    if
        Mb =:= false -> {noreply, State};
        %% 在副本中无法普通退出副本
        IsOnDungeon ->
            {noreply, State};
        % LockType /= 0 -> {noreply, State};
        MemberLen < 2 ->
            StateAfInterrupt0 = lib_team_mod:interrupt_special_match(State),
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(StateAfInterrupt0),
            {stop, normal, StateAfInterrupt#team{member = []}};
        true ->
            StateAfInterrupt0 = lib_team_mod:interrupt_special_match(State),
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(StateAfInterrupt0),
            %% 重新设置空闲位置
            Free = lists:sort([Mb#mb.location | FreeLocation]),
            NewMembers = lists:keydelete(RoleId, #mb.id, StateAfInterrupt#team.member),
            mod_team_enlist:change_team(ClsType, TeamId, [{num, -1},{mbs, NewMembers}]),
            if
                RoleId =:= LeaderId ->
                    %% 新队长数据,
                    case lists:keysort(#mb.join_time, [M || M <- NewMembers, lib_team:is_fake_mb(M) =:= false]) of
                        [NewLeaderInfo|_OtherMb] ->
                            #mb{id = NewLeaderId, node = NewLeaderNode} = NewLeaderInfo,
                            NewState = StateAfInterrupt#team{leader_id = NewLeaderId, leader_node = NewLeaderNode, member = NewMembers, free_location = Free},
                            lib_team_mod:set_member_attr(NewState, NewLeaderInfo#mb.node, NewLeaderId, ?TEAM_LEADER, TeamId),
                            mod_team_enlist:change_team(ClsType, TeamId, [{leader, NewLeaderId}]),
                            %% 发送队长变更信息
                            {ok, BinData1} = pt_240:write(24015, [NewLeaderId]),
                            lib_team:send_team(NewState, BinData1);
                        _ ->
                            NewState = StateAfInterrupt#team{member = NewMembers, free_location = Free}
                    end;
                true ->
                    NewState = StateAfInterrupt#team{member = NewMembers, free_location = Free}
            end,
            %% 发送离开队员id
            {ok, BinData} = pt_240:write(24014, [RoleId]),
            lib_team:send_team(NewState, BinData),
            lib_team:notify_team_change(none, ?ERRCODE(err240_self_out_team), ?ERRCODE(err240_out_team), 5, Mb, NewState),
            NewState1 = lib_team_mod:delay_notify_teammates_update(NewState),
            {noreply, NewState1}
    end;

handle_info({fake_agree_arbitrate, RoleId}, State) ->
    #team{arbitrate_result_ref = ArbRef, arbitrate = Arbitrate} = State,
    #team_arbitrate{id = ArbitrateId, vote_list = VoteList} = Arbitrate,
    % #team_enlist{module_id = Module, sub_module = SubModule} = Enlist,
    if
        is_reference(ArbRef) == false -> 
            {noreply, State};
        true ->
            case lists:keyfind(RoleId, #vote_info.role_id, VoteList) of
                false ->
                    NewState = lib_team_mod:do_arbitrate_res(State, RoleId, 1, undefined, fake_mb),
                    NewState2 = lib_team_mod:arbitrate_result(NewState, {vote, RoleId, 1}),
                    {ok, BinData3} = pt_240:write(24036, [RoleId, ArbitrateId, 1]),
                    lib_team:send_team(NewState2, BinData3),
                    {noreply, NewState2};
                _ ->
                    {noreply, State}
            end
    end;

handle_info({check_for_sth_timeout, CheckId}, State) ->
    #team{after_check = AfterCheck} = State,
    case AfterCheck of
        #after_check{id = CheckId, pass = 0} ->
            Code = ?ERRCODE(system_busy),
            NewState = lib_team_mod:check_for_sth_fail(State, 0, {false, Code, Code}),
            {noreply, NewState};
        _ ->
            {noreply, State}
    end;

handle_info({auto_start_vote, ActivityId, SubTypeId}, State) ->
    case State of
        #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}, after_check = #after_check{pass = 1},
            leader_node = LeaderNode, leader_id = LeaderId, id = TeamId, auto_type = 1} ->
            lib_player:apply_cast(LeaderNode, LeaderId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, auto_arbitrate, [TeamId, ActivityId, SubTypeId]);
        _ ->
            ok
    end,
    {noreply, State};

%% 没有匹配到的消息.
handle_info(_Info, State) ->
    ?DEBUG("handle_info no math ~p", [_Info]),
    {noreply, State}.

fake_join_team(MbInfo, State) ->
    #team{id=TeamId, cls_type=ClsType, fake_mb_ref = Ref,
        free_location=FreeLoaction, member=MemberList,
        is_matching = IsMatching, enlist = EnList} = State,
    lib_team:notify_team_change(none, ?ERRCODE(err240_join_team), ?ERRCODE(err240_new_member), 4, MbInfo, State),
    [Free|T] = FreeLoaction,
    % set_member_attr(State, MbInfo#mb.node, MbInfo#mb.id, ?TEAM_MEMBER, TeamId),
    %% MbInfoAfHelp = lib_team_mod:auto_trans_help_type_by_mb(MbInfo, EnList, ?HELP_TYPE_TRANS_ANY),
    NewMbInfo = MbInfo#mb{location=Free, id = MbInfo#mb.id + Free, join_time = utime:unixtime()},
    NewMemberList=[NewMbInfo|MemberList],
    % PreNumFull=get_pre_num_full(OldPreNumFull, NewMemberList),
    % Rela = ?IF(ClsType =:= ?NODE_GAME, handle_rela(MbInfo, MemberList, OldRela), OldRela),
    % TeamSkills = set_member_team_skill(ClsType, NewMemberList),
    %% ?PRINT("OLDRELA ~p Rela ~p~n", [OldRela, Rela]),
    % NewState1 = lib_team_mod:delay_notify_teammates_update(State),

    NewState0 = State#team{free_location=T, member=NewMemberList},

    %% lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_team, send_ac_left_time, [EnList#team_enlist.activity_id]),
    erlang:send_after(?FAKE_LEAVE_TIME, self(), {fake_mb_leave, NewMbInfo#mb.id}),
    mod_team_enlist:change_team(ClsType, TeamId, [{num, 1}, {mbs, NewMemberList}]),
    if
        T =:= [] ->
            NewState = lib_team_mod:handle_team_member_full(NewState0);
        IsMatching =:= 1 ->
            #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId} = EnList,
            JoinInTime = lib_team_match:get_fake_join_in_time(State, ActivityId, SubTypeId),
            Ref1 = util:send_after(Ref, JoinInTime, self(), try_match_fake_mb),
            NewState = NewState0#team{fake_mb_ref = Ref1};
        true ->
            NewState = NewState0#team{fake_mb_ref = undefined}
    end,

    lib_team:send_team_info(NewState),
    %% lib_team:handle_barbecue_buff(NewState, 2).
    NewState.


