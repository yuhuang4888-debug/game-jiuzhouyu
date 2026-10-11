%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_nine_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 九魂圣殿挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_nine_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(13502, PS, [ErrCode]) ->
	lib_fake_client_nine:enter_activity_result(PS, ErrCode);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    ?PRINT("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.