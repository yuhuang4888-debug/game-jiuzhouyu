%% ---------------------------------------------------------------------------
%% @doc lib_team_api
%% @author ming_up@foxmail.com
%% @since  2016-11-17
%% @deprecated  队伍api接口
%% ---------------------------------------------------------------------------
-module(lib_team_api).

-export([
         create_team/5
        , thing_to_mb/1
        , send_to_team/2
        , quit_team/2
        , get_mb_ids/1
        , where_i_am/5
        , handle_event/2
        , get_his_teammate/1
        , share_mon_exp/6
        , kill_mon/4
        , change_location/1
        , inerrupt_follow/2
        , team_to_onhook/1
        , update_team_mb/2
        ]).

-include("team.hrl").
-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("skill.hrl").
-include("errcode.hrl").

%% 系统创建一个队伍 @return TeamId
create_team(ActivityId, SubTypeId, SceneId, Mbs, Args) ->
    lib_team:create_cast(ActivityId, SubTypeId, SceneId, Mbs, Args).

%% 处理成队员record
thing_to_mb(PS) when is_record(PS, player_status) ->
    Skill = case lists:keyfind(?SP_SKILL_KILLING, 1, PS#player_status.skill#status_skill.skill_passive) of
        false -> 0;
        _ -> ?SP_SKILL_KILLING
    end,
    Node = mod_disperse:get_clusters_node(),
    JoinValueList = get_join_value_list(PS),
    #player_status{
        id=Id, platform=Platform, server_num=SerNum, scene=Scene, combat_power = Power, action_lock = Lock,
        scene_pool_id=ScenenPoolId, copy_id=CopyId, figure=Figure, online = OL, server_id = ServerId} = PS,
    TaskMap = get_task_map(PS),
    ShareSkillL = get_share_skill_list(PS),
    #mb{id=Id, platform=Platform, server_num=SerNum, figure=Figure, scene=Scene, skill = Skill,
        scene_pool_id=ScenenPoolId, copy_id=CopyId, join_time=utime:unixtime(), power = Power, node = Node, online = OL,
        server_id = ServerId, lock = Lock, join_value_list = JoinValueList, task_map = TaskMap,
        share_skill_list = ShareSkillL};
thing_to_mb(_) -> #mb{}.

