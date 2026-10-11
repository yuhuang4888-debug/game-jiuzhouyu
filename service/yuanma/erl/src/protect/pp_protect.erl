%% ---------------------------------------------------------------------------
%% @doc pp_protect.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-08-03
%% @deprecated 免战保护
%% ---------------------------------------------------------------------------
-module(pp_protect).

-compile(export_all).

%% 场景保护信息
handle(20201, Player, []) ->
    lib_protect:send_info(Player);

%% 使用保护
handle(20202, Player, [SceneType]) ->
    lib_protect:use_protect(Player, SceneType);

%% 保护结束时间
handle(20203, Player, []) ->
    lib_protect:send_protect_info(Player);

%% 结束保护
handle(20205, Player, [SceneType]) ->
    lib_protect:close_protect(Player, SceneType);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.