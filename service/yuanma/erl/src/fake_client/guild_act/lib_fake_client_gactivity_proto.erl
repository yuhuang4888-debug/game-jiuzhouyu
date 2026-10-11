%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_gactivity_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 公会活动挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_gactivity_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(40212, PS, [ErrCode]) ->
	lib_fake_client_gfeast:enter_activity_result(PS, ErrCode);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.