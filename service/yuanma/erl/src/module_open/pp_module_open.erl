% %%%===================================================================
% %%% @author lxl
% %%% @doc 功能开放预告
% %%% @end
% %%% @update by 
% %%%===================================================================
-module(pp_module_open).
-include("server.hrl").
-compile(export_all).

-export([handle/3]).


%%功能列表
handle(13800,Status,[]) ->
	lib_module_open:get_open_module_list(Status);

%%领取奖励
handle(13801, #player_status{sid = Sid} = Status,[Id, NewState]) ->
	case lib_module_open:finish_open_module(Status, Id, NewState) of
		{true, NStatus} ->
			lib_server_send:send_to_sid(Sid, pt_138, 13801, [1, Id, NewState]),
			{ok, NStatus};
		{false, Res} ->
			lib_server_send:send_to_sid(Sid, pt_138, 13801, [Res, Id, NewState])
	end;

handle(_Cmd, _Player, _Data) ->
	% util:errlog("M:~p, L:~p _Cmd:~p _Data:~p ~n", [?MODULE, ?LINE, _Cmd, {_Data,_Player#player_status.scene_old,_Player#player_status.copy_id_old}]),
	ok.