%% ---------------------------------------------------------------------------
%% @doc lib_clusters_api
%% @author ming_up@foxmail.com
%% @since  2017-08-23
%% @deprecated 跨服集群接口模块
%% ---------------------------------------------------------------------------
-module(lib_clusters_center_api).

-include("common.hrl").
-include("clusters.hrl").
-include("def_module.hrl").

-export([
        node_conn_center/2,
        node_down_center/3,
        update/2,
        get_zone/1,
        get_zone/2,
        get_world_lv/1,
        get_world_lv/2,
        get_max_world_lv/1,
        zone_change/4,
        start_recalc_all_zone/0,
        end_recalc_all_zone/0,
        sync_zone_group/1,
        sync_zone_change/4
    ]).

%% 节点(Node)连接上跨服中心
%% 各个功能可以同步状态
node_conn_center(AddNodeMsg, CenterConnPid) ->
    #add_node_msg{
        game_node = Node, server_id = ServerId, open_time = OpTime, merge_server_ids = MergeSerIds,
        server_num = ServerNum, server_name = ServerName, world_lv = WorldLv,
        server_combat_power = ServerCombatPower, active_type = ActiveType
    } = AddNodeMsg,
    %% 手动分区(部分功能根据对应的服分区生成活动数据)
    % ServerCombatPower = lib_common_rank_api:server_combat_power_10(),
    ?PRINT("ServerNum:~p, ServerName:~p, WorldLv:~p, ServerCombatPower:~p MergeSerIds:~p ~n",
        [ServerNum, ServerName, WorldLv, ServerCombatPower, MergeSerIds]),
    mod_zone_mgr:add_zone(ServerId, OpTime, MergeSerIds, ServerNum, ServerName, WorldLv, ServerCombatPower, ActiveType),
    mod_zone_mod:center_connected(ServerId, MergeSerIds),
    mod_clusters_center:apply_cast(Node, lib_clusters_node_api, center_connected, [CenterConnPid]),
    %% 分区玩法数据在确定分区之后才同步到游戏服:具体代码位置在mod_zone_mgr:do_sync_zone_func_data/1,
    %% 幻兽功能
    %% mod_eudemons_land:sync_eudemons_boss_info(ServerId, Node, 1), %% 1强制更新
    mod_void_fam:sync_act_status(Node),
    %mod_diamond_league_ctrl:sync_act_status(Node),
    mod_eudemons_land:sync_server_data(ServerId, OpTime),
    mod_eudemons_land:handle_merge_server(ServerId, MergeSerIds),
    %mod_c_sanctuary:center_connected(ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds),
    mod_sanctuary_cluster_mgr:center_connected(ServerId, MergeSerIds),
    mod_holy_spirit_battlefield:center_connected(ServerId, OpTime, WorldLv, ServerNum, ServerName, MergeSerIds),
    mod_custom_act_kf:apply_cast(sync_server_data, [ServerId]),
    mod_decoration_boss_center:center_connected(ServerId, MergeSerIds, OpTime),
    mod_territory_war:center_connected(ServerId, MergeSerIds),
    mod_escort_kf:center_connected(ServerId, ServerNum, MergeSerIds),
    mod_kf_sell:center_connected(ServerId, MergeSerIds),
    mod_clusters_center:apply_cast(ServerId, lib_3v3_local, sync_server_data, []),  %% 同步本地的战队到跨服
%%    mod_kf_seacraft:center_connected(ServerId, OpTime, ServerNum, ServerName, MergeSerIds),
    mod_cluster_luckey_value:center_connected(ServerId, MergeSerIds),
    % 跨服1vn
    mod_kf_1vN:sync_state(Node),
    % 跨服掉落限制记录
    mod_drop_statistics:server_merge(ServerId, MergeSerIds),
    %% id自增
    mod_id_create_cls:node_conn(ServerId),
    true.

%% 游戏节点断开连接
%% @param MergeSerIds 合服列表id(包括主服id)
node_down_center(_Node, _ServerId, _MergeSerIds) ->
    mod_sea_treasure_kf:node_down(_MergeSerIds),
    ?PRINT("_Node:~p, _ServerId:~p, _MergeSerIds:~p ~n", [_Node, _ServerId, _MergeSerIds]),
    true.

%% 数据更新
%% {world_lv, WorldLv}:世界等级
%% {combat_power, CombatPower}:服前十的战力
update(ServerId, KvList) ->
    mod_zone_mgr:update_server(ServerId, KvList),
    do_update(KvList, ServerId),
    mod_zone_mgr:kf_sanctum_init(),
    ok.

