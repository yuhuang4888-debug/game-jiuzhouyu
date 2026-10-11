%% ---------------------------------------------------------------------------
%% @doc lib_zone
%% @author ming_up@foxmail.com
%% @since  2018-12-19
%% @deprecated 集群-游戏分区库函数
%% ---------------------------------------------------------------------------

-module(lib_zone).

-include("server.hrl").
-include("common.hrl").
-include("clusters.hrl").
-include("def_fun.hrl").

-export([
    ets_name/1, save_zone/2, save_zones/2, save_ets_zones/2
    , save_merge_ets_zones/2
]).

-export([ets_main_zone_name/1, save_ets_main_zone/1, save_ets_main_zone/3, update_main_world_lv/4]).

%% --------------------------------------------------------
%% 配置
%% --------------------------------------------------------


%% --------------------------------------------------------
%% clusters_zone
%% --------------------------------------------------------


%% ets表名字
ets_name(ZoneTypeId) ->
    list_to_atom(lists:concat(["clusters_zone_", ZoneTypeId])).

%% 回写
save_zone(ZoneType, ZoneBase) -> 
    #zone_base{
        server_id = ServerId, zone = Zone, time=Time, combat_power=CombatPower, merge_ids = _MergeIds, server_num = ServerNum, 
        server_name = ServerName, world_lv = WorldLv, active_type = ActiveType
        } = ZoneBase,
    ServerNameF = util:fix_sql_str(ServerName),
    SqlReplace  = io_lib:format(<<"replace into server_zone (`zone_type`, `server_id`, `zone`, `time`, `combat_power`, server_num, server_name, world_lv, active_type) values (~w,~w,~w,~w,~w,~w,'~s',~w,~w)">>, 
        [ZoneType, ServerId, Zone, Time, CombatPower, ServerNum, ServerNameF, WorldLv, ActiveType]),
    db:execute(SqlReplace).

%% 批量回写
save_zones(_ZoneType, []) -> ok;
save_zones(ZoneType, Zones) ->
    save_ets_zones(ZoneType, Zones),
    DataStr = format_bin_string(Zones, ZoneType, <<>>),
    SqlReplace  = io_lib:format(<<"replace into server_zone (`zone_type`, `server_id`, `zone`, `time`, `combat_power`, server_num, server_name, world_lv, active_type) values ~s">>, [DataStr]),
    db:execute(SqlReplace).

%% 内存写入
save_ets_zones(ZoneType, [H|T]) ->
    #zone_base{server_id = ServerId, zone = Zone, merge_ids = _MergeIds, world_lv = WorldLv} = H,
    % ?PRINT("ServerId:~p WorldLv:~p~n", [ServerId, WorldLv]),
    ets:insert(lib_zone:ets_name(ZoneType), #clusters_zone{server_id = ServerId, zone = Zone, world_lv = WorldLv}),
    save_ets_zones(ZoneType, T);
save_ets_zones(_, _) ->
    ok.

%% 内存写入(合服id列表)
save_merge_ets_zones(ZoneType, Zones) ->
    F = fun(#zone_base{zone = Zone, merge_ids = MergeIds, world_lv = WorldLv}, List) ->
        [#clusters_zone{server_id = MergeId, zone = Zone, world_lv = WorldLv}||MergeId<-MergeIds] ++ List
    end,
    List = lists:foldl(F, [], Zones),
    % ?MYLOG("zone", "save_merge_ets_zones List:~p ~n", [List]),
    % ?PRINT("save_merge_ets_zones Zones:~p List:~p~n", [Zones, List]),
    ets:insert(lib_zone:ets_name(ZoneType), List),
    ok.

%% sql语句封装
format_bin_string([H], ZoneType, ResultBin) ->
    #zone_base{server_id=ServerId, zone = Zone, time = Time, combat_power=CP, server_num = ServerNum, server_name = ServerName, world_lv = WorldLv, active_type = ActiveType} = H,
    ServerNameF = util:fix_sql_str(ServerName),
    list_to_binary([ ResultBin, io_lib:format(<<" (~w,~w,~w,~w,~w,~w,'~s',~w, ~w)">>, [ZoneType, ServerId, Zone, Time, CP, ServerNum, ServerNameF, WorldLv, ActiveType]) ]);
format_bin_string([H|T], ZoneType, ResultBin) ->
    #zone_base{server_id=ServerId, zone = Zone, time = Time, combat_power=CP, server_num = ServerNum, server_name = ServerName, world_lv = WorldLv, active_type = ActiveType} = H,
    ServerNameF = util:fix_sql_str(ServerName),
    ResultBin1 = list_to_binary([ ResultBin, io_lib:format(<<" (~w,~w,~w,~w,~w,~w,'~s',~w, ~w)">>, [ZoneType, ServerId, Zone, Time, CP, ServerNum, ServerNameF, WorldLv, ActiveType]), <<",">> ]),
    format_bin_string(T, ZoneType, ResultBin1);
format_bin_string(_, _, ResultBin) -> ResultBin.

%% --------------------------------------------------------
%% ets_main_zone
%% --------------------------------------------------------

%% ets区域名字
%% 以 zone_id 作为主键
ets_main_zone_name(ZoneTypeId) ->
    list_to_atom(lists:concat(["ets_main_zone_", ZoneTypeId])).

%% 初始化
save_ets_main_zone(ZonesMap) ->
    % ?MYLOG("zone", "save_ets_main_zone ~n", []),
    F = fun(ZoneTypeId, #zone_data{zones = ZoneBases, z2s_map = Z2SMap}, Acc) ->
        save_ets_main_zone(ZoneTypeId, ZoneBases, Z2SMap),
        Acc
    end,
    maps:fold(F, ok, ZonesMap).

save_ets_main_zone(ZoneTypeId, ZoneBases, Z2SMap) ->
    EtsName = ets_main_zone_name(ZoneTypeId),
    F = fun(ZoneId, Servers, Acc) ->
        F2 = fun(ServerId, MaxWorldLv) ->
            case lists:keyfind(ServerId, #zone_base.server_id, ZoneBases) of
                #zone_base{world_lv = WorldLv} -> ?IF(WorldLv > MaxWorldLv, WorldLv, MaxWorldLv);
                _ -> MaxWorldLv
            end
        end,
        MaxWorldLv = lists:foldl(F2, 0, Servers),
        % ?MYLOG("zone", "save_ets_main_zone ZoneId:~p MaxWorldLv:~p ~n", [ZoneId, MaxWorldLv]),
        ets:insert(EtsName, #ets_main_zone{zone_id = ZoneId, world_lv = MaxWorldLv}),
        Acc
    end,
    maps:fold(F, ok, Z2SMap).

%% 更新主zone的世界等级
update_main_world_lv(ZoneTypeId, ZoneId, ZoneBases, Z2SMap) ->
    % ?MYLOG("zone", "ZoneTypeId:~p ZoneId:~p ~n", [ZoneTypeId, ZoneId]),
    case maps:find(ZoneId, Z2SMap) of
        {ok, Servers} -> 
            F2 = fun(ServerId, MaxWorldLv) ->
            case lists:keyfind(ServerId, #zone_base.server_id, ZoneBases) of
                #zone_base{world_lv = WorldLv} -> ?IF(WorldLv > MaxWorldLv, WorldLv, MaxWorldLv);
                _ -> MaxWorldLv
            end
            end,
            MaxWorldLv = lists:foldl(F2, 0, Servers),
            ets:update_element(ets_main_zone_name(ZoneTypeId), ZoneId, {#ets_main_zone.world_lv, MaxWorldLv});
        _ -> 
            skip 
    end.