%%%-----------------------------------
%%% @Module      : lib_festival_recharge
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 12. 六月 2019 11:48
%%% @Description : 文件摘要  节日首冲
%%%-----------------------------------
-module(lib_festival_recharge).
-author("chenyiming").

%% API
-compile(export_all).


-include("server.hrl").
-include("festival_recharge.hrl").
-include("custom_act.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("goods.hrl").



login(PS) ->
	FestivalRecharge = select_from_db(PS#player_status.id),
	PS#player_status{festival_recharge = FestivalRecharge}.

%%更新充值状态
refresh_recharge(PS, SubType) ->
	#player_status{festival_recharge = FestivalRecharge} = PS,
	case FestivalRecharge of
		#festival_recharge{is_recharge = IsRecharge} ->
			if
				IsRecharge == ?festival_recharge_yet_recharge ->  %%已经充值了，不用记录状态
					PS;
				true ->
					NewFestivalRecharge = FestivalRecharge#festival_recharge{is_recharge = ?festival_recharge_yet_recharge},
					save_to_db(PS#player_status.id, NewFestivalRecharge),
					NewPS = PS#player_status{festival_recharge = NewFestivalRecharge},
					info(NewPS, ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE, SubType),
					NewPS
			end;
		_ ->
			NewFestivalRecharge = #festival_recharge{is_recharge = ?festival_recharge_yet_recharge},
			save_to_db(PS#player_status.id, NewFestivalRecharge),
			NewPS = PS#player_status{festival_recharge = NewFestivalRecharge},
			info(NewPS, ?CUSTOM_ACT_TYPE_FESTIVAL_RECHARGE, SubType),
			NewPS
	end.

%%活动状态
info(Player, Type, SubType) ->
	#player_status{sid = Sid, festival_recharge = FestivalRecharge} = Player,
	case FestivalRecharge of
		#festival_recharge{} ->
			Status = get_status(FestivalRecharge),
			SendList = get_reward_status(Type, SubType, Status),
%%			?MYLOG("cym", "info ~p~n", [{Type, SubType, SendList}]),
			lib_server_send:send_to_sid(Sid, pt_331, 33104, [Type, SubType, SendList]);
		_ ->
			SendList = get_reward_status(Type, SubType, 0),
%%			?MYLOG("cym", "info ~p~n", [{Type, SubType, SendList}]),
			lib_server_send:send_to_sid(Sid, pt_331, 33104, [Type, SubType, SendList])
	end.

%%领取奖励
get_reward(Player, Type, SubType, GradeId) ->
	#player_status{festival_recharge = FestivalRecharge, sid = Sid, id = RoleId} = Player,
	Status = get_status(FestivalRecharge),
	if
		Status == 0 -> %%不可领取
			lib_server_send:send_to_sid(Sid, pt_331, 33105, [?ERRCODE(err331_act_can_not_get), Type, SubType, 0]),
			Player;
		Status == 1 -> %%可以去领取
			case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
				#custom_act_reward_cfg{} = RewardCfg ->
					Reward = lib_custom_act_util:count_act_reward(Player, RewardCfg),
					lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = festival_recharge_reward}),
					lib_server_send:send_to_sid(Sid, pt_331, 33105, [?SUCCESS, Type, SubType, GradeId]),
%%					?MYLOG("cym", "Reward ~p~n", [Reward]),
					lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
					NewFestivalRecharge = FestivalRecharge#festival_recharge{status = ?festival_recharge_got_reward},
					save_to_db(RoleId, NewFestivalRecharge),
					{ok, Player#player_status{festival_recharge = NewFestivalRecharge}};
				_ ->
					lib_server_send:send_to_sid(Sid, pt_331, 33105, [?MISSING_CONFIG, Type, SubType, 0]),
					{ok, Player}
			end;
		Status == 2 ->
			lib_server_send:send_to_sid(Sid, pt_331, 33105, [?ERRCODE(err331_already_get_reward), Type, SubType, GradeId]),
			{ok, Player};
		true ->
			{ok, Player}
	end.

get_status(undefined) ->  %%不可领取
	0;
%%没有用充值 => 不可领取
get_status(#festival_recharge{is_recharge = ?festival_recharge_not_recharge}) ->
	0;
%%充值了，且没有领取 => 可以去领取
get_status(#festival_recharge{is_recharge = ?festival_recharge_yet_recharge, status = ?festival_recharge_not_got_reward}) ->
	1;
%%充值了，且已经领取 => 已经领取
get_status(#festival_recharge{is_recharge = ?festival_recharge_yet_recharge, status = ?festival_recharge_got_reward}) ->
	2;
%%容错
get_status(_) ->
	0.
	


save_to_db(_RoleId, undefined) ->
	ok;
save_to_db(RoleId, FestivalRecharge) ->
	#festival_recharge{is_recharge = IsRecharge, status = Status} = FestivalRecharge,
	Sql = io_lib:format(<<"REPLACE INTO  role_festival_recharge(role_id, is_recharge, status) VALUES(~p, ~p, ~p)">>, [RoleId, IsRecharge, Status]),
	db:execute(Sql).


select_from_db(RoleId) ->
	Sql = io_lib:format(<<"select is_recharge, status from role_festival_recharge where role_id = ~p">>, [RoleId]),
	case db:get_row(Sql) of
		[IsRecharge, Status] ->
			#festival_recharge{is_recharge = IsRecharge, status = Status};
		_ ->
			undefined
	end.




%%活动期间的清理
day_clear_act_data(_Type, _SubType) ->
	Sql = io_lib:format(<<"UPDATE  role_festival_recharge SET is_recharge = ~p, status = ~p">>,
		[?festival_recharge_not_recharge, ?festival_recharge_not_got_reward]),
	db:execute(Sql),
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_festival_recharge, day_clear_act_data, []) || E <- OnlineRoles].

day_clear_act_data(PS) ->
	#player_status{festival_recharge = FestivalRecharge, id = RoleId} = PS,
	case FestivalRecharge of
		#festival_recharge{} ->
			NewFestivalRecharge = FestivalRecharge#festival_recharge{is_recharge = ?festival_recharge_not_recharge, status = ?festival_recharge_not_got_reward},
			save_to_db(RoleId, NewFestivalRecharge),
			PS#player_status{festival_recharge = NewFestivalRecharge};
		_ ->
			PS
	end.


%% 获取奖励状态
get_reward_status(Type, SubType, Status) ->
	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(RewardId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of
			#custom_act_reward_cfg{
				name = Name,
				desc = Desc,
				condition = Condition,
				format = Format,
				reward = Reward
			} = _RewardCfg ->
				ConditionStr = util:term_to_string(Condition),
				RewardStr = util:term_to_string(Reward),
				[{RewardId, Format, Status, 0, Name, Desc, ConditionStr, RewardStr} | Acc];
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], RewardIdAll).


%%活动结束清理
act_clear(_Type, _SubType, _WLv) ->
%%	?MYLOG("cym", "++++++++++++++ act_close ~n", []),
	Sql = io_lib:format(<<"truncate role_festival_recharge">>, []),
	db:execute(Sql),
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_festival_recharge, act_clear, []) || E <- OnlineRoles].


act_clear(PS) ->
	PS#player_status{festival_recharge = undefined}.














