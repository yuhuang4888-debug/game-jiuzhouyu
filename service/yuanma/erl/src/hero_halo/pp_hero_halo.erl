%%%-------------------------------------------------------------------
%%% @author xzj
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%             主角光环配置
%%% @end
%%% Created : 20. 11月 2022 19:42
%%%-------------------------------------------------------------------
-module(pp_hero_halo).

-include("common.hrl").
-include("errcode.hrl").
-include("server.hrl").

-compile([export_all]).

handle(Cmd, Ps, Data) ->
	case catch do_handle(Cmd, Ps, Data) of
		{'EXIT', Error} ->
			?ERR("pp_hero_halo error: ~p~n", [Error]),
			skip;
		Return  ->
			Return
	end.

%% 获取主角光环信息
do_handle(51400, Ps, []) ->
	lib_hero_halo:notify_hero_halo_info(Ps);

%% 领取特权奖励
do_handle(51401, Ps, [Id]) ->
	case lib_hero_halo:get_reward(Ps, Id) of
		{ok, NewPs, NewState} -> Code = ?SUCCESS;
		{false, Code, NewState} -> NewPs = Ps
	end,
	{ok, BinData} = pt_514:write(51401, [Id, NewState, Code]),
	lib_server_send:send_to_uid(Ps#player_status.id, BinData),
	{ok, NewPs};

do_handle(51402, Ps, [HaloId, Type, State]) ->
	lib_hero_halo:set_privilege_state(Ps, HaloId, Type, State);

do_handle(_Cmd, Ps, _Data) ->
	?ERR("cmd error, cmd :~p ~n data : ~p ~n", [_Cmd, _Data]),
	{ok, Ps}.