%% ---------------------------------------------------------------------------
%% @doc 看门狗服务API
%% @author hek
%% @since  2018-05-24
%% @deprecated 守家护院就靠watchdog啦，值得信赖的伙伴
%% ---------------------------------------------------------------------------
-module(lib_watchdog_api).
-include("common.hrl").
-include("server.hrl").
-include("watchdog.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-export([
    handle_event/2,
    add_monitor/2
]).

%% ------------------------------ 玩家事件回调 %% ------------------------------
%% 玩家上线
handle_event(PS, #event_callback{type_id = ?EVENT_ONLINE_FLAG, data = ?ONLINE_ON}) 
        when is_record(PS, player_status) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_ADD, ?WATCHDOG_LOGIN_PLAYER_CNT, 1),
    {ok, PS};
%% 玩家下线
handle_event(PS, #event_callback{type_id = ?EVENT_ONLINE_FLAG, data = ?ONLINE_OFF}) 
        when is_record(PS, player_status) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_ADD, ?WATCHDOG_LOGOUT_PLAYER_CNT, 1),
    {ok, PS};
handle_event(PS, _EC) ->
    {ok, PS}.

%% 服务器状态
add_monitor(Id = ?WATCHDOD_SERVER_STATUS, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 当前错误次数
add_monitor(Id = ?WATCHDOG_GAME_ERR_CNT, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 错误日志是否超过阀值
add_monitor(Id = ?WATCHDOG_GAME_ERR_OVERFLOW, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 日志服务恢复次数
add_monitor(Id = ?WATCHDOG_GAME_ERR_RESUME_CNT, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_ADD, Id, Value),
    ok;
%% 跨服连接状态
add_monitor(Id = ?WATCHDOG_CLUSTER_LINK_STATUS, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 当前活动列表
add_monitor(Id = ?WATCHDOD_OPENNING_ACT_LIST, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 0点日清时间
add_monitor(Id = ?WATCHDOG_MIDNIGHT_CLEAR, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 4点日清时间
add_monitor(Id = ?WATCHDOG_FOUR_CLEAR, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 在线人数
add_monitor(Id = ?WATCHDOG_ONLINE_PLAYER_CNT, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value),
    ok;
%% 场景对象数量
add_monitor(Id = ?WATCHDOG_ONLINE_OBJECT_CNT, Value) ->
    NewTimes = case get({?MODULE, update_online_objct_times}) of
        undefined -> 1;
        Times -> Times + 1
    end,
    put({?MODULE, update_online_objct_times}, NewTimes),
    case NewTimes rem 200 of
        0 -> mod_watchdog:add_monitor(?CTRL_TYPE_SET, Id, Value);
        _ -> skip
    end,
    ok;
%% db内存回收次数
add_monitor(Id = ?WATCHDOG_DB_GC_NUM, Value) ->
    mod_watchdog:add_monitor(?CTRL_TYPE_ADD, Id, Value),
    ok;
add_monitor(_Id, _Value) ->
    ok.

