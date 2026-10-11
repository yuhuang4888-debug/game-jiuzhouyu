%%%-----------------------------------
%%% @Module      : pp_chrono_rift
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 09. 十二月 2019 19:16
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(pp_chrono_rift).
-author("carlos").
-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("chrono_rift.hrl").
-include("figure.hrl").
-include("goods.hrl").
%% API
-export([]).


handle(Cmd, Status, Args) ->
	#player_status{figure = Figure, id = _RoleId} = Status,
	#figure{lv = Lv} = Figure,
	OpenDayLimit = ?CR_OPEN_DAY,
	OpenDay = util:get_open_day(),
	LvLimit = ?CR_ROLE_LV,
	if
		Lv >= LvLimit orelse OpenDay < OpenDayLimit ->
			case do_handle(Cmd, Status, Args) of
				#player_status{} = NewPS ->
					{ok, NewPS};
				{ok, NewPS} ->
					{ok, NewPS};
				_ ->
					{ok, Status}
			end;
		true ->
			{ok, Status}
	end.



do_handle(20401, Status, []) ->
	#player_status{id = RoleId, server_id = _ServerId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{scramble_value = V} = ChronoRift,
	mod_clusters_node:apply_cast(mod_kf_chrono_rift, get_act_info, [config:get_server_id(), RoleId, V]);


do_handle(20402, Status, [CastleId]) ->
	#player_status{id = RoleId, server_id = _ServerId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{scramble_value = V} = ChronoRift,
	mod_clusters_node:apply_cast(mod_kf_chrono_rift, get_castle_info, [config:get_server_id(), RoleId, CastleId, V]);


do_handle(20403, Status, [ChangeCastleId]) ->
%%	?PRINT("ChangeCastleId ~p~n", [ChangeCastleId]),
	#player_status{id = RoleId, server_id = _ServerId, chrono_rift = ChronoRift, figure = F} = Status,
	#chrono_rift_in_ps{scramble_value = V, castle_id = OldCastleId} = ChronoRift,
	Role =
		Role = #castle_role_msg{
			role_id = RoleId
			, role_name = F#figure.name
			, castle_id = OldCastleId
			, server_name = util:get_server_name()
			, server_id = config:get_server_id()
			, server_num = config:get_server_num()
			, is_occupy = 1
		},
	mod_clusters_node:apply_cast(mod_kf_chrono_rift, change_castle, [config:get_server_id(), Role, OldCastleId, ChangeCastleId, V]);


%% 每日争夺值
do_handle(20404, Status, []) ->
	#player_status{id = RoleId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{act_list = ActList} = ChronoRift,
%%	PackList = [{Mod, SubMod, Value} || {{Mod, SubMod}, Value} <- ActList],
	AllActList = data_chrono_rift:get_all_act(),
	F = fun({Mod, SubMod}, AccList) ->
			case lists:keyfind({Mod, SubMod}, 1, ActList) of
				{_, Count} ->
					case data_chrono_rift:get_act(Mod, SubMod) of
						#chrono_act_cfg{count = NeedCount, value = CanGetValue} ->
							V = trunc(Count / NeedCount) * CanGetValue;
						_ ->
							V = 0
					end,
					[{Mod, SubMod, V} | AccList];
				_ ->
					[{Mod, SubMod, 0} | AccList]
			end
		end,
	PackList = lists:reverse(lists:foldl(F, [], AllActList)),
	{ok, Bin} = pt_204:write(20404, [PackList]),
%%	?MYLOG("chrono", "20404 ~p~n", [PackList]),
	lib_server_send:send_to_uid(RoleId, Bin);

%% 每日争夺奖励
do_handle(20405, Status, []) ->
	#player_status{id = RoleId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{today_reward_list = List, today_value = Value, scramble_value = AllValue} = ChronoRift,
	StageList = data_chrono_rift:get_stage_list(),
	F = fun({StageId, NeedValue}, AccList) ->
		if
			NeedValue > Value ->  %% 不能领取
				[{StageId, 0} | AccList];
			true ->  %% 可以领取
				case lists:keyfind(StageId, 1, List) of
					{_, 2} -> %% 2 是已经领取
						[{StageId, 2} | AccList];
					_ ->  %% 除此之外都是可以领取
						[{StageId, 1} | AccList]
				end
		end
	    end,
	PackList = lists:reverse(lists:foldl(F, [], StageList)),
