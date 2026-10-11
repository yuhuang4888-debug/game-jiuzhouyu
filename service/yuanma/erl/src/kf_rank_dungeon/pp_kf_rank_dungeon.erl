%% ---------------------------------------------------------------------------
%% @doc lib_territory_treasure.erl
%% @author  lxl
%% @email   
%% @since   
%% @deprecated 个人排行本
%% ---------------------------------------------------------------------------
-module(pp_kf_rank_dungeon).

-include("kf_rank_dungeon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("predefine.hrl").

-export([
		handle/3
	]).


handle(50701, PS, []) ->
	#player_status{id = RoleId, sid = Sid} = PS,
	lib_kf_rank_dungeon:rank_dungeon_open(PS) 
        andalso mod_kf_rank_dungeon_local:send_self_rank_dungeon_info([RoleId, Sid]);

handle(50702, PS, [AreaId]) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    Node = mod_disperse:get_clusters_node(),
    lib_kf_rank_dungeon:rank_dungeon_open(PS) andalso
        mod_kf_rank_dungeon_local:send_self_area_challengers([Node, RoleId, Sid, AreaId]);

handle(50703, PS, [AreaId]) ->
    #player_status{sid = Sid} = PS,
    Node = mod_disperse:get_clusters_node(),
    case AreaId > 0 andalso AreaId =< 10 of 
        true ->
            lib_kf_rank_dungeon:rank_dungeon_open(PS) andalso
                mod_clusters_node:apply_cast(mod_kf_rank_dungeon, send_area_challengers, [[Node, Sid, AreaId]]);
        _ ->
            ok
    end;

handle(50704, PS, []) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    lib_kf_rank_dungeon:rank_dungeon_open(PS) andalso
        mod_kf_rank_dungeon_local:get_level_reward([RoleId, Sid]);

handle(_Comd, _PS, _Data) ->
    {error, "pp_kf_rank_dungeon no match~n"}.