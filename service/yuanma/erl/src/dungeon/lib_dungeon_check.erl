%%% ------------------------------------------------------------------------------------------------
%%% @doc            lib_dungeon_check.erl
%%% @author         kyd
%%% @email          kuangyaode@qq.com
%%% @created        2021-08-12
%%% @description    副本功能检查函数
%%% ------------------------------------------------------------------------------------------------
-module(lib_dungeon_check).

-include("boss.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_module.hrl").
-include("dungeon.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("scene.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("team.hrl").

-export([enter_dungeon/3]).

-export([can_change_scene/1, check_dungeon_count/4, check_daily_count/2, is_exist_mutex/1,
        is_dungeon_open/1,check_scene/3]).

% -compile(export_all).

%%% ====================================== exported functions ======================================

%% -----------------------------------------------
%% @doc 副本进入检查
-spec
enter_dungeon(PS, Dun, EnterType) -> skip | true | {false, ErrCode} when
    PS        :: #player_status{},
    Dun       :: #dungeon{} | [],
    EnterType :: pid() | integer(),
    ErrCode   :: integer().
%% -----------------------------------------------
enter_dungeon(PS, Dun, EnterType) ->
    CheckList = [
        {fun is_dungeon_exist/1, [Dun]}, {fun is_gm_close/1, [Dun]}, {fun can_change_scene/1, [PS]},
        {fun is_dungeon_legal/1, [Dun]}, {fun is_old_dun_pid_exist/3, [PS, Dun, EnterType]},
        {fun can_enter_again/2, [PS, EnterType]}, {fun is_dun_scene_exist/1, [Dun]},
        {fun is_exist_mutex/1, [PS]}, {fun is_dungeon_open/1, [Dun]}, {fun have_enough_cost/2, [PS, Dun]},
        {fun check_dungeon_count/2, [PS, Dun]}, {fun check_dungeon_condition/3, [PS, Dun, EnterType]},
        {fun check_extra/2, [PS, Dun]}, {fun check_dungeon_count_vip_boss/2, [PS, Dun]}
    ],
    check_list(CheckList).

%%% ======================================== inner functions =======================================

%% 条件列表检查
%% @return skip | true | {false, ErrCode}
check_list([]) -> true;
check_list([H|T]) ->
    case check(H) of
        skip         -> skip;
        true         -> check_list(T);
        {false, Res} -> {false, Res};    % {false, ?FAIL}都是非正常错误
        _            -> {false, ?FAIL}
    end.

check({Fun, Args}) when is_function(Fun) -> % 尽量每个条件采用单独函数
    apply(Fun, Args);

check(_) ->
    {false, ?FAIL}.

%% 副本是否存在
is_dungeon_exist(Dun) when is_record(Dun, dungeon) -> true;
is_dungeon_exist(_) -> {false, ?ERRCODE(err610_dungeon_not_exist)}.

%% 相关功能接口是否用秘籍关闭
is_gm_close(#dungeon{type = DunType}) ->
    IsModuleOpen  = lib_gm_stop:check_gm_close_act(?MOD_DUNGEON, 0),
    IsDunTypeOpen = lib_gm_stop:check_gm_close_act(?MOD_DUNGEON, DunType),
    case {IsModuleOpen, IsDunTypeOpen} of
        {true, true} -> true;
        _ -> {false, ?ERR_GM_STOP}
    end.

%% 玩家是否可以切换场景
can_change_scene(PS) ->
    #player_status{id = RoleId, scene = SceneId, copy_id = CopyId, x = OldX, y = OldY} = PS,
    {CanOut, ErrCode} = lib_scene:is_transferable_out(PS),
    OusideScene       = lib_boss:is_in_outside_scene(SceneId),
    IsOnDungeon       = lib_scene:is_dungeon_scene(SceneId),
    IsInBoss          = lib_boss:is_in_can_change_scene(SceneId),
    IsInEudemons      = lib_eudemons_land:is_in_eudemons_boss(SceneId),
    %IsInkfSanctuary   = lib_c_sanctuary:is_in_sanctuary_scene(SceneId),
    IsInkfSanctuary   = lib_sanctuary_cluster_util:is_in_sanctuary_scene(SceneId),
    IsInSanctuary     = lib_boss:is_in_sanctuary_scene(SceneId),
    IsKfGreatDemon    = lib_boss:is_in_kf_great_demon_boss(SceneId),
    if
        not CanOut ->
            {false, ErrCode};
        OusideScene; IsOnDungeon ->
            true;
        IsInBoss ->
            BossType = lib_boss:get_boss_type_by_scene(SceneId),
            if
                BossType == ?BOSS_TYPE_SPECIAL; BossType == ?BOSS_TYPE_PHANTOM_PER; BossType == ?BOSS_TYPE_WORLD_PER ->
                    mod_special_boss:exit(RoleId, BossType, SceneId, OldX, OldY), true;
                BossType == ?BOSS_TYPE_FORBIDDEN orelse BossType == ?BOSS_TYPE_DOMAIN ->
                    true;
                true ->
                    mod_boss:quit(RoleId, BossType, CopyId, SceneId, OldX, OldY), true
            end;
        IsInEudemons ->
            lib_eudemons_land:exit_eudemons_land(PS), true;
        %IsInkfSanctuary ->
        %    mod_c_sanctuary:exit(PS#player_status.server_id, PS#player_status.id, SceneId), true;
        IsInkfSanctuary ->
            mod_sanctuary_cluster_local:quit(PS#player_status.id, SceneId), true;
        IsInSanctuary ->
            true;
        IsKfGreatDemon ->
            lib_great_demon_local:exit_great_demon(PS);
        true ->
            {false, ?ERRCODE(err120_cannot_transfer_scene)}
    end.

%% 副本类型是否合法
is_dungeon_legal(#dungeon{type = Type}) when
    Type == ?DUNGEON_TYPE_MON_INVADE;
    Type == ?DUNGEON_TYPE_PET2
    -> false;
is_dungeon_legal(_) -> true.

%% 是否已存在旧的目标副本进程,如有,请求再次进入
is_old_dun_pid_exist(PS, Dun, ?DUN_CREATE) ->
    #player_status{id = RoleId, copy_id = CopyId, dungeon = RoleDungeon} = PS,
    #status_dungeon{dun_id = OldDunId, is_end = IsEnd} = RoleDungeon,
    #dungeon{id = DunId, type = DunType} = Dun,
    SpecDunList  = [?DUNGEON_TYPE_COUPLE],
    OldDun       = data_dungeon:get(OldDunId),
    IsSpecDun    = lists:member(DunType, SpecDunList), % 特殊类型副本不能直接进入
    IsCfgRecord  = is_record(OldDun, dungeon),
    IsDunegonEnd = lib_dungeon:is_on_dungeon(PS) andalso IsEnd == ?DUN_IS_END_YES,
    case (not IsSpecDun) andalso IsCfgRecord andalso IsDunegonEnd of
        true ->
            mod_dungeon:again_enter_dungeon(CopyId, RoleId, node(), DunId, DunType),
            skip;
        _ ->
            true
    end;
is_old_dun_pid_exist(_PS, _Dun, DunPid) when is_pid(DunPid) ->
    misc:is_process_alive(DunPid);
is_old_dun_pid_exist(_, _, _) -> true.

%% 副本进程是否存在
is_dun_scene_exist(Dun) ->
    #dungeon{scene_id = SceneId} = Dun,
    case data_scene:get(SceneId) of
        #ets_scene{} -> true;
        _ -> {false, ?ERRCODE(err610_dungeon_scene_not_exist)}
    end.

%% 是否可以再次进入
can_enter_again(PS, ?DUN_AGAIN) ->
    #player_status{dungeon = #status_dungeon{is_end = IsEnd}} = PS,
    IsOnDungeon = lib_dungeon:is_on_dungeon(PS),
    case {IsOnDungeon, IsEnd} of
        {true, ?DUN_IS_END_NO} -> % 在副本中但副本未结束
            {false, ?ERRCODE(err610_had_on_dungeon)};
        _ ->
            true
    end;
can_enter_again(_, _) -> true.

%% 是否存在互斥,场景安全问题等
is_exist_mutex(PS) ->
    #player_status{scene = SceneId} = PS,
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} when
        SceneType == ?SCENE_TYPE_DUNGEON; SceneType==?SCENE_TYPE_MAIN_DUN; SceneType == ?SCENE_TYPE_EUDEMONS_BOSS;
        SceneType == ?SCENE_TYPE_FORBIDDEB_BOSS; SceneType == ?SCENE_TYPE_ABYSS_BOSS; SceneType == ?SCENE_TYPE_NEW_OUTSIDE_BOSS;
        SceneType == ?SCENE_TYPE_SPECIAL_BOSS; SceneType == ?SCENE_TYPE_KF_SANCTUARY; SceneType == ?SCENE_TYPE_SANCTUARY;
        SceneType == ?SCENE_TYPE_PHANTOM_BOSS_PER; SceneType == ?SCENE_TYPE_WORLD_BOSS_PER
        ->
            CheckList = [action_free];
        _ ->
            CheckList = [alive, safe_scene, action_free]
    end,
    lib_player_check:check_list(PS, CheckList).

%% 副本是否已开启
is_dungeon_open(Dun) ->
    #dungeon{open_begin = OpenBegin, open_end = OpenEnd, start_time = StartTime, end_time = EndTime, week_list = WeekList} = Dun,
    OpenDay = util:get_open_day(),
    IsCheckOpen = OpenDay >= OpenBegin andalso (OpenDay =< OpenEnd orelse OpenEnd == 0),
    Unixtime = utime:unixtime(),
    IsCheckTime = Unixtime >= StartTime andalso (Unixtime =< EndTime orelse EndTime == 0),
    WeekDay = utime:day_of_week(),
    IsCheckWeek = lists:member(WeekDay, WeekList) orelse WeekList == [],
    case IsCheckOpen andalso IsCheckTime andalso IsCheckWeek of
        true -> true;
        false -> {false, ?ERRCODE(err610_dungeon_not_open)}
    end.

%% 副本配置进入条件检查
check_dungeon_condition(PS, Dun, EnterType) ->
    #dungeon{condition = Conditions} = Dun,
    check_dungeon_condition(Conditions, Dun, EnterType, PS).

check_dungeon_condition([], _, _, _) -> true;
check_dungeon_condition([T|L], Dun, DunPid, Player) ->
    #player_status{id = RoleId, tid = Tid, figure = #figure{lv = Lv, turn = Turn, vip = VipLv, vip_type = VipType}, team = StatusTeam} = Player,
    #dungeon{id = DunId, count_deduct = CountDeduct, type = DunType} = Dun,
    #status_team{team_id = TeamId} = StatusTeam,
    case T of
        {num, 1, 1} ->
            case TeamId > 0 of
                true ->
                    {false, ?ERRCODE(err610_single_dungeon_must_quit_team)};
                false ->
                    check_dungeon_condition(L, Dun, DunPid, Player)
            end;
        {num, Min, Max} ->
            IdsList = lib_team_api:get_mb_ids(TeamId),
            Num = max(length(IdsList), 1),
            if
                Num < Min ->
                    {false, ?ERRCODE(err610_dungeon_num_not_satisfy)};
                Num > Max ->
                    {false, {?ERRCODE(err610_too_many_members), [Max]}};
                true ->
                    check_dungeon_condition(L, Dun, DunPid, Player)
            end;
        {lv, NeedLv} ->
            case Lv >= NeedLv of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_not_enough_lv_to_enter_dungeon)}
            end;
        {vip_lv, NeedVipLv} ->
            case VipLv >= NeedVipLv of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_not_enough_vip_lv_to_enter_dungeon)}
            end;
        {vip_type, NeedVipType} ->
            case VipType >= NeedVipType of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_not_enough_vip_type_to_enter_dungeon)}
            end;
        {turn, NeedTurn} ->
            case Turn >= NeedTurn of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_not_enough_turn_to_enter_dungeon)}
            end;
	    {finish_dun_id2, SubModuleId, FinishDunId} ->
		    Count = mod_counter:get_count(RoleId, ?MOD_DUNGEON, SubModuleId, FinishDunId),
		    case Count > 0 of
			    true -> check_dungeon_condition(L, Dun, DunPid, Player);
			    false ->
                    case DunType of
                        ?DUNGEON_TYPE_RUNE ->
                            {false, ?ERRCODE(err610_need_finish_dun_id2)};
                        _ ->
                            {false, ?ERRCODE(err610_need_finish_dun_id)}
                    end
		    end;
        {finish_dun_id, FinishDunId} ->
            SubModuleId =
                if
                    CountDeduct =:= ?DUN_COUNT_DEDUCT_ENTER ->
                        ?MOD_DUNGEON_ENTER;
                    true ->
                        ?MOD_DUNGEON_SUCCESS
                end,
            Count = mod_counter:get_count(RoleId, ?MOD_DUNGEON, SubModuleId, FinishDunId),
            case Count > 0 of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_need_finish_dun_id)}
            end;
        {just_once_finish} ->
            SubModuleId = if CountDeduct =:= ?DUN_COUNT_DEDUCT_ENTER -> ?MOD_DUNGEON_ENTER; true -> ?MOD_DUNGEON_SUCCESS end,
            Count = mod_counter:get_count(RoleId, ?MOD_DUNGEON, SubModuleId, DunId),
            case Count == 0 of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_just_once_finish)}
            end;
        {today_finish_dun, FinishDunId} ->
            SubModuleId = if CountDeduct =:= ?DUN_COUNT_DEDUCT_ENTER -> ?MOD_DUNGEON_ENTER; true -> ?MOD_DUNGEON_SUCCESS end,
            Count = mod_daily:get_count(RoleId, ?MOD_DUNGEON, SubModuleId, FinishDunId),
            case Count > 0 of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_need_finish_dun_id)}
            end;
        {cd, _Cd} ->
            NextTime = lib_dungeon:get_cd_info(Player, DunId),
            case utime:unixtime() >= NextTime of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_not_enough_cd)}
            end;
        {task_id, TaskId} ->
            case mod_task:is_finish_task_id(Tid, TaskId) of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_not_finish_task)}
            end;
        {trigger_task_id, TaskId} ->
            case mod_task:is_trigger_task_id(Tid, TaskId) of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                false -> {false, ?ERRCODE(err610_not_tigger_task)}
            end;
        % {safe_scene}、{enter_scene, _SceneIdList}、{enter_scene2, _SceneXyList} 任意满足就可以
        {safe_scene} ->
            case check_scene(Player, Dun, DunPid) of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                Error -> Error
            end;
        {enter_scene, _} ->
            case check_scene(Player, Dun, DunPid) of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                Error -> Error
            end;
        {enter_scene2, _} ->
            case check_scene(Player, Dun, DunPid) of
                true -> check_dungeon_condition(L, Dun, DunPid, Player);
                Error -> Error
            end;
        {pass_dun_star, LastDunId, NeedStar} ->
            case check_dungeon_pass_start(LastDunId, DunType, NeedStar, Player) of
                true ->  check_dungeon_condition(L, Dun, DunPid, Player);
                Error -> Error
            end;
        _ -> % 非副本进入条件
            check_dungeon_condition(L, Dun, DunPid, Player)
    end.

