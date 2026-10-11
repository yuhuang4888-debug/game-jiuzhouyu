%% ---------------------------------------------------------------------------
%% @doc pp_arcana.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2019-10-22
%% @deprecated 远古奥术
%% ---------------------------------------------------------------------------
-module(pp_arcana).
-export([handle/3]).

-include("server.hrl").

%% 远古奥术信息
handle(21101, Player, []) ->
    lib_arcana:send_info(Player);

%% 升级
handle(21102, Player, [ArcanaId]) ->
    lib_arcana:up_lv(Player, ArcanaId);

%% 突破
handle(21103, Player, [ArcanaId]) ->
    lib_arcana:break_lv(Player, ArcanaId);

%% 核心类型选择
handle(21104, Player, [CoreType]) ->
    lib_arcana:select_core(Player, CoreType);

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.