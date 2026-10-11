%%%-----------------------------------
%%% @Module  : lib_clusters_center
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.10.29
%%% @Description: 只在跨服中心用的方法
%%%-----------------------------------
-module(lib_clusters_center).
-export([
        get_node/1,
        send_to_uid/2,
        send_to_uid/3,
        add_node/2,
        del_node/1,
        get_node_by_role_id/1,
        clean_nodes/0
	 ]).
-include("clusters.hrl").

get_node(SerId) -> 
    case ets:lookup(?ROUTE, SerId) of
        [R] -> R#route.node;
        _   -> undefined
    end.

get_node_by_role_id(RoleId) ->
    ServId = mod_player_create:get_serid_by_id(RoleId),
    get_node(ServId).

%% 给指定节点玩家发消息
send_to_uid(Node, Id, Bin) ->
    rpc:cast(Node, lib_server_send, send_to_uid, [Id, Bin]).

%% 给未指定节点玩家发消息
send_to_uid(Id, Bin) ->
    ServId = mod_player_create:get_serid_by_id(Id),
    mod_clusters_center:apply_cast(ServId, lib_server_send, send_to_uid, [Id, Bin]).

%% 添加节点
add_node(SerId, Node) ->
    catch db:execute(io_lib:format(<<"replace into `clusters` (server_id, node) values(~w, '~s')">>,[SerId, Node])).

%% 删除节点
del_node(SerId) ->
    catch db:execute(io_lib:format(<<"delete from `clusters` where `server_id` = '~w'">>,[SerId])).

%% 删除节点
clean_nodes() ->
    catch db:execute(<<"truncate `clusters`">>).