%%	?MYLOG("chrono", "20405 ~p~n", [{Value, AllValue, PackList}]),
	{ok, Bin} = pt_204:write(20405, [Value, AllValue, PackList]),
	lib_server_send:send_to_uid(RoleId, Bin);


%% 领取阶段奖励
do_handle(20406, Status, [StageId]) ->
	#player_status{id = RoleId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{today_reward_list = List, today_value = Value} = ChronoRift,
	StageList = data_chrono_rift:get_stage_list(),
	case lists:keyfind(StageId, 1, StageList) of
		{_, NeedValue} ->
			if
				NeedValue > Value ->
					send_error(RoleId, ?ERRCODE(err204_not_enough_scramble_value));
				true ->
					case lists:keyfind(StageId, 1, List) of
						{_, 2} ->  %%err204_yet_get_reward
							send_error(RoleId, ?ERRCODE(err204_yet_get_reward));
						_ ->
							NewList = lists:keystore(StageId, 1, List, {StageId, 2}),
							NewChronoRift = ChronoRift#chrono_rift_in_ps{today_reward_list = NewList},
                            lib_chrono_rift_data:db_save_status_role(RoleId, NewChronoRift),
							Reward = data_chrono_rift:get_stage_reward(StageId),
							%%log
							lib_log_api:log_chrono_rift_stage_reward(RoleId, StageId, Value, Reward),
%%							?MYLOG("chrono", "20405 Reward ~p~n", [Reward]),
							lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = day_chrono_rift_reward}),
							NewPS = Status#player_status{chrono_rift = NewChronoRift},
							pp_chrono_rift:handle(20405, NewPS, []),
							{ok, Bin} = pt_204:write(20406, [StageId, ?SUCCESS]),
							lib_server_send:send_to_uid(RoleId, Bin),
							NewPS
					end
			end;
		_ ->
			send_error(RoleId, ?ERRCODE(err204_error_stage))
	end;


%% 赛季目标
do_handle(20407, Status, []) ->
	#player_status{id = RoleId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{season_reward = SeasonReward} = ChronoRift,
	mod_clusters_node:apply_cast(mod_kf_chrono_rift_goal, get_season_goal_info, [config:get_server_id(), RoleId, SeasonReward]);


%% 领取赛季目标
do_handle(20408, Status, [GoalId]) ->
	#player_status{id = RoleId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{season_reward = SeasonReward} = ChronoRift,
	case data_chrono_rift:get_goal_msg(GoalId) of
		{Type, NeedValue} ->
			case lists:keyfind(Type, 1, SeasonReward) of
				{_, 2} ->
					send_error(RoleId, ?ERRCODE(err204_yet_get_reward));
				_ ->
					mod_clusters_node:apply_cast(mod_kf_chrono_rift_goal, get_season_goal_reward, [config:get_server_id(), RoleId, GoalId, Type, NeedValue])
			end;
		_ ->
			send_error(RoleId, ?ERRCODE(err204_error_goal_id))
	end;


%% 个人排行榜
do_handle(20409, Status, []) ->
	#player_status{id = RoleId} = Status,
	mod_clusters_node:apply_cast(mod_kf_chrono_rift_scramble_rank, get_role_rank_list, [config:get_server_id(), RoleId]);


%% 当前据点
do_handle(20410, Status, []) ->
	#player_status{id = RoleId, chrono_rift = ChronoRift} = Status,
	#chrono_rift_in_ps{castle_id = CastleId} = ChronoRift,
	if
		CastleId == 0 ->
			mod_clusters_node:apply_cast(mod_kf_chrono_rift, get_role_castle_id, [config:get_server_id(), RoleId]);
		true ->
			{ok, Bin} = pt_204:write(20410, [CastleId]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end;


%% 世界信息
do_handle(20411, Status, []) ->
	#player_status{id = RoleId} = Status,
	mod_clusters_node:apply_cast(mod_kf_chrono_rift, get_world_msg, [config:get_server_id(), RoleId]);




do_handle(_Cmd, Status, _Args) ->
	Status.

send_error(RoleId, Error) ->
	{ok, Bin} = pt_204:write(20400, [Error]),
	lib_server_send:send_to_uid(RoleId, Bin).