%% 检查场景
%% DunPid : pid() | ?DUN_CREATE(创建副本) | ?DUN_AGAIN(重新进入)
%% @return {false, ErrorCode} | true
check_scene(Player, Dun, DunPid) ->
    #player_status{scene = SceneId, x = X, y = Y} = Player,
    #dungeon{condition = Condition} = Dun,
    CheckSafeScene = case lists:keyfind(safe_scene, 1, Condition) of
        false -> false;
        {safe_scene} ->
            case skip_check_safe_scene(Player, Dun, DunPid) of
                true -> true;
                false ->
                    case lib_scene:is_transferable(Player) of
                        {true, _Success} -> true;
                        {false, ErrorCode} -> {false, ErrorCode}
                    end
            end
    end,
    CheckEnterScene = case lists:keyfind(enter_scene, 1, Condition) of
        false -> false;
        {enter_scene, SceneIdList} ->
            case lists:member(SceneId, SceneIdList) of
                true -> true;
                false -> {false, ?ERRCODE(err610_not_on_enter_scene)}
            end
    end,
    CheckEnterScene2 = case lists:keyfind(enter_scene2, 1, Condition) of
        false -> false;
        {enter_scene2, SceneXyList} ->
            F = fun({TmpSceneId, TmpX, TmpY, TmpXrange, TmpYrange}) ->
                IsRightX = (X >= TmpX - TmpXrange) andalso (X =< TmpX + TmpXrange),
                IsRightY = (Y >= TmpY - TmpYrange) andalso (Y =< TmpY + TmpYrange),
                SceneId == TmpSceneId andalso IsRightX andalso IsRightY
            end,
            case lists:any(F, SceneXyList) of
                true -> true;
                false -> {false, ?ERRCODE(err610_not_on_enter_scene)}
            end
    end,
    SceneOfBattle = ?ERRCODE(err120_cannot_transfer_on_battle),
    if
        % 战斗状态中不能传送
        CheckSafeScene == {false, SceneOfBattle} -> ?INFO("Dun ~p Condition ~p ~n", [Dun, Condition]),CheckSafeScene;
        CheckSafeScene == true orelse CheckEnterScene == true orelse CheckEnterScene2 == true -> true;
        CheckSafeScene =/= false -> CheckSafeScene;
        CheckEnterScene =/= false -> CheckEnterScene;
        CheckEnterScene2 =/= false -> CheckEnterScene2;
        % 必须要填进入条件,容错
        true -> {false, ?ERRCODE(err610_not_on_safe_scene_to_enter_dungeon)}
    end.

