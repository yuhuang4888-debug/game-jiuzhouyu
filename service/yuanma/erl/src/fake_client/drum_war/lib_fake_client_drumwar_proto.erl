%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_drumwar_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 钻石大战挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_drumwar_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(13704, PS, [ErrCode]) ->
	lib_fake_client_drumwar:enter_activity_result(PS, ErrCode);

handle_proto(13708, PS, [Settlement, Result, ActionId]) ->
	lib_fake_client_drumwar:match_settlement(PS, Settlement, Result, ActionId);

handle_proto(13710, PS, [SelfLife, _OtherLife]) ->
	lib_fake_client_drumwar:set_left_live(PS, SelfLife);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    ?PRINT("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.