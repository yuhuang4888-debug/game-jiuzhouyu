%% ---------------------------------------------------------------------------
%% @doc pp_boss_rotary.erl
%% @author  lxl
%% @email   
%% @since   
%% @deprecated boss转盘
%% ---------------------------------------------------------------------------
-module(pp_boss_rotary).

-include("boss_rotary.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

-export([
		handle/3
	]).


handle(51001, PS, []) ->
    lib_boss_rotary:send_rotary_list(PS);

handle(51003, PS, [RotaryId]) ->
	case lib_boss_rotary:abandon_rotary(PS, RotaryId) of
		{ok, NewPS} ->
			lib_server_send:send_to_sid(PS#player_status.sid, pt_510, 51003, [?SUCCESS, RotaryId]),
			{ok, NewPS};
		_ ->
			{ok, PS}
	end;

handle(51004, PS, [RotaryId]) ->
	case lib_boss_rotary:get_rotary_reward(PS, RotaryId) of
		{ok, NewPS, PoolId, RewardId, Rewards} ->
			lib_server_send:send_to_sid(PS#player_status.sid, pt_510, 51004, [?SUCCESS, RotaryId, PoolId, RewardId, Rewards]),
			{ok, NewPS};
		{false, Res} ->
			lib_server_send:send_to_sid(PS#player_status.sid, pt_510, 51004, [Res, RotaryId, 0, 0, []]),
			{ok, PS}
	end;

handle(51005, PS, [RotaryId]) ->
	lib_boss_rotary:rotary_end(PS, RotaryId);

handle(_Comd, _PS, _Data) ->
    {error, "pp_boss_rotary no match~n"}.