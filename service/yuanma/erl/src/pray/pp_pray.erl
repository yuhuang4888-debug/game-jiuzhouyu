%%-----------------------------------------------------------------------------
%% @Module  :       pp_pray
%% @Author  :       Czc
%% @Email   :       389853407@qq.com
%% @Created :       2017-12-20
%% @Description:    祈愿
%%-----------------------------------------------------------------------------
-module(pp_pray).

-include("server.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("pray.hrl").

-export([handle/3]).

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = data_pray:get_cfg(5),
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.

%% 祈愿界面
do_handle(_Cmd = 41501, PlayerStatus, _) ->
%%    ?PRINT("Start 41501~n",[]),
    #player_status{id = RoleId, figure = Figure, status_pray = StatusPray} = PlayerStatus,
    StaPray = StatusPray#status_pray.pray_map,
    FinStaPray  = lib_pray:send_pray_info(RoleId, Figure#figure.vip_type, Figure#figure.vip,StaPray),
    NewStatusPray= StatusPray#status_pray{pray_map = FinStaPray},
    {ok ,PlayerStatus#player_status{status_pray = NewStatusPray} };

%% 祈愿
do_handle(_Cmd = 41502, PlayerStatus, [Type]) ->
%%    ?PRINT("41502 :~p~n",[Type]),
    lib_pray:pray(PlayerStatus, Type);

do_handle(_Cmd, _Player, _Data) ->
    {error, "pp_pray no match~n"}.