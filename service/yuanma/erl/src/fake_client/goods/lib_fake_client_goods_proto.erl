%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_goods_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 物品协议处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_goods_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("fake_client.hrl").

%% 
handle_proto(15053, PS, [Res, Args, Status, DropId]) ->
    case lib_fake_client:get_onhook_type() of
        ?ON_HOOK_BEHAVIOR ->
            lib_player_behavior:pick_up_result(PS, Res, Args, Status, DropId);
        _ ->
            lib_fake_client_battle:pick_result(PS, Res, Args, Status, DropId)
    end;

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.