%% 获取任务map
get_task_map(#player_status{task_map = TaskMap}) ->
    TriTaskIdL = data_team_m:get_trigger_task_id_list(),
    F = fun(TaskId, TeamTaskMap) ->
        case maps:get(TaskId, TaskMap, []) of
            [] -> TeamTaskMap;
            TaskState -> maps:put(TaskId, TaskState, TeamTaskMap)
        end
    end,
    lists:foldl(F, #{}, TriTaskIdL).

%% 获得被动共享技能列表
get_share_skill_list(PS) ->
    DunSkillL = lib_dungeon_learn_skill:get_passive_share_skill_list(PS),
    DunSkillL.

%% 发送二进制给队员
send_to_team(TeamId, Bin) ->
    mod_team:cast_to_team(TeamId, {'send_to_team', Bin}).

%% 离开队伍
%% QuitType 0普通|1离线
quit_team(PS, QuitType) ->
    #player_status{id = RoleId, team = #status_team{team_id=TeamId}} = PS,
    case TeamId > 0 of
        true -> mod_team:cast_to_team(TeamId, {'quit_team', RoleId, QuitType});
        _ -> skip
    end.

%% 获取队伍内成员所有id @return list() = [Id1, Id2,...]
get_mb_ids(TeamId) ->
    case mod_team:call_to_team(TeamId, 'get_mb_ids') of
        false -> [];
        Other -> Other
    end.

%% 获得队伍历史人员ID列表
get_his_teammate(TeamId) ->
    case mod_team:call_to_team(TeamId, 'get_his_teammate') of
        false -> [];
        Other -> Other
    end.

%% 告诉队伍进程场景信息
where_i_am(TeamId, Id, Scene, ScenenPoolId, CopyId) when TeamId > 0 ->
    mod_team:cast_to_team(TeamId, {'change_my_position', Id, Scene, ScenenPoolId, CopyId}),
    ok;
where_i_am(_, _, _, _, _) -> ok.

%% 处理升级回调事件
handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) when is_record(PS, player_status) ->
    #player_status{id = PlayerId, figure = #figure{lv = Lv}, team = #status_team{team_id=TeamId}} = PS,
    if
        TeamId>0 -> mod_team:cast_to_team(TeamId, {'update_team_mb', PlayerId, [{lv, Lv}]});
        true -> skip
    end,
    {ok, PS};
%% 客户端断开连接
handle_event(PS, #event_callback{type_id = LogoutEvent}) when is_record(PS, player_status) andalso
        (LogoutEvent =:= ?EVENT_DISCONNECT orelse
        LogoutEvent =:= ?EVENT_DISCONNECT_HOLD_END) ->
    case PS of
        #player_status{team = #status_team{positon = ?TEAM_LEADER, team_id = TeamId}, action_lock = Lock, id = RoleId} ->
            case ?ERRCODE(err240_change_when_matching) of
                Lock ->
                    mod_team:cast_to_team(TeamId, {'set_matching_state', RoleId, 0});
                _ ->
                    ok
            end,
            NewPS = PS;
        _ ->
            NewPS = lib_team:silent_cancel_team_match(PS)
    end,
    {ok, NewPS};

%% 处理角色改名回调事件
handle_event(PS, #event_callback{type_id = ?EVENT_RENAME, data = Name}) when is_record(PS, player_status) ->
    #player_status{id = PlayerId, team = #status_team{team_id=TeamId}} = PS,
    if
        TeamId>0 -> mod_team:cast_to_team(TeamId, {'update_team_mb', PlayerId, [{name, Name}]});
        true -> skip
    end,
    {ok, PS};

%% 战力改变
handle_event(PS, #event_callback{type_id = ?EVENT_COMBAT_POWER, data = #callback_combat_power_data{combat_power = CombatPower}}) when is_record(PS, player_status) ->
    #player_status{id = PlayerId, team = #status_team{team_id=TeamId}} = PS,
    if
        TeamId>0 -> mod_team:cast_to_team(TeamId, {'update_team_mb', PlayerId, [{power, CombatPower}]});
        true -> skip
    end,
    {ok, PS};

handle_event(PS, #event_callback{type_id = ?EVENT_TRANSFER}) when is_record(PS, player_status) ->
    #player_status{id = PlayerId, team = #status_team{team_id=TeamId}, figure = Figure} = PS,
    if
        TeamId > 0 ->
            mod_team:cast_to_team(TeamId, {'update_team_mb', PlayerId, [{figure, Figure}]});
        true ->
            skip
    end,
    {ok, PS};

handle_event(PS, #event_callback{type_id = ?EVENT_CLS_SHUTDOWN}) when is_record(PS, player_status) ->
    #player_status{team = #status_team{team_id=TeamId}} = PS,
    if
        TeamId > 0 andalso TeamId rem 2 == 0 ->
            NewPS = lib_team:lose_team(PS),
            {ok, NewPS};
        true ->
            {ok, PS}
    end;

%%handle_event(PS, #event_callback{type_id = ?EVENT_ACTION_LOCK, data = ActionLock}) when is_record(PS, player_status) ->
%%    #player_status{team = #status_team{team_id=TeamId}, id = PlayerId} = PS,
%%    if
%%        TeamId > 0  ->
%%            SkipActionLock = [?ERRCODE(err240_change_when_matching)],
%%            case lists:member(ActionLock, SkipActionLock) of
%%                false ->
%%                    mod_team:cast_to_team(TeamId, {'mb_action_locked', PlayerId});
%%                true ->
%%                    ok
%%            end;
%%        true ->
%%            ok
%%    end,
%%    {ok, PS};

handle_event(PS, #event_callback{type_id = ?EVENT_FIN_CHANGE_SCENE}) when is_record(PS, player_status) ->
    #player_status{team = #status_team{team_id=TeamId}} = PS,
    if
        TeamId > 0 ->
            mod_team:cast_to_team(TeamId, {'fin_change_scene'});
        true ->
            skip
    end,
    {ok, PS};

handle_event(PS, _) ->
    {ok, PS}.

%% 分享队员经验
share_mon_exp(AtterTeamId, AtterId, Exp, SceneId, ScenenPoolId, CopyId) ->
    case AtterTeamId > 0 of
        true  -> mod_team:cast_to_team(AtterTeamId, {'share_mon_exp', AtterId, Exp, SceneId, ScenenPoolId, CopyId});
        false -> skip
    end.

%% 队员击杀怪物
kill_mon(TeamId, SceneId, Mid, MonLv) ->
    case TeamId > 0 of
        true  -> mod_team:cast_to_team(TeamId, {'kill_mon', SceneId, Mid, MonLv});
        false -> skip
    end.

%% 切换场景或线路更新跟随者位置
change_location(Status) ->
    #player_status{team=STeam, follows=_FollowMbs, id=Id, scene=Scene, scene_pool_id=ScenePoolId, copy_id=CopyId, x=X, y=Y} = Status,
    case STeam#status_team.team_id > 0  of
        true ->
            mod_team:cast_to_team(STeam#status_team.team_id, {'change_location', Id, Scene, ScenePoolId, CopyId, X, Y, X, Y});
        false ->
            skip
    end.

%% 中断跟随
inerrupt_follow(TeamId, Id) ->
    case TeamId > 0 of
        true  -> mod_team:cast_to_team(TeamId, {'inerrupt_follow', Id});
        false -> skip
    end.

%% 队长离线挂机处理
team_to_onhook(Ps)->
    #player_status{id = RoleId, scene = SceneId, team = STeam} = Ps,
    #status_team{team_id = TeamId} = STeam,
    if
%%        TeamId > 0 andalso Position == ?TEAM_LEADER ->
%%            mod_team:cast_to_team(TeamId, {'onhook_team_to_match', RoleId});
        TeamId > 0 -> %% 队员离线挂机直接退出队伍
            mod_team:cast_to_team(TeamId, {'quit_team', RoleId, 1});
        true ->
            {Target, _LvMin, _LvMax} = lib_team:get_onhook_target_type(SceneId),
            #team_enlist{activity_id = ActivityId, subtype_id = SubId} = Target,
            Mb = thing_to_mb(Ps),
            case lib_team:is_cls_target(ActivityId, SubId) of
                true ->
                    mod_clusters_node:apply_cast(mod_team_enlist, match_teams, [Mb, [{ActivityId, SubId}]]);
                _ ->
                    mod_team_enlist:match_teams(Mb, [{ActivityId, SubId}])
            end
    end.

%% 更新队伍成员
update_team_mb(#player_status{team = undefined}, _) -> skip;
update_team_mb(Status, AttrList) ->
    #player_status{team=STeam, id = PlayerId} = Status,
    #status_team{team_id = TeamId} = STeam,
    if
        TeamId > 0 ->
            mod_team:cast_to_team(TeamId, {'update_team_mb', PlayerId, AttrList});
        true ->
            skip
    end.

%% 获取每个活动当前玩家的入队参数值
get_join_value_list(PS) ->
    ActivityList = [?ACTIVITY_ID_WEEKDUN],
    F = fun(ActivityId, List) ->
        SubTypeIdList = data_team_ui:get_activity_subtype_ids(ActivityId),
        F2 = fun(SubTypeId, List2) ->
            JoinValue = get_activity_join_value(PS, ActivityId, SubTypeId),
            [{{ActivityId, SubTypeId}, JoinValue}|List2]
        end,
        lists:foldl(F2, List, SubTypeIdList)
    end,
    JoinValueList = lists:foldl(F, [], ActivityList),
    JoinValueList.

get_activity_join_value(PS, ?ACTIVITY_ID_WEEKDUN, SubTypeId) ->
    lib_week_dungeon:get_team_join_value(PS, ?ACTIVITY_ID_WEEKDUN, SubTypeId);
get_activity_join_value(_PS, _ActivityId, _SubTypeId) ->
    0.