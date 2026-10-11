%% ---------------------------------------------------------------------------
%% @doc mod_team_call
%% @author ming_up@foxmail.com
%% @since  2016-11-01
%% @deprecated 
%% ---------------------------------------------------------------------------

-module(mod_team_call).
-export([handle_call/3]).
-include("common.hrl").
-include("team.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("dungeon.hrl").

handle_call('get_mb_ids', _From, State) -> 
    #team{member=Mbs} = State,
    {reply, [Mb#mb.id ||Mb <- Mbs], State};

handle_call({'create_dun', SelfPid, DunId, DungeonRole, StartDunArgs}, _From, State) -> 
    #team{id=TeamId}=State,
    Pid = mod_dungeon:start(TeamId, SelfPid, DunId, [DungeonRole], StartDunArgs),
    Dun=#team_dungeon{dun_id=DunId, dun_pid=Pid},
    {reply, Pid, State#team{dungeon=Dun}};
    
handle_call('get_his_teammate', _From, State) ->
    #team{his_teammate=HisTeammate} = State,
    {reply, HisTeammate, State};

handle_call({'quit_team', RoleId, QuitType}, _From, State) ->
    Node = undefined,
    #team{id=TeamId, cls_type=ClsType, member=MemberList, leader_id=LeaderId, free_location=FreeLocation, rela=OldRela} = State,
    MemberLen = length(MemberList),
    Mb = lists:keyfind(RoleId, #mb.id, MemberList),
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    % IsTsmaps = lib_team_mod:is_dun_tsmaps(State),
    if
        Mb =:= false -> {reply, false, State};
        % 在副本中无法普通退出副本
        QuitType == 0 andalso IsOnDungeon -> {noreply, false, State};
        MemberLen < 2 ->
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
            {ok, BinData1} = pt_240:write(24030, [?ERRCODE(err240_self_out_team)]),
            lib_team:send_to_uid(Node, RoleId, BinData1),
            % set_member_attr(StateAfInterrupt, Mb#mb.node, RoleId, 0, 0, 0),
            {ok, BinData} = pt_240:write(24005, [?SUCCESS]),
            lib_team:send_to_uid(Node, RoleId, BinData),
            % ?IF(DunId/=0, mod_dungeon:quit_dungeon(DunPid, RoleId), skip),
            {stop, normal, true, StateAfInterrupt#team{member = []}};
        RoleId == LeaderId ->
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
            %% 重新设置空闲位置
            Free = lists:sort([Mb#mb.location | FreeLocation]),
            FollowState = lib_team:cancel_follow(StateAfInterrupt, RoleId),
            FollowsState = lib_team:cancel_follows(FollowState, RoleId),

            NewMembers = lists:keydelete(RoleId, #mb.id, FollowsState#team.member),
            [NewLeaderInfo|_OtherMb] = NewMembers,
            %% 新队长数据
            #mb{id = NewLeaderId, node = NewLeaderNode} = NewLeaderInfo,
            Rela = mod_team_cast:del_rela(OldRela, RoleId, []),
            NewState = FollowsState#team{leader_id = NewLeaderId, leader_node = NewLeaderNode,
                member = NewMembers, free_location = Free, rela=Rela},

            % set_member_attr(NewState, Mb#mb.node, RoleId, 0, 0, 0),
            % set_member_attr(NewState, NewLeaderInfo#mb.node, NewLeaderId, ?TEAM_LEADER, TeamId, 0),
            mod_team_enlist:change_team(ClsType, TeamId, [{num, -1}, {mbs, NewMembers}]),
            %% 发送离开队员id
            {ok, BinData} = pt_240:write(24014, [RoleId]),
            lib_team:send_team(NewState, BinData),
            %% 发送队长变更信息
            {ok, BinData1} = pt_240:write(24015, [NewLeaderId]),
            lib_team:send_team(NewState, BinData1),
            %lib_team:send_team_info(NewState),
            {ok, BinData2} = pt_240:write(24005, [?SUCCESS]),
            lib_team:send_to_uid(Node, RoleId, BinData2),
            %% BuffState = lib_team:handle_barbecue_buff(NewState, 2),
            lib_team:notify_team_change(Node, ?ERRCODE(err240_self_out_team), ?ERRCODE(err240_out_team), 5, Mb, NewState),
            % ?IF(DunId/=0, mod_dungeon:quit_dungeon(DunPid, RoleId), skip),
            {reply, true, NewState};
        true -> 
            StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
            %% 更新玩家进程和场景进程的数据，并告诉附近的玩家.
            % set_member_attr(StateAfInterrupt, Mb#mb.node, RoleId, 0, 0, 0),
            %% 重新设置空闲位置
            Free = lists:sort([Mb#mb.location | FreeLocation]),
            %% 处理跟随状态
            FollowState = lib_team:cancel_follow(StateAfInterrupt, RoleId),
            FollowsState = lib_team:cancel_follows(FollowState, RoleId),

            NewMembers = lists:keydelete(RoleId, #mb.id, FollowsState#team.member),
            Rela = mod_team_cast:del_rela(OldRela, RoleId, []),
            NewState = FollowsState#team{member = NewMembers, free_location = Free, rela=Rela},
            mod_team_enlist:change_team(ClsType, TeamId, [{num, -1},{mbs, NewMembers}]),
            {ok, BinData} = pt_240:write(24014, [RoleId]),
            lib_team:send_team(NewState, BinData),
            {ok, BinData2} = pt_240:write(24005, [?SUCCESS]),
            lib_team:send_to_uid(Node, RoleId, BinData2),
            %% BuffState = lib_team:handle_barbecue_buff(NewState, 2),
            lib_team:notify_team_change(Node, ?ERRCODE(err240_self_out_team), ?ERRCODE(err240_out_team), 5, Mb, NewState),
            % ?IF(DunId/=0, mod_dungeon:quit_dungeon(DunPid, RoleId), skip),
            {reply, true, NewState}
    end;

% handle_call('is_dun_tsmaps', _From, State) ->
%     #team{dungeon = Dun} = State,
%     #team_dungeon{dun_id = DunId} = Dun,
%     Reply = case data_dungeon:get(DunId) of
%         #dungeon{type = ?DUNGEON_TYPE_TSMAP} ->
%             true;
%         _ ->
%             false
%     end,
%     {reply, Reply, State};

handle_call(_R, _From, State) ->
    % ?PRINT("mod_team:handle_call not match: ~p", [_R]),
    {reply, _R, State}.



%% 更新玩家属性  1通知到玩家自身进程 0不通知
% set_member_attr(State, Node, MemberId, TeamMemberType, TeamId, Type) -> 
    % ?IF(Type == 1,
    %     mod_team_cast:set_member_attr(State, Node, MemberId, TeamMemberType, TeamId),
    %     skip).
