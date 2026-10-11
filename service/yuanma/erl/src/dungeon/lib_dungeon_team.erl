%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_team.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-04-07
%% @deprecated 副本队伍处理 pt_24020_[]
%% ---------------------------------------------------------------------------
-module(lib_dungeon_team).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("dungeon.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("errcode.hrl").
-include("team.hrl").
-include("common.hrl").
-include("predefine.hrl").
-include("skill.hrl").
-include("supreme_vip.hrl").

%% 检查副本的条件
%% @param Args 参数
%% {false, {ErrorCode, Args}(带名字), {ErrorCode2, Args2}(玩家自身的错误消息)} | {false, ErrorCode} | {ok, DungeonRole}
check_mb_dungeon_condition(Player, DunId, Args) ->
    IsOnDungeon = lib_dungeon:is_on_dungeon(Player),
    if
        IsOnDungeon -> {false, ?ERRCODE(err610_on_dungeon)};
        true ->
            Dun = data_dungeon:get(DunId),
            #dungeon{count_cond = CountCond, condition = Condition} = Dun,
            HelpType = get_help_type(Player, DunId),
            CheckList = [
                {fun lib_dungeon_check:is_exist_mutex/1, [Player]},
                {fun check_dungeon_condition/4, [Condition, Dun, Args, Player]},
                {fun check_dungeon_count_cond/4, [CountCond, Dun, HelpType, Player]},
                {fun check_extra/3, [Player, Dun, Args]}
            ],
            case check_all(CheckList) of
                true ->
                    case check_cost(Player, Dun, Args) of
                        true ->
                            Res = {ok, lib_dungeon:trans_to_dungeon_role(Player, Dun)};
                        _ ->
                            #player_status{figure = #figure{name = Name}} = Player,
                            CostName = lib_goods_api:get_first_object_name(Dun#dungeon.cost),
                            case Dun#dungeon.type of
                                ?DUNGEON_TYPE_EXP ->
                                    MyErrorCode = ?ERRCODE(err240_my_cost_error_exp);
                                _ ->
                                    MyErrorCode = {?ERRCODE(what_not_enough), [CostName]}
                            end,
                            Res = {
                                false,
                                {?ERRCODE(err240_me_to_other), [Name, util:make_error_code_msg({?ERRCODE(what_not_enough), [CostName]})]},
                                MyErrorCode
                            }
                    end,
                    Res;
                Res ->
                    Res
            end
        % CheckCountCond =/= true -> CheckCountCond;
        % CheckCondition =/= true -> CheckCondition;
        % CheckExtra =/= true -> CheckExtra;
        % true -> {true, lib_dungeon:trans_to_dungeon_role(Player, Dun)}
    end.

check_all([{F, A}|T]) ->
    case erlang:apply(F, A) of
        true ->
            check_all(T);
        Res ->
            Res
    end;

check_all([]) -> true.

%% 检查次数
check_dungeon_count_cond([], _Dun, _HelpType, _Player) -> true;
check_dungeon_count_cond([H|T], #dungeon{id = DunId, type = DunType} = Dun, HelpType, Player) ->
    #player_status{id = RoleId, figure = #figure{name = Name}} = Player,
    case H of
        {?DUN_COUNT_COND_DAILY, _} ->
            if
                HelpType == ?HELP_TYPE_NO ->
                    case lib_dungeon_check:check_daily_count(Player, Dun) of
                        {false, AllCountLimit} ->
%%                            ?ERR("{false, AllCountLimit} = ~p~n", [[RoleId,AllCountLimit]]),
                            {
                                false
                                , {?ERRCODE(err610_dungeon_count_daily_by_other), [Name, AllCountLimit]}
                                , {?ERRCODE(err610_dungeon_count_daily), [AllCountLimit]}
                            };
                        true ->
                            check_dungeon_count_cond(T, Dun, HelpType, Player)
                    end;
                % DunType =:= ?DUNGEON_TYPE_EQUIP andalso Position =:= ?TEAM_LEADER ->
                %     {
                %         false
                %         , {?ERRCODE(err610_dungeon_leader_help_type_limit), []}
                %         , {?ERRCODE(err610_dungeon_leader_help_type_limit), []}
                %     };
                true ->
                    check_dungeon_count_cond(T, Dun, HelpType, Player)
            end;
        {?DUN_COUNT_COND_WEEK, MaxNum} ->
            Num = mod_week:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
            case Num < MaxNum of
                true -> check_dungeon_count_cond(T, Dun, HelpType, Player);
                false ->
                    {
                        false
                        , {?ERRCODE(err610_dungeon_count_week_by_other), [Name, MaxNum]}
                        , {?ERRCODE(err610_dungeon_count_week), [MaxNum]}
                    }
            end;
        {?DUN_COUNT_COND_PERMANENT, MaxNum} ->
            Num = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
            case Num < MaxNum of
                true -> check_dungeon_count_cond(T, Dun, HelpType, Player);
                false ->
                    {
                        false
                        , {?ERRCODE(err610_dungeon_count_permanent_by_other), [Name, MaxNum]}
                        , {?ERRCODE(err610_dungeon_count_permanent), [MaxNum]}
                    }
            end;
        {?DUN_COUNT_COND_DAILY_HELP, MaxNum} ->
            if
                HelpType =:= ?HELP_TYPE_YES ->
                    CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
                    Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, CountType),
                    if
                        Num >= MaxNum ->
                            {
                                false
                                , {?ERRCODE(err610_dungeon_count_daily_help_by_other), [Name, MaxNum]}
                                , {?ERRCODE(err610_dungeon_count_daily_help), [MaxNum]}
                            };
                        true ->
                            check_dungeon_count_cond(T, Dun, HelpType, Player)
                    end;
                true ->
                    check_dungeon_count_cond(T, Dun, HelpType, Player)
            end;
        {?DUN_COUNT_COND_DAILY_REWARD, _MaxNum} ->
            check_dungeon_count_cond(T, Dun, HelpType, Player);
        _ ->
            {false, ?ERRCODE(err610_dungeon_count_cfg_error)}
    end.

%% 检查副本条件
check_dungeon_condition([], _Dun, _Args, _Player) -> true;
check_dungeon_condition([H|T], Dun, Args, Player) ->
    #player_status{figure = #figure{name = Name, lv = Lv}, scene = SceneId, id = RoleId} = Player,
    #dungeon{count_deduct = CountDeduct} = Dun,
    case lists:keyfind(no_check_scene_type_list, 1, Args) of
        false -> IsCheckScene = 1;
        {no_check_scene_type_list, NoCheckSceneTypeList} ->
            case data_scene:get(SceneId) of
                [] -> IsCheckScene = 1;
                #ets_scene{type = SceneType} ->
                    case lists:member(SceneType, NoCheckSceneTypeList) of
                        true -> IsCheckScene = 0;
                        false -> IsCheckScene = 1
                    end
            end
    end,
    case H of
        {num, _NumMin, _NumMax} ->
            check_dungeon_condition(T, Dun, Args, Player);
        {lv, NeedLv} ->
            case Lv >= NeedLv of
                true -> check_dungeon_condition(T, Dun, Args, Player);
                false ->
                    {
                    false
                    , {?ERRCODE(err610_not_enough_lv_to_enter_dungeon_by_other), [Name]}
                    , ?ERRCODE(err610_not_enough_lv_to_enter_dungeon)
                    }
            end;
        {safe_scene} when IsCheckScene == 1 ->
            case lib_dungeon_check:check_scene(Player, Dun, ?DUN_CREATE) of
                true ->
                    check_dungeon_condition(T, Dun, Args, Player);
                {false, ErrorCode} ->
                    {OtherErrorCode, MyErrorCode} = lib_dungeon:trans_error_code(ErrorCode, Player),
                    {false, OtherErrorCode, MyErrorCode}
            end;
        {enter_scene, _SceneIdList} when IsCheckScene == 1 ->
            case lib_dungeon_check:check_scene(Player, Dun, ?DUN_CREATE) of
                true ->
                    check_dungeon_condition(T, Dun, Args, Player);
                {false, ErrorCode} ->
                    {OtherErrorCode, MyErrorCode} = lib_dungeon:trans_error_code(ErrorCode, Player),
                    {false, OtherErrorCode, MyErrorCode}
            end;
        {enter_scene2, _SceneXyList} when IsCheckScene == 1 ->
            case lib_dungeon_check:check_scene(Player, Dun, ?DUN_CREATE) of
                true ->
                    check_dungeon_condition(T, Dun, Args, Player);
                {false, ErrorCode} ->
                    {OtherErrorCode, MyErrorCode} = lib_dungeon:trans_error_code(ErrorCode, Player),
                    {false, OtherErrorCode, MyErrorCode}
            end;
        {finish_dun_id, FinishDunId} ->
            SubModuleId = if CountDeduct =:= ?DUN_COUNT_DEDUCT_ENTER -> ?MOD_DUNGEON_ENTER; true -> ?MOD_DUNGEON_SUCCESS end,
            Count = mod_counter:get_count(RoleId, ?MOD_DUNGEON, SubModuleId, FinishDunId),
            case Count > 0 of
                true -> check_dungeon_condition(T, Dun, Args, Player);
                false -> {false, ?ERRCODE(err610_need_finish_dun_id)}
            end;
        _ ->
            check_dungeon_condition(T, Dun, Args, Player)
    end.

%% 检查额外
check_extra(Player, Dun, _Args) ->
    #dungeon{type = DunType} = Dun,
    if
        DunType == ?DUNGEON_TYPE_WEEK_DUNGEON ->
            lib_week_dungeon:dunex_check_extra(Player, Dun, _Args);
        true ->
            true
    end.
%     check_extra_help(Args, Player).

check_cost(Player, Dun, _Args) ->
    case Dun of
        #dungeon{cost = [_|_] = Cost} ->
            lib_goods_api:check_object_list(Player, Cost);
        _ ->
            true
    end.


%% 在队伍中检查副本条件(操作队伍的时候判断)
check_dungeon_on_team(Player, Dun) ->
    #player_status{id = RoleId, figure = Figure} = Player,
    check_dungeon_on_team_help(RoleId, Figure, Dun).

check_dungeon_on_team_help(RoleId, Figure, Dun) ->
    #dungeon{count_cond = CountCond, condition = Condition} = Dun,
    CheckCountCond = check_dungeon_count_cond_on_team(RoleId, Figure, Dun, CountCond),
    CheckCondition = check_dungeon_condition_on_team(Condition, RoleId, Figure),
    if
        CheckCountCond =/= true -> CheckCountCond;
        CheckCondition =/= true -> CheckCondition;
        true -> true
    end.

%% 在队伍中检查副本次数条件
check_dungeon_count_cond_on_team(RoleId, Figure, Dun, CountCond) ->
    #figure{name = Name} = Figure,
    #dungeon{id = DunId, type = DunType} = Dun,
    CountType = lib_dungeon_api:get_daily_count_type(DunType, DunId),
    case lists:keyfind(?DUN_COUNT_COND_DAILY, 1, CountCond) of
        false -> MaxNum = 16#FFFFFF;
        {_, MaxNum} -> ok
    end,
    case lists:keyfind(?DUN_COUNT_COND_DAILY_HELP, 1, CountCond) of
        false -> MaxHelpNum = 16#FFFFFF;
        {_, MaxHelpNum} -> ok
    end,
    Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, CountType),
    HelpCountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
    HelpNum = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, HelpCountType),
    NewCountCond = [{TmpType, TmpNum}||{TmpType, TmpNum}<-CountCond, lists:member(TmpType, [?DUN_COUNT_COND_DAILY, ?DUN_COUNT_COND_DAILY_HELP, ?DUN_COUNT_COND_DAILY_REWARD]) == false],
    if
        Num < MaxNum orelse HelpNum < MaxHelpNum -> do_check_dungeon_count_cond_on_team(NewCountCond, Dun, RoleId, Figure);
        Num >= MaxNum ->
            {
                false
                , {?ERRCODE(err610_have_no_count_to_enter_target_with_name), [Name]}
                , ?ERRCODE(err610_have_no_count_to_enter_target)
            };
        true ->
            {
                false
                , {?ERRCODE(err610_have_no_count_to_enter_target_with_name), [Name]}
                , ?ERRCODE(err610_have_no_count_to_enter_target)
            }
     end.

