%%% -------------------------------------------------------------------
%%% @doc        lib_beings_gate_mod_local
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-08 19:07
%%% @deprecated 众生之门本服逻辑层
%%% -------------------------------------------------------------------

-module(lib_beings_gate_mod_local).

-include("beings_gate.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("clusters.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("predefine.hrl").

%% API
-export([
    beings_gate_sync_partition/2
    , act_start/3
    , beings_gate_sync_data/2
    , act_end/1
    , add_activity_value/3
    , refresh_activity_value/1
    , enter_beings_gate_scene/3
    , match_teams/3
    , enter_portal/4
    , is_exit_portal/2
    , destroy_portal_by_id/4
    , gm_act_start/2
    , gm_clear_activity/1
    , send_beings_portal_info/3
    , send_beings_gate_info/2
    , beings_gate_sync_activity/2
]).

%% -----------------------------------------------------------------
%% @desc 同步分服情况
%% @param State 进程State
%% @param BeingsGateZone {ZoneId, GroupId, Mod, ZoneBaseList}
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
beings_gate_sync_partition(State, BeingsGateZone) ->
    {ZoneId, GroupId, Mod, ZoneBaseList} = BeingsGateZone,
    case Mod =/= ?LOCAL_SERVER of
        true ->
            NewState = State#beings_gate_status{
                zone_id        = ZoneId,
                group_id       = GroupId,
                mod            = Mod,
                zone_base_list = ZoneBaseList,
                cls_type       = ?CROSS_SERVER
            },
            OnlineList = ets:tab2list(?ETS_ONLINE),
            [lib_beings_gate_mod:send_beings_gate_info(NewState, {RoleId, uid}) || #ets_online{id = RoleId} <- OnlineList],
            %?MYLOG("lwcbeings","{NewState}:~p~n",[{NewState}]),
            {noreply, NewState};
        false -> {noreply, State}
    end.

%% -----------------------------------------------------------------
%% @desc  活动开始
%% @param State     进程State
%% @param ModuleSub 子Id
%% @param AcSub     活动子类
%% @return {noreply, State}
%% -----------------------------------------------------------------
act_start(#beings_gate_status{mod = Mod} = State, ModuleSub, AcSub) ->
    case lib_activitycalen:get_act_open_time_region(?MOD_BEINGS_GATE, ModuleSub, AcSub) of
        {ok, [_StartTime, EndTime]} ->
            case Mod =/= ?LOCAL_SERVER of
                true ->
                    mod_beings_gate_kf:cast_center([{'apply', act_start, [EndTime]}]),
                    {noreply, State};
                false ->
                    NewState = act_start(State, EndTime),
                    {noreply, NewState}
            end;
        false -> {noreply, State}
    end.

%% -----------------------------------------------------------------
%% @desc 开始活动
%% @param State   进程State
%% @param EndTime 结束时间
%% @return NewState
%% -----------------------------------------------------------------
act_start(#beings_gate_status{status = ?STATE_OPEN} = State, _EndTime) -> {noreply, State};
act_start(State, EndTime) ->
    #beings_gate_status{
        zone_id       = ZoneId,
        group_id      = GroupId,
        mod           = Mod,
        end_ref       = OldEndRef,
        portal_map    = PortalMap,
        activity_list = ActivityList
    } = State,
    NewPortalMap = lib_beings_gate_mod:cale_portal_map(ZoneId, GroupId, Mod, ActivityList, PortalMap, PortalMap),
    SurPlusTime = EndTime - utime:unixtime(),
    NewEndRef = util:send_after(OldEndRef, max(SurPlusTime, 0) * 1000, self(), {'apply', act_end}),
    NewState = State#beings_gate_status{
        status     = ?STATE_OPEN,
        end_ref    = NewEndRef,
        portal_map = NewPortalMap,
        end_time   = EndTime
    },
    lib_beings_gate_mod:send_beings_gate_info(State, all),
    lib_activitycalen_api:success_start_activity(?MOD_BEINGS_GATE, 1),
    #activity_data{yesterday = YesterDay} = ulists:keyfind(config:get_server_id(), #activity_data.server_id, ActivityList, #activity_data{}),
    lib_log_api:log_beings_gate_activity(config:get_server_id(), YesterDay, maps:get({ZoneId, GroupId, Mod}, NewPortalMap), EndTime),
    lib_chat:send_TV({all_lv, ?ENTER_LV, 99999}, ?MOD_DUNGEON, 8, []),
    %?MYLOG("lwcbeings","{NewState}act_open:~p~n",[{NewState}]),
    NewState.


%% -----------------------------------------------------------------
%% @desc  活动结束
%% @param State 进程State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
act_end(State) -> lib_beings_gate_mod:do_act_end(State).

%% -----------------------------------------------------------------
%% @desc 发送众生之门信息
%% @param State 进程State
%% @param Flag  发送类型
%% @return {noreply, State}
%% -----------------------------------------------------------------
send_beings_gate_info(State, Flag) -> lib_beings_gate_mod:send_beings_gate_info(State, Flag).

%% -----------------------------------------------------------------
%% @desc 本服同步跨服信息
%% @param State 进程State
%% @param Args [{NewClsType, NewStatus, SurPlusTime}]
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
beings_gate_sync_data(State, Args) ->
    [{NewClsType, NewStatus, SurPlusTime}] = Args,
    case State#beings_gate_status.mod =/= ?LOCAL_SERVER of
        true ->
            case NewStatus of
                ?STATE_OPEN ->
                    lib_activitycalen_api:success_start_activity(?MOD_BEINGS_GATE, 1),
                    lib_chat:send_TV({all_lv, ?ENTER_LV, 99999}, ?MOD_DUNGEON, 8, []),
                    NewState = State#beings_gate_status{cls_type = NewClsType, status = NewStatus, end_time = SurPlusTime},
                    lib_beings_gate_mod:send_beings_gate_info(NewState, all);
                ?STATE_CLOSE ->
                    NewState = State#beings_gate_status{cls_type = NewClsType, status = NewStatus, end_time = SurPlusTime},
                    mod_guild_assist:beings_gate_end(),
                    lib_activitycalen_api:success_end_activity(?MOD_BEINGS_GATE, 1),
                    lib_beings_gate_mod:send_beings_gate_info(NewState, all)
            end;
        false -> NewState = State
    end,
    {noreply, NewState}.

%% -----------------------------------------------------------------
%% @desc 增加活跃度
%% @param AddValue 需要增加的活跃度
%% @param ServerId 服务器Id
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
add_activity_value(State, AddValue, ServerId) ->
    #beings_gate_status{mod = Mod, activity_list = ActivityList} = State,
    % 本服数据更新
    ActivityData = ulists:keyfind(ServerId, #activity_data.server_id, ActivityList, #activity_data{server_id = ServerId}),
    #activity_data{today = Today} = ActivityData,
    NewActivityData = ActivityData#activity_data{today = Today + AddValue},
    NewActivityList = lists:keystore(ServerId, #activity_data.server_id, ActivityList, NewActivityData),
    NewState = State#beings_gate_status{activity_list = NewActivityList},
    lib_beings_gate_sql:db_replace_beings_gate_activity([NewActivityData]),
    % 跨服数据更新
    case Mod of
        ?LOCAL_SERVER -> skip;
        _ -> mod_beings_gate_kf:cast_center([{apply, sync_activity_value, [NewActivityData]}])
    end,
    {noreply, NewState}.

%% -----------------------------------------------------------------
%% @desc 刷新活跃度
%% @param State 进程State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
refresh_activity_value(State) ->
    #beings_gate_status{mod = Mod} = State,
    {_, NewState} = lib_beings_gate_mod:do_refresh_activity_value(State),
    case Mod of
        ?LOCAL_SERVER ->
            {noreply, NewState};
        _ ->
            mod_beings_gate_kf:cast_center([{apply, refresh_activity_value, []}]), {noreply, NewState}
    end.

%% -----------------------------------------------------------------
%% @desc 同步活跃度
%% @param ActivityData
%% @return
%% -----------------------------------------------------------------
beings_gate_sync_activity(State, ActivityData) ->
    lib_beings_gate_sql:db_replace_beings_gate_activity([ActivityData]),
    #beings_gate_status{activity_list = ActivityList} = State,
    ServerId = config:get_server_id(),
    NewActivityList = lists:keystore(ServerId, #activity_data.server_id, ActivityList, ActivityData),
    {noreply, State#beings_gate_status{activity_list = NewActivityList}}.

%% -----------------------------------------------------------------
%% @desc 进入众生之门场景
%% @param State    进程State
%% @param RoleId   角色Id
%% @param ServerId 服务器Id
%% @return {noreply, State}
%% -----------------------------------------------------------------
enter_beings_gate_scene(State, RoleId, ServerId) ->
    #beings_gate_status{mod = Mod, zone_id = ZoneId, group_id = GroupId} = State,
    case Mod =:= ?LOCAL_SERVER of
        true -> lib_beings_gate_mod:do_enter_beings_gate_scene(State, RoleId, ServerId, ZoneId, GroupId, ?SCENE_LOCAL);
        false -> mod_beings_gate_kf:cast_center([{apply, enter_beings_gate_scene, [RoleId, ServerId, ZoneId, GroupId, ?SCENE_CENTER]}]), {noreply, State}
    end.

%% -----------------------------------------------------------------
%% @desc 队伍匹配
%% @param State        进程State
%% @param Mb           成员
%% @param ActivityList 活动列表
%% @return {noreply, State}
%% -----------------------------------------------------------------
match_teams(State, Mb, ActivityList) ->
    #beings_gate_status{mod = Mod} = State,
    case Mod =:= ?LOCAL_SERVER of
        true -> mod_team_enlist:match_teams(Mb, ActivityList);
        false -> mod_clusters_node:apply_cast(mod_team_enlist, match_teams, [Mb, ActivityList])
    end,
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 进入传送门
%% @param State    进程State
%% @param PortalId 传送门Id
%% @param ServerId 服务器Id
%% @param RoleId   角色Id
%% @return {noreply, State}
%% -----------------------------------------------------------------
enter_portal(State, PortalId, ServerId, RoleId) ->
    #beings_gate_status{zone_id = ZoneId, group_id = GroupId, mod = Mod} = State,
    case Mod =:= ?LOCAL_SERVER of
        true -> lib_beings_gate_mod:do_enter_portal(State, PortalId, ServerId, RoleId, ZoneId, GroupId, Mod);
        false -> mod_beings_gate_kf:cast_center([{apply, enter_portal, [PortalId, ServerId, RoleId, ZoneId, GroupId, Mod]}])
    end,
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 判断是否存在传送门
%% @param State    进程Id
%% @param PortalId 传送门Id
%% @return {reply, Flag, State}
%% -----------------------------------------------------------------
is_exit_portal(State, PortalId) ->
    #beings_gate_status{zone_id = ZoneId, group_id = GroupId, mod = Mod} = State,
    #beings_gate_status{portal_map = PortalMap} = State,
    PortalDataList = maps:get({ZoneId, GroupId, Mod}, PortalMap, []),
    #portal_data{portal_id = PortalIdA} = ulists:keyfind(PortalId, #portal_data.portal_id, PortalDataList, #portal_data{}),
    Flag = PortalId =/= 0 andalso PortalIdA =:= PortalId,
    {reply, Flag, State}.

%% -----------------------------------------------------------------
%% @desc 销毁传送门
%% @param State    进程State
%% @param ServerId 服务器Id
%% @param PortalId 传送门Id
%% @param PoolId   场景池Id
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
destroy_portal_by_id(State, ServerId, PortalId, PoolId) ->
    #beings_gate_status{zone_id = ZoneId, mod = Mod, group_id = GroupId} = State,
    case Mod =:= ?LOCAL_SERVER of
        true -> lib_beings_gate_mod:do_destroy_portal_by_id(State, ServerId, PortalId, PoolId, ZoneId, Mod, GroupId);
        false -> mod_beings_gate_kf:cast_center([{apply, destroy_portal_by_id, [ServerId, PortalId, PoolId, ZoneId, Mod, GroupId]}]), {noreply, State}
    end.

%% -----------------------------------------------------------------
%% @desc 发送传送门信息
%% @param State    进程State
%% @param RoleId   角色Id
%% @param ServerId 服务器Id
%% @return {noreply, State}
%% -----------------------------------------------------------------
send_beings_portal_info(State, RoleId, ServerId) ->
    #beings_gate_status{
        mod      = Mod,
        group_id = GroupId,
        zone_id  = ZoneId
    } = State,
    %?MYLOG("lwcbeings","{Mod, GroupId, ZoneId}:~p~n",[{Mod, GroupId, ZoneId}]),
    ?IF(Mod =:= ?LOCAL_SERVER,
        lib_beings_gate_mod:send_beings_portal_info(State, RoleId, ZoneId, GroupId, Mod, ServerId),
        mod_beings_gate_kf:cast_center([{apply, send_beings_portal_info, [RoleId, ZoneId, GroupId, Mod, ServerId]}])),
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 秘籍开启活动
%% @param State   进程State
%% @param EndTime 结束时间
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
gm_act_start(State, EndTime) ->
    #beings_gate_status{mod = Mod} = State,
    case utime:unixtime() < EndTime of
        true ->
            case Mod =/= ?LOCAL_SERVER of
                false ->
                    %?MYLOG("lwcbeings","{gm_false}:~p~n",[{EndTime}]),
                    NewState = act_start(State, EndTime);
                true ->
                    %?MYLOG("lwcbeings","{gm_true}:~p~n",[{EndTime}]),
                    mod_beings_gate_kf:cast_center([{'apply', act_start, [EndTime]}]),
                    NewState = State
            end;
        false -> NewState = State
    end,
    {noreply, NewState}.

gm_clear_activity(State) ->
    #beings_gate_status{mod = Mod} = State,
    lib_beings_gate_sql:db_truncate_beings_gate_activity(),
    NewState = State#beings_gate_status{activity_list = []},
    case Mod of
        ?LOCAL_SERVER -> skip;
        _ -> mod_beings_gate_kf:cast_center([{'apply', gm_clear_activity, []}])
    end,
    {noreply, NewState}.