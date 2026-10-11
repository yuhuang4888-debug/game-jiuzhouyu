%%% -------------------------------------------------------------------
%%% @doc        lib_beings_gate_mod_kf
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-08 19:07
%%% @deprecated 众生之门跨服逻辑层
%%% -------------------------------------------------------------------

-module(lib_beings_gate_mod_kf).

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
    beings_gate_sync_server_data/2
    , act_start/2
    , act_end/1
    , get_zone_group_map/1
    , add_activity_value/3
    , sync_activity_value/2
    , refresh_activity_value/1
    , enter_beings_gate_scene/6
    , enter_portal/7
    , is_exit_portal/2
    , destroy_portal_by_id/7
    , send_beings_portal_info/6
    , sync_zone_group/2
    , server_info_change/4
    , gm_clear_activity/1
]).


%% -----------------------------------------------------------------
%% @desc 分区分组信息同步
%% @param State 进程State
%% @param InfoList {ZoneId, {Servers, GroupInfo}}
%% @return {noreply, State}
%% -----------------------------------------------------------------
sync_zone_group(#beings_gate_status{state_type = ?CROSS_SERVER} = State, InfoList) ->
    FA = fun({ZoneId, {Servers, GroupInfo}}, AccMap) ->
        #zone_group_info{group_mod_servers = GroupModServers} = GroupInfo,
        FB = fun(ModGroupData, {AccSerModMap, AccModGroupMap}) ->
            #zone_mod_group_data{group_id = GroupId, mod = Mod, server_ids = ServerIds} = ModGroupData,
            ServerZones = [Server || Server <- Servers, lists:member(Server#zone_base.server_id, ServerIds)],
            NewAccModGroupMap = AccModGroupMap#{{Mod, GroupId} => ServerZones},
            Map = maps:from_list([{SerId, {Mod, GroupId}} || SerId <- ServerIds]),
            NewAccSerModMap = maps:merge(AccSerModMap, Map),
            [mod_clusters_center:apply_cast(SerId, mod_beings_gate_local, beings_gate_sync_partition, [{ZoneId, GroupId, Mod, ServerZones}]) || SerId <- ServerIds],
            {NewAccSerModMap, NewAccModGroupMap}
             end,
        {ServerModMap, ModGroupMap} = lists:foldl(FB, {#{}, #{}}, GroupModServers),
        AccMap#{ZoneId => {ServerModMap, ModGroupMap}}
         end,
    GroupMap = lists:foldl(FA, #{}, InfoList),
    {noreply, State#beings_gate_status{group_map = GroupMap}}.

%% -----------------------------------------------------------------
%% @desc 本服进程区域信息初始化
%% @param State    进程State
%% @param ServerId 服务器Id
%% @return {noreply, State}
%% -----------------------------------------------------------------
beings_gate_sync_server_data(State, ServerId) ->
    #beings_gate_status{group_map = GroupMap} = State,
    ZoneId = lib_clusters_center_api:get_zone(ServerId),
    case maps:get(ZoneId, GroupMap, false) of
        false -> skip;
        {ServerMap, ModGroupMap} ->
            case maps:get(ServerId, ServerMap, false) of
                false -> skip;
                {ModNum, GroupId} ->
                    ZoneBaseList = maps:get({ModNum, GroupId}, ModGroupMap, []),
                    mod_clusters_center:apply_cast(ServerId, mod_beings_gate_local, beings_gate_sync_partition, [{ZoneId, GroupId, ModNum, ZoneBaseList}])
            end
    end,
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 服信息发生改变
%% @param State
%% @param ServerId
%% @param KvList
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
server_info_change(State, ZoneId, ServerId, KvList) ->
    #beings_gate_status{group_map = GroupMap} = State,
    case maps:get(ZoneId, GroupMap, false) of
        false -> NewGroupMap = GroupMap;
        {ServerMap, ModGroupMap} ->
            case maps:get(ServerId, ServerMap, false) of
                false -> NewGroupMap = GroupMap;
                {ModNum, GroupId} ->
                    ZoneBaseList = maps:get({ModNum, GroupId}, ModGroupMap, []),
                    case lists:keyfind(ServerId, #zone_base.server_id, ZoneBaseList) of
                        false -> NewGroupMap = GroupMap;
                        ZoneBase ->
                            NewZoneBase = lib_beings_gate_util:update_zone_base(ZoneBase, KvList),
                            NewZoneBaseList = lists:keystore(ServerId, #zone_base.server_id, ZoneBaseList, NewZoneBase),
                            NewModGroupMap = maps:put({ModNum, GroupId}, NewZoneBaseList, ModGroupMap),
                            NewGroupMap = maps:put(ZoneId, {ServerMap, NewModGroupMap}, GroupMap),
                            mod_clusters_center:apply_cast(ServerId, mod_beings_gate_local, beings_gate_sync_partition, [{ZoneId, GroupId, ModNum, NewZoneBaseList}])
                    end
            end
    end,
    %?MYLOG("lwctest","{State,NewState}:~p~n",[{State, State#beings_gate_status{group_map = NewGroupMap}}]),
    {noreply, State#beings_gate_status{group_map = NewGroupMap}}.

%% -----------------------------------------------------------------
%% @desc 活动开始
%% @param State   进程State
%% @param EndTime 结束时间
%% @return {noreply, State}
%% -----------------------------------------------------------------
act_start(#beings_gate_status{status = ?STATE_OPEN} = State, _EndTime) -> {noreply, State};
act_start(State, EndTime) ->
    #beings_gate_status{
        end_ref       = OldEndRef,
        group_map     = GroupMap,
        portal_map    = PortalMap,
        activity_list = ActivityList
    } = State,
    ZoneGroupMap = get_zone_group_map(GroupMap),
    ActivityMap = get_activity_map(ZoneGroupMap, ActivityList),
    FA = fun({ZoneId, GroupId, Mod}, ActivityListA, PortalMapA) ->
        NewPortalMapA = lib_beings_gate_mod:cale_portal_map(ZoneId, GroupId, Mod, ActivityListA, PortalMap, PortalMapA),
        FB = fun(Activity, ActivityNum) -> ActivityNum + Activity#activity_data.yesterday end,
        NewActivityNum = lists:foldl(FB, 0, ActivityListA),
        lib_log_api:log_beings_gate_activity_cls(ZoneId, GroupId, Mod, NewActivityNum, EndTime, maps:get({ZoneId, GroupId, Mod}, NewPortalMapA)),
        NewPortalMapA
        end,
    NewPortalMap = maps:fold(FA, PortalMap, ActivityMap),
    SurPlusTime = EndTime - utime:unixtime(),
    NewEndRef = util:send_after(OldEndRef, max(SurPlusTime, 0) * 1000, self(), {'apply', act_end}),
    NewState = State#beings_gate_status{
        status     = ?STATE_OPEN,
        end_ref    = NewEndRef,
        portal_map = NewPortalMap,
        end_time   = EndTime
    },
    Args = [{?CROSS_SERVER, ?STATE_OPEN, EndTime}],
    mod_clusters_center:apply_to_all_node(mod_beings_gate_local, beings_gate_sync_data, [Args]),
    %?MYLOG("lwcbeings","{NewState}act_open:~p~n",[{NewState}]),
    {noreply, NewState}.

%% -----------------------------------------------------------------
%% @desc 获得区组模式Map
%% @param GroupMap
%% @return #{{ZoneId, GroupId, Mod} => [#zone_base{},...]}
%% -----------------------------------------------------------------
get_zone_group_map(GroupMap) ->
    FA = fun(_ZoneId, {_ServerMap, ModGroupMap}, ZoneGroupMapA) ->
        FB = fun({Mod, GroupId}, ZoneBaseList, ZoneGroupMapB) ->
            FC = fun(ZoneBase, ZoneGroupMapC) ->
                #zone_base{zone = ZoneIdC} = ZoneBase,
                ZoneBaseListC = maps:get({ZoneIdC, GroupId}, ZoneGroupMapC, []),
                maps:put({ZoneIdC, GroupId, Mod}, [ZoneBase | ZoneBaseListC], ZoneGroupMapC)
                 end,
            lists:foldl(FC, ZoneGroupMapB, ZoneBaseList)
             end,
        maps:fold(FB, ZoneGroupMapA, ModGroupMap)
         end,
    maps:fold(FA, #{}, GroupMap).

%% -----------------------------------------------------------------
%% @desc 获得活跃度Map
%% @param ZoneGroupMap
%% @param ActivityList
%% @return #{{ZoneId, GroupId, Mod} => [#activity_data{},...]}
%% -----------------------------------------------------------------
get_activity_map(ZoneGroupMap, ActivityList) ->
    FA = fun({ZoneId, GroupId, Mod}, ZoneBaseList, ActivityMapA) ->
        FB = fun(ZoneBase, ActivityMapB) ->
            #zone_base{server_id = ServerId} = ZoneBase,
            ActivityData = ulists:keyfind(ServerId, #activity_data.server_id, ActivityList, #activity_data{server_id = ServerId}),
            lib_beings_gate_util:update_activity_map(ZoneId, GroupId, Mod, ActivityMapB, ActivityData)
             end,
        lists:foldl(FB, ActivityMapA, ZoneBaseList)
         end,
    maps:fold(FA, #{}, ZoneGroupMap).

%% -----------------------------------------------------------------
%% @desc  活动结束
%% @param State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
act_end(State) ->
    lib_beings_gate_mod:do_act_end(State).

%% -----------------------------------------------------------------
%% @desc 增加活跃度
%% @param AddValue
%% @param ServerId
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
add_activity_value(State, AddValue, ServerId) ->
    lib_beings_gate_mod:do_add_activity_value(State, AddValue, ServerId).

%% -----------------------------------------------------------------
%% @desc 游戏服活跃度同步跨服
%% @param ActivityData
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
sync_activity_value(State, ActivityData) ->
    #beings_gate_status{activity_list = ActivityList} = State,
    #activity_data{server_id = ServerId} = ActivityData,
    NewActivityList = lists:keystore(ServerId, #activity_data.server_id, ActivityList, ActivityData),
    NewState = State#beings_gate_status{activity_list = NewActivityList},
    lib_beings_gate_sql:db_replace_beings_gate_activity_cls([ActivityData]),
    {noreply, NewState}.

%% -----------------------------------------------------------------
%% @desc 刷新活跃度
%% @param State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
refresh_activity_value(State) ->
    lib_beings_gate_mod:do_refresh_activity_value(State).

%% -----------------------------------------------------------------
%% @desc 进入众生之门场景
%% @param State
%% @param RoleId
%% @param ServerId
%% @param ZoneId
%% @param GroupId
%% @param SceneId
%% @return {noreply, State}
%% -----------------------------------------------------------------
enter_beings_gate_scene(State, RoleId, ServerId, ZoneId, GroupId, SceneId) ->
    lib_beings_gate_mod:do_enter_beings_gate_scene(State, RoleId, ServerId, ZoneId, GroupId, SceneId).

%% -----------------------------------------------------------------
%% @desc 进入传送门
%% @param State
%% @param PortalId
%% @param ServerId
%% @param RoleId
%% @param ZoneId
%% @param GroupId
%% @param Mod
%% @return {noreply, State}
%% -----------------------------------------------------------------
enter_portal(State, PortalId, ServerId, RoleId, ZoneId, GroupId, Mod) ->
    lib_beings_gate_mod:do_enter_portal(State, PortalId, ServerId, RoleId, ZoneId, GroupId, Mod).

%% -----------------------------------------------------------------
%% @desc 判断是否存在传送门
%% @param State
%% @param PortalId
%% @return {reply, Flag, State}
%% -----------------------------------------------------------------
is_exit_portal(State, PortalId) ->
    #beings_gate_status{portal_map = PortalMap} = State,
    F = fun(_Key, PortalDataList, FlagA) ->
        ?IF(FlagA, true, lists:keymember(PortalId, #portal_data.portal_id, PortalDataList))
    end,
    FlagB = maps:fold(F, false, PortalMap),
    Flag = PortalId =/= 0 andalso FlagB,
    %?MYLOG("lwcbeings","Flag:~p~n",[{Flag, PortalId, FlagB}]),
    {reply, Flag, State}.

%% -----------------------------------------------------------------
%% @desc 销毁传送门
%% @param State
%% @param ServerId
%% @param PortalId
%% @param PoolId
%% @param ZoneId
%% @param Mod
%% @param GroupId
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
destroy_portal_by_id(State, ServerId, PortalId, PoolId, ZoneId, Mod, GroupId) ->
    lib_beings_gate_mod:do_destroy_portal_by_id(State, ServerId, PortalId, PoolId, ZoneId, Mod, GroupId).

%% -----------------------------------------------------------------
%% @desc 发送传送门信息
%% @param State
%% @param RoleId
%% @param ZoneId
%% @param GroupId
%% @param Mod
%% @param ServerId
%% @return {noreply, State}
%% -----------------------------------------------------------------
send_beings_portal_info(State, RoleId, ZoneId, GroupId, Mod, ServerId) ->
    lib_beings_gate_mod:send_beings_portal_info(State, RoleId, ZoneId, GroupId, Mod, ServerId).

%% 秘籍清理活跃度统计
gm_clear_activity(State) ->
    NewState = State#beings_gate_status{activity_list = []},
    {noreply, NewState}.