%% ---------------------------------------------------------------------------
%% @doc mod_team
%% @author ming_up@foxmail.com
%% @since  2016-11-01
%% @deprecated 组队进程模块
%% ---------------------------------------------------------------------------

-module(mod_team).
-behaviour(gen_server).

-export([start/1, cast_to_team/2, cast_to_team/3, cast_to_game/5, call_to_team/2, stop/1]).
-export([init/1, handle_call/3, handle_cast/2, 
         handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("team.hrl").
-include("predefine.hrl").
-include("errcode.hrl").

%% --------------------------------- 公共函数 ----------------------------------
start(Args) ->
    gen_server:start(?MODULE, Args, []).

cast_to_team(0, _Msg) ->
    ok;
cast_to_team(TeamId, Msg) when is_integer(TeamId)-> 
    % ?PRINT("cast_to_team ~p ~p~n", [TeamId, Msg]),
    IsCenter = config:get_cls_type() == ?NODE_CENTER,
    case TeamId rem 2 of %% 偶数为跨服队伍
        0 when not IsCenter -> 
            Node = mod_disperse:get_clusters_node(),
            mod_clusters_node:apply_cast(mod_team, cast_to_team, [Node, TeamId, Msg]);
        _ -> 
            cast_to_team(undefined, TeamId, Msg)
    end;

cast_to_team(TeamPid, Msg) when is_pid(TeamPid) ->
    gen_server:cast(TeamPid, {node(), Msg}).

cast_to_team(Node, TeamId, Msg) -> 
    case ets:lookup(?ETS_TEAM, TeamId) of
        [#ets_team{pid=Pid}|_] -> gen_server:cast(Pid, {Node, Msg});
        _ ->
            if
                Node =/= undefined ->
                    unode:apply(Node, lib_team, respond_team_disappear, [Msg]);                    
                true ->
                    lib_team:respond_team_disappear(Msg)
            end, 
            false
    end.

%% 同一节点请求队伍数据
call_to_team(TeamId, Msg) -> 
    case ets:lookup(?ETS_TEAM, TeamId) of
        [#ets_team{pid=Pid}|_] -> gen_server:call(Pid, Msg);
        _ -> false
    end.

stop(TeamPid) ->
    gen_server:cast(TeamPid, stop).

cast_to_game(?NODE_CENTER, SerIdOrNode, M, F, A) -> mod_clusters_center:apply_cast(SerIdOrNode, M, F, A);
cast_to_game(_, _, M, F, A) -> apply(M,F,A).

%% --------------------------------- 内部函数 ----------------------------------
%% 启动服务器.
init([TeamId, CreateType, ActivityId, SubTypeId, _SceneId, _TeamName, JoinType, _IsInvite, [LeaderInfo|_]=Mbs, Args]) ->
    case data_team_ui:get(ActivityId, SubTypeId) of
        [] -> Module = 0, SubModule = 0, DunId = 0, SceneId = 0, LvMin = 0, LvMax = 0, TeamMemberMax = ?TEAM_MEMBER_MAX;
        #team_enlist_cfg{module_id=Module, sub_module=SubModule, dun_id = DunId, scene_id = SceneId,
                         default_lv_min = LvMin, default_lv_max = LvMax, num = TeamMemberMax} -> ok
    end,
    Enlist = #team_enlist{activity_id=ActivityId, subtype_id=SubTypeId, module_id=Module, sub_module=SubModule, scene_id=SceneId, dun_id = DunId},
    ClsType = case TeamId rem 2 of 0 -> ?NODE_CENTER; _ -> ?NODE_GAME end,
    HisTeammate = [RoleId||#mb{id=RoleId}<-Mbs],
    {NewMemberList, FreeLocations} = lib_team:calc_location(Mbs, TeamMemberMax),
    % MemberListAfHelp = lib_team_mod:auto_trans_help_type(NewMemberList, Enlist, ?HELP_TYPE_TRANS_ANY),
    % 默认不自动同意
    case lists:member(JoinType, ?TEAM_JOIN_TYPE_TYPE_LIST) of
        true -> NewJoinType = JoinType;
        false -> NewJoinType = ?TEAM_JOIN_TYPE_NO
    end,
    AutoType = lib_team_match:get_team_auto_type(ActivityId, SubTypeId),
    State = #team{
        id = TeamId,
        pid = self(),
        cls_type = ClsType,
        leader_id = LeaderInfo#mb.id,
        leader_node = LeaderInfo#mb.node,
        member = NewMemberList,
        free_location = FreeLocations,
        join_type = NewJoinType,
        enlist = Enlist,
        arbitrate = #team_arbitrate{},
        dungeon = #team_dungeon{},
        his_teammate = HisTeammate,
        lv_limit_max = LvMax,
        lv_limit_min = LvMin,
        max_num = TeamMemberMax,
        auto_type = AutoType,
        after_check = #after_check{pass = 1}, %% 目前能进队的都是判断通过了的
        delay_update_ref = if ClsType =:= ?NODE_GAME -> erlang:send_after(2000, self(), 'notify_teammates_update'); true -> undefined end
    },
    NewState = init_team_args(Args, State),
    OrderTeamId
    = case CreateType of
        {?CREATE_TYPE_TAKE_OVER, OldTeamId} ->
            OldTeamId;
        _ ->
            TeamId
    end,
    lib_team:send_team_info(NewState),
    F1 = fun(EMb) ->
        TeamPosition = case EMb#mb.id == LeaderInfo#mb.id of
            true -> ?TEAM_LEADER;
            _ -> ?TEAM_MEMBER
        end,
        cast_to_game(ClsType, EMb#mb.node, lib_player, update_player_info, [EMb#mb.id, [{team_flag, {OrderTeamId, TeamPosition, TeamId}}]]),
        lib_player:apply_cast(EMb#mb.node, EMb#mb.id, ?APPLY_CAST_STATUS, ?NOT_HAND_OFFLINE, lib_team, update_help_type, [DunId, TeamId, EMb#mb.help_type])
    end,
    lists:map(F1, NewMemberList),
    lib_team:update_ets_team(NewState),
    mod_team_enlist:add_team(ClsType, TeamId, ActivityId, SubTypeId, SceneId, 1, LeaderInfo#mb.id, 
        [{lv, LvMin, LvMax},{mbs, NewMemberList}, {join_type, NewJoinType}, {join_con_value, NewState#team.join_con_value}]),
    % ?PRINT("create_team ~p~n", [TeamId]),
    NewState1
    = case CreateType of
        {?CREATE_TYPE_TAKE_OVER, _} ->
            {take_over, Info} = lists:keyfind(take_over, 1, Args),
            take_over_team(NewState, Info);
        _ ->
            NewState
    end,
    {ok, NewState1}.

%% 同步消息处理.
handle_call(Event, From, Status) ->
    mod_team_call:handle_call(Event, From, Status).

%% 异步消息处理.
handle_cast(Event, Status) ->
    #team{waiting_status = WaitingStatus} = Status,
    if
        is_record(WaitingStatus, waiting_status) ->
            MsgList = [{cast, Event}|WaitingStatus#waiting_status.msg_list],
            NowTime = utime:unixtime(),
            if
                NowTime - WaitingStatus#waiting_status.time < 5 ->
                    {noreply, Status#team{waiting_status = WaitingStatus#waiting_status{msg_list = MsgList}}};
                true ->
                    lib_team:handle_message(Status#team{waiting_status = []}, lists:reverse(MsgList))
            end;
        true ->
            mod_team_cast:handle_cast(Event, Status)
    end.

handle_info({ignore_waiting, Info}, Status) ->
    mod_team_info:handle_info(Info, Status);

%% handle_info信息处理
handle_info(Info, Status) ->
    #team{waiting_status = WaitingStatus} = Status,
    if
        is_record(WaitingStatus, waiting_status) ->
            MsgList = [{info, Info}|WaitingStatus#waiting_status.msg_list],
            NowTime = utime:unixtime(),
            if
                NowTime - WaitingStatus#waiting_status.time < 5 ->
                    {noreply, Status#team{waiting_status = WaitingStatus#waiting_status{msg_list = MsgList}}};
                true ->
                    lib_team:handle_message(Status#team{waiting_status = []}, lists:reverse(MsgList))
            end;
        true ->
            mod_team_info:handle_info(Info, Status)
    end.

%% 服务器停止.
terminate(_R, State) ->
    #team{id=TeamId, cls_type=ClsType, is_matching = MatchingState,
          enlist=#team_enlist{activity_id=ActivityId, subtype_id=SubTypeId, scene_id=SceneId},  member = MemberList} = State,
    lib_team:delete_ets_team(TeamId),
    [
        begin
            %%通知客户端
            {ok, BinData2} = pt_240:write(24005, [?SUCCESS]),
            lib_team:send_to_uid(Mb#mb.node, Mb#mb.id, BinData2),
            %%修改玩家数据
            cast_to_game(ClsType, Mb#mb.node, lib_player, update_player_info, [Mb#mb.id, [{team_flag, {TeamId, 0, 0}}]]),
            % 修改场景
            % mod_scene_agent:update(Mb#mb.scene, Mb#mb.scene_pool_id, Mb#mb.id, [{skill_passive_share, []}])
            mod_scene_agent:update_skill_passive_share(Mb#mb.scene, Mb#mb.scene_pool_id, Mb#mb.node, Mb#mb.id, Mb#mb.share_skill_list, [])
        end
        ||Mb<-MemberList, not lib_team:is_fake_mb(Mb)
    ],
    mod_team_enlist:delete_team(ClsType, TeamId, ActivityId, SubTypeId, SceneId),
    if
        MatchingState /= 0 ->
            case lib_team_match:get_special_api_mod(ActivityId, SubTypeId, team_set_match_state, 2) of
                undefined ->
                    skip;
                Mod ->
                    Mod:team_set_match_state(State, 0)
            end;
        true ->
            skip
    end,
    % ?PRINT("team terminate ~p~n", [[TeamId, _R]]),
    ok.

%% 热代码替换.
code_change(_OldVsn, State, _Extra)->
    {ok, State}.

init_team_args([{K, V}|T], State) -> 
    NewState = case K of
        name -> State#team{name=V};
        join_type -> State#team{join_type=V};
        is_invite -> State#team{is_allow_mem_invite=V};
        create_type -> State#team{create_type=V};
        %% bonfire_ids -> State#team{bonfire_ids=V};
        lv ->
            [Min, Max] = V,
            State#team{lv_limit_min = Min, lv_limit_max = Max};
        join_con_value ->
            State#team{join_con_value = V};
        take_over ->
            State
    end,
    init_team_args(T, NewState);
init_team_args([], State) -> State.

take_over_team(State, Info) ->
    [OldTeamPid, ToArgs, BackArgs] = Info,
    NewTeamPid = self(),
    #team{cls_type = ClsType, member = Mbs, id = TeamId} = State,
    lib_team:members_apply_cast(ClsType, Mbs, ?APPLY_CAST_STATUS, lib_team, team_is_took_over, [TeamId, NewTeamPid]),
    NewState = lib_team:take_over_team(State, ToArgs),
    OldTeamPid ! {ignore_waiting, {take_over_team_done, NewTeamPid, BackArgs}},
    NewState.