%% 更新同步
do_update([], _ServerId) -> skip;
do_update([{world_lv, _WorldLv}|T], ServerId) ->
    %mod_c_sanctuary:server_info_chage(ServerId, [{world_lv, _WorldLv}]),
    mod_sanctuary_cluster_mgr:server_info_change(ServerId, [{world_lv, _WorldLv}]),
    mod_sea_treasure_kf:server_info_chage(ServerId, [{world_lv, _WorldLv}]),
    mod_night_ghost_kf:server_info_change(ServerId, [{world_lv, _WorldLv}]),
    do_update(T, ServerId);
do_update([{server_active, _}|T], ServerId) ->
    do_update(T, ServerId);
do_update([{combat_power, _CombatPower}|T], ServerId) ->
    do_update(T, ServerId);
do_update([{open_time, _OpenTime}|T], ServerId) ->
    mod_cluster_luckey_value:server_info_change(ServerId, [{open_time, _OpenTime}]),
    %mod_c_sanctuary:server_info_chage(ServerId, [{open_time, _OpenTime}]),
    mod_sanctuary_cluster_mgr:server_info_change(ServerId, [{open_time, _OpenTime}]),
    mod_activation_draw_kf:server_info_chage(ServerId, [{open_time, _OpenTime}]),
    mod_sea_treasure_kf:server_info_chage(ServerId, [{open_time, _OpenTime}]),
    do_update(T, ServerId).

%% 获取服务器所在区域
%% @return: integer
get_zone(ServerId) -> get_zone(?ZONE_TYPE_1, ServerId).
get_zone(ZoneTypeId, ServerId) ->
    case catch ets:lookup(lib_zone:ets_name(ZoneTypeId), ServerId) of
        [#clusters_zone{zone = ZoneId}] -> ZoneId;
        _R ->
            % tool:back_trace_to_file(),
            % ?ERR("get_zone fail server_id=~w, Reason=~p~n", [ServerId, _R]),
            0
    end.

%% 开服第二天才有,可以检查一下
% get_zone_(OpTime, ServerId) ->


%% 获取服务器所在区域
%% @return: integer
get_world_lv(ServerId) -> get_world_lv(?ZONE_TYPE_1, ServerId).
get_world_lv(ZoneTypeId, ServerId) ->
    case catch ets:lookup(lib_zone:ets_name(ZoneTypeId), ServerId) of
        [#clusters_zone{world_lv = WorldLv}] -> WorldLv;
        _R ->
            % ?ERR("get_world_lv fail server_id=~w, Reason=~p~n", [ServerId, _R]),
            0
    end.

%% 获取服务器所在区域
%% @return: integer
get_max_world_lv(ZoneId) -> get_max_world_lv(?ZONE_TYPE_1, ZoneId).
get_max_world_lv(ZoneTypeId, ZoneId) ->
    case catch ets:lookup(lib_zone:ets_main_zone_name(ZoneTypeId), ZoneId) of
        [#ets_main_zone{world_lv = WorldLv}] -> WorldLv;
        _R ->
            % ?ERR("get_max_world_lv fail zone_id=~w, Reason=~p~n", [ZoneId, _R]),
            0
    end.

%% 区域更改回调接口
%% ZoneType = 1, 8服分区
%% 新服分区OldZone=0
zone_change(?ZONE_TYPE_1, ServerId, OldZone, NewZone) ->
    ?PRINT("zone change zonetype:~w, server_id:~w, ~w->~w~n", [?ZONE_TYPE_1, ServerId, OldZone, NewZone]),
    lib_log_api:log_zone_change(ServerId, NewZone, OldZone),
    mod_race_act:zone_change(ServerId, OldZone, NewZone), %% 竞榜活动
    mod_rush_treasure_kf:zone_change(ServerId, OldZone, NewZone), %% 冲榜夺宝
    %mod_c_sanctuary:zone_change(ServerId, OldZone, NewZone),
    % mod_feast_cost_rank_clusters:zone_change(ServerId, OldZone, NewZone), %% 跨服消费
    mod_eudemons_land:zone_change(ServerId, OldZone, NewZone),
    mod_kf_flower_act:zone_change(ServerId, OldZone, NewZone),
    mod_activation_draw_kf:zone_change(ServerId, OldZone, NewZone),
    mod_escort_kf:zone_change(ServerId, OldZone, NewZone),
    mod_kf_chrono_rift:zone_change(ServerId, OldZone, NewZone),
    mod_kf_seacraft:zone_change(ServerId, OldZone, NewZone),
    mod_kf_seacraft_daily:zone_change(ServerId, OldZone, NewZone),
    mod_kf_auction:zone_change(OldZone, NewZone),
    mod_kf_sell:zone_change(OldZone, NewZone),
    mod_sea_treasure_kf:zone_change(ServerId, OldZone, NewZone),
    mod_dragon_language_boss:zone_change(ServerId, OldZone, NewZone),
    mod_great_demon:zone_change(ServerId, OldZone, NewZone),
    ok;
zone_change(_ZoneType, _ServerId, _OldZone, _NewZone) ->
    ?PRINT("zone change unknow zonetype:~w, server_id:~w, ~w->~w~n", [_ZoneType, _ServerId, _OldZone, _NewZone]),
    ok.

%% 重新分小跨服开始
start_recalc_all_zone() ->
    mod_eudemons_land:reset_start(),
    mod_decoration_boss_center:reset_start(),
    mod_kf_seacraft_daily:zone_reset_start(),
    mod_great_demon:start_zone_change(),
    ok.

%% 重新分小跨服结束
end_recalc_all_zone() ->
    mod_eudemons_land:reset_end(),
    mod_decoration_boss_center:reset_end(),
    mod_zone_mgr:sanctuary_kf_init(),
    mod_zone_mgr:treasure_hunt_init(),
    mod_zone_mgr:kf_sanctum_init(),
    mod_zone_mgr:activation_draw_init(),
    mod_race_act:reset_end(),
    mod_zone_mgr:kf_escort_init(),
    mod_zone_mgr:seacraft_init(2),
    mod_kf_seacraft_daily:end_recalc_all_zone(),
    mod_zone_mgr:common_get_info(mod_sea_treasure_kf, init_after, []),
    mod_kf_chrono_rift:re_load(),
    mod_sys_sell:daily_timer(),
    mod_great_demon:end_zone_change(),
    ok.


%% --------------------------------------
%% 同步分组信息到各个跨服功能模块
%% @param ModuleId 功能ID 见 def_module.hrl 定义
%% @param InfoList 分组信息 [{ZoneId, {Servers, #zone_group_info{}}|_]
sync_zone_group({ModuleId, InfoList}) ->
    % ?PRINT("{ModuleId, InfoList} ~p ~n", [{ModuleId, InfoList}]),
    case ModuleId of
        ?MOD_NINE ->
            mod_nine_center:sync_zone_group(InfoList);
        ?MOD_C_SANCTUARY ->
            mod_sanctuary_cluster_mgr:sync_zone_group(InfoList);
        ?MOD_TERRITORY_WAR ->
            mod_territory_war:sync_zone_group(InfoList);
        ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
            % mod_holy_spirit_battlefield:sync_zone_group(InfoList),
            mod_holy_spirit_battlefield:re_alloc_group();
        ?MOD_GUILD_ACT ->
            mod_kf_guild_feast_topic:sync_zone_group(InfoList);
        ?MOD_BEINGS_GATE ->
            mod_beings_gate_kf:sync_zone_group(InfoList);
        ?MOD_ENCHANTMENT_GUARD ->
            mod_enchantment_guard_rank:sync_zone_group(InfoList);
        ?MOD_NIGHT_GHOST ->
            mod_night_ghost_kf:sync_zone_group(InfoList);
        _ ->
            skip
    end.


%% 小跨服分区修改后分组 ,分组信息同步到对应的服，再相应处理
%% 注：该函数InfoList仅含被修改的分区信息，不要直接同步覆盖原有信息
%% @param ModuleId 功能ID 见 def_module.hrl 定义
%% @param InfoList 分组信息 [{ZoneId, {Servers, #zone_group_info{}}|_]
%% @param ChangeSerId 被调整分区的服务器ID
%% @param OldZoneId 被调整分区的服务器旧的分区ID
%% @param NewZoneId 被调整分区的服务器新的分区ID
sync_zone_change({ModuleId, InfoList}, ChangeSerId, OldZoneId, NewZoneId) ->
    {_, OZoneGroupInfo} = lists:keyfind(OldZoneId, 1, InfoList),
    {_, NZoneGroupInfo} = lists:keyfind(NewZoneId, 1, InfoList),
    case ModuleId of
        % ?MOD_NINE ->
        %     mod_nine_center:sync_zone_group(InfoList);
        ?MOD_C_SANCTUARY ->
            mod_sanctuary_cluster_mgr:zone_change(ChangeSerId, OldZoneId, OZoneGroupInfo, NewZoneId, NZoneGroupInfo);
        % ?MOD_TERRITORY_WAR ->
        %     mod_territory_war:sync_zone_group(InfoList);
        ?MOD_HOLY_SPIRIT_BATTLEFIELD ->
            mod_holy_spirit_battlefield:re_alloc_group();
        % ?MOD_GUILD_ACT ->
        %     mod_kf_guild_feast_topic:sync_zone_group(InfoList);
        % ?MOD_BEINGS_GATE ->
        %     mod_beings_gate_kf:sync_zone_group(InfoList);
        % ?MOD_ENCHANTMENT_GUARD ->
        %     mod_enchantment_guard_rank:sync_zone_group(InfoList);
        % ?MOD_NIGHT_GHOST ->
        %     mod_night_ghost_kf:sync_zone_group(InfoList);
        _ ->
            skip
    end.



