%% ---------------------------------------------------------------------------
%% @doc lib_team_dungeon_mod.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-04-07
%% @deprecated 队伍进程的副本处理
%% ---------------------------------------------------------------------------
-module(lib_team_dungeon_mod).
-export([]).

-compile(export_all).

-include("team.hrl").
-include("dungeon.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("figure.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("scene.hrl").
-include("def_fun.hrl").

%% 检查队伍条件
%% @param Args [T,...] 参数检查和参数其他处理
%%  T:{no_check_scene_type_list, SceneTypeList} 是否检查场景条件
%% @return {true, DungeonRoleList(#dungeon_role{})} | {false, ErrorCode}
check_condition(State, Args) ->
    #team{member = Mbs, target_enlist = Enlist} = State,
    #team_enlist{dun_id = DunId} = Enlist,
    case data_dungeon:get(DunId) of
        [] -> {false, ?ERRCODE(err240_not_team_dungeon)};
        #dungeon{type = DunType, condition = Condition} = Dun ->
            CheckCond = check_dungeon_condition(Condition, Dun, State),
            CheckOpen = lib_dungeon_check:is_dungeon_open(Dun),
            if
                CheckCond =/= true -> CheckCond;
                CheckOpen =/= true -> CheckOpen;
                true ->
                    case check_mb_dungeon_condition(Mbs, DunId, Args, []) of
                        {true, DunRoles} ->
                            case DunType =/= ?DUNGEON_TYPE_WEEK_DUNGEON of
                                true ->
                                    case lists:any(fun(#dungeon_role{help_type = HelpType}) -> HelpType =:= ?HELP_TYPE_NO end, DunRoles) of
                                        false ->
                                            {false, ?ERRCODE(err240_all_for_help_other)};
                                        _ ->
                                            {true, DunRoles}
                                    end;
                                _ ->
                                    {true, DunRoles}
                            end;
                        Error ->
                            Error
                    end
            end
    end.

% %% 检查个人条件
check_condition(State, RoleId, Args) ->
    #team{member = Mbs, target_enlist = Enlist} = State,
    #team_enlist{dun_id = DunId} = Enlist,
    case data_dungeon:get(DunId) of
        [] -> {false, ?ERRCODE(err240_not_team_dungeon)};
        #dungeon{condition = Condition} = Dun ->
            CheckCond = check_dungeon_condition(Condition, Dun, State),
            CheckOpen = lib_dungeon_check:is_dungeon_open(Dun),
            if
                CheckCond =/= true -> CheckCond;
                CheckOpen =/= true -> CheckOpen;
                true ->
                    case lists:keyfind(RoleId, #mb.id, Mbs) of
                        false -> ?PRINT("check_condition #mb.id:~p", [RoleId]), {false, ?FAIL};
                        Mb -> check_mb_dungeon_condition([Mb], DunId, Args, [])
                    end
            end
    end.

% %% 检查副本条件
check_dungeon_condition([], _Dun, _State) -> true;
check_dungeon_condition([T|L], Dun, State) ->
    #team{member = Mbs} = State,
    case T of
        {num, Min, Max} ->
            Num = length(Mbs),
            if
                Num < Min ->
                    {false, ?ERRCODE(err610_dungeon_num_not_satisfy)};
                Num > Max ->
                    {false, {?ERRCODE(err610_too_many_members), [Max]}};
                true ->
                    check_dungeon_condition(L, Dun, State)
            end;
        {relationship, RelationShip} ->
            case check_relationship(Mbs, RelationShip) of
                true ->
                    check_dungeon_condition(L, Dun, State);
                Error ->
                    Error
            end;
        _ ->
            check_dungeon_condition(L, Dun, State)
    end.

check_relationship(Mbs, couple) ->
    case Mbs of
        [#mb{id = Id}, #mb{figure = #figure{lover_role_id = Id}}] ->
            true;
        [#mb{figure = #figure{sex = Sex1}},#mb{figure = #figure{sex = Sex2}}] when Sex2 =/= Sex1 ->
            true;
        _ ->
            {false, ?ERRCODE(err610_only_couple_enter)}
    end;

check_relationship(_Mbs, _) ->
    {false, ?ERRCODE(err610_dungeon_count_cfg_error)}.

check_mb_dungeon_condition([], _DunId, _Args, Result) ->
    {true, Result};
check_mb_dungeon_condition([Mb|Mbs], DunId, Args, Result) ->
    #mb{id = RoleId} = Mb,
    case lib_team:is_fake_mb(Mb) of
        false ->
            case lib_player:apply_call(RoleId, ?APPLY_CALL_STATUS, lib_dungeon_team, check_mb_dungeon_condition, [DunId, Args], 3000) of
                {ok, DungeonRole} -> check_mb_dungeon_condition(Mbs, DunId, Args, [DungeonRole|Result]);
                Error ->
                    consume_checked_roles(Result, DunId, Args),
                    case Error of
                        {false, ErrorCode} -> {false, ErrorCode};
                        {false, ErrorCode, ErrorCode2} -> {false, ErrorCode, ErrorCode2};
                        _Error -> ?ERR("check_mb_dungeon_condition _Error:~p", [_Error]), {false, ?FAIL}
                    end
            end;
        _ -> check_mb_dungeon_condition(Mbs, DunId, Args, Result)
    end.

%% 进入副本
enter_dungeon(State, []) ->
    State;
enter_dungeon(State, DungeonRoleList) ->
    #team{id = TeamId, target_enlist = Enlist, dungeon = TeamDungeon, member = Mbs, leader_id = LeaderId} = State,
    #team_enlist{dun_id = DunId} = Enlist,
    StartDunArgs = lib_dungeon:get_start_dun_args(State, data_dungeon:get(DunId)),
    Pid = mod_dungeon:start(TeamId, self(), DunId, DungeonRoleList, StartDunArgs),
    NewTeamDungeon = TeamDungeon#team_dungeon{dun_id = DunId, dun_pid = Pid},
    case [M || M <- Mbs, lib_team:is_fake_mb(M)] of
        [] ->
            ok;
        _ ->
            #dungeon_role{node = Node, id = RoleId}
            = case lists:keyfind(LeaderId, #dungeon_role.id, DungeonRoleList) of
                false ->
                    [H|_] = DungeonRoleList,
                    H;
                H -> H
            end,
            lib_player:apply_cast(Node, RoleId, ?APPLY_CALL_STATUS, ?NOT_HAND_OFFLINE, lib_dungeon_team, get_dummy_data_for_fake_mb, [TeamId])
    end,
    State#team{dungeon = NewTeamDungeon}.

%% 在队伍中检查副本条件(操作队伍的时候判断)
% @return true | {false, OtherErrorCode, MyErrorCode}
check_dungeon_on_team(State, Mb, Dun) ->
    #mb{id = RoleId, figure = Figure} = Mb,
    #team{member = Mbs} = State,
    case lib_dungeon_team:check_dungeon_on_team_help(RoleId, Figure, Dun) of
        true ->
            #dungeon{condition = Condition} = Dun,
            CheckConditions = [Item || Item <- Condition, lists:member(element(1, Item), [num, relationship])],
            check_dungeon_condition(CheckConditions, Dun, State#team{member = [Mb|Mbs]});
        Error ->
            Error
    end.

check_mbs_relationship(State, Dun) when is_record(Dun, dungeon) ->
    #dungeon{condition = Condition} = Dun,
    CheckConditions = [Item || Item <- Condition, lists:member(element(1, Item), [relationship])],
    check_dungeon_condition(CheckConditions, Dun, State);

check_mbs_relationship(_State, _) ->
    true.

consume_checked_roles(DunRoles, DunId, Args) ->
    case data_dungeon:get(DunId) of
        #dungeon{cost = [_|_] = Cost} ->
            case lists:keyfind(cost, 1, Args) of
                {cost, 1} ->
                    Rewards
                    = [begin
                        case G of
                            {GoodsId, Num} when is_integer(GoodsId) ->
                                {?TYPE_BIND_GOODS, GoodsId, Num};
                            _ -> G
                        end
                    end || G <- Cost],
                    [lib_goods_api:send_reward_by_id(Rewards, dungeon_check_fail_return, RoleId) || #dungeon_role{id = RoleId} <- DunRoles];
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

check_team_for_enter_dun(DungeonRoleList, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = ?DUNGEON_TYPE_WEEK_DUNGEON, condition = Conditions} ->
            do_check_team_for_enter_dun(Conditions, DungeonRoleList);
        #dungeon{type = ?DUNGEON_TYPE_BEINGS_GATE, condition = Conditions} ->
            do_check_team_for_enter_dun([{not_all_help, 1}, {portal}] ++ Conditions, DungeonRoleList);
        #dungeon{condition = Conditions} ->
            do_check_team_for_enter_dun([{not_all_help, 1}|Conditions], DungeonRoleList);
        _ ->
            {false, ?FAIL}
    end.

do_check_team_for_enter_dun([{num, Min, Max}|Conditions], DungeonRoleList) ->
    Num = length(DungeonRoleList),
    if
        Num < Min ->
            {false, ?ERRCODE(err610_dungeon_num_not_satisfy)};
        Num > Max ->
            {false, {?ERRCODE(err610_too_many_members), [Max]}};
        true ->
            do_check_team_for_enter_dun(Conditions, DungeonRoleList)
    end;

do_check_team_for_enter_dun([{relationship, couple}|Conditions], DungeonRoleList) ->
    case DungeonRoleList of
        [#dungeon_role{id = Id}, #dungeon_role{figure = #figure{lover_role_id = Id}}] ->
            do_check_team_for_enter_dun(Conditions, DungeonRoleList);
        [#dungeon_role{figure = #figure{sex = Sex1}},#dungeon_role{figure = #figure{sex = Sex2}}] when Sex2 =/= Sex1 ->
            do_check_team_for_enter_dun(Conditions, DungeonRoleList);
        _ ->
            {false, ?ERRCODE(err610_only_couple_enter)}
    end;

do_check_team_for_enter_dun([{not_all_help, 1}|Conditions], DungeonRoleList) ->
    case lists:any(fun(#dungeon_role{help_type = HelpType}) -> HelpType =:= ?HELP_TYPE_NO end, DungeonRoleList) of
        false ->
            {false, ?ERRCODE(err240_all_for_help_other)};
        _ ->
            do_check_team_for_enter_dun(Conditions, DungeonRoleList)
    end;

do_check_team_for_enter_dun([{portal}|Conditions], DungeonRoleList) ->
    #dungeon_role{portal_id = PortalId} = ulists:keyfind(?TEAM_LEADER, #dungeon_role.team_position, DungeonRoleList, #dungeon_role{}),
    Result = ?IF(util:is_cls(), mod_beings_gate_kf:is_exit_portal(PortalId), mod_beings_gate_local:is_exit_portal(PortalId)),
    case Result of
        false -> {false, ?ERRCODE(err241_no_portal_id)};
        _ -> do_check_team_for_enter_dun(Conditions, DungeonRoleList)
    end;

do_check_team_for_enter_dun([_|Conditions], DungeonRoleList) ->
    do_check_team_for_enter_dun(Conditions, DungeonRoleList);

do_check_team_for_enter_dun([], _) -> true.

%% 创建假人
create_dummy(#dungeon_state{load_status = ?DUN_NOT_LOAD, dummy_args_list = DummyList} = State, {Figures, BattleAttr, _SkillList, TeamId}) ->
    State#dungeon_state{dummy_args_list = [{Figures, BattleAttr, _SkillList, TeamId} | DummyList]};
create_dummy(State, {Figures, BattleAttr, _SkillList, TeamId}) ->
    #dungeon_state{now_scene_id = SceneId, scene_pool_id = ScenePoolId, dun_id = DunId, dun_type = DunType} = State,
    % [Figure, BattleAttr, SkillList] = DummyData,
    #ets_scene{x = X, y = Y} = data_scene:get(SceneId),
    Paths
    = case data_dungeon_special:get(DunId, dummy_path) of
        Data  when is_tuple(Data)-> tuple_to_list(Data);
        _ -> []
    end,
    BaseArgs = [{group, ?DUN_DEF_GROUP}, {find_target, 1500},{type, 1},{check_block, true},{revive_time, 5000},
        {warning_range, 1000}, {dummy, #scene_dummy{team_id = TeamId}}],
    F = fun
        ({SerId, SerNum, Figure, Location}, [Path|T]) ->
            #figure{career = Career, sex = Sex} = Figure,
            Skills = lib_skill_api:get_career_active_skill_default_lv_list(Career, Sex),
            {X1, Y1}  = get_xy_msg(DunType, DunId, Location, X, Y),
            Args = [{server_id, SerId}, {server_num, SerNum}, {skill, Skills}, {path, Path} | BaseArgs],
            lib_scene_object:async_create_a_dummy(SceneId, ScenePoolId, X1, Y1, self(), 1, Figure, BattleAttr, Args),
            case T of
                [] ->
                    [Path];
                _ ->
                    T
            end;
        ({SerId, SerNum, Figure, Location}, _) ->
            #figure{career = Career, sex = Sex} = Figure,
            Skills = lib_skill_api:get_career_active_skill_default_lv_list(Career, Sex),
            {X1, Y1}  = get_xy_msg(DunType, DunId, Location, X, Y),
            Args = [{server_id, SerId}, {server_num, SerNum}, {skill, Skills} | BaseArgs],
            lib_scene_object:async_create_a_dummy(SceneId, ScenePoolId, X1, Y1, self(), 1, Figure, BattleAttr, Args),
            []
    end,
    lists:foldl(F, Paths, Figures).

is_need_check_before_match(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = ?DUNGEON_TYPE_EQUIP} ->
            true;
        #dungeon{type = ?DUNGEON_TYPE_EXP} ->
            true;
        #dungeon{type = ?DUNGEON_TYPE_EVIL} ->
            true;
        _ ->
            false
    end.

%% -----------------------------------------------------------------
%% @desc     功能描述  在场景中的出生坐标
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_xy_msg(?DUNGEON_TYPE_DRAGON, _DunId, Location, X, Y) ->
    case data_dungeon_special:get(?DUNGEON_TYPE_DRAGON, scene_xy_list) of
        List when is_list(List) ->
            case lists:keyfind(Location, 1, List) of
                {Location, X1, Y1} ->
                    {X1, Y1};
                _ ->
                    {X, Y}
            end;
        _ ->
            {X, Y}
    end;
get_xy_msg(_DunType, _DunId, _Location, X, Y) ->
    {X, Y}.
