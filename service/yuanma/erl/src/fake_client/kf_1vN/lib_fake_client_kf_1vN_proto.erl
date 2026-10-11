%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_kf_1vN_proto.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 钻石大战挂机处理
%% ---------------------------------------------------------------------------
-module(lib_fake_client_kf_1vN_proto).
-export([handle_proto/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

handle_proto(62101, PS, [Stage, _Turn, _Edtime, _SubStage, _SubEdtime]) ->
	lib_fake_client_kf_1vN:war_stage(PS, Stage);

%% 
handle_proto(62103, PS, [ErrCode]) ->
	lib_fake_client_kf_1vN:enter_activity_result(PS, ErrCode);

handle_proto(_Cmd, PS, _Data) ->
    ?ERR("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    ?PRINT("handle_proto no match : ~p~n", [{_Cmd, _Data}]),
    PS.