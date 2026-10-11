%%%------------------------------------
%%% @Module  : mod_disperse
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2011.06.24
%%% @Description: 线路分布式管理
%%%------------------------------------
-module(mod_disperse).
-behaviour(gen_server).
-export([
         start_link/1,
         rpc_node_add/7,
         node_id/0,
         node_list/0,
         node_all_list/0,
         rpc_node_hide/1,
         rpc_node_show/1,
         cast_to_hide/0,
         cast_to_show/0,
         rpc_cast_by_id/4,
         rpc_call_by_id/4,
         send_other_server/3,
         call_to_unite/3,
         cast_to_unite/3,
         get_clusters_node/0,
         reconnect_node/0,
         get_center_node/0
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("unite.hrl").
-include("record.hrl").
-include("server.hrl").
-include("common.hrl").
-record(state, {
    id,
    ip,
    port,
    sslport,
    node,
    cookie,
    lburl
}).

%%隐藏线路
cast_to_hide() ->
    Sid = node_id(),
    case db:get_all(<<"select `node` from node">>) of
        [] -> [];
        Server ->
            db:execute(io_lib:format(<<"update `node` set `state` = 1 where id = ~p">>,[Sid])),
            F = fun(Node) ->
                Node1 = list_to_atom(binary_to_list(Node)),
                case net_kernel:connect_node(Node1) of
                    true  -> catch rpc:cast(Node1, mod_disperse, rpc_node_hide, [Sid]);
                    false -> ok
                end
            end,
            [F(Node) || [Node] <- Server]
    end.

%%显示线路
cast_to_show() ->
    Sid = node_id(),
    db:execute(io_lib:format(<<"update `node` set `state` = 0 where id = ~p">>,[Sid])),
    case db:get_all(<<"select `node` from node">>) of
        [] -> [];
        Server ->
            F = fun(Node) ->
                Node1 = list_to_atom(binary_to_list(Node)),
                case net_adm:connect_node(Node1) of
                    true -> catch rpc:cast(Node1, mod_disperse, rpc_node_show, [Sid]);
                    false -> ok
                end
            end,
            [F(Node) || [Node] <- Server]
    end.

%% 查询当前节点ID号
%% 返回:int()
node_id() ->
    case catch gen:call(?MODULE, '$gen_call', get_node_id) of
        {ok, Res} ->
            Res;
        _ ->
            0
    end.

%% 节点重连
reconnect_node() ->
    case misc:get_global_pid(mod_online) of
        Pid when is_pid(Pid) ->
            skip;
        _ ->
            List = node_all_list(),
            %% [erlang:disconnect_node(N#node.node) || N <-List],
            [net_adm:ping(N#node.node) || N <-List]
    end.

%% 获取所有游戏节点的列表
%% 返回:[#node{} | ...]
node_list() ->
    Node = ets:tab2list(?ETS_NODE),
    [S || S <- Node, S#node.id >= 10].

%% 获取所有连接的节点的列表
%% 返回:[#node{} | ...]
node_all_list() ->
    Node = ets:tab2list(?ETS_NODE),
    [S || S <- Node].

%% 接收其它节点的加入信息
rpc_node_add(Id, Node, Ip, Port, SSLPort, Cookie, LBUrl) ->
    ?MODULE ! {rpc_node_add, Id, Node, Ip, Port, SSLPort, Cookie, LBUrl}.

%%隐藏线路
rpc_node_hide(Id) ->
    ?MODULE ! {rpc_node_hide, Id}.

%%显示线路
rpc_node_show(Id) ->
    ?MODULE ! {rpc_node_show, Id}.


%% 单服集群启动
start_link(NetArgs) ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [NetArgs], []).

init([NetArgs]) -> 
    #net_args{line = Line, ip = Ip, port = Port, sslport=SSLPort, lburl=LBUrl} = NetArgs,
    State = #state{id = Line, ip = Ip, port = Port, sslport=SSLPort, node = node(), cookie = erlang:get_cookie(), lburl=LBUrl},
    db_add_node([State#state.ip, State#state.port, State#state.sslport, State#state.id, State#state.node, State#state.lburl]),
    %% 获取并通知当前所有线路
    get_and_call_node(State),
    {ok, State}.

handle_cast(_R , State) ->
    {noreply, State}.

%% 获取节点ID号
handle_call(get_node_id, _From, State) ->
    {reply, State#state.id, State};

handle_call(_R , _FROM, State) ->
    {reply, ok, State}.

%% 新线加入
handle_info({rpc_node_add, Id, Node, Ip, Port, SSLPort, Cookie, LBUrl}, State) ->
    ets:insert(?ETS_NODE, #node{id = Id, node = Node, ip = Ip, port = Port, sslport=SSLPort, cookie = Cookie, lburl=LBUrl}),
    {noreply, State};

%% 隐藏线路
handle_info({rpc_node_hide, Id}, State) ->
    case ets:lookup(?ETS_NODE, Id) of
        [S] ->
            ets:insert(?ETS_NODE, S#node{state = 1});
        _ -> skip
    end,
    {noreply, State};

%% 显示线路
handle_info({rpc_node_show, Id}, State) ->
    case ets:lookup(?ETS_NODE, Id) of
        [S] ->
            ets:insert(?ETS_NODE, S#node{state = 0});
        _ -> skip
    end,
    {noreply, State};

handle_info(_Reason, State) ->
    {noreply, State}.

terminate(_R, State) ->
    {ok, State}.

code_change(_OldVsn, State, _Extra)->
    {ok, State}.


%% ----------------------- 私有函数 ---------------------------------

%%加入服务器集群
db_add_node([Ip, Port, SSLPort, Sid, Node, LBUrl]) ->
    Cookie = erlang:get_cookie(),
    db:execute(io_lib:format(<<"replace into `node` (id, ip, port, sslport, node, cookie, lburl) values(~p, '~s', ~p, ~p, '~s', '~s', '~s')">>,
        [Sid, Ip, Port, SSLPort, Node, Cookie, LBUrl])).

%%退出服务器集群
del_node(Sid) ->
    db:execute(io_lib:format(<<"delete from `node` where id = ~p">>,[Sid])).

%%获取并通知所有线路信息
get_and_call_node(State) ->
    case db:get_all(<<"select id, ip, port, sslport, node, cookie, state, lburl from node order by id">>) of
        [] ->  [];
        Server ->
            F = fun([Id, Ip, Port, SSLPort, Node, Cookie, S, LBUrl]) ->
                Node1 = list_to_atom(binary_to_list(Node)),
                Cookie1 = list_to_atom(binary_to_list(Cookie)),
                Ip1 = binary_to_list(Ip),
                case Id /= State#state.id of  % 自己不写入和不通知
                    true ->
                        case net_adm:ping(Node1) of
                            pong ->
                                ets:insert(?ETS_NODE, #node{ id = Id, node = Node1, ip = Ip1,
                                    port = Port, sslport=SSLPort, cookie = Cookie1,state = S, lburl=LBUrl}), 
                                %% 通知已有的线路加入当前线路的节点，包括线路0网关
                                rpc:call(Node1, mod_disperse, rpc_node_add,
                                         [State#state.id, State#state.node, State#state.ip, State#state.port, State#state.sslport, State#state.cookie, State#state.lburl]);
                            pang ->
                                del_node(Id)
                        end;
                    false ->
                        %% Modified: 18/10/2016 by hekai <1472524632@qq.com>
                        %% Note: 自己也写入进ets表
                        ets:insert(?ETS_NODE, #node{ id = Id, node = Node1, ip = Ip1,
                            port = Port, sslport=SSLPort, cookie = Cookie1,state = S, lburl=LBUrl})
                end
            end,
            [F(S) || S <- Server]
    end.

%% -----------------------------------------------------------------
%% 调用指定线路的模块函数
%% -----------------------------------------------------------------

%%rpc_cast调用指定线路
rpc_cast_by_id(Id, Mod, Fun, Arg) ->
    case ets:lookup(?ETS_NODE, Id) of
        [] -> false;
        [S] ->
            rpc:cast(S#node.node, Mod, Fun, Arg)
    end.

%%rpc_call调用指定线路
rpc_call_by_id(Id, Mod, Fun, Arg) ->
    case ets:lookup(?ETS_NODE, Id) of
        [S] -> rpc:call(S#node.node, Mod, Fun, Arg);
        _ -> []
    end.

%%call调用公共服务器
call_to_unite(Mod, Fun, Arg) ->
    case ets:lookup(?ETS_NODE, 1) of
        [] -> [];
        [S] ->
            rpc:call(S#node.node, Mod, Fun, Arg)
    end.

%%cast调用公共服务器
cast_to_unite(Mod, Fun, Arg) ->
    case ets:lookup(?ETS_NODE, 1) of
        [] -> [];
        [S] ->
            rpc:cast(S#node.node, Mod, Fun, Arg)
    end.

%% -----------------------------------------------------------------
%% 调用其它分线的模块函数
%% -----------------------------------------------------------------

%% 通知其他游戏节点
send_other_server(Module, Fun, Args) ->
    ServerList = node_list(),
    send_other_server_helper(ServerList, Module, Fun, Args).

send_other_server_helper([], _Module, _Fun, _Args) -> ok;
send_other_server_helper([H | T], Module, Fun, Args) ->
    rpc:cast(H#node.node, Module, Fun, Args),
    send_other_server_helper(T, Module, Fun, Args).

%% 获取节点
%% 单节点的情况下：就是游戏节点本身
get_clusters_node() ->
    case get("get_clusters_node") of
        undefined ->
            case ets:lookup(?ETS_NODE, ?GAME_NODE_ID) of
                [S] ->
                    put("get_clusters_node", S#node.node),
                    S#node.node;
                _ ->
                    case mod_disperse:node_id() =:= ?GAME_NODE_ID of
                        true ->
                            put("get_clusters_node", node()),
                            node();
                        false ->
                            none
                    end
            end;
        Node ->
            Node
    end.

%% 获取跨服中心节点
get_center_node() ->
    case get("get_center_node") of
        undefined ->
            case ets:lookup(?ETS_NODE, ?CLUSTERS_NODE_ID) of
                [S] ->
                    put("get_center_node", S#node.node),
                    S#node.node;
                _ ->
                    case mod_disperse:node_id() =:= ?CLUSTERS_NODE_ID of
                        true ->
                            put("get_center_node", node()),
                            node();
                        false ->
                            none
                    end
            end;
        Node ->
            Node
    end.
