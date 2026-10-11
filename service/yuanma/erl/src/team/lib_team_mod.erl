%% ---------------------------------------------------------------------------
%% @doc lib_team_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-04-07
%% @deprecated 队伍进程的副本处理
%% ---------------------------------------------------------------------------
-module(lib_team_mod).
-export([]).

-compile(export_all).

-include("team.hrl").
-include("dungeon.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("chat.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("activitycalen.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("def_daily.hrl").
-include("awakening.hrl").
-include("task.hrl").

%% 队伍中的操作,注意要限制住:
%%  任命队长，同意别人进入队伍，退出队伍（主动退出，离线退出）
%%  邀请别人加入队伍，被邀请人回应加入队伍请求，踢出队伍，更改队伍目标，申请加入队伍

%% 组队操作的一些判断规则:
%%  修改组队副本需要加条件判断
%%      lib_team_mod
%%      lib_team_dungeon_mod
%%      lib_team
%%      lib_dungeon_team
%%

%% ---------------------------------------------------------------------------
%% 仲裁
%% ---------------------------------------------------------------------------

%% ---------------------------------------------------------------------------
%% #team_enlist{activity_id = ActivityId, subtype_id = SubtypeId, module_id = Module, sub_module = SubModule}:
%%  ActivityId和SubtypeId只作为排序和分组
%%  Module和SubModule:队伍逻辑根据模块id和子模块id进行处理
%% 流程
%%  1、发起仲裁:arbitrate_req
%%      根据模块id和子模块id判断检查.默认是成功
%%  2、回应仲裁:arbitrate_res
%%      根据模块id和子模块id判断检查是否能回应.默认是成功
%%  3、仲裁结果:arbitrate_result
%%      (1)回应仲裁会调用该函数,该函数需要根据模块id和子模块id来进行判断处理,成功就进入,否则拒绝。
%%      (2)超时会调用该结果,该函数需要根据模块id和子模块id来进行判断处理,成功就进入,否则拒绝。默认:超时是仲裁失败
%% ---------------------------------------------------------------------------

%% 发起仲裁
arbitrate_req(State, RoleId, Node, ActivityId1, SubTypeId1, Data) ->
    case check_arbitrate_req(State, RoleId, Node, ActivityId1, SubTypeId1) of
        {false, CodeToMe} -> TvErrorCode = CodeToMe, NewState2 = State;
        {false, CodeToMe, _MyCode} -> TvErrorCode = CodeToMe, NewState2 = State;
        {my_false, OtherErrorCode, CodeToMe} -> TvErrorCode = OtherErrorCode, NewState2 = State;
        {true, CheckState} ->
            CodeToMe = ?SUCCESS,
            TvErrorCode = CodeToMe,
            NewState1 = do_arbitrate_req(CheckState, RoleId, Node, Data),
            % NewState2 = case NewState1#team.member of
            %     [_] ->
            %         arbitrate_result(NewState1, {vote, RoleId, 1});
            %     _ ->
            %         NewState1
            % end;
            % 直接判定结算,不需要判断人数的
            NewState2 = NewState1;
            % NewState2 = arbitrate_result(NewState1, {vote, RoleId, 1});
        {true, NewState, _Args} ->
            CodeToMe = ?SUCCESS,
            TvErrorCode = CodeToMe,
            NewState1 = do_arbitrate_req(NewState, RoleId, Node, Data),
            % NewState2 = case NewState1#team.member of
            %     [_] ->
            %         arbitrate_result(NewState1, {vote, RoleId, 1});
            %     _ ->
            %         NewState1
            % end
            % 直接判定结算,
            NewState2 = NewState1
            % NewState2 = arbitrate_result(NewState1, {vote, RoleId, 1})
    end,
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(CodeToMe),
    #team{arbitrate = Arbitrate, member = Members, id = TeamId, cls_type = ClsType} = NewState2,
    #team_arbitrate{id = ArbitrateId, end_time = EndTime} = Arbitrate,
    #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId, scene_id = SceneId, module_id = _ModuleId, sub_module = _SubId}
        = ?IF(CodeToMe =:= ?SUCCESS, NewState2#team.target_enlist, NewState2#team.enlist),
    % ?MYLOG("hjhteam", "arbitrate_req ActivityId:~p SubTypeId:~p ActivityId1:~p, SubTypeId1:~p ArbitrateId:~p RoleId:~p ErrorCodeInt:~p, ErrorCodeArgs:~w ~n",
    %     [ActivityId, SubTypeId, ActivityId1, SubTypeId1, ArbitrateId, RoleId, ErrorCodeInt, ErrorCodeArgs]),
    {ok, BinData} = pt_240:write(24020, [ErrorCodeInt, ErrorCodeArgs, ActivityId, SubTypeId, SceneId, ArbitrateId]),
    lib_team:send_to_uid(Node, RoleId, BinData),
    % 广播仲裁
    case CodeToMe == ?SUCCESS of
        true ->
            %% case ModuleId == ?MOD_TASK andalso SubId == ?MOD_SUB_TASK_OUTDOOR andalso length(Members) < 2 of
            %%     true->
            %%         ok;
            %%     false->
            %% {ok, BinData2} = pt_240:write(24035, [ActivityId, SubTypeId, SceneId, ArbitrateId, EndTime]),
            %% end,
            % 设置玩家队伍状态
            Args = [TeamId, ActivityId, SubTypeId, SceneId, ArbitrateId, EndTime],
            lib_team:members_apply_cast(ClsType, Members, ?APPLY_CAST_STATUS, lib_team, start_arbitrate, [Args]),
            % 通知玩家发起仲裁
            {ok, BinData2} = pt_240:write(24035, [ActivityId, SubTypeId, SceneId, ArbitrateId, EndTime]),
            lib_team:send_team(NewState2, BinData2),
            % 只有队长一人时,默认投票成功
            case Members of
                [_] ->
                    {ok, BinData3} = pt_240:write(24036, [RoleId, ArbitrateId, 1]),
                    lib_team:send_team(NewState2, BinData3);
                _ ->
                    skip
            end,
            % 假人仲裁
            AgreeGap = lib_team_match:get_fake_agree_gap(State, ActivityId, SubTypeId),
            F = fun(#mb{id = TmpRoleId, agree_ref = OldAgreeRef} = Mb, {N, TmpMembers}) ->
                case lib_team:is_fake_mb(Mb) of
                    true ->
                        AgreeRef = util:send_after(OldAgreeRef, AgreeGap*N*1000, self(), {fake_agree_arbitrate, TmpRoleId}),
                        NewMb = Mb#mb{agree_ref = AgreeRef},
                        {N+1, [NewMb|TmpMembers]};
                    false ->
                        {N, [Mb|TmpMembers]}
                end
            end,
            {_N, NewMemberList} = lists:foldl(F, {1, []}, Members),
            StateAfFakeAgree = NewState2#team{member = lists:reverse(NewMemberList)},
            % [erlang:send_after(AgreeGap*N*1000, self(), {fake_agree_arbitrate, M#mb.id}) || M <- Members, lib_team:is_fake_mb(M)],
            StateAfArbResult = arbitrate_result(StateAfFakeAgree, {vote, RoleId, 1});
        false ->
            {ErrorCodeInt2, ErrorCodeArgs2} = util:parse_error_code(TvErrorCode),
            {ok, BinData2} = pt_240:write(24038, [ErrorCodeInt2, ErrorCodeArgs2]),
            lib_team:send_team(NewState2, BinData2, RoleId),
            StateAfArbResult = NewState2
    end,
    % 系统消息 11017协议
    send_team_channel(StateAfArbResult, TvErrorCode),
    {ok, StateAfArbResult}.

%% 检查投票
%% @return {true, []} | {true, State, _Args} | {false, ErrorCode} | {false, ErrorCode, OtherErrorCode} | {my_false, OtherErrorCode, MyErrorCode}
%%  ErrorCode : integer() | {integer(), Args}
check_arbitrate_req(State, RoleId, _Node, ActivityId, SubTypeId) ->
    #team{leader_id = LeaderId, arbitrate_result_ref = ArbRef, dungeon = Dungeon, member = Mbs, is_matching = IsMatching, enlist = #team_enlist{activity_id = ActId, subtype_id = SubId, dun_id = DunId1} = EnList} = State,
    #team_dungeon{dun_pid = DunPid} = Dungeon,
    case data_dungeon:get(DunId1) of
        #dungeon{type = DunType} -> skip;
        _ -> DunType = 0
    end,
    IsAlivePid = misc:is_process_alive(DunPid),
    Cfg = data_team_ui:get(ActivityId, SubTypeId),
    SameTargetCheckList
    = if
        DunType == ?DUNGEON_TYPE_BEINGS_GATE; ActivityId == ActId, SubTypeId == SubId, DunType =/= ?DUNGEON_TYPE_WEEK_DUNGEON ->
            [{any_not_help, Mbs}];
        true ->
            []
    end,
    case check_arbitrate_req(
        SameTargetCheckList ++ [
            {is_leader, LeaderId == RoleId},
            {is_record, is_record(Cfg, team_enlist_cfg)},
            {repeat, ArbRef},
            {is_matching, IsMatching},
            {dunpid_alive, IsAlivePid},
            {all_online, Mbs},
            {safe_scene, Mbs},
            {same_cls, [ActId, SubId, ActivityId, SubTypeId]},
            {lock, Mbs}
        ]
    ) of
        true ->
            #team_enlist_cfg{module_id=Module, sub_module=SubModule, dun_id=DunId} = Cfg,
            NewDunId = lib_team_match:get_enlist_team_dun_id(ActivityId, SubTypeId, DunId),
            TargetEnList = EnList#team_enlist{activity_id=ActivityId, subtype_id=SubTypeId, dun_id=NewDunId,  module_id=Module, sub_module=SubModule},
            NewState = State#team{target_enlist = TargetEnList},
            % {true, NewState};
            %% 加上跨服支持后，先返回通过，再由各个玩家进程进行判断和扣除操作，然后再进行下一步
            case config:get_cls_type() of
                ?NODE_GAME ->
                    case lib_team_dungeon_mod:check_condition(NewState, []) of
                        {true, _} ->
                            {true, NewState};
                        OtherResult ->
                            OtherResult
                    end;
                _ ->
                    {true, NewState}
            end;
        Result ->
            Result
    end.

check_arbitrate_req([{repeat, ArbRef}|T]) ->
    if
        is_reference(ArbRef) -> {false, ?ERRCODE(err240_not_again_arbitrate_req)};
        true -> check_arbitrate_req(T)
    end;

check_arbitrate_req([{is_matching, IsMatching}|T]) ->
    if
        IsMatching =:= 1 -> {false, ?ERRCODE(err240_change_when_matching)};
        true -> check_arbitrate_req(T)
    end;

check_arbitrate_req([{dunpid_alive, IsAlivePid}|T]) ->
    if
        IsAlivePid -> {false, ?ERRCODE(err240_not_arbitrate_req_in_dungeon)};
        true -> check_arbitrate_req(T)
    end;

check_arbitrate_req([{is_leader, IsLeader}|T]) ->
    if
        not IsLeader -> {false, ?ERRCODE(err240_not_leader_to_arbitrate_req)};
        true -> check_arbitrate_req(T)
    end;

check_arbitrate_req([{is_record, Value}|T]) ->
    if
        Value ->
            check_arbitrate_req(T);
        true ->
            {false, ?ERRCODE(err_config)}
    end;

check_arbitrate_req([{any_not_help, Mbs}|T]) ->
    case lists:keyfind(?HELP_TYPE_NO, #mb.help_type, Mbs) of
        false ->
            {false, ?ERRCODE(err240_all_for_help_other)};
        _ ->
            check_arbitrate_req(T)
    end;
check_arbitrate_req([{all_online, Mbs}|T]) ->
    case ulists:find(fun
        (#mb{online = OL}) ->
            OL =/= ?ONLINE_ON
    end, Mbs) of
        {ok, #mb{figure = #figure{name = RoleName}}} ->
            {false, {?ERRCODE(err240_teammates_offline), [RoleName]}};
        _ ->
            check_arbitrate_req(T)
    end;
check_arbitrate_req([{safe_scene, Mbs}|T]) ->
    F = fun
        (#mb{scene = SceneId}) ->
            case data_scene:get(SceneId) of
                #ets_scene{type = Type} ->
                    Type =/= ?SCENE_TYPE_NORMAL andalso Type =/= ?SCENE_TYPE_OUTSIDE andalso Type =/= ?SCENE_TYPE_BEINGS_GATE; % andalso (not lib_jail:is_in_jail(SceneId));
                _ ->
                    true
            end
    end,
    CheckMbs = [Mb || #mb{is_fake = IsFake} = Mb <- Mbs, IsFake =/= 1],
    case ulists:find(F, CheckMbs) of
        {ok, #mb{figure = #figure{name = RoleName}}} ->
            {false, {?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon_by_other), [RoleName]}};
        _ ->
            check_arbitrate_req(T)
    end;

check_arbitrate_req([{lock, Mbs}|T]) ->
    F = fun
            (#mb{lock = Lock}) ->
                Lock =:= ?ERRCODE(err332_throw_mon_gaming)
        end,
    case ulists:find(F, Mbs) of
        {ok, #mb{figure = #figure{name = RoleName}}} ->
            {false, {?ERRCODE(err332_throw_mon_other_gaming), [RoleName]}};
        _ ->
            check_arbitrate_req(T)
    end;

check_arbitrate_req([{same_cls, [ActId, SubId, ActivityId, SubTypeId]}|T]) ->
    if
        ActId =:= ActivityId andalso SubId =:= SubTypeId ->
            check_arbitrate_req(T);
        true ->
            case lib_team:is_cls_target(ActId, SubId) =:= lib_team:is_cls_target(ActivityId, SubTypeId) of
                true ->
                    check_arbitrate_req(T);
                _ ->
                    {false, {?ERRCODE(err240_cls_type_error), [lib_team:get_target_name(ActivityId, SubTypeId)]}}
            end
    end;

check_arbitrate_req([]) ->
    true.

%% 处理发起仲裁
do_arbitrate_req(State, RoleId, _Node, Data) ->
    #team{arbitrate_result_ref = OldArbRef, arbitrate_result_op_ref = OldArbOpRef, arbitrate = Arbitrate, target_enlist = Enlist, member = Mbs} = State,
    #team_enlist{module_id = Module, sub_module = SubModule} = Enlist,
    LeftTime = data_team_m:get_arbitrate_time(Module, SubModule),
    ArbRef = util:send_after(OldArbRef, LeftTime*1000 + 2000, self(), {'arbitrate_result'}),
    ArbOpRef = util:send_after(OldArbOpRef, LeftTime*1000, self(), {'arbitrate_result_op_timeout'}),
    #team_arbitrate{id = ArbitrateId, agree_num = AgreeNum, vote_list = VoteList} = Arbitrate,
    NewArbitrateId = ArbitrateId+1, %% NewVoteList = [#vote_info{role_id = RoleId, res = 1}|VoteList],
    NewMbs = [if Mb#mb.id == RoleId -> Mb#mb{target_start_data = Data}; true -> Mb end || Mb <- Mbs],
    case NewMbs of
        [_] -> %% 只有队长一人
            NewVoteList = [#vote_info{role_id = RoleId, res = 1}|VoteList],
            NewAgreeNum = AgreeNum+1;
        _ ->
            NewVoteList = VoteList,
            NewAgreeNum = AgreeNum
    end,
    % 发起仲裁默认同意
    % NewVoteList = [#vote_info{role_id = RoleId, res = 1}|VoteList],
    % NewAgreeNum = AgreeNum+1,
    NewArbitrate = Arbitrate#team_arbitrate{id = NewArbitrateId, agree_num = NewAgreeNum, end_time = utime:unixtime()+LeftTime, vote_list = NewVoteList},
    State#team{arbitrate_result_ref = ArbRef, arbitrate_result_op_ref = ArbOpRef, arbitrate = NewArbitrate, member = NewMbs}.

%% 回应仲裁
arbitrate_res(State, RoleId, ArbitrateId, Res, Node) ->
    {Agree, _} = Res,
    case check_arbitrate_res(State, RoleId, ArbitrateId, Res, Node) of
        {false, MyErrorCode} ->
            % 先广播玩家投票,再广播投票结果
            {ok, RoleBinData} = pt_240:write(24036, [RoleId, ArbitrateId, 0]),
            lib_team:send_team(State, RoleBinData),
            NewState = do_arbitrate_res(State, RoleId, 0, Node, []),
            NewState2 = arbitrate_result(NewState, {vote, RoleId, 0});
        {false, OtherErrorCode, MyErrorCode} ->
            {ok, RoleBinData} = pt_240:write(24036, [RoleId, ArbitrateId, 0]),
            lib_team:send_team(State, RoleBinData),
            NewState = do_arbitrate_res(State, RoleId, 0, Node, {false, OtherErrorCode}),
            NewState2 = arbitrate_result(NewState, {vote, RoleId, 0});
        {ok, Data} ->
            MyErrorCode = ?SUCCESS,
            {ok, RoleBinData} = pt_240:write(24036, [RoleId, ArbitrateId, Agree]),
            lib_team:send_team(State, RoleBinData),
            NewState = do_arbitrate_res(State, RoleId, Agree, Node, Data),
            NewState2 = arbitrate_result(NewState, {vote, RoleId, Agree});
        vote_repeat ->
            MyErrorCode = ?ERRCODE(err240_arbitrate_vote_repeat),
            NewState2 = State
    end,
    % 是否归属于非安全区域的错误码
    SceneErrorCodeList = [?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon), ?ERRCODE(err610_not_on_enter_scene)],
    case lists:member(MyErrorCode, SceneErrorCodeList) of
        true ->
            #team{member = Mbs} = NewState2,
            case lists:keyfind(RoleId, #mb.id, Mbs) of
                false -> skip;
                #mb{figure = #figure{name = Name} } ->
                    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code({?ERRCODE(err240_agree_to_enter_safety_scene), [Name]}),
                    {ok, BinData} = pt_110:write(11017, [?CHAT_WINDOW_ONLY, ErrorCodeInt, ErrorCodeArgs]),
                    lib_team:send_team(NewState2, BinData)
            end;
        false ->
            {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(MyErrorCode),
            {ok, BinData} = pt_240:write(24021, [ErrorCodeInt, ErrorCodeArgs, Agree]),
            lib_team:send_to_uid(Node, RoleId, BinData)
            % ?PRINT("arbitrate_res RoleId:~p ErrorCodeInt:~p, ErrorCodeArgs:~w ~n", [RoleId, ErrorCodeInt, ErrorCodeArgs]),
            % case MyErrorCode == ?SUCCESS of
            %     true ->
            %         {ok, BinData3} = pt_240:write(24036, [RoleId, ArbitrateId, Agree]),
            %         lib_team:send_team(NewState2, BinData3);
            %     false ->
            %         skip
            % end
    end,
    {ok, NewState2}.

%% 检查回应
check_arbitrate_res(State, RoleId, OldArbitrateId, {_, ErrorCode}, _Node) ->
    #team{arbitrate_result_ref = ArbRef, arbitrate = Arbitrate} = State,
    #team_arbitrate{id = ArbitrateId, vote_list = VoteList} = Arbitrate,
    % #team_enlist{module_id = Module, sub_module = SubModule} = Enlist,
    if
        is_reference(ArbRef) == false -> {false, ?ERRCODE(err240_not_on_arbitrate_req_to_vote)};
        ArbitrateId =/= OldArbitrateId -> {false, ?ERRCODE(err240_not_current_aribirate_req)};
        true ->
            case lists:keyfind(RoleId, #vote_info.role_id, VoteList) of
                false ->
                    ErrorCode;
                _ ->
                    vote_repeat
            end
    end.

%% 处理回应仲裁
do_arbitrate_res(State, RoleId, Res, _Node, Data) ->
    #team{arbitrate = Arbitrate, member = Mbs} = State,
    #team_arbitrate{id = ArbitrateId, agree_num = AgreeNum, refuse_num = RefuseNum, vote_list = VoteList} = Arbitrate,
    NewArbitrateId = ArbitrateId,
    case Res == 1 of
        true -> NewAgreeNum = AgreeNum+1, NewRefuseNum = RefuseNum, Res1 = 1;
        false -> NewAgreeNum = AgreeNum, NewRefuseNum = RefuseNum+1, Res1 = 0
    end,
    NewVoteList = [#vote_info{role_id = RoleId, res = Res1}|VoteList],
    NewArbitrate = Arbitrate#team_arbitrate{id = NewArbitrateId, agree_num = NewAgreeNum, refuse_num = NewRefuseNum, vote_list = NewVoteList},
    NewMbs = [if
        Mb#mb.id == RoleId ->
            #mb{agree_ref = OldRef} = Mb,
            util:cancel_timer(OldRef),
            Mb#mb{agree_ref = none, target_start_data = Data};
        true -> Mb
    end || Mb <- Mbs],
    State#team{arbitrate = NewArbitrate, member = NewMbs}.

%% 仲裁结果
%% Args: timeout | {vote, RoleId, Res}
arbitrate_result(State, {vote, _RoleId, _}) ->
    #team{arbitrate = Arbitrate, member = Mbs} = State,
    #team_arbitrate{vote_list = VoteList} = Arbitrate,
    IsWithRefuse = lists:keymember(0, #vote_info.res, VoteList),
    % ?PRINT("arbitrate_result IsWithRefuse:~p IsOk:~p ~n", [IsWithRefuse, length(VoteList) == length(Mbs)]),
    if
        % 是否有拒绝
        IsWithRefuse ->
            NewState = arbitrate_result_common(State),
            #vote_info{role_id = RefuseRoleId} = lists:keyfind(0, #vote_info.res, VoteList),
            case lists:keyfind(RefuseRoleId, #mb.id, Mbs) of
                #mb{target_start_data = {false, ErrorCode}} -> ok;
                #mb{figure = #figure{name = Name}} -> ErrorCode = {?ERRCODE(err240_arbitrate_refuse), [Name]};
                _ -> Name = "", ErrorCode = {?ERRCODE(err240_arbitrate_refuse), [Name]}
            end,
            % ErrorCode = {?ERRCODE(err240_arbitrate_refuse), [Name]},
            arbitrate_result_fail(NewState, ErrorCode, RefuseRoleId);
        length(VoteList) == length(Mbs) ->
            % ?PRINT("arbitrate_result_success ErrorCode:~p ~n", [1]),
            NewState = arbitrate_result_common(State),
            arbitrate_result_success(NewState);
        true ->
            % ?PRINT("arbitrate_result_success ErrorCode:~p ~n", [no_match]),
            State
    end;

arbitrate_result(State, timeout) ->
    % #team{enlist = Enlist} = State,
    % #team_enlist{module_id = Module, sub_module = SubModule} = Enlist,
    if
        % (SubModule == 0 andalso (Module == ?MOD_DUNGEON_PENTACLE orelse
        %                 Module == ?MOD_DUNGEON_RISK orelse Module == ?MOD_DUNGEON_OBLIVION orelse Module == ?MOD_HUNTING))
        %                 orelse (SubModule == ?MOD_SUB_TASK_OUTDOOR andalso Module == ?MOD_TASK )->
        %     broadcast_arbitrate_timeout_success_msg(State),
        %     NewState = arbitrate_result_common(State),
        %     arbitrate_result_success(NewState);
        true ->
            NewState = arbitrate_result_common(State),
            arbitrate_result_fail(NewState, ?ERRCODE(err240_arbitrate_timeout))
    end.

%% 通用(仲裁取消)
arbitrate_result_common(State) ->
    % State1 = ?IF(ReturnCost, return_target_cost(State), State),
    #team{member = Members, arbitrate = Arbitrate, arbitrate_result_ref = ArbRef, arbitrate_result_op_ref = ArbOpRef} = State,
    #team_arbitrate{id = ArbitrateId, vote_list = VoteList} = Arbitrate,
    util:cancel_timer(ArbRef),
    util:cancel_timer(ArbOpRef),
    % 仲裁结束取消锁
    F = fun (Id) ->
        case lists:keyfind(Id, #vote_info.role_id, VoteList) of
            #vote_info{res = Res} ->
                Res =/= 0;
            _ ->
                false
        end
    end,
    [lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_player, break_action_lock, [?ERRCODE(err240_in_arbitrate)])
        || #mb{node = Node, id = RoleId} = Mb <- State#team.member, F(RoleId) andalso not lib_team:is_fake_mb(Mb)],
    NewArbitrate = Arbitrate#team_arbitrate{id = ArbitrateId, agree_num = 0, refuse_num = 0, vote_list = [], end_time = 0},
    MbsAfClearAgree = clear_members_agree_ref(Members),
    State#team{member = MbsAfClearAgree, arbitrate = NewArbitrate, arbitrate_result_ref = 0, arbitrate_result_op_ref = 0}.

%% 成功
%% @return #team{}
arbitrate_result_success(State) ->
    #team{target_enlist = #team_enlist{module_id = _Module, sub_module = _SubModule, dun_id = DunId}, member = Mbs} = State,
    % #team_enlist{module_id = Module, sub_module = SubModule } = Enlist,
    % ?PRINT("arbitrate_result_success Module:~p SubModule:~p ~n", [ActivityId]),
    % case lib_team_dungeon_mod:check_condition(State, [{cost, 1}]) of
    %     {false, ErrorCode} -> DungeonRoleList = [];
    %     {false, ErrorCode, _OtherErrorCode} -> DungeonRoleList = [];
    %     {true, DungeonRoleList} -> ErrorCode = ?SUCCESS
    % end,
    % ?PRINT("arbitrate_result_success ErrorCode:~p ~n", [ErrorCode]),
    if
        DunId > 0 ->
            DungeonRoleList = [Data#dungeon_role{location = Location} || #mb{target_start_data = Data, location = Location} <- Mbs, is_record(Data, dungeon_role)],
            case lib_team_dungeon_mod:check_team_for_enter_dun(DungeonRoleList, DunId) of
                true ->
                    lib_team_event:arbitrate_result_success(State, DungeonRoleList),
                    NewState = lib_team_dungeon_mod:enter_dungeon(State, DungeonRoleList),
                    ErrorCode = ?SUCCESS,
                    broadcast_arbitrate_result(State, ErrorCode);
                {false, ErrorCode} ->
                    broadcast_arbitrate_result(State, ErrorCode),
                    send_team_channel(State, ErrorCode),
                    NewState = State
            end;
            % case lists:any(fun(#dungeon_role{help_type = HelpType}) -> HelpType =:= ?HELP_TYPE_NO end, DungeonRoleList) of
            %     false ->
            %         NewState = State,
            %         ErrorCode = ?ERRCODE(err240_all_for_help_other);
            %     _ ->
            %         ErrorCode = ?SUCCESS,
            %         NewState = lib_team_dungeon_mod:enter_dungeon(State, DungeonRoleList)
            % end;
        true ->
%%            ErrorCode = ?SUCCESS,
%%            broadcast_arbitrate_result(State, ErrorCode),
%%            send_team_channel(State, ErrorCode),
            NewState = State
    end,
%%    broadcast_arbitrate_result(NewState, ErrorCode),
%%    send_team_channel(NewState, ErrorCode),
    NewState.

%% 失败
arbitrate_result_fail(State, ErrorCode) ->
    arbitrate_result_fail(State, ErrorCode, 0).
arbitrate_result_fail(State, ErrorCode, RefuseRoleId) ->
    broadcast_arbitrate_result(State, ErrorCode, RefuseRoleId),
    send_team_channel(State, ErrorCode),
    {ok, BinData} = pt_240:write(24040, []),
    lib_team:send_team(State, BinData),
    State.
    % State.

%% 广播仲裁的结果
broadcast_arbitrate_result(State, ErrorCode) ->
    broadcast_arbitrate_result(State, ErrorCode, 0).
%% 广播仲裁的结果
broadcast_arbitrate_result(State, ErrorCode, SkipId) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
    {ok, BinData} = pt_240:write(24037, [ErrorCodeInt, ErrorCodeArgs]),
    lib_team:send_team(State, BinData, SkipId),
    ok.

%% 广播超时成功的信息
broadcast_arbitrate_timeout_success_msg(_State) ->
%%    #team{arbitrate = Arbitrate, member = Mbs} = State,
%%    #team_arbitrate{id = ArbitrateId, vote_list = VoteList} = Arbitrate,
%%    F = fun(#mb{id = RoleId}) ->
%%        case lists:keymember(RoleId, #vote_info.role_id, VoteList) of
%%            true -> skip;
%%            false ->
%%                {ok, BinData} = pt_240:write(24036, [RoleId, ArbitrateId, 1]),
%%                lib_team:send_team(State, BinData)
%%        end
%%    end,
%%    lists:foreach(F, Mbs),
    ok.

%% 发送到聊天窗口
%% @return ok | skip
send_team_channel(State, ErrorCode) ->
    {ErrorCodeInt, ErrorCodeArgs} = util:parse_error_code(ErrorCode),
    BroadcastList = [
        ?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon_by_other)
        , ?ERRCODE(err610_not_enough_lv_to_enter_dungeon_by_other)
        , ?ERRCODE(err610_dungeon_count_daily_help_by_other)
        , ?ERRCODE(err610_dungeon_count_permanent_by_other)
        , ?ERRCODE(err610_dungeon_count_week_by_other)
        , ?ERRCODE(err610_dungeon_count_daily_by_other)
        , ?ERRCODE(err610_cannot_join_act_on_battle_with_name)
        , ?ERRCODE(err610_cannot_transfer_scene_on_fill_magic_with_name)
        , ?ERRCODE(err240_me_to_other)

        , ?ERRCODE(err240_not_enough_lv_to_enter_target_with_name)

        % , ?ERRCODE(err502_mb_lv_not_enough)?
        % , ?ERRCODE(err240_arbitrate_refuse)
    ],
    case lists:member(ErrorCodeInt, BroadcastList) of
        true ->
            ?PRINT("ErrorCodeInt:~p ~n", [ErrorCodeInt]),
            {ok, BinData} = pt_110:write(11017, [?CHAT_WINDOW_ONLY, ErrorCodeInt, ErrorCodeArgs]),
            lib_team:send_team(State, BinData),
            ok;
        false ->
            skip
    end.

%% 仲裁超时处理(比超时时间快2秒,目的是为了cast到玩家进程执行操作)
arbitrate_result_op_timeout(State) ->
    #team{arbitrate = Arbitrate, member = Members, id = TeamId, cls_type = ClsType, target_enlist = Enlist, arbitrate_result_op_ref = ArbOpRef} = State,
    #team_arbitrate{id = ArbitrateId, end_time = EndTime, vote_list = VoteList} = Arbitrate,
    #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId, scene_id = SceneId} = Enlist,
    Args = [TeamId, ActivityId, SubTypeId, SceneId, ArbitrateId, EndTime],
    VoteMembers = [Mb||#mb{id = RoleId}=Mb<-Members, not lists:keymember(RoleId, #vote_info.role_id, VoteList)],
    lib_team:members_apply_cast(ClsType, VoteMembers, ?APPLY_CAST_STATUS, lib_team, start_arbitrate_silent, [Args]),
    util:cancel_timer(ArbOpRef),
    MbsAfClearAgree = clear_members_agree_ref(Members),
    State#team{member = MbsAfClearAgree, arbitrate_result_op_ref = 0}.

%% 其他操作自动使仲裁结束
%% @return #team{}
auto_interrupt_arbitrate(State) ->
    case check_auto_interrput_arbitrate(State) of
        true ->
            NewState = arbitrate_result_common(State),
            {ok, BinData} = pt_110:write(11017, [?CHAT_WINDOW_ONLY, ?ERRCODE(err240_change_state_to_interrput_arbitrate), []]),
            lib_team:send_team(NewState, BinData),
            % 取消仲裁界面
            {ok, BinData2} = pt_240:write(24040, []),
            lib_team:send_team(NewState, BinData2),
            NewState;
        false ->
            State
    end.

check_auto_interrput_arbitrate(State) ->
    #team{arbitrate_result_ref = ArbRef, dungeon = Dungeon} = State,
    #team_dungeon{dun_pid = DunPid} = Dungeon,
    IsAlivePid = misc:is_process_alive(DunPid),
    if
        is_reference(ArbRef) == false -> false;
        IsAlivePid -> false;
        true -> true
    end.

%% ---------------------------------------------------------------------------
%% 检查函数
%% ---------------------------------------------------------------------------

% %% 检查是否能退出队伍
% %% @param QuitType 0普通|1离线
% check_quit_team(State, RoleId, QuitType) ->
%     #team{dungeon = Dungeon, member = MemberList} = State,
%     Mb = lists:keyfind(RoleId, #mb.id, MemberList),
%     #team_dungeon{dun_pid = DunPid} = Dungeon,
%     IsAlivePid = misc:is_process_alive(DunPid),
%     if
%         Mb =:= false -> {false, ?ERRCODE(err240_on_dungeon_not_to_do)};
%         % 在副本中无法普通退出副本
%         QuitType == 0 andalso IsAlivePid -> {false, ?ERRCODE(err240_on_dungeon_not_to_do)};
%         true -> true
%     end.

% %% 检查是否能踢出玩家
% %% @param KickId 被踢
% %% @param RoleId 踢人
% check_kick_out(State, KickId, RoleId) ->


%% 通用检查
%% @return true | {false, OtherErrorCode, MyErrorCode}
%%  OtherErrorCode, MyErrorCode :: is_integer()|{is_integer(), is_list()}
common_check(State) ->
    #team{member = Mbs} = State,
    do_common_check(Mbs, State).

do_common_check([], _State) -> true;
do_common_check([Mb|T], State) ->
    case common_check(State, Mb) of
        true -> do_common_check(T, State);
        Result -> Result
    end.

common_check(State, Mb) ->
    CheckList = [dungeon,lv,join_con_value],
    do_common_check(CheckList, State, Mb).

%% 重连数据处理
do_common_check([], _State, _Mb) -> true;
do_common_check([H|T], State, Mb) ->
    case common_check_help(H, State, Mb) of
        true -> do_common_check(T, State, Mb);
        {false, OtherErrorCode, MyErrorCode} -> {false, OtherErrorCode, MyErrorCode};
        {false, ErrorCode} ->   {false, ErrorCode, ErrorCode}
    end.

common_check_help(dungeon, #team{cls_type = ClsType} = State, Mb) when ClsType =:= ?NODE_CENTER ->
    #team{enlist = Enlist, member = Mbs} = State,
    #team_enlist{dun_id = DunId} = Enlist,
    case data_dungeon:get(DunId) of
        Dun when is_record(Dun, dungeon) ->
            lib_team_dungeon_mod:check_mbs_relationship(State#team{member = [Mb|Mbs]}, Dun);
        _ ->
            true
    end;

common_check_help(dungeon, State, Mb) ->
    #team{enlist = Enlist} = State,
    #team_enlist{dun_id = DunId} = Enlist,
    case data_dungeon:get(DunId) of
        [] -> true;
        Dun -> lib_team_dungeon_mod:check_dungeon_on_team(State, Mb, Dun)
    end;
common_check_help(lv, State, Mb) ->
    #team{lv_limit_min = Min, lv_limit_max = Max} = State,
    #mb{figure = #figure{lv = Lv, name = Name}} = Mb,
    if
        Lv < Min ->
            {false, {?ERRCODE(err240_not_enough_lv_to_enter_target_with_name), [Name]}, {?ERRCODE(player_lv_less), [Min]}};
        Max > 0 andalso Lv > Max ->
            {false, {?ERRCODE(err240_not_enough_lv_to_enter_target_with_name), [Name]}, {?ERRCODE(player_lv_large), [Max]}};
        true ->
            true
    end;
common_check_help(join_con_value, State, Mb) ->
    #team{enlist = Enlist, join_con_value = JoinConValue} = State,
    #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId} = Enlist,
    #mb{join_value_list = JoinValueList} = Mb,
    {_, JoinValue} = ulists:keyfind({ActivityId, SubTypeId}, 1, JoinValueList, {{ActivityId, SubTypeId}, 0}),
    if
        JoinConValue > 0 andalso JoinValue < JoinConValue ->
            {false, {?ERRCODE(err240_not_enough_join_value_to_enter_target_with_name), []}, {?ERRCODE(err240_no_qualification), []}};
        true ->
            true
    end.

%% ---------------------------------------------------------------------------
%% 数据处理
%% ---------------------------------------------------------------------------

%% 更新队伍信息
update_team_mb(State, RoleId, AttrList) ->
    #team{member=Mbs}=State,
    case lists:keyfind(RoleId, #mb.id, Mbs) of
        false -> {ok, State};
        Mb ->
            NewMb = do_update_team_mb(AttrList, Mb),
            NewMbs = lists:keyreplace(RoleId, #mb.id, Mbs, NewMb),
            % #mb{scene = SceneId, scene_pool_id = PoolId, copy_id = CopyId, figure = #figure{career = Career}} = NewMb,
            % RoleIdL = [TmpRoleId||#mb{
            %         id = TmpRoleId, scene = TmpSceneId, scene_pool_id = TmpPoolId, copy_id = TmpCopyId,
            %         figure = #figure{career = TmpCareer}
            %     }=TmpMb<-NewMbs,
            %     TmpRoleId=/=RoleId, TmpSceneId == SceneId, TmpPoolId == PoolId, TmpCopyId == CopyId, TmpCareer =/= Career, not lib_team:is_fake_mb(TmpMb)],
            % share_skill_list_to_scene(AttrList, RoleIdL, SceneId, PoolId),
            share_skill_list_to_scene(NewMbs, AttrList),
            NewState = State#team{member = NewMbs},
            lib_team:send_team_info(NewState),
            {ok, NewState}
    end.

%% 是否需要广播队伍信息
is_need_broadcast_team_info([]) -> false;
is_need_broadcast_team_info([{name, _Name}|_]) -> true;
is_need_broadcast_team_info([{lv, _Lv}|_]) -> true;
is_need_broadcast_team_info([_|L]) ->
    is_need_broadcast_team_info(L).

do_update_team_mb([], Mb) -> Mb;
do_update_team_mb([H|T], Mb) ->
    #mb{figure = Figure, task_map = TaskMap, share_skill_list = ShareSkillL} = Mb,
    case H of
        {name, Name} -> NewMb = Mb#mb{figure = Figure#figure{name = Name}};
        {lv, Lv} -> NewMb = Mb#mb{figure = Figure#figure{lv = Lv}};
        {power, Power} -> NewMb = Mb#mb{power = Power};
        {figure, NewFigure} -> NewMb = Mb#mb{figure = NewFigure};
        {task_id, TaskId, TaskState} ->
            TaskIdL = data_team_m:get_trigger_task_id_list(),
            case lists:member(TaskId, TaskIdL) of
                true when TaskState == ?TASK_STATE_TRIGGER -> NewTaskMap = maps:put(TaskId, TaskState, TaskMap);
                _ -> NewTaskMap = maps:remove(TaskId, TaskMap)
            end,
            NewMb = Mb#mb{task_map = NewTaskMap};
        {del_share_skill_list, _} ->
            NewMb = Mb#mb{share_skill_list = []};
        {add_share_skill_list, AddShareSkillL} ->
            F = fun({SkillId, SLv}, TSkills) -> lists:keystore(SkillId, 1, TSkills, {SkillId, SLv}) end,
            NewShareSkillL = lists:foldl(F, ShareSkillL, AddShareSkillL),
            NewMb = Mb#mb{share_skill_list = NewShareSkillL};
        _ ->
            NewMb = Mb
    end,
    do_update_team_mb(T, NewMb).

%% ---------------------------------------------------------------------------
%% 共享技能
%% ---------------------------------------------------------------------------

% %% 共享技能同步到其他玩家
% %% @param AttrList 队伍信息的kv列表(do_update_team_mb/2)
% share_skill_list_to_scene(AttrList, RoleIdL, _SceneId, _PoolId) when AttrList == [] orelse RoleIdL == [] -> ok;
% share_skill_list_to_scene([H|T], RoleIdL, SceneId, PoolId) ->
%     F = fun(RoleId) ->
%         case H of
%             {add_share_skill_list, AddShareSkillL} ->
%                 mod_scene_agent:update(SceneId, PoolId, RoleId, [{add_skill_passive_share, AddShareSkillL}]);
%             _ ->
%                 skip
%         end
%     end,
%     lists:foreach(F, RoleIdL),
%     share_skill_list_to_scene(T, RoleIdL, SceneId, PoolId).

%% 共享技能同步到其他玩家
share_skill_list_to_scene(Mbs, AttrList) ->
    IsMember = lists:keymember(add_share_skill_list, 1, AttrList),
    case IsMember of
        true -> share_skill_list(Mbs);
        false -> skip
    end.

%% 同步共享技能列表
share_skill_list(Mbs) ->
    RealMbs = [Mb||Mb<-Mbs, not lib_team:is_fake_mb(Mb)],
    share_skill_list(RealMbs, Mbs).

share_skill_list([], _Mbs) -> ok;
share_skill_list([H|T], Mbs) ->
    #mb{id = RoleId, node = Node, scene = SceneId, scene_pool_id = PoolId, copy_id = CoyId, share_skill_list = MyShareSkillL} = H,
    F = fun(TmpMb, List) ->
        #mb{
            id = TmpRoleId, scene = TmpSceneId, scene_pool_id = TmpPoolId, copy_id = TmpCopyId,
            share_skill_list = TmpShareSkillL
            } = TmpMb,
        case TmpRoleId == RoleId orelse {SceneId, PoolId, CoyId} =/= {TmpSceneId, TmpPoolId, TmpCopyId} of
            true -> List;
            false ->
                % 先过滤玩家身上的技能id
                F1 = fun({SkillId, _SLv}, TSkills) -> lists:keydelete(SkillId, 1, TSkills) end,
                AddShareSkillL = lists:foldl(F1, TmpShareSkillL, MyShareSkillL),
                % 塞进去保证唯一
                F2 = fun({SkillId, SLv}, TSkills) -> lists:keystore(SkillId, 1, TSkills, {SkillId, SLv}) end,
                lists:foldl(F2, List, AddShareSkillL)
        end
    end,
    SceneShareSkillL = lists:foldl(F, [], Mbs),
    % mod_scene_agent:update(SceneId, PoolId, RoleId, [{skill_passive_share, SceneShareSkillL}]),
    mod_scene_agent:update_skill_passive_share(SceneId, PoolId, Node, RoleId, MyShareSkillL, SceneShareSkillL),
    share_skill_list(T, Mbs).

%% ---------------------------------------------------------------------------
%% 其他函数
%% ---------------------------------------------------------------------------

%% 是否在副本中
is_on_dungeon(#team{dungeon = #team_dungeon{dun_pid = DunPid}}) ->
    misc:is_process_alive(DunPid).

% is_dun_tsmaps(#team{dungeon = #team_dungeon{dun_id = DunId}}) ->
%     case data_dungeon:get(DunId) of
%         #dungeon{type = ?DUNGEON_TYPE_TSMAP} ->
%             true;
%         _ ->
%             false
%     end.

%% 是否允许掉落
is_dungeon_allow_drop(State, Mb) ->
    #team{dungeon = #team_dungeon{dun_id = DunId}} = State,
    Dun = data_dungeon:get(DunId),
    IsOnDungeon = is_on_dungeon(State),
    #mb{help_type = HelpType} = Mb,
    if
        % 是否在副本中
        IsOnDungeon == false -> true;
        is_record(Dun, dungeon) == false -> true;
        % Dun#dungeon.type == ?DUNGEON_TYPE_TSMAP -> true;
        % 在副本中助战不能有奖励
        HelpType == ?HELP_TYPE_YES -> false;
        true -> true
    end.

check_team_matching_state(_State, _RoleId, 0) -> true;
check_team_matching_state(State, RoleId, MatchingState) ->
    #team{
        leader_id = LeaderId,
        is_matching = MatchingState0,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId},
        free_location = FreeLoaction,
        after_check = AfterCheck,
        member = Mbs
    } = State,
    case data_team_ui:get(ActivityId, SubTypeId) of
        #team_enlist_cfg{auto_pair = AutoPair, dun_id = DunId} ->
            ok;
        _ ->
            AutoPair = 0, DunId = 0
    end,
    NowTime = utime:unixtime(),
    case ulists:find(fun(#mb{online = OL}) -> OL =/= ?ONLINE_ON end, Mbs) of
        {ok, #mb{figure = #figure{name = RoleName}}} ->
            CheckOnline = {false, {?ERRCODE(err240_teammates_offline), [RoleName]}};
        _ ->
            CheckOnline = true
    end,
    if
        AutoPair =:= 0 ->
            {false, ?ERRCODE(err240_auto_pair_limit)};
        ActivityId =:= 1 ->
            {false, ?ERRCODE(err240_choose_target_first)};
        FreeLoaction =:= [] ->
            {false, ?ERRCODE(err240_max_member)};
        LeaderId =/= RoleId andalso MatchingState =:= 1 ->
            {false, ?ERRCODE(err240_not_leader)};
        MatchingState0 > 255 andalso NowTime - MatchingState0 < 5 ->
            {false, ?ERRCODE(operation_too_quickly)};
        CheckOnline =/= true ->
            CheckOnline;
        is_record(AfterCheck, after_check) andalso AfterCheck#after_check.pass == 1 ->
            true;
        DunId > 0 ->
            case lib_team_dungeon_mod:is_need_check_before_match(DunId) of
                true ->
                    after_check;
                _ ->
                    true
            end;
        true ->
            true
    end.

check_change_team_enlist(State, RoleId, ActivityId, SubTypeId, LvMin, LvMax) ->
    #team{cls_type = ClsType, leader_id = LeaderId, member = Members, is_matching = IsMatching, leader_node = LeaderNode} = State,
    Cfg = data_team_ui:get(ActivityId, SubTypeId),
    IsOnDungeon = lib_team_mod:is_on_dungeon(State),
    TargetClsType = case lib_team:is_cls_target(ActivityId, SubTypeId) of
        true -> ?NODE_CENTER;
        _ -> ?NODE_GAME
    end,
    NowTime = utime:unixtime(),
    DunId = case Cfg of
        #team_enlist_cfg{dun_id = V} -> V;
        _ -> 0
    end,
    MemberCheck = case Members of
        [_] -> true;
        _ -> lib_team_dungeon_mod:check_mbs_relationship(State, data_dungeon:get(DunId))
    end,

    if
        LeaderId =/= RoleId -> {false, ?ERRCODE(err240_not_leader)};
        IsMatching =:= 1 -> {false, ?ERRCODE(err240_change_when_matching)};
        IsMatching > 255 andalso NowTime - IsMatching < 5 -> {false, ?ERRCODE(err240_change_when_matching)};
        is_record(Cfg, team_enlist_cfg) == false -> {false, ?ERRCODE(err_config)};
        LvMax < LvMin -> {false, ?ERRCODE(err240_choose_lv_error)};
        Cfg#team_enlist_cfg.default_lv_min > LvMin -> {false, ?ERRCODE(err240_choose_lv_error)};
        Cfg#team_enlist_cfg.default_lv_max > 0 andalso Cfg#team_enlist_cfg.default_lv_max < LvMax ->
            {false, ?ERRCODE(err240_choose_lv_error)};
        Cfg#team_enlist_cfg.num < length(Members) ->
            {false, ?ERRCODE(err240_too_many_members)};
        IsOnDungeon -> {false, ?ERRCODE(err240_on_dungeon_not_to_do)};
        MemberCheck =/= true ->
            case MemberCheck of
                {false, _} ->
                    MemberCheck;
                {false, _, Code} ->
                    {false, Code}
            end;
        TargetClsType =/= ClsType -> %% 不同节点
            case TargetClsType =:= ?NODE_GAME andalso lists:any(fun
                (#mb{node = N}) ->
                    N =/= LeaderNode
            end, Members) of
                true ->
                    {false, ?ERRCODE(err240_local_team_with_other_serv)};
                _ ->
                    {take_over, TargetClsType}
                    % take_over({'change_team_enlist', RoleId, ActivityId, SubTypeId, SceneId, LvMin, LvMax}, Node, TargetClsType, State)
            end;
        true ->
            {true, Cfg}
    end.

change_team_enlist(State, Cfg, SceneId, LvMin, LvMax, JoinConValue) ->
    #team{id = TeamId, cls_type = ClsType, enlist = EnList, member = Members, max_num = MaxNum} = State,
    #team_enlist_cfg{activity_id = ActivityId, subtype_id = SubTypeId, module_id=Module, sub_module=SubModule, dun_id=DunId, num = MaxMemberNum} = Cfg,
    NewEnList = EnList#team_enlist{activity_id=ActivityId, subtype_id=SubTypeId, dun_id=DunId, scene_id=SceneId, module_id=Module, sub_module=SubModule},
    StateAfInterrupt = lib_team_mod:auto_interrupt_arbitrate(State),
    mod_team_enlist:change_team(ClsType, TeamId, [{enlist, EnList, NewEnList}, {lv, LvMin, LvMax}, {join_con_value, JoinConValue}]),
    [lib_player:apply_cast(MNode, Id, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, change_team_enlist, [TeamId, NewEnList, HelpType])||#mb{id = Id, help_type = HelpType, node = MNode}<-Members],
    % case Cfg#team_enlist_cfg.subtype_name == [] of
    %     true-> Target = Cfg#team_enlist_cfg.activity_name;
    %     false-> Target = Cfg#team_enlist_cfg.subtype_name
    % end,
    % lib_chat:send_TV({team, TeamId}, 240, 7, [Target]),
    TmpState = delay_notify_teammates_update(StateAfInterrupt),
    TmpState1
    = if
        MaxNum =/= MaxMemberNum ->
            {NewMemberList, NewFreeLocation} = lib_team:calc_location(Members, MaxMemberNum),
            TmpState#team{member = NewMemberList, free_location = NewFreeLocation};
        true ->
            TmpState
    end,
    TmpState1#team{enlist=NewEnList, lv_limit_min = LvMin, lv_limit_max = LvMax, join_con_value = JoinConValue, max_num = MaxMemberNum, after_check = undefined}.

delay_notify_teammates_update(State) ->
    #team{delay_update_ref = Ref} = State,
    if
        is_reference(Ref) -> State;
%%        ClsType =:= ?NODE_CENTER -> State;
        true ->
            Ref1 = erlang:send_after(2000, self(), 'notify_teammates_update'),
            State#team{delay_update_ref = Ref1}
    end.

set_team_matching_state(State, 0) ->
    #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId} = State#team.enlist,
    case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, team_set_match_state, 2) of
        undefined ->
            Code = ?SUCCESS,
            mod_team_enlist:change_team(State#team.cls_type, State#team.id, [{matching, 0}]),
            util:cancel_timer(State#team.fake_mb_ref),
            lib_team:members_apply_cast(State#team.cls_type, State#team.member, ?APPLY_CAST_STATUS, lib_player, break_action_lock, [?ERRCODE(err240_change_when_matching)]),
            NewState = State#team{is_matching = 0, match_st = 0, fake_mb_ref = undefined},
            {Code, NewState};
        Mod ->
            Mod:team_set_match_state(State, 0)
    end;

set_team_matching_state(State, MatchingState) ->
    #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId} = State#team.enlist,
    case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, team_set_match_state, 2) of
        undefined ->
            #team{id = TeamId, cls_type = ClsType} = State,
            Code = ?SUCCESS,
            mod_team_enlist:change_team(ClsType, TeamId, [{matching, MatchingState}]),
            StateAfUp = State#team{is_matching = MatchingState, match_st = utime:unixtime()},
            NewState
                = case lib_team_match:try_match_fake_mb(StateAfUp) of
                      {ok, S} -> S;
                      _ -> StateAfUp
                  end,
            lib_team:members_apply_cast(State#team.cls_type, State#team.member, ?APPLY_CAST_STATUS, lib_player, setup_action_lock, [?ERRCODE(err240_change_when_matching)]),
            {Code, NewState};
        Mod ->
            Mod:team_set_match_state(State, MatchingState)
    end.

interrupt_special_match(#team{is_matching = 0} = State) -> State;
interrupt_special_match(State) ->
    #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}} = State,
    case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, team_set_match_state, 2) of
        undefined ->
            State;
        Mod ->
            {Code, NewState} = Mod:team_set_match_state(State, 0),
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 0, 0, ActivityId, SubTypeId, 0]),
            lib_team:send_team(NewState, BinData),
            NewState
    end.

%% 更新玩家属性
set_member_attr(State, Node, MemberId, TeamMemberType, TeamId) ->
    #team{id = TId, cls_type=ClsType, dungeon=#team_dungeon{dun_pid=DunPid}} = State,
    mod_team:cast_to_game(ClsType, Node, lib_player, update_player_info, [MemberId, [{team_flag, {TId, TeamMemberType, TeamId} }]]),
    if
        is_pid(DunPid) ->
            lib_dungeon_api:set_member_attr(ClsType, DunPid, MemberId, TeamMemberType);
        true ->
            ok
    end.

%% 操作某一个方法时,回调到玩家进程判断是否有执行和通过
check_members_before_dosth(State, Sth, Args) ->
    #team{member = Members, enlist = Enlist, after_check = AfterCheck, id = TeamId, pid = TeamPid} = State,
    CheckId =
        case AfterCheck of
            #after_check{what2do = Sth} ->
                0;
            #after_check{id = Id} ->
                Id + 1;
            _ ->
                1
        end,
    if
        CheckId == 0 ->
            State;
        true ->
            TimeoutRef = erlang:send_after(5000, TeamPid, {check_for_sth_timeout, CheckId}),
            NewAfterCheck = #after_check{id = CheckId, what2do = Sth, timeout_ref = TimeoutRef, args = Args},
            [
                lib_player:apply_cast(
                    Node,
                    RoleId,
                    ?APPLY_CAST_STATUS,
                    ?NOT_HAND_OFFLINE,
                    lib_team,
                    check_for_sth,
                    [TeamId, Enlist, Sth, CheckId]
                )
                || #mb{node = Node, id = RoleId} = Mb <- Members, not lib_team:is_fake_mb(Mb)],
            State#team{after_check = NewAfterCheck}
    end.

%% 检查操作返回
handle_check_sth_respond(State, RoleId, Res) ->
    #team{member = Members, after_check = AfterCheck} = State,
    case lists:keyfind(RoleId, #mb.id, Members) of
        false ->
            State;
        _Mb ->
            if
                Res == true ->
                    #after_check{ready_list = ReadyList} = AfterCheck,
                    NewReadyList = [RoleId|ReadyList],
                    NewState = State#team{after_check = AfterCheck#after_check{ready_list = NewReadyList}},
                    case lists:all(fun (#mb{id = Id} = Mb) -> lib_team:is_fake_mb(Mb) orelse lists:member(Id, NewReadyList) end, Members) of
                        true ->
                            check_for_sth_success(NewState);
                        false ->
                            NewState
                    end;
                true ->
                    check_for_sth_fail(State, RoleId, Res)
            end
    end.

check_for_sth_fail(State, RoleId, Reason) ->
    util:cancel_timer(State#team.after_check#after_check.timeout_ref),
    {false, OtherCode, Code} = Reason,
    lib_team:send_error(State, RoleId, Code, OtherCode),
    State#team{after_check = undefined}.

%% 所有玩家检查成功
check_for_sth_success(State) ->
    #team{after_check = AfterCheck} = State,
    #after_check{what2do = What2Do, args = Args, timeout_ref = Ref} = AfterCheck,
    util:cancel_timer(Ref),
    NewState = handle_after_check(State, What2Do, Args),
%%    todo,
    NewState#team{after_check = AfterCheck#after_check{pass = 1}}.

handle_after_check(#team{is_matching = 0} = State, set_matching_state, _) ->
    {Code, NewState} = lib_team_mod:set_team_matching_state(State, 1),
    if
        Code =:= skip ->
            skip;
        true ->
            #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}, leader_id = LeaderId, match_st = MatchSt} = NewState,
            {CodeInt, CodeArgs} = util:parse_error_code(Code),
            {ok, BinData} = pt_240:write(24048, [CodeInt, CodeArgs, 1, MatchSt, ActivityId, SubTypeId, LeaderId]),
            lib_team:send_team(NewState, BinData)
    end,
    NewState;

handle_after_check(State, send_invite_tv, [Node, RoleId, MinLv, MaxLv]) ->
    send_invite_tv(State, Node, RoleId, MinLv, MaxLv),
    State;

handle_after_check(State, lock_and_start, _) ->
    #team{enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}, member = Members} = State,
    lock_and_wait_for_start(Members, ActivityId, SubTypeId),
    State;

handle_after_check(State, _, _) ->
    State.

%% 锁住状态、发送准备开始投票时间、定时自动投票
lock_and_wait_for_start(Members, ActivityId, SubTypeId) ->
    Delay = 1,% 5,
    BeginTime = utime:unixtime() + Delay,
    [lib_player:apply_cast(Node, RoleId, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, lock_for_start, [BeginTime]) || #mb{node = Node, id = RoleId} = Mb <- Members, lib_team:is_fake_mb(Mb) == false],
    erlang:send_after(Delay * 1000, self(), {auto_start_vote, ActivityId, SubTypeId}).

send_invite_tv(State, Node, RoleId, MinLv, MaxLv) ->
    #team{
        id = TeamId,
        member = Members,
        free_location = FreeLocation,
        cls_type = ClsType,
        enlist = #team_enlist{activity_id = ActivityId, subtype_id = SubTypeId}
    } = State,
    case FreeLocation of
        [] ->
            {ok, BinData} = pt_240:write(24030, [?ERRCODE(err240_max_member)]),
            lib_team:send_to_uid(Node, RoleId, BinData);
        _ ->
            case lists:keyfind(RoleId, #mb.id, Members) of
                false ->
                    {ok, BinData} = pt_240:write(24030, [?ERRCODE(err240_self_out_team)]),
                    lib_team:send_to_uid(Node, RoleId, BinData);
                #mb{figure = #figure{name = Name}} ->
                    {ok, BinData} = pt_240:write(24055, []),
                    lib_team:send_to_uid(Node, RoleId, BinData),
                    % Count = length(Members), MaxCount = Count + length(FreeLocation),
                    TargetName = data_team_ui:get_target_name(ActivityId, SubTypeId),
                    % case data_team_ui:get(ActivityId, SubTypeId) of
                    %     #team_enlist_cfg{default_lv_min = LvMin, default_lv_max = LvMax} -> ok;
                    %     _ -> LvMin = 1, LvMax = 999
                    % end,
                    if
                        MinLv > ?AWAKENING_LV andalso MaxLv >= ?MAX_LV ->
                            ShowMinLv = MinLv - ?AWAKENING_LV,
                            ShowMaxLv = MaxLv,
                            TvId = 11;
                        MinLv > ?AWAKENING_LV andalso MaxLv < ?MAX_LV ->
                            ShowMinLv = MinLv - ?AWAKENING_LV,
                            ShowMaxLv = MaxLv - ?AWAKENING_LV,
                            TvId = 8;
                        MinLv =< ?AWAKENING_LV andalso MaxLv < ?MAX_LV ->
                            ShowMinLv = MinLv,
                            ShowMaxLv = MaxLv - ?AWAKENING_LV,
                            TvId = 12;
                        true ->
                            ShowMinLv = MinLv,
                            ShowMaxLv = MaxLv,
                            TvId = 9
                    end,
                    TvArgs = [Name, TargetName, ShowMinLv, ShowMaxLv, TeamId, ActivityId, SubTypeId],
                    case ClsType of
                        ?NODE_GAME ->
                            lib_chat:send_TV({all}, ?MOD_TEAM, TvId, TvArgs);
                        _ ->
                            mod_clusters_center:apply_cast(Node, lib_chat, send_TV, [{all}, ?MOD_TEAM, TvId, TvArgs])
                    end
            end
    end.

handle_team_member_full(State) ->
    #team{id=TeamId, cls_type=ClsType, fake_mb_ref = Ref, is_matching = IsMatching} = State,
    if
        IsMatching =:= 1 ->
            mod_team_enlist:change_team(ClsType, TeamId, [{matching, 0}]),
            TmpState
                = case lib_team:handle_match_complete(State) of
                      {ok, S} ->
                          util:cancel_timer(Ref),
                          S#team{is_matching = 0};
                      _ ->
                          util:cancel_timer(Ref),
                          State#team{is_matching = 0}
                  end;
        true ->
            TmpState = State
    end,
    try_auto_start(TmpState).

try_auto_start(State) ->
    #team{auto_type = AutoType, enlist = EnList, after_check = AfterCheck, member = MemberList} = State,
    if
        AutoType == 1 ->
            case EnList of
                #team_enlist{dun_id = DunId, activity_id = ActivityId, subtype_id = SubTypeId} when DunId > 0 ->
                    case AfterCheck of
                        #after_check{pass = 1} ->
                            lib_team_mod:lock_and_wait_for_start(MemberList, ActivityId, SubTypeId),
                            NewState = State;
                        _ -> NewState = lib_team_mod:check_members_before_dosth(State, lock_and_start, [])
                    end;
                _ -> NewState = State
            end,
            NewState;
        true -> State
    end.

%% 清理玩家同意定时器
clear_members_agree_ref(Members) ->
    [begin
        util:cancel_timer(OldRef),
        Mb#mb{agree_ref = none}
    end||#mb{agree_ref = OldRef}=Mb <- Members].