do_check_dungeon_count_cond_on_team([], _Dun, _RoleId, _Figure) -> true;
do_check_dungeon_count_cond_on_team([H|T], Dun, RoleId, Figure) ->
    #dungeon{id = DunId} = Dun,
    #figure{name = Name} = Figure,
    case H of
        {?DUN_COUNT_COND_WEEK, MaxNum} ->
            Num = mod_week:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
            case Num < MaxNum of
                true -> do_check_dungeon_count_cond_on_team(T, Dun, RoleId, Figure);
                false ->
                    {
                        false
                        , {?ERRCODE(err610_have_no_count_to_enter_target_with_name), [Name]}
                        , ?ERRCODE(err610_have_no_count_to_enter_target)
                    }
            end;
        {?DUN_COUNT_COND_PERMANENT, MaxNum} ->
            Num = mod_counter:get_count_offline(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
            case Num < MaxNum of
                true -> do_check_dungeon_count_cond_on_team(T, Dun, RoleId, Figure);
                false ->
                    {
                        false
                        , {?ERRCODE(err610_have_no_count_to_enter_target_with_name), [Name]}
                        , ?ERRCODE(err610_have_no_count_to_enter_target)
                    }
            end;
        _ ->
            {false, ?ERRCODE(err610_dungeon_count_cfg_error), ?ERRCODE(err610_dungeon_count_cfg_error)}
    end.

%% 在队伍中检查副本条件(操作队伍的时候判断)
%% @return true | {false, OtherErrorCode, MyErrorCode}
check_dungeon_condition_on_team([], _RoleId, _Figure) -> true;
check_dungeon_condition_on_team([H|T], RoleId, Figure) ->
    #figure{lv = Lv, name = Name} = Figure,
    case H of
        {lv, NeedLv} ->
            case Lv >= NeedLv of
                true -> check_dungeon_condition_on_team(T, RoleId, Figure);
                false ->
                    {
                        false
                        , {?ERRCODE(err240_not_enough_lv_to_enter_target_with_name), [Name]}
                        , ?ERRCODE(err240_not_enough_lv_to_enter_target)
                    }
            end;
        _ ->
            check_dungeon_condition_on_team(T, RoleId, Figure)
    end.

get_help_type(Player, DunId) ->
    #player_status{help_type_setting = HMap} = Player,
    case maps:find(DunId, HMap) of
        {ok, {default, HelpType}} ->
            HelpType;
        {ok, HelpType} ->
            HelpType;
        _ ->
            get_default_help_type(Player, DunId)
    end.

check_help_type_setup(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            lists:member(DunType, ?HELP_DUNGEON_TYPES);
        _ ->
            false
    end.

get_default_help_type(#player_status{id = RoleId} = PS, DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} = Dun ->
            case lists:member(DunType, ?HELP_DUNGEON_TYPES) of
                true ->
                    % case lib_dungeon:get_recommend_dun_id(Player, DunType) of
                    %     DunId ->
                    if
                        DunType == ?DUNGEON_TYPE_WEEK_DUNGEON ->
                            lib_week_dungeon:get_help_type(Dun, RoleId);
                        true ->
                            case lib_dungeon:get_daily_left_count(PS, Dun) of
                                Num when Num > 0 ->
                                    ?HELP_TYPE_NO;
                                _ ->
                                    ?HELP_TYPE_YES
                            end
                    end;
                    %     _ ->
                    %         ?HELP_TYPE_YES
                    % end;
                _ ->
                    ?HELP_TYPE_NO
            end;
        _ ->
            ?HELP_TYPE_NO
    end.


init_help_type(#player_status{help_type_setting = HMap} = Player, DunId) ->
    case maps:is_key(DunId, HMap) of
        true ->
            Player;
        _ ->
            HelpType = get_help_type(Player, DunId),
            Player#player_status{help_type_setting = HMap#{DunId => {default, HelpType}}}
    end.

get_dummy_data_for_fake_mb(Player, TeamId) ->
    #player_status{battle_attr = BattleAttr} = Player,
    SkillList = lib_dummy_api:get_skill_list(Player),
    mod_team:cast_to_team(TeamId, {dummy_data_for_fake_mb, BattleAttr, SkillList}),
    ok.

check_continue_dungeon(Player, DunId, Teammates) ->
    #player_status{team = #status_team{team_id = TeamId}} = Player,
    if
        TeamId > 0 ->
            HelpType = get_help_type(Player, DunId),
            Dun = data_dungeon:get(DunId),
            #dungeon{count_cond =  CountCond} = Dun,
            CheckList = [
%%                {fun lib_dungeon:check_other_conditions/1, [Player]},
%%                {fun check_dungeon_condition/4, [Condition, Dun, Args, Player]},
                {fun check_dungeon_count_cond/4, [CountCond, Dun, HelpType, Player]},
                {fun check_cost/3, [Player, Dun, []]}
%%                {fun check_extra/3, [Player, Dun, Args]}
            ],
            case check_all(CheckList) of
                true ->
                    case Teammates of
                        [_|_] ->
                            {ok, BinData} = pt_240:write(24056, [Teammates]),
                            lib_server_send:send_to_sid(Player#player_status.sid, BinData);
                        _ ->
                            ok
                    end;
                _ ->
                    mod_team:cast_to_team(TeamId, {'quit_team', Player#player_status.id, 1})
            end;
        true ->
            skip
    end.

get_dummy_power_ratio(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            case data_dungeon_special:get(DunType, dummy_data) of
                [_, _, L, H|_] ->
                    urand:rand(L, H) / 100;
                _ ->
                    1
            end;
        _ ->
            1
    end.

get_dummy_attr_ratio(DunId) ->
    case data_dungeon:get(DunId) of
        #dungeon{type = DunType} ->
            case data_dungeon_special:get(DunType, dummy_data) of
                [L, H|_] ->
                    urand:rand(L, H) / 100;
                _ ->
                    1
            end;
        _ ->
            1
    end.
