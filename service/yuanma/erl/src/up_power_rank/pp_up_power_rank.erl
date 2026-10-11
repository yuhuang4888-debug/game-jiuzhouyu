%%%-----------------------------------
%%% @Module      : pp_up_power_rank
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 04. 六月 2020 17:14
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(pp_up_power_rank).
-author("carlos").

%% API
-export([]).




-include("def_module.hrl").
-include("up_power_rank.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("mount.hrl").
-include("pet.hrl").
-include("custom_act.hrl").

%% 榜单信息
handle(22601, #player_status{sid =  Sid } = Player, [SubType]) ->
	%?PRINT(" 22101 RankType:~p ~n", [RankType]),
	case lists:member(SubType, ?up_power_rank_list) of
		true ->
			case  lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType) of
				true ->
					SelValue = lib_up_power:get_sel_value(Player, SubType),  %%对应的排序值
					mod_up_power_rank:send_rank_list(SubType, Player#player_status.id, SelValue);
				_ ->
					{ok, Bin} = pt_226:write(22600, [?ERRCODE(err331_act_closed)]),
					lib_server_send:send_to_sid(Sid, Bin)
			end;
		false -> skip
	end;

%% 目标奖励列表
handle(22602, Player, [SubType]) ->
	#player_status{id = RoleId} = Player,
	case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType) of
		true ->
%%			?PRINT("err ~p ~n", [get_stage_reward]),
			lib_up_power:send_client_stage_list(Player, SubType);
		_ ->
			lib_up_power:send_err_code(RoleId, ?ERRCODE(err331_act_closed))
	end;
	

%% 领取目标奖励
handle(22603, Player, [SubType, GoalId]) ->
	#player_status{id = RoleId} = Player,
	case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_UP_POWER_RANK, SubType) of
		true ->
			
			NewPs = lib_up_power:get_stage_reward(Player, SubType, GoalId),
			{ok, NewPs};
		_ ->
			lib_up_power:send_err_code(RoleId, ?ERRCODE(err331_act_closed))
	end;




handle(_Cmd, _Player, _Data) ->
	?PRINT(" Data:~p ~n", [_Data]),
	{error, "pp_common_rank no match~n"}.



