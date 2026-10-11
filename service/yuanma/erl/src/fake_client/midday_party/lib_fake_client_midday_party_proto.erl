%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_midday_party_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 午间派对挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_midday_party_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(28501, PS, [ErrCode]) ->
	lib_fake_client_midday_party:enter_activity_result(PS, ErrCode);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.