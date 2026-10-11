%%%-----------------------------------
%%% @Module  : lib_clusters
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2012.10.29
%%% @Description: 跨服共用方法
%%%-----------------------------------
-module(lib_clusters).
-export([
        add_node/2,
        del_node/1,
        update_zone_base/2
	 ]).
-include("clusters.hrl").

%% 添加节点
add_node(SerId, Node) ->
    catch db:execute(io_lib:format(<<"replace into `clusters` (server_id, node) values(~w, '~s')">>,[SerId, Node])).

%% 删除节点
del_node(SerId) ->
    catch db:execute(io_lib:format(<<"delete from `clusters` where `server_id` = '~w'">>,[SerId])).

%% 更新游戏服信息
update_zone_base([], ZoneBase) -> ZoneBase;
update_zone_base([{K, V} | T], ZoneBase) ->
    NZoneBase =
    case K of
        world_lv ->
            ZoneBase#zone_base{world_lv = V};
        server_name ->
            ZoneBase#zone_base{server_name = V};
        _ ->
            ZoneBase
    end,
    update_zone_base(T, NZoneBase).