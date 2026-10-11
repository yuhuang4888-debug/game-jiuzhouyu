%% ---------------------------------------------------------------------------
%% @doc lib_clusters_node_api
%% @author ming_up@foxmail.com
%% @since  2017-10-19
%% @deprecated 集群-游戏节点api
%% ---------------------------------------------------------------------------
-module(lib_clusters_node_api).

-include("common.hrl").
-include("clusters.hrl").
-include("def_module.hrl").

-export([
      center_connected/1
    , sync_zone_mod/1
    , pack_10200/1
    , server_info_change/2
    , get_zone_mod/1
    , get_avg_world_lv/1
    , get_next_avg_world_lv/1
    , is_cls_mod/1
    , get_zone_id/0
]).

%% 连接上跨服中心！
center_connected(CenterConnPid) ->
    mod_clusters_node:center_connected(CenterConnPid),
    lib_kf_guild_war_api:connect_center(),
    ?PRINT("CENTER CONNNECTED !~n", []),
    ok.

%% 同步分组情况
sync_zone_mod(ZoneModData) ->
    BinData = pack_10200(ZoneModData),
    ets:insert(ets_server_zone_mod, {zone_mod, ZoneModData}),
    lib_server_send:send_to_all(BinData).

pack_10200(ZoneModData) ->
    ServerId = config:get_server_id(),
    OpenDay = util:get_open_day(),
    #zone_mod_data{module_map = ModuleMap, servers = Servers} = ZoneModData,
    F = fun(ModuleId, GroupInfo, AccL) ->
        #zone_group_info{group_mod_servers = GroupModServers, server_group_map = ServerGroupMap} = GroupInfo,
        GroupId = maps:get(ServerId, ServerGroupMap, 0),
        #zone_mod_group_data{mod = Mod, server_ids = ServerIds, next_server_ids = NextServerIds, next_avg_lv = AvgLv} =
            ulists:keyfind(GroupId, #zone_mod_group_data.group_id, GroupModServers, #zone_mod_group_data{}),
        [{ModuleId, Mod, AvgLv, ServerIds, NextServerIds}|AccL]
        end,
    ModuleInfoL = maps:fold(F, [], ModuleMap),
    % 这两个模式暂时不统一#处理有点麻烦，客户端额外获取
    SendModuleInfoL = [Item||{ModuleId, _, _, _, _} = Item <-ModuleInfoL,
        ModuleId /= ?MOD_HOLY_SPIRIT_BATTLEFIELD andalso ModuleId =/= ?MOD_TERRITORY_WAR],
    ServerInfoSend = pack_server_info_10200(Servers),
    {ok, BinData} = pt_102:write(10200, [OpenDay, ServerInfoSend, SendModuleInfoL]),
    BinData.

pack_server_info_10200(ServerInfoL) ->
    %[{SerId, SerNum, SerName, CSerMsg, WorldLv}||#zone_base{server_id = SerId, server_num = SerNum, server_name = SerName, c_server_msg = CSerMsg, world_lv = WorldLv} <-ServerInfoL],
    [{SerId, SerNum, SerName, WorldLv}||#zone_base{server_id = SerId, server_num = SerNum, server_name = SerName, world_lv = WorldLv} <-ServerInfoL].

server_info_change(ServerId, KvList) ->
    case ets:lookup(ets_server_zone_mod, zone_mod) of
        [{zone_mod, ZoneModData}] ->
            #zone_mod_data{servers = Servers} = ZoneModData,
            NewServers =
                case lists:keyfind(ServerId, #zone_base.server_id, Servers) of
                    #zone_base{} = ServerZone ->
                        F = fun({Key, Val}, ZoneBase) ->
                            case Key of
                                server_name -> ZoneBase#zone_base{server_name = Val};
                                _ -> ZoneBase
                            end
                            end,
                        lists:keystore(ServerId, #zone_base.server_id, Servers, lists:foldl(F, ServerZone, KvList));
                    _ -> Servers
                end,
            NewZoneModData = ZoneModData#zone_mod_data{servers = NewServers},
            ets:insert(ets_server_zone_mod, {zone_mod, NewZoneModData}),
            BinData = pack_10200(NewZoneModData),
            lib_server_send:send_to_all(BinData);
        _ -> skip
    end.


%% 获取服务器分服模式
get_zone_mod(ModuleId) ->
    #zone_mod_group_data{mod = Mod} = get_zone_mod_group_data(ModuleId),
    Mod.

%% 获取平均世界等级
get_avg_world_lv(ModuleId) ->
    #zone_mod_group_data{avg_lv = AvgLv} = get_zone_mod_group_data(ModuleId),
    AvgLv.

get_zone_id() ->
    case ets:lookup(ets_server_zone_mod, zone_mod) of
        [{zone_mod, #zone_mod_data{zone_id = ZoneId}}] -> ZoneId;
        _ -> 0
    end.

%% 获取平均世界等级
get_next_avg_world_lv(ModuleId) ->
    #zone_mod_group_data{next_avg_lv = AvgLv} = get_zone_mod_group_data(ModuleId),
    AvgLv.

%% 是否跨服模式
is_cls_mod(ModuleId) ->
    get_zone_mod(ModuleId) =/= 1.

get_zone_mod_group_data(ModuleId) ->
    case ets:lookup(ets_server_zone_mod, zone_mod) of
        [{zone_mod, ZoneModData}] ->
            #zone_mod_data{module_map = ModuleMap} = ZoneModData,
            case maps:get(ModuleId, ModuleMap, false) of
                #zone_group_info{server_group_map = ServerGroupMap, group_mod_servers = GroupModServers} ->
                    GroupId = maps:get(config:get_server_id(), ServerGroupMap, 0),
                    ulists:keyfind(GroupId, #zone_mod_group_data.group_id, GroupModServers, #zone_mod_group_data{avg_lv = util:get_world_lv()});
                _ -> #zone_mod_group_data{avg_lv = util:get_world_lv()}
            end;
        _ -> #zone_mod_group_data{avg_lv = util:get_world_lv()}
    end.
