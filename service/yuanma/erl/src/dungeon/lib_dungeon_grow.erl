%% ---------------------------------------------------------------------------
%% @doc lib_dungeon_grow.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2017-03-20
%% @deprecated 成长试炼
%% ---------------------------------------------------------------------------
-module(lib_dungeon_grow).

-export([gm_set_dungeon_grow/2]).

-compile(export_all).

-include("server.hrl").
-include("dungeon.hrl").
-include("def_module.hrl").

%% 设置成长试炼的进度
gm_set_dungeon_grow(#player_status{id = RoleId} = Player, SortId) ->
    DunIdList = data_dungeon_grow:get_dungeon_grow_dun_id_list(),
    F = fun(DunId) -> 
        #dungeon_grow{sort_id = TmpSortId} = data_dungeon_grow:get_dungeon_grow(DunId),
        case TmpSortId =< SortId of
            true -> Count = 1;
            false -> Count = 0
        end,
        mod_counter:set_count(RoleId, ?MOD_DUNGEON, ?MOD_DUNGEON_SUCCESS, DunId, Count)
    end,
    lists:map(F, DunIdList),
    pp_dungeon_grow:handle(61101, Player, []),
    ok.