-module(pp_guild_daily).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("figure.hrl").
-include("def_module.hrl").



handle(Cmd, PS, Args) ->
    #player_status{figure = #figure{lv = RoleLv}} = PS,
    NeedLv = data_guild_m:get_config(apply_join_guild_lv),
    case NeedLv =< RoleLv of
        true ->
            do_handle(Cmd, PS, Args);
        _ ->
            {ok, PS}
    end.

do_handle(40301, PS, []) ->
    lib_guild_daily:get_info(PS);

do_handle(40302, PS, [AutoId]) ->
    lib_guild_daily:recieve_reward(PS, AutoId);

do_handle(_, PS, _) -> {ok, PS}.