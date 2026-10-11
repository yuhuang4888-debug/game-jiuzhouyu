%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_toppk_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 巅峰竞技挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_toppk_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").


%% 
handle_proto(28110, PS, [ErrCode]) ->
	lib_fake_client_toppk:match_result(PS, ErrCode);

handle_proto(28113, PS, [Res, Honor, Flag, Point]) ->
	lib_fake_client_toppk:end_fight(PS, Res, Honor, Flag, Point);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.