-module(pp_resource_back).
-compile(export_all).

-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

%% 资源找回信息
handle(41900, PlayerStatus, []) ->
	lib_resource_back:report_res_act(PlayerStatus),
	{ok, PlayerStatus};

%% 资源找回
handle(41903, PlayerStatus, [Id, ActSub, Type, Times, Times_Others]) ->
	?PRINT("~p, ~p, ~p,~p~n", [Id, ActSub, Type, Times]),
	case lib_resource_back:resource_back(PlayerStatus, Id, ActSub, Type, Times, Times_Others) of
		{true, NewPS} -> 			
			%lib_resource_back:report_res_act(NewPS),		
			%lib_player_event:dispatch(NewPS, ?EVENT_RESOURCE_BACK);
			%lib_server_send:send_to_sid(NewPS#player_status.sid, pt_419, 41903, [?SUCCESS]),
			{ok, NewPS};
		{false, Res, NewPS} -> 
			lib_server_send:send_to_sid(NewPS#player_status.sid, pt_419, 41903, [Res, 0, 0, 0,0, 0,0]),
			{ok, NewPS}
	end;

%% 资源一键找回
handle(41904, PlayerStatus, [Type]) ->
	case lib_resource_back:resource_back_onekey(PlayerStatus, Type) of
		{true, NewPS} ->
			{ok, NewPS};
		{false, Res, NewPS} ->
			lib_server_send:send_to_sid(NewPS#player_status.sid, pt_419, 41904, [Res, Type, []]),
			{ok, NewPS}
	end;

handle(_, PlayerStatus, _) ->
  {ok, PlayerStatus}.