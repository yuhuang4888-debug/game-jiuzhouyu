%%% -------------------------------------------------------------------
%%% @doc        lib_beings_gate_util
%%% @author     lwc
%%% @email      liuweichao@suyougame.com
%%% @since      2022-02-28 17:30
%%% @deprecated 众生之门辅助层
%%% -------------------------------------------------------------------

-module(lib_beings_gate_util).

-include("beings_gate.hrl").
-include("server.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("clusters.hrl").
-include("activitycalen.hrl").
-include("common.hrl").
-include("def_module.hrl").

%% API
-export([
    get_new_activity/3
    , update_portal_map/5
    , update_activity_map/5
    , create_portal_id/4
    , get_new_x_y/1
    , delete_portal_map/5
    , dispatch_execute/4
    , is_in_outside_scene/1
    , send_to_uid/3
    , send_to_scene/4
    , zone_dispatch_execute/7
    , get_next_activity_time/1
    , get_beings_gate_dungeon_id/0
    , update_zone_base/2]).

%% -----------------------------------------------------------------
%% @desc 更新活跃度（零点或登录）
%% @param Time      时间
%% @param Today     今日活跃度
%% @param Yesterday 昨日活跃度
%% @return {NewYesterday, NewToday, NewTime}
%% -----------------------------------------------------------------
get_new_activity(Time, Today, Yesterday) ->
    case utime:is_today(Time) of
        false -> NewYesterday = Today, NewToday = 0, NewTime = utime:unixtime();
        true -> NewYesterday = Yesterday, NewToday = Today, NewTime = Time
    end,
    {NewYesterday, NewToday, NewTime}.

%% -----------------------------------------------------------------
%% @desc 更新传送门Map
%% @param ZoneId     区Id
%% @param GroupId    组Id
%% @param Mod        模式
%% @param PortalMap  传送门Map
%% @param PortalData 传送门数据
%% @return NewPortalMap
%% -----------------------------------------------------------------
update_portal_map(ZoneId, GroupId, Mod, PortalMap, PortalData) ->
    PortalDataList = maps:get({ZoneId, GroupId, Mod}, PortalMap, []),
    NewPortalDataList = [PortalData | PortalDataList],
    maps:put({ZoneId, GroupId, Mod}, NewPortalDataList, PortalMap).

%% -----------------------------------------------------------------
%% @desc 删除传送门
%% @param ZoneId    区Id
%% @param GroupId   组Id
%% @param Mod       模式
%% @param PortalMap 传送门Map
%% @param Num       删除数量
%% @return NewPortalMap
%% -----------------------------------------------------------------
delete_portal_map(ZoneId, GroupId, Mod, PortalMap, Num) ->
    PortalDataList = maps:get({ZoneId, GroupId, Mod}, PortalMap, []),
    NewPortalDataList = lists:sublist(PortalDataList, Num),
    maps:put({ZoneId, GroupId, Mod}, NewPortalDataList, PortalMap).

%% -----------------------------------------------------------------
%% @desc 更新活跃度Map
%% @param ZoneId       区Id
%% @param GroupId      组Id
%% @param Mod          模式
%% @param ActivityMap  活跃度Map
%% @param ActivityData 需更新的活跃度记录
%% @return NewActivityMap
%% -----------------------------------------------------------------
update_activity_map(ZoneId, GroupId, Mod, ActivityMap, ActivityData) ->
    PortalDataList = maps:get({ZoneId, GroupId, Mod}, ActivityMap, []),
    NewActivityDataList = [ActivityData | PortalDataList],
    maps:put({ZoneId, GroupId, Mod}, NewActivityDataList, ActivityMap).

%% -----------------------------------------------------------------
%% @desc 创建传送门Id
%% @param ZoneId  区Id
%% @param GroupId 组Id
%% @param Mod     模式
%% @param Num     创建编号
%% @return PortalId
%% -----------------------------------------------------------------
create_portal_id(ZoneId, GroupId, Mod, Num) ->
    list_to_integer(lists:concat([ZoneId, GroupId, Mod, Num])).

%% -----------------------------------------------------------------
%% @desc 获得不重复的传送门坐标
%% @param PortalDataList 已生成的传送门列表
%% @return NewCfgXYList
%% -----------------------------------------------------------------
get_new_x_y(PortalDataList) ->
    F = fun(PortalData, XYList) ->
        #portal_data{x = X, y = Y} = PortalData,
        lists:delete({X, Y}, XYList)
    end,
    CfgXYList = lists:foldl(F, ?COORDINATES, PortalDataList),
    urand:list_rand(CfgXYList).

%% -----------------------------------------------------------------
%% @desc 派发函数
%% @param ServerId 服务器Id
%% @param M        模块
%% @param F        方法
%% @param A        参数
%% @return
%% -----------------------------------------------------------------
dispatch_execute(ServerId, M, F, A) ->
    ?IF(util:is_cls(), mod_clusters_center:apply_cast(ServerId, M, F, A), erlang:apply(M, F, A)).

%% -----------------------------------------------------------------
%% @desc 是否在野外场景或者主城
%% @param SceneId 场景Id
%% @return true | false
%% -----------------------------------------------------------------
is_in_outside_scene(SceneId) ->
    case data_scene:get(SceneId) of
        #ets_scene{type = SceneType} ->
            if
                SceneType == ?SCENE_TYPE_OUTSIDE orelse ?SCENE_TYPE_NORMAL -> true;
                true -> false
            end;
        _ -> false
    end.

%% -----------------------------------------------------------------
%% @desc 给id玩家信息
%% @param ServerId 服务器Id
%% @param RoleId   角色Id
%% @param BinData  数据
%% @return
%% -----------------------------------------------------------------
send_to_uid(ServerId, RoleId, BinData) ->
    ?IF(util:is_cls(),
        mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, BinData]),
        lib_server_send:send_to_uid(RoleId, BinData)).

%% -----------------------------------------------------------------
%% @desc 场景发送消息
%% @param ServerId 服务器Id
%% @param Sid      场景Id
%% @param PoolId   场景池Id
%% @param Bin      数据
%% @return
%% -----------------------------------------------------------------
send_to_scene(ServerId, Sid, PoolId, Bin) ->
    ?IF(util:is_cls(),
        mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_scene, [Sid, PoolId, Bin]),
        lib_server_send:send_to_scene(Sid, PoolId, Bin)).

%% -----------------------------------------------------------------
%% @desc 区域派发
%% @param GroupMap 组Map
%% @param ZoneId   区Id
%% @param ModNum   模式
%% @param GroupId  组Id
%% @param M        模块
%% @param F        方法
%% @param A        参数
%% @return
%% -----------------------------------------------------------------
zone_dispatch_execute(GroupMap, ZoneId, ModNum, GroupId, M, F, A) ->
    case util:is_cls() of
        true ->
            case maps:get(ZoneId, GroupMap, false) of
                false -> skip;
                {_, ZonesMap} ->
                    case maps:get({ModNum, GroupId}, ZonesMap, false) of
                        false -> skip;
                        ZoneList ->
                            [mod_clusters_center:apply_cast(ServerId, M, F, A)
                                || #zone_base{server_id = ServerId} <- ZoneList]
                    end
            end;
        false -> erlang:apply(M, F, A)
    end.

%% -----------------------------------------------------------------
%% @desc 获得下一次活动开始时间
%% @param Module
%% @return Time
%% -----------------------------------------------------------------
get_next_activity_time(Module) ->
    ActivityList = data_activitycalen:get_ac_list(),
    FA = fun({ModuleA, SubModuleA, AcSubA}, ModuleActivityList) ->
        ?IF(ModuleA =:= Module, [{ModuleA, SubModuleA, AcSubA} | ModuleActivityList], ModuleActivityList)
        end,
    NewModuleActivityList = lists:foldl(FA, [], ActivityList),
    FB = fun({ModuleB, SubModuleB, AcSubB}, ModuleActivityA) ->
        #base_ac{week = WeekList} = ModuleActivityB = data_activitycalen:get_ac(ModuleB, SubModuleB, AcSubB),
        NowWeek = utime:day_of_week(),
         ?IF(length(WeekList) =:= 0 orelse lists:member(NowWeek, WeekList), ModuleActivityB, ModuleActivityA)
        end,
    NewModuleActivity = lists:foldl(FB, [], NewModuleActivityList),
    {_NowDay, {NowH,NowM,_}} = calendar:local_time(),
    Now = NowH * 60 + NowM,
    ZeroAclock = utime:unixdate(),
    case NewModuleActivity of
        [] -> 0;
        #base_ac{time_region = TimeRegion} ->
            FC = fun({StartCfgTime, EndCfgTime}, Time) ->
                {SH, SM} = StartCfgTime,
                {EH, EM} = EndCfgTime,
                ETime = EH * 60 + EM,
                 if
                     Time =/= 0 -> Time;
                     Now < ETime -> ZeroAclock + SH * 3600 + SM * 60;
                     true -> 0
                 end
            end,
            NewTime = lists:foldl(FC, 0, TimeRegion),
            if
                NewTime =/= 0 -> NewTime;
                length(TimeRegion) =/= 0 ->
                    {{SHA, SMA}, {_EH, _EM}} = hd(TimeRegion),
                    (ZeroAclock + SHA * 3600 + SMA * 60) + ?ONE_DAY_SECONDS;
                true -> 0
            end
    end.

%% -----------------------------------------------------------------
%% @desc 获得副本Id
%% @param
%% @return DunId
%% -----------------------------------------------------------------
get_beings_gate_dungeon_id() ->
    ?IF(lib_clusters_node_api:is_cls_mod(?MOD_BEINGS_GATE), urand:list_rand(?DUNGEON_CENTER), urand:list_rand(?DUNGEON_LOCAL)).

%% -----------------------------------------------------------------
%% @desc 根据KVList更新ZoneBase
%% @param ZoneBase
%% @param KVList
%% @return NewZoneBase
%% -----------------------------------------------------------------
update_zone_base(ZoneBase, KVList) ->
    F = fun({Key, Value}, TempZoneBase) ->
        case Key of
            world_lv -> TempZoneBase#zone_base{world_lv = Value};
            open_time -> TempZoneBase#zone_base{time = Value};
            server_name -> TempZoneBase#zone_base{server_name = Value};
            % c_server_msg -> TempZoneBase#zone_base{c_server_msg = Value};
            _ -> TempZoneBase
        end
    end,
    lists:foldl(F, ZoneBase, KVList).