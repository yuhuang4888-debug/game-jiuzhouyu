%% ---------------------------------------------------------------------------
%% @doc pp_spirit_rotary.erl
%% @author  lxl
%% @email   
%% @since   
%% @deprecated 精灵转盘
%% ---------------------------------------------------------------------------
-module(pp_spirit_rotary).

-include("spirit_rotary.hrl").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").

-export([
		handle/3
	]).


handle(50901, PS, []) ->
    lib_server_send:send_to_sid(PS#player_status.sid, pt_509, 50901, [PS#player_status.spirit_rotary_status#spirit_rotary_status.bless_value]);

handle(50902, PS, [RotaryId, Count]) when (Count == 1 orelse Count == 10) andalso (RotaryId == 1 orelse RotaryId == 2) ->
	case lib_spirit_rotary:get_reward(PS, RotaryId, Count) of 
		{ok, NewBlessValue, RewardList, NewPS} ->
			lib_server_send:send_to_sid(PS#player_status.sid, pt_509, 50902, [?SUCCESS, RotaryId, Count, NewBlessValue, RewardList]),
			{ok, NewPS};
		{false, Res} ->
			lib_server_send:send_to_sid(PS#player_status.sid, pt_509, 50902, [Res, RotaryId, Count, 0, []])
	end;

handle(_Comd, _PS, _Data) ->
    {error, "pp_spirit_rotary no match~n"}.