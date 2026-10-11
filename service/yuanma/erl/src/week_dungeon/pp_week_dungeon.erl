%% ---------------------------------------------------------------------------
%% @doc pp_week_dungeon.erl
%% @author  lxl
%% @email   
%% @since   
%% @deprecated 周常副本
%% ---------------------------------------------------------------------------
-module(pp_week_dungeon).

-include("week_dungeon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("predefine.hrl").

-export([
		handle/3
	]).


handle(50801, PS, []) ->
    lib_week_dungeon:send_player_week_dun_info(PS);

handle(50802, PS, [TeamDunId, Rank1, Rank2]) when Rank1 < Rank2 andalso Rank1 > 0 andalso Rank2 =< 30 ->
    #player_status{id = RoleId, sid = Sid} = PS,
    Node = mod_disperse:get_clusters_node(),
    mod_clusters_node:apply_cast(mod_week_dun_rank, send_rank_list, [[TeamDunId, Rank1, Rank2, RoleId, Sid, Node]]);

handle(_Comd, _PS, _Data) ->
    {error, "pp_week_dungeon no match~n"}.