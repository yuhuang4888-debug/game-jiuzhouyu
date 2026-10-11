%%%------------------------------------
%%% @Module  : mod_clusters_center
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.10.29
%%% @Description: 跨服中心管理
%%%------------------------------------
-module(mod_clusters_center).
-behaviour(gen_server).
-export([
         start_link/0,
         add_node/1,
         %% apply_call/4,
         apply_cast/4,
         apply_to_all_node/3,
         apply_to_all_node/4,
         get_all_node/0,
         check_node_status/1,
         cast_node_restart/1
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("clusters.hrl").
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% 通过场景调用函数 - call(禁用这个方法，以免堵塞rpc进程)
%% apply_call(Node, Module, Method, Args) ->
%%     rpc:call(Node, Module, Method, Args).
%%     case catch gen:call(?MODULE, '$gen_call', {'apply_call', Node, Module, Method, Args}) of
%%        {ok, Res} ->
%%            Res;
%%        Reason ->
%%            ?ERR("ERROR mod_clusters_center apply_call/4 function: ~p Reason : ~p~n", [{Module, Method, Args}, Reason]),
%%            skip
%%     end.

%% 通过场景调用函数 - cast
apply_cast(SerId, Module, Method, Args) when is_integer(SerId) ->
    case lib_clusters_center:get_node(SerId) of
        undefined -> ?ERR("apply_cast false ~p~n", [[SerId, Module, Method, Args]]);
        Node -> rpc:cast(Node, Module, Method, Args)
    end;
apply_cast(Node, Module, Method, Args) ->
    rpc:cast(Node, Module, Method, Args).

%% 通知所有节点执行
apply_to_all_node(Module, Method, Args) ->
    gen_server:cast(?MODULE, {'apply_to_all_node', Module, Method, Args}).

%% 通知所有节点执行
%% SleepMs:毫秒
apply_to_all_node(Module, Method, Args, SleepMs) ->
    gen_server:cast(?MODULE, {'apply_to_all_node', Module, Method, Args, SleepMs}).

%% 添加跨服节点
add_node(AddNodeMsg) ->
    gen_server:cast(?MODULE, {add_node, AddNodeMsg}).

%% 获取所有节点
get_all_node() ->
    gen_server:call(?MODULE, {'get_all_node'}).

%% 检查跨服状态
check_node_status(Node) ->
    case rpc:call(Node, misc, whereis_name, [local, mod_online]) of
        Pid when is_pid(Pid) -> 1;
        _ -> 0
    end.

%% 通知重启
cast_node_restart(Node) ->
    case rpc:call(Node, init, restart, []) of
        ok -> 1;
        _ ->  0
    end.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    lib_clusters_center:clean_nodes(),
    {ok, #clusters_center{}}.

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
    %% ?ERR("mod_clusters_center is terminate:~p", [R]),
    ok.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.


%% 统一模块+过程调用(call)
do_call({'apply_call', SerId, Module, Method, Args}, _From, State) ->
    %% route路由表
    Data = case lib_clusters_center:get_node(SerId) of
               undefined ->
                   ?ERR("mod_clusters_center_call server_id:~p not find, {~p, ~p, ~p}", [SerId, Module, Method, Args]),
                   false;
               Node ->
                   rpc:call(Node, Module, Method, Args)
           end,
    {reply, Data, State};

%% 获取所有节点
do_call({'get_all_node'}, _From, State) ->
    {reply, State#clusters_center.node_list, State};

%% 默认匹配
do_call(Event, _From, Status) ->
    ?ERR("do_call not match: ~p", [Event]),
    {reply, ok, Status}.

%% 添加跨服节点
do_cast({add_node, AddNodeMsg}, State) ->
    #add_node_msg{game_node = Node, game_conn_pid = ConnPid, server_id = ServerId, merge_server_ids = MergeSerIds} = AddNodeMsg,
    F = fun(SerId) ->
        ets:insert(?ROUTE, #route{server_id=SerId, node=Node})
    end,
    lists:map(F, MergeSerIds),
    NodeList = case lists:keyfind(Node, #game_node.node, State#clusters_center.node_list) of
        false ->
            case catch lib_clusters_center_api:node_conn_center(AddNodeMsg, self()) of
                true   -> skip;
                _Other -> ?ERR("lib_clusters_center_api:node_conn_center SerId:~w, Node:~p error:~p~n", [ServerId, Node, _Other])
            end,
            lib_clusters_center:add_node(ServerId, Node),
            MRef = erlang:monitor(process, ConnPid),
            [#game_node{node=Node, m_ref=MRef, server_id=ServerId, merge_ids=MergeSerIds}|State#clusters_center.node_list];
         _ ->
            State#clusters_center.node_list
    end,
    {noreply, State#clusters_center{node_list=NodeList}};

%% 统一模块+过程调用(cast)
do_cast({'apply_cast', SerId, Module, Method, Args} , State) ->
    case lib_clusters_center:get_node(SerId) of
        undefined ->
            ?ERR("mod_clusters_center_cast server_id:~w not find, {~p, ~p, ~p}", [SerId, Module, Method, Args]);
        Node ->
            rpc:cast(Node, Module, Method, Args)
    end,
    {noreply, State};

%% 通知所有节点执行
do_cast({'apply_to_all_node', Module, Method, Args} , State) ->
    [ rpc:cast(GameNode#game_node.node, Module, Method, Args) || GameNode <- State#clusters_center.node_list],
    {noreply, State};

%% 通知所有节点
%% timeout延迟发送
do_cast({'apply_to_all_node', Module, Method, Args, TimeOut} , State) ->
    AllNode = State#clusters_center.node_list,
    spawn(
      fun() ->
              F = fun(#game_node{node=Node}) ->
                          rpc:cast(Node, Module, Method, Args),
                          timer:sleep(TimeOut)
                  end,
              [F(Node) || Node <- AllNode]
      end
     ),
    {noreply, State};

%% 默认匹配
do_cast(Event, State) ->
    ?ERR("do_cast not match: ~p", [Event]),
    {noreply, State}.

%% 游戏节点断开连接
do_info({'DOWN', MonitorRef, _Type, _Object, _Info}, #clusters_center{node_list=NodeList} = State) ->
    case lists:keyfind(MonitorRef, #game_node.m_ref, NodeList) of
        #game_node{node=Node, server_id=ServerId, merge_ids=MergeSerIds} ->
            ?PRINT("node ~w DOWN ~n", [Node]),
            case erlang:is_reference(MonitorRef) of
                true  -> erlang:demonitor(MonitorRef);
                false -> skip
            end,
            case catch lib_clusters_center_api:node_down_center(Node, ServerId, MergeSerIds) of
                true -> skip;
                _Other -> ?ERR("lib_clusters_center_api:node_down_center Node:~p error:~p~n", [Node, _Other])
            end,
            NL = lists:keydelete(MonitorRef, #game_node.m_ref, NodeList),
            Mspec = ets:fun2ms(fun(#route{node = TmpNode}) when TmpNode =:= Node -> true end),
            ets:select_delete(?ROUTE, Mspec),
            {noreply, State#clusters_center{node_list=NL}};
        _ ->
            {noreply, State}
    end;

%% 默认匹配
do_info(Info, State) ->
    ?ERR("do_info not match: ~p", [Info]),
    {noreply, State}.
