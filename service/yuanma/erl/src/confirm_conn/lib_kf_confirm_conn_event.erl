%% ---------------------------------------------------------------------------
%% @doc lib_kf_confirm_conn_event.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2020-07-20
%% @deprecated 跨服确认链接的事件
%% ---------------------------------------------------------------------------
-module(lib_kf_confirm_conn_event).
-compile(export_all).

-include("common.hrl").

%% 跨服确认链接到本服(可能多次触发)
%% 注意:每次链接都会调用:跨服中心和本服中心断开重连、游戏服重启、跨服中心重启
confirm_conn(ServerId, Node, MergeServerIds, Optime, ServerName, ServerNum, MergeDay) ->
    % ?INFO("lib_bf_confirm_conn_event:confirm_conn ~n", []),
    mod_clusters_center:apply_cast(ServerId, mod_bf_confirm_conn, confirm_conn, []),
    %% ===== 跨服确认链接到本服的操作 =====
    %% 跨服1vn
    ?TRY_CATCH(mod_kf_1vN:sync_state(Node)),
    ?TRY_CATCH(mod_kf_1vN_auction:sync_auction_state(Node, 0)),
    ?TRY_CATCH(mod_sea_treasure_kf:center_connected(ServerId, MergeServerIds)),
    ?TRY_CATCH(mod_beings_gate_kf:beings_gate_sync_server_data(ServerId)),
    ?TRY_CATCH(mod_enchantment_guard_rank:center_connected(ServerId)),
    %% 增加MergeDay参数，为防止不是合服第一天时，有任一节点启动时都广播同步冲榜数据
    ?TRY_CATCH(mod_cycle_rank:center_connected(ServerId, Node, MergeServerIds, MergeDay)),
    ?TRY_CATCH(mod_night_ghost_kf:center_connected(ServerId)),
    ?TRY_CATCH(mod_great_demon:sync_server_data_to_game(ServerId, Optime)),
    true.
