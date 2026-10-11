%%% -------------------------------------------------------------------
%%% @doc        lib_beings_gate_mod
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-03-08 19:06
%%% @deprecated 众生之门本服/跨服逻辑层
%%% -------------------------------------------------------------------

-module(lib_beings_gate_mod).

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
    init/2
    , send_beings_gate_info/2
    , do_act_end/1
    , cale_portal_map/6
    , do_add_activity_value/3
    , do_refresh_activity_value/1
    , do_enter_beings_gate_scene/6
    , do_enter_portal/7
    , do_destroy_portal_by_id/7
    , send_beings_portal_info/6
]).

%% -----------------------------------------------------------------
%% @desc   进程启动初始化
%% @param StateType      进程类型
%% @param DBActivityList 活跃度列表
%% @return NewState
%% -----------------------------------------------------------------
init(StateType, DBActivityList) ->
    FA = fun(DBActivity, ActivityList) ->
        [ServerId, Yesterday, Today, Time] = DBActivity,
        {NewYesterday, NewToday, NewTime} = lib_beings_gate_util:get_new_activity(Time, Today, Yesterday),
        ActivityData = #activity_data{
            server_id = ServerId,
            yesterday = NewYesterday,
            today = NewToday,
            time = NewTime
        },
        [ActivityData | ActivityList]
         end,
    NewActivityList = lists:foldl(FA, [], DBActivityList),
    %?MYLOG("lwcbeings", "{StateType,NewActivityList}:~p~n", [{StateType, NewActivityList}]),
    #beings_gate_status{
        state_type = StateType,
        activity_list = NewActivityList
    }.

%% -----------------------------------------------------------------
%% @desc 发送众生之门信息
%% @param State 进程State
%% @param Flag  发送类型
%% @return {noreply, State}
%% -----------------------------------------------------------------
send_beings_gate_info(State, Flag) ->
    #beings_gate_status{
        status = Status,
        end_time = EndTime,
        zone_base_list = ZoneBaseList,
        mod = Mod,
        group_id = GroupId
    } = State,
    case Mod of
        ?LOCAL_SERVER ->
            %% TODO
            %ServerInfoList = [{config:get_server_id(), config:get_server_num(), util:get_c_server_msg(), util:get_server_name(), util:get_world_lv()}],
            ServerInfoList = [{config:get_server_id(), config:get_server_num(), util:get_server_name(), util:get_world_lv()}],
            AvgLv = util:get_world_lv();
        _ ->
            F = fun(ZoneBase, {InfoList, SLv}) ->
                #zone_base{
                    server_id = Id,
                    server_name = Name,
                    server_num = Num,
                    world_lv = Lv
                    % ,c_server_msg = CServerMsg
                } = ZoneBase,
                %% TODO
                %Item = {Id, Num, CServerMsg, Name, Lv},
                Item = {Id, Num, Name, Lv},
                {[Item | InfoList], SLv + Lv}
                end,
            {ServerInfoList, AllLvA} = lists:foldl(F, {[], 0}, ZoneBaseList),
            Length = length(ServerInfoList),
            AvgLv = ?IF(Length == 0, util:get_world_lv(), AllLvA div Length)
    end,
    NextStartTime = lib_beings_gate_util:get_next_activity_time(?MOD_BEINGS_GATE),
    %?MYLOG("lwcbeings", "{Status, EndTime, Mod, GroupId, AvgLv}:~p~n", [{Status, EndTime, Mod, GroupId, AvgLv}]),
    %?MYLOG("lwcbeings", "{ServerInfoList}:~p~n", [{ServerInfoList}]),
    {ok, BinData} = pt_241:write(24101, [Status, EndTime, Mod, GroupId, NextStartTime, ServerInfoList, AvgLv]),
    case Flag of
        all -> lib_server_send:send_to_all(BinData);
        {RoleId, uid} -> lib_server_send:send_to_uid(RoleId, BinData);
        _ -> skip
    end,
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 计算传送门Map
%% @param ActivityMap 活跃度Map
%% @param PortalMap   传送门Map
%% @return #{{ZoneId, GroupId, Mod} => [#portal_data{},...]}
%% -----------------------------------------------------------------
cale_portal_map(ZoneId, GroupId, Mod, ActivityList, _PortalMap, PortalMapA) ->
    FB = fun(Activity, ActivityNum) -> ActivityNum + Activity#activity_data.yesterday end,
    NewActivityNum = lists:foldl(FB, 0, ActivityList),
    CreatePortalNum = ?IF(config:get_cls_type() == 0 andalso util:get_open_day() =:= 1,
        ?FIRST_DAY, data_beings_gate:get_portal_num(Mod, NewActivityNum)),
    %% 清空旧传送门
    ClearPortalMap = maps:put({ZoneId, GroupId, Mod}, [], PortalMapA),
    FC = fun(Num, PortalMapC) ->
        % 不用该方法生成
        % PortalId = lib_beings_gate_util:create_portal_id(ZoneId, GroupId, Mod, Num),
        %% 获得已生成的坐标
        NewPortalDataList = maps:get({ZoneId, GroupId, Mod}, PortalMapC, []),
        {X, Y} = lib_beings_gate_util:get_new_x_y(NewPortalDataList),
        PortalData = #portal_data{
            portal_id = Num,
            x = X,
            y = Y
        },
        {ok, lib_beings_gate_util:update_portal_map(ZoneId, GroupId, Mod, PortalMapC, PortalData)}
    end,
    {ok, NewPortalMap} = util:for(1, CreatePortalNum, FC, ClearPortalMap),
    NewPortalMap.

