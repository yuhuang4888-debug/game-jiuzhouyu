%%---------------------------------------------------------------------------
%% @doc:        pp_look_over
%% @author:     lianghaihui
%% @email:      1457863678@qq.com
%% @since:      2022-4月-12. 11:08
%% @deprecated: 查看玩家信息
%%---------------------------------------------------------------------------
-module(pp_look_over).

-include("common.hrl").

%% API
-export([
    handle/3
]).

handle(19501, Player, [ServerId, LookOverRoleId, ModuleId]) ->
    lib_player_look_over:apply_other_server_player(Player, ServerId, LookOverRoleId, ModuleId),
    ok;

handle(_Cmd, _Status, _Data) ->
    ?PRINT("pp_goods no match :~p~n", [{_Cmd, _Data}]),
    {error, "pp_goods no match"}.
