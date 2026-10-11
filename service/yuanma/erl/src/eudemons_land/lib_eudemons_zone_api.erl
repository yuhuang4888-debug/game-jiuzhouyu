%%%-------------------------------------------------------------------
%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%% 幻兽之域 分区
%%% @end
%%% Created : 27 Oct 2017 by root <root@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(lib_eudemons_zone_api).

-compile(export_all).

-include("common.hrl").
-include("chat.hrl").
-include("eudemons_land.hrl").
-include("def_fun.hrl").
-include("eudemons_zone.hrl").

%% Api 回调
%% 游戏服连接跨服后回调
%% Type ： old:已分配过的服, new:新服
sync_server_data(_Type, _ServerId, _State) -> 
    % #eudemons_zone_mgr{next_reset_time = NextResetTime, server_map = ServerMap, zone_map = ZoneMap} = State,
    % ZoneId = mod_eudemons_land_zone:get_zone_id(ServerId, ServerMap),
    % ServerList = mod_eudemons_land_zone:get_same_zone_servers(ZoneId, ZoneMap, ServerMap),
    % %% 同步圣兽领的boss信息
    % mod_eudemons_land:sync_server_data(ServerId, ServerMap, ZoneMap),
    % %% 同步游戏服的服务器列表
    % case Type of
    %     old ->
    %         mod_clusters_center:apply_cast(ServerId, mod_eudemons_land_zone_local, sync_server_data, [ZoneId, NextResetTime, ServerList]);
    %     _ ->
    %         [mod_clusters_center:apply_cast(SerId, mod_eudemons_land_zone_local, sync_server_data, [ZoneId, NextResetTime, ServerList]) || #eudemons_server{server_id = SerId} <- ServerList]
    % end,
    ok.

%% 获取分区id
get_zone_id(ServerId) ->
    case catch ets:lookup(eudemons_zone, ServerId) of
        [#eudemons_zone{zone_id = ZoneId}] -> ZoneId;
        _R -> 
            ?ERR("get_zone_id fail server_id=~w, Reason=~p~n", [ServerId, _R]), 
            0
    end.

%% 预告重置
reset_pre(_AnnounceTime) ->
    ok.

%% 开始重置区域
reset_start(_State) -> 
    % #eudemons_zone_mgr{reset_etime = ResetETime, next_reset_time = NextResetTime} = State,
    % mod_eudemons_land:reset_start(ResetETime, NextResetTime),
    % mod_clusters_center:apply_to_all_node(mod_eudemons_land_zone_local, reset_start, [ResetETime]),
    ok.

%% 正在重置区域(游戏服第一次连接，处于重置状态时进行的回调)
in_reset(_ServerId, _State) ->
    % #eudemons_zone_mgr{reset_etime = ResetETime, next_reset_time = _NextResetTime} = State,
    % mod_clusters_center:apply_cast(ServerId, mod_eudemons_land_zone_local, in_reset, [ResetETime]),
    ok.

%% 重置区域结束
reset_end(_State) -> 
    % #eudemons_zone_mgr{next_reset_time = NextResetTime, server_map = ServerMap, zone_map = ZoneMap} = State,
    % mod_eudemons_land:reset_end(NextResetTime, ServerMap, ZoneMap),
    % %% 将同区域的服务器同步到游戏服
    % apply_cast_all_node_info(NextResetTime, ServerMap, ZoneMap),
    ok.

%% 增加一个新区域
add_new_zone(_NewZoneId, _State) ->
    % mod_eudemons_land:add_new_zone(NewZoneId),
    ok.

%% 区域更改
zone_change(_SerId, _OZoneId, _NewZoneId) ->
    ok.

%%-- 游戏服 获取服务器的基本信息
get_server_info_local() ->
    % spawn(
    %     fun() ->
    %         timer:sleep(60000), %% 睡眠一分钟，游戏服连上跨服时，尽量确保排行榜进程初始完
    %         Power = lib_common_rank_api:server_combat_power_10(),
    %         ServerId = config:get_server_id(),
    %         Node = node(),
    %         ServerNum = config:get_server_num(),
    %         ServerName = util:get_server_name(),
    %         OpTime = util:get_open_time(),
    %         MergeServerIds = config:get_merge_server_ids(),
    %         ?PRINT("get_server_info_local succ Power ~p~n", [Power]),
    %         mod_clusters_node:apply_cast(mod_eudemons_land_zone, add_server_in_eudemons,
    %                                             [ServerId, Node, ServerNum, ServerName, Power, OpTime, MergeServerIds])
    %     end),
    ok.

%%--- private
%% 跨服聊天状态广播
apply_cast_all_node_info(_NextResetTime, _ServerMap, _ZoneMap) ->
    % F = fun(ZoneId, SerList, L) ->
    %     FI = fun(SerId, L1) ->
    %         case maps:get(SerId, ServerMap, false) of 
    %             #eudemons_server{} = EudemonsServer -> [EudemonsServer|L1];
    %             _ -> L1
    %         end
    %     end,
    %     ServerList = lists:foldl(FI, [], SerList),
    %     [{ZoneId, ServerList}|L]
    % end,
    % LastL = maps:fold(F, [], ZoneMap),
    % spawn(fun() ->
    %     [begin
    %         [ mod_clusters_center:apply_cast(SerId, mod_eudemons_land_zone_local, reset_end, [ZId, NextResetTime, List]) || #eudemons_server{server_id = SerId} <- List],
    %         timer:sleep(100)
    %     end||{ZId, List} <- LastL]
    % end),
    ok.