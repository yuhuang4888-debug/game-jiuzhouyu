%%%------------------------------------
%%% @Module  : mod_clusters_node
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.10.29
%%% @Description: 跨服客户端管理
%%%------------------------------------
-module(mod_clusters_node).
-behaviour(gen_server).
-export([
         start_link/0,
         get_link_state/0,
         apply_cast/3,
         apply_call/3,
         set_center_info/0,
         set_center_info/2,
         center_connected/1,
         server_name_change/0
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("clusters.hrl").
-include("record.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("watchdog.hrl").

%% 跨服节点调用跨服中心函数
%% 小跨服，放开限制
apply_call(Module, Method, Args) ->
    Node = mod_disperse:get_clusters_node(),
    case Node =/= none of
        true ->
            case catch rpc:call(Node, gen_server, call, [?MODULE, {'apply_call', Module, Method, Args}]) of
                {badrpc, Reason} ->
                    ?ERR("ERROR mod_clusters_node apply_call/4 function: ~p Reason : ~p~n", [{Module, Method, Args}, Reason]),
                    none;
                Data ->
                    Data
            end;
        false ->
            none
    end.

%% 跨服节点调用跨服中心函数 - cast
apply_cast(Module, Method, Args) ->
    Node = mod_disperse:get_center_node(),
    case Node =/= none of
        true ->
            rpc:cast(Node, Module, Method, Args);
        false ->
            ?ERR("apply_cast_none ~p~n", [[Module, Method, Args, Node]]),
            none
    end.

%% 跨服链接
center_connected(CenterConnPid) ->
    gen_server:cast(?MODULE, {center_connected, CenterConnPid}).

%% 获取连接状态
get_link_state() ->
    gen_server:call(?MODULE, {get_link_state}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

set_center_info() ->
    {CenterNode, Cookie, _Ip, _Port} = config:get_cls_info(),
    set_center_info(CenterNode, Cookie).

set_center_info(CenterNode, CenterCookie) ->
    gen_server:call(?MODULE, {'set_center_info', CenterNode, CenterCookie}).

server_name_change() ->
    gen_server:cast(?MODULE, {'server_name_change'}).

init([]) ->
    process_flag(trap_exit, true),
    {CenterNode, Cookie, Ip, Port} = config:get_cls_info(),
    Cn = #clusters_node{
        center_node = CenterNode,
        server_id = config:get_server_id(),
        merge_server_ids = config:get_merge_server_ids(),
        optime = util:get_open_time(),
        server_name = util:get_server_name(),
        server_num = config:get_server_num(),
        link = ?CLUSTER_LINK_CLOSE,
        active_type = lib_server_kv:get_server_active()
       },
    erlang:set_cookie(CenterNode, Cookie), % 节点cookie相同才能ping通
    net_adm:ping(CenterNode), %% 进程启动连接跨服中心(建立tcp连接,后续才能继续通信)
    erlang:send_after(3000, self(), 'ping_center'),
    mod_disperse:rpc_node_add(?CLUSTERS_NODE_ID, CenterNode, Ip, Port, 0, Cookie, ""),
    lib_watchdog_api:add_monitor(?WATCHDOG_CLUSTER_LINK_STATUS, ?CLUSTER_LINK_CLOSE),
    init_zone_mod_ets(),
    {ok, Cn}.

handle_cast(R , State) ->
    case catch do_cast(R, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_cast error: ~p, Reason:=~p~n",[R, Reason]),
            {noreply, State}
    end.

handle_call(R, From, State) ->
    case catch do_call(R , From, State) of
        {reply, NewFrom, NewState} ->
            {reply, NewFrom, NewState};
        Reason ->
            ?ERR("handle_call error: ~p, Reason=~p~n",[R, Reason]),
            {reply, error, State}
    end.

handle_info(R, State) ->
    case catch do_info(R, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("handle_info error: ~p, Reason:=~p~n",[R, Reason]),
            {noreply, State}
    end.

terminate(_R, _State) ->
    ?ERR("mod_clusters_node is terminate:~p", [_R]),
    ok.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.


%% 获取连接状态
do_call({get_link_state}, _From, State) ->
    {reply, State#clusters_node.link, State};

%% 统一模块+过程调用(call)
do_call({'apply_call', Module, Method, Args}, _From, State) ->
    {reply, rpc:call(State#clusters_node.center_node, Module, Method, Args), State};

do_call({'set_center_info', CenterNode, CenterCookie}, _From, State) ->
    {_, _, Ip, Port} = config:get_cls_info(),
    Cn = State#clusters_node{center_node = CenterNode},
    erlang:set_cookie(CenterNode, CenterCookie),
    Res = net_adm:ping(CenterNode),
    mod_disperse:rpc_node_add(?CLUSTERS_NODE_ID, CenterNode, Ip, Port, 0, CenterCookie, ""),
    %% 加上链接返回值
    {reply, {true, Res}, Cn};

%% 默认匹配
do_call(Event, _From, State) ->
    ?ERR("do_call not match: ~p", [Event]),
    {reply, ok, State}.

%% 连接上跨服中心
do_cast({center_connected, CenterConnPid}, State) ->
    MRef = erlang:monitor(process, CenterConnPid),
    {Node, Cookie, Ip, Port} = config:get_cls_info(),
    mod_disperse:rpc_node_add(?CLUSTERS_NODE_ID, Node, Ip, Port, 0, Cookie, ""),
    lib_watchdog_api:add_monitor(?WATCHDOG_CLUSTER_LINK_STATUS, ?CLUSTER_LINK_CONNECTED),
    mod_bf_confirm_conn:center_connected(),
    ?PRINT("center_connected !~n", []),
    {noreply, State#clusters_node{link = ?CLUSTER_LINK_CONNECTED, m_ref = MRef}};

do_cast({server_name_change}, State) ->
    NewState = State#clusters_node{
        server_name = util:get_server_name()
    },
    {noreply, NewState};

%% 默认匹配
do_cast(Event, State) ->
    ?ERR("do_cast not match: ~p", [Event]),
    {noreply, State}.

%% 连接跨服中心
do_info('ping_center', State) ->
    %% 重连本地节点
    mod_disperse:reconnect_node(),
    % 会动态变化
    WorldLv = util:get_world_lv(),
    ServerCombatPower = lib_common_rank_api:server_combat_power_10(),
    #clusters_node{
        center_node = CenterNode, optime = OpTime, merge_server_ids = MergeSerIds,
        server_num = SerNum, server_id = SerId, server_name = SerName,
        active_type = ActiveType
    } = State,
    %% 重连跨服中心
    AddNodeMsg = #add_node_msg{
        game_node = node(), game_conn_pid = self(), server_id = SerId, open_time = OpTime, merge_server_ids = MergeSerIds,
        server_num = SerNum, server_name = SerName, world_lv = WorldLv, server_combat_power = ServerCombatPower
    },
    rpc:cast(CenterNode, mod_clusters_center, add_node, [AddNodeMsg]),
    erlang:send_after(?CONNECT_CENTER_TIME, self(), 'ping_center'),
    {noreply, State};

%% 跨服中心连接断开
do_info({'DOWN', MonitorRef, _Type, _Obj, _Reason}, #clusters_node{m_ref=MonitorRef, link=?CLUSTER_LINK_CONNECTED} = State) ->
    case erlang:is_reference(MonitorRef) of
        true -> erlang:demonitor(MonitorRef);
        false -> skip
    end,
    lib_online:apply_cast_to_onlines(lib_player_event, dispatch, [?EVENT_CLS_SHUTDOWN]),
    lib_watchdog_api:add_monitor(?WATCHDOG_CLUSTER_LINK_STATUS, ?CLUSTER_LINK_CLOSE),
    mod_bf_confirm_conn:cluster_link_close(),
    ?PRINT(" center DOWN ~p~n", [_Reason]),
    {noreply, State#clusters_node{m_ref=undefined, link=?CLUSTER_LINK_CLOSE}};

%% 默认匹配
do_info(Info, State) ->
    ?ERR("do_info not match: ~p", [Info]),
    {noreply, State}.

%% 初始化分服模式ets
init_zone_mod_ets() ->
    ets:new(ets_server_zone_mod, [named_table, public, set]).