%% -----------------------------------------------------------------
%% @desc 活动结束
%% @param State 进程State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
do_act_end(State) ->
    #beings_gate_status{end_ref = EndRef, state_type = StateType} = State,
    util:cancel_timer(EndRef),
    NewState = State#beings_gate_status{
        status = ?STATE_CLOSE,
        portal_map = #{},
        end_time = 0
    },
    case StateType == ?LOCAL_SERVER of
        true ->
            send_beings_gate_info(NewState, all),
            mod_guild_assist:beings_gate_end(),
            lib_activitycalen_api:success_end_activity(?MOD_BEINGS_GATE, 1);
        false ->
            Args = [{?LOCAL_SERVER, ?STATE_CLOSE, 0}],
            mod_clusters_center:apply_to_all_node(mod_beings_gate_local, beings_gate_sync_data, [Args])
    end,
    {noreply, NewState}.

%% -----------------------------------------------------------------
%% @desc 增加活跃度(弃用)
%% @param State    进程State
%% @param AddValue 需增加的活跃度
%% @param ServerId 服务器Id
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
do_add_activity_value(State, AddValue, ServerId) ->
    #beings_gate_status{activity_list = ActivityList} = State,
    ActivityData = ulists:keyfind(ServerId, #activity_data.server_id, ActivityList, #activity_data{server_id = ServerId}),
    #activity_data{today = Today} = ActivityData,
    NewActivityData = ActivityData#activity_data{today = Today + AddValue},
    NewActivityList = lists:keystore(ServerId, #activity_data.server_id, ActivityList, NewActivityData),
    %?MYLOG("lwcbeings", "NewActivityList:~p~n", [NewActivityList]),
    case util:is_cls() of
        true ->
            mod_clusters_center:apply_cast(ServerId, mod_beings_gate_local, beings_gate_sync_activity, [NewActivityData]),
            lib_beings_gate_sql:db_replace_beings_gate_activity_cls([NewActivityData]);
        false -> lib_beings_gate_sql:db_replace_beings_gate_activity([NewActivityData])
    end,
    {noreply, State#beings_gate_status{activity_list = NewActivityList}}.

%% -----------------------------------------------------------------
%% @desc 刷新活跃度
%% @param State 进程State
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
do_refresh_activity_value(State) ->
    #beings_gate_status{state_type = StateType, activity_list = ActivityList} = State,
    F = fun(ActivityData, ActivityListA) ->
        #activity_data{
            server_id = ServerId,
            time = Time,
            today = Today,
            yesterday = Yesterday
        } = ActivityData,
        {NewYesterday, NewToday, NewTime} = lib_beings_gate_util:get_new_activity(Time, Today, Yesterday),
        NewActivityData = #activity_data{
            server_id = ServerId,
            time = NewTime,
            today = NewToday,
            yesterday = NewYesterday
        },
        [NewActivityData | ActivityListA]
        end,
    NewActivityList = lists:foldl(F, [], ActivityList),
    ?IF(StateType == ?LOCAL_SERVER,
        lib_beings_gate_sql:db_replace_beings_gate_activity(NewActivityList),
        lib_beings_gate_sql:db_replace_beings_gate_activity_cls(NewActivityList)
    ),
    {noreply, State#beings_gate_status{activity_list = NewActivityList}}.

%% -----------------------------------------------------------------
%% @desc 进入众生之门场景
%% @param State    进程State
%% @param RoleId   角色Id
%% @param ServerId 服务器Id
%% @param ZoneId   区Id
%% @param GroupId  组Id
%% @param SceneId  场景Id
%% @return {noreply, State}
%% -----------------------------------------------------------------
do_enter_beings_gate_scene(State, RoleId, ServerId, ZoneId, GroupId, SceneId) ->
    KeyValueList = [{group, 0}, {ghost, 0}],
    NeedOut = lib_beings_gate_util:is_in_outside_scene(SceneId),
    lib_beings_gate_util:dispatch_execute(ServerId, lib_scene, player_change_scene, [RoleId, SceneId, ZoneId, GroupId, NeedOut, KeyValueList]),
    {ok, BinData} = pt_241:write(24104, [?SUCCESS]),
    lib_beings_gate_util:send_to_uid(ServerId, RoleId, BinData),
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 进入传送门
%% @param State    进程Id
%% @param PortalId 传送门Id
%% @param ServerId 服务器Id
%% @param RoleId   角色Id
%% @param ZoneId   区Id
%% @param GroupId  组Id
%% @param Mod      模式
%% @return {noreply, State}
%% -----------------------------------------------------------------
do_enter_portal(State, PortalId, ServerId, RoleId, ZoneId, GroupId, Mod) ->
    #beings_gate_status{portal_map = PortalMap} = State,
    PortalDataList = maps:get({ZoneId, GroupId, Mod}, PortalMap, []),
    #portal_data{portal_id = PortalIdA} = ulists:keyfind(PortalId, #portal_data.portal_id, PortalDataList, #portal_data{}),
    Args = [RoleId, ?APPLY_CAST_SAVE, lib_beings_gate, enter_portal, [PortalIdA =:= PortalId, PortalId]],
    ?IF(util:is_cls(), mod_clusters_center:apply_cast(ServerId, lib_player, apply_cast, Args),
        lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_beings_gate, enter_portal, [PortalIdA =:= PortalId, PortalId])),
    {noreply, State}.

%% -----------------------------------------------------------------
%% @desc 销毁传送门
%% @param State    进程Id
%% @param SceneId  场景Id
%% @param PortalId 传送门Id
%% @param PoolId   场景池Id
%% @param ZoneId   区Id
%% @param Mod      模式
%% @param GroupId  组Id
%% @return {noreply, NewState}
%% -----------------------------------------------------------------
do_destroy_portal_by_id(State, SceneId, PortalId, PoolId, ZoneId, Mod, GroupId) ->
    #beings_gate_status{portal_map = PortalMap, group_map = GroupMap} = State,
    PortalDataList = maps:get({ZoneId, GroupId, Mod}, PortalMap, []),
    NewPortalList = lists:keydelete(PortalId, #portal_data.portal_id, PortalDataList),
    NewPortalMap = maps:put({ZoneId, GroupId, Mod}, NewPortalList, PortalMap),
    {ok, BinData} = pt_241:write(24106, [PortalId]),
    lib_server_send:send_to_scene(SceneId, PoolId, BinData),
    %?MYLOG("lwcbeings","NewPortalMap:~p~n",[NewPortalMap]),
    %?MYLOG("lwcbeings","{SceneId, PoolId, PortalId}:~p~n",[{SceneId, PoolId, PortalId}]),
    %% 所有传送门销毁传闻
    length(NewPortalList) =:= 0 andalso
        lib_beings_gate_util:zone_dispatch_execute(GroupMap, ZoneId, Mod, GroupId, lib_chat, send_TV, [{all_lv, ?ENTER_LV, 99999}, ?MOD_DUNGEON, 9, []]),
    {noreply, State#beings_gate_status{portal_map = NewPortalMap}}.

%% -----------------------------------------------------------------
%% @desc 发送传送门信息
%% @param State    进程Id
%% @param RoleId   角色Id
%% @param ZoneId   区Id
%% @param GroupId  组Id
%% @param Mod      模式
%% @param ServerId 服务器Id
%% @return {noreply, State}
%% -----------------------------------------------------------------
send_beings_portal_info(State, RoleId, ZoneId, GroupId, Mod, ServerId) ->
    #beings_gate_status{portal_map = PortalMap} = State,
    PortalList = maps:get({ZoneId, GroupId, Mod}, PortalMap, []),
    F = fun(Portal, ClientPortalList) ->
        #portal_data{
            portal_id = PortalId,
            x = X,
            y = Y
        } = Portal,
        [{PortalId, X, Y} | ClientPortalList]
        end,
    NewClientPortalList = lists:foldl(F, [], PortalList),
    %?MYLOG("lwcbeings", "{ZoneId, GroupId, Mod}:~p~n", [{ZoneId, GroupId, Mod}]),
    %?MYLOG("lwcbeings", "{NewClientPortalList}:~p~n", [{NewClientPortalList}]),
    {ok, BinData} = pt_241:write(24102, [NewClientPortalList]),
    lib_beings_gate_util:send_to_uid(ServerId, RoleId, BinData),
    {noreply, State}.