%% 跳过安全区域检查
%% 2.玩家不在副本中,玩家处于副本场景中
skip_check_safe_scene(Player, _Dun, EnterType) ->
    % 玩家在副本中,但是不是再次挑战和已经结束
    case can_enter_again(Player, EnterType) of
        true -> true;
        _ ->
            #player_status{scene = SceneId} = Player,
            lib_scene:is_dungeon_scene(SceneId)
    end.

%% VIP个人BOSS特殊处理
have_enough_cost(PS, #dungeon{id = DunId, type = Type} = Dun) when Type =:= ?DUNGEON_TYPE_VIP_PER_BOSS->
    case mod_counter:get_count(PS#player_status.id, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, DunId) of
        0 -> true;
        _ -> check_cost_multi(PS, Dun, 1)
    end;

%% 副本消耗检查
have_enough_cost(PS, Dun) ->
    check_cost_multi(PS, Dun, 1).   % 默认进入一次

check_cost_multi(PS, Dun, Count) ->
    Cost = lib_dungeon:calc_real_cost_multi(PS, Dun, Count),
    case lib_goods_api:check_object_list(PS, Cost) of
        true -> true;
        _ ->
            case Dun#dungeon.type of
                ?DUNGEON_TYPE_EXP ->
                    MyErrorCode = ?ERRCODE(err240_my_cost_error_exp);
                ?DUNGEON_TYPE_EXP_SINGLE ->
                    MyErrorCode = ?ERRCODE(err240_my_cost_error_exp);
                _ ->
                    CostName = lib_goods_api:get_first_object_name(Cost),
                    MyErrorCode = {?ERRCODE(what_not_enough), [CostName]}
            end,
            {false, MyErrorCode}
    end.

check_dungeon_count_vip_boss(PS, #dungeon{id = DunId, type = Type} = Dun) when Type =:= ?DUNGEON_TYPE_VIP_PER_BOSS ->
    case mod_counter:get_count(PS#player_status.id, ?MOD_BOSS, ?MOD_SUB_BOSS_FIRST_REWARD, DunId) of
        0 -> true;
        _ -> check_dungeon_count(PS, Dun)
    end;

check_dungeon_count_vip_boss(_PS, _Dun) -> true.

check_dungeon_count(_PS, #dungeon{type = Type} = _Dun) when Type =:= ?DUNGEON_TYPE_VIP_PER_BOSS -> true;

%% 副本进入次数检查
check_dungeon_count(PS, Dun) ->
    #dungeon{count_cond = Conditions} = Dun,
    case check_dungeon_count(Conditions, Dun, PS) of
        true -> true;
        Error ->
            #player_status{id = RoleId} = PS,
            case Dun of
                % yyhx:项目特殊处理,防止卡流程
                #dungeon{id = DunId = 20002, type = DunType = ?DUNGEON_TYPE_EXP_SINGLE} ->
                    lib_task_api:fin_dun_type(RoleId, DunType),
                    lib_task_api:fin_dun(RoleId, DunId);
                #dungeon{id = DunId, type = DunType} when
                DunType == ?DUNGEON_TYPE_DEVIL_INSIDE; DunType == ?DUNGEON_TYPE_TURN ->
                    lib_task_api:fin_dun_type(RoleId, DunType),
                    lib_task_api:fin_dun(RoleId, DunId);
                _ ->
                    skip
            end,
            Error
    end.

check_dungeon_count(Conditions, Dun, PS) ->
    HelpType = lib_dungeon_team:get_help_type(PS, Dun#dungeon.id),
    check_dungeon_count(Conditions, Dun, HelpType, 1, PS).

check_dungeon_count(Conditions, Dun, Count, PS) ->
    HelpType = lib_dungeon_team:get_help_type(PS, Dun#dungeon.id),
    check_dungeon_count(Conditions, Dun, HelpType, Count, PS).

check_dungeon_count([], _, _, _, _) -> true;
check_dungeon_count([{CountType, _} | T], Dun, HelpType, Count, PS) when
    CountType /= ?DUN_COUNT_COND_DAILY_HELP, HelpType == ?HELP_TYPE_YES;
    CountType == ?DUN_COUNT_COND_DAILY_HELP, HelpType == ?HELP_TYPE_NO;
    CountType == ?DUN_COUNT_COND_DAILY_REWARD
    ->
    check_dungeon_count(T, Dun, ?HELP_TYPE_YES, Count, PS);
check_dungeon_count([{?DUN_COUNT_COND_DAILY, _} | T], Dun, HelpType, Count, PS) ->
    case check_daily_count(PS, Dun, Count) of
        {false, AllCountLimit} ->
            {false, {?ERRCODE(err610_dungeon_count_daily), [AllCountLimit]}};
        true ->
            check_dungeon_count(T, Dun, HelpType, Count, PS)
    end;
check_dungeon_count([{?DUN_COUNT_COND_WEEK, MaxNum} | T], Dun, HelpType, Count, PS) ->
    #player_status{id = RoleId} = PS,
    #dungeon{id = DunId} = Dun,
    Num = mod_week:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
    case Num + Count =< MaxNum of
        true -> check_dungeon_count(T, Dun, HelpType, Count, PS);
        false -> {false, {?ERRCODE(err610_dungeon_count_week), [MaxNum]}}
    end;
check_dungeon_count([{?DUN_COUNT_COND_PERMANENT, MaxNum} | T], Dun, HelpType, Count, PS) ->
    #player_status{id = RoleId} = PS,
    #dungeon{id = DunId} = Dun,
    Num = mod_counter:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_ENTER, DunId),
    case Num + Count =< MaxNum of
        true ->
            check_dungeon_count(T, Dun, HelpType, Count, PS);
        false ->
            {false, {?ERRCODE(err610_dungeon_count_permanent), [MaxNum]}}
    end;
check_dungeon_count([{?DUN_COUNT_COND_DAILY_HELP, MaxNum} | T], Dun, HelpType, Count, PS) ->
    #player_status{id = RoleId} = PS,
    #dungeon{id = DunId, type = DunType} = Dun,
    CountType = lib_dungeon_api:get_daily_help_type(DunType, DunId),
    Num = mod_daily:get_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_HELP, CountType),
    if
        Num + Count =< MaxNum ->
            check_dungeon_count(T, Dun, HelpType, Count, PS);
        true ->
            {false, {?ERRCODE(err610_dungeon_count_daily_help), [MaxNum]}}
    end;
check_dungeon_count(_, _, _, _, _) ->
    {false, ?ERRCODE(err610_dungeon_count_cfg_error)}.

%% 检查日常次数是否足够
check_daily_count(PS, Dun) ->
    check_daily_count(PS, Dun, 1).

check_daily_count(PS, Dun, Count) ->
    {AllCount, LeftCount} = lib_dungeon:get_daily_count(PS, Dun),
    ?IF(LeftCount >= Count, true, {false, AllCount}).

%% 副本类型额外检查
check_extra(PS, #dungeon{type = DunType} = Dun) ->
    lib_dungeon_api:invoke(DunType, dunex_check_extra, [PS, Dun], true).

check_dungeon_pass_start(DunId, DunType, NeedStar, Player) ->
    #player_status{dungeon_record = Rec} = Player,
    case maps:find(DunId, Rec) of
        {ok, RecData} ->
            Score = lib_dungeon:calc_record_score(DunId, DunType, RecData),
            Score >= NeedStar;
        _ ->
            %% 防止卡其他副本流程
            case lib_dungeon_resource:is_resource_dungeon_type(DunType) of
                true -> false;
                _ -> true
            end
    end.