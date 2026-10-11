%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_msg.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_fake_client_msg).


-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

-export([
	send_msg/4
	]).

-define(proto_is_regis(ProtoId, RegisMap), maps:get(ProtoId, RegisMap, 0) =/= 0).

send_msg(ProtoMod, TransMod, Socket, PlayerPid) ->
	DefalutProtoList = data_fake_client_m:get_regis_proto(0, 0),
	RegisMap = regis_proto(#{}, DefalutProtoList),
	send_msg_do(ProtoMod, TransMod, Socket, PlayerPid, RegisMap, true).

send_msg_do(ProtoMod, TransMod, Socket, PlayerPid, RegisMap, IsSend) ->
	receive
        {send, Bin} when is_binary(Bin) andalso IsSend == true ->
        	%% 做测试，也先发给客户端
      %   	case is_port(Socket) of 
      %   		true ->
		    %         SendB = ProtoMod:pack(Bin),
		    % 		TransMod:send(Socket, SendB);
		    % 	_ -> ok
		    % end,
    		handle_send_binary(Bin, PlayerPid, RegisMap),
    		send_msg_do(ProtoMod, TransMod, Socket, PlayerPid, RegisMap, IsSend);
        {add_regis, ProtoList} -> %% 协议注册
        	NRegisMap = regis_proto(RegisMap, ProtoList),
        	send_msg_do(ProtoMod, TransMod, Socket, PlayerPid, NRegisMap, IsSend);
        {del_regis, ProtoList} -> %%
        	NRegisMap = unregis_proto(RegisMap, ProtoList),
        	send_msg_do(ProtoMod, TransMod, Socket, PlayerPid, NRegisMap, IsSend);
        {is_send, IsSendNew} ->
        	send_msg_do(ProtoMod, TransMod, Socket, PlayerPid, RegisMap, IsSendNew);
        {relogin_close} ->
        	ok;
        _ ->
            send_msg_do(ProtoMod, TransMod, Socket, PlayerPid, RegisMap, IsSend)
    end.

regis_proto(RegisMap, ProtoList) ->
	F = fun(ProtoId, Map) -> maps:put(ProtoId, 1, Map) end,
	lists:foldl(F, RegisMap, ProtoList).

unregis_proto(RegisMap, ProtoList) ->
	F = fun(ProtoId, Map) -> maps:remove(ProtoId, Map) end,
	lists:foldl(F, RegisMap, ProtoList).

handle_send_binary(Bin, PlayerPid, RegisMap) ->
	{ProtoId, DataBin, LeftBin} = pt_server:unpack(Bin),
	case ?proto_is_regis(ProtoId, RegisMap) of 
		true -> 
			%?MYLOG("lxl_proto", "handle_send_binary regis#2: ~p~n", [{ProtoId, DataBin}]),
			%?PRINT("handle_send_binary regis : ~p~n", [ProtoId]),
			PlayerPid ! {fake_client_route, ProtoId, DataBin};
		_ -> 
			ok
	end,
	case LeftBin of 
		<<>> -> ok;
		_ -> handle_send_binary(LeftBin, PlayerPid, RegisMap)
	end.
	 