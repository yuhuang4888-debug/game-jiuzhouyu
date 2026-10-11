%%%-----------------------------------
%%% @Module      : lib_recharge_one
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 16. 七月 2019 17:43
%%% @Description : 
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_recharge_one).
-author("carlos").


%% API
-export([]).

-include("server.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("custom_act.hrl").

%%  1 可以领取  2:已经领取  0 不能领取

refresh_recharge(PS, ProductId) ->
%%	?MYLOG("one", "ProductId ~p~n", [ProductId]),
	#player_status{status_custom_act = CustomAct, id = RoleId} = PS,
	#status_custom_act{data_map = DataMap} = CustomAct,
	SubIds = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_RECHARGE_ONE),
	F = fun(SubId, AccDataMap) ->
		case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_RECHARGE_ONE, SubId) of
			#custom_act_cfg{condition = Condition} ->
				case lists:keyfind(recharge, 1, Condition) of
					{recharge, ProductId} ->  %%可以触发这个礼包
						case maps:get({?CUSTOM_ACT_RECHARGE_ONE, SubId}, AccDataMap, []) of
							#custom_act_data{data = OldState} = Data ->
								case OldState of
									[1] ->
										Data1 = Data;
									[2] ->
										Data1 = Data;
									_ ->
										Data1 = Data#custom_act_data{id = {?CUSTOM_ACT_RECHARGE_ONE, SubId}, subtype = SubId, type = ?CUSTOM_ACT_RECHARGE_ONE, data = [1]},
										lib_custom_act:db_save_custom_act_data(RoleId, Data1)
								end;
							_ ->
								Data1 = #custom_act_data{id = {?CUSTOM_ACT_RECHARGE_ONE, SubId}, subtype = SubId, type = ?CUSTOM_ACT_RECHARGE_ONE, data = [1]},
								lib_custom_act:db_save_custom_act_data(RoleId, Data1)
						end,
						maps:put({?CUSTOM_ACT_RECHARGE_ONE, SubId}, Data1, AccDataMap);
					_ ->
						AccDataMap
				end;
			_ ->
				AccDataMap
		end
	    end,
	NewDataMap = lists:foldl(F, DataMap, SubIds),
	NewCustomAct = CustomAct#status_custom_act{data_map = NewDataMap},
	NewPS = PS#player_status{status_custom_act = NewCustomAct},
	SubActInfos = lib_custom_act_util:get_open_subtype_list(?CUSTOM_ACT_RECHARGE_ONE),
	[pp_custom_act:handle(33104, NewPS, [?CUSTOM_ACT_RECHARGE_ONE, SubId]) || #act_info{key = {_, SubId}} <- SubActInfos],
	NewPS.

%% 勾玉购买
buy_other_grade(PS, Type, SubType, GradeId) ->
	#player_status{status_custom_act = CustomAct, id = RoleId} = PS,
	#status_custom_act{data_map = DataMap} = CustomAct,
	case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(cost, 1, Condition) of
				{cost, Cost} ->  %%可以触发这个礼包
					case lib_goods_api:cost_object_list_with_check(PS, Cost, buy_one_gift, "") of
						{true, NewPs} ->
							case maps:get({Type, SubType}, DataMap, []) of
								#custom_act_data{data = OldState} = Data ->
									case OldState of
										[1] ->
											Data1 = Data;
										[2] ->
											Data1 = Data;
										_ ->
											Data1 = Data#custom_act_data{id = {Type, SubType}, subtype = SubType, type = Type, data = [1]},
											lib_custom_act:db_save_custom_act_data(RoleId, Data1)
									end;
								_ ->
									Data1 = #custom_act_data{id = {Type, SubType}, subtype = SubType, type = Type, data = [1]},
									lib_custom_act:db_save_custom_act_data(RoleId, Data1)
							end,
							NewDataMap = maps:put({Type, SubType}, Data1, DataMap),
							NewCustomAct = CustomAct#status_custom_act{data_map = NewDataMap},
							NewPS2 = NewPs#player_status{status_custom_act = NewCustomAct},
							pp_custom_act:handle(33104, NewPS2, [Type, SubType]),
							{ok, BinData} = pt_332:write(33265, [Type, SubType, GradeId, ?SUCCESS]),
							lib_server_send:send_to_sid(NewPS2#player_status.sid, BinData),
							{ok, NewPS2};
						{false, Error, _} ->
							{false, Error}
					end;
				_ ->
					{false, ?FAIL}
			end;
		_ ->
			{false, ?FAIL}
	end.

%%奖励状态
info(Player, Type, SubType) ->
	#player_status{status_custom_act = CustomAct, sid = Sid} = Player,
	#status_custom_act{data_map = Map} = CustomAct,
	case maps:get({Type, SubType}, Map, []) of
		#custom_act_data{data = Status} ->
			case Status of
				[0] ->
%%					?MYLOG("cym", "Map ~p~n", [Map]),
					RewardStatus = 0;
				[1] ->
					RewardStatus = 1;
				[2] ->
					RewardStatus = 2
			end;
		_ ->
			RewardStatus = 0
	end,
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(GradeId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
			#custom_act_reward_cfg{
				name = Name, desc = Desc, condition = Condition, format = Format, reward = Reward
			} ->
				ConditionStr = util:term_to_string(Condition),
				RewardStr = util:term_to_string(Reward),
				[{GradeId, Format, RewardStatus, 0, Name, Desc, ConditionStr, RewardStr} | Acc];
			_ ->
				Acc
		end
	    end,
	PackList = lists:foldl(F, [], GradeIds),
%%	?MYLOG("cym", "PackList ~p~n", [PackList]),
	{ok, Bin} = pt_331:write(33104, [Type, SubType, PackList]),
	lib_server_send:send_to_sid(Sid, Bin).


%%领取奖励
get_reward(PS, Type, SubType, GradeId) ->
	#player_status{status_custom_act = CustomAct, sid = Sid, id = RoleId} = PS,
	#status_custom_act{data_map = Map} = CustomAct,
	case maps:get({Type, SubType}, Map, []) of
		#custom_act_data{data = OldState} = Data ->
			case OldState of
				[1] ->  %%可以领取
					case send_reward(PS, Type, SubType, GradeId) of
						{true, NewPS} ->
							NewData = Data#custom_act_data{data = [2]},
							lib_custom_act:db_save_custom_act_data(RoleId, NewData),
							NewMap = maps:put({Type, SubType}, NewData, Map),
							NewCustomAct = CustomAct#status_custom_act{data_map = NewMap},
							{ok, NewPS#player_status{status_custom_act = NewCustomAct}};
						{false, Err} ->
							{ok, Bin} = pt_331:write(33100, [Err]),
							lib_server_send:send_to_sid(Sid, Bin),
							{ok, PS}
					end;
				[2] ->  %%已经领取
					send_error(Sid, ?ERRCODE(err331_already_get_reward)),
					{ok, PS};
				_ ->
					send_error(Sid, ?ERRCODE(err331_act_can_not_get)),
					{ok, PS}
			end;
		_ ->
			send_error(Sid, ?ERRCODE(err331_act_can_not_get)),
			{ok, PS}
	end.



%%发送奖励
send_reward(PS, Type, SubType, GradeId) ->
	#player_status{id = RoleId, sid = Sid} = PS,
	case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
		#custom_act_reward_cfg{} = RewardCfg ->
			Reward = lib_custom_act_util:count_act_reward(PS, RewardCfg),
			lib_goods_api:send_reward_with_mail(RoleId, #produce{reward = Reward, type = recharge_one_reward}),
			lib_server_send:send_to_sid(Sid, pt_331, 33105, [?SUCCESS, Type, SubType, GradeId]),
%%			?MYLOG("one", "Reward ~p~n", [Reward]),
			lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
			{true, PS};
		_ ->
			{false, ?ERRCODE(err331_no_act_reward_cfg)}
	end.

send_error(Sid, ERROR) ->
	{ok, Bin} = pt_331:write(33100, [ERROR]),
	lib_server_send:send_to_sid(Sid, Bin).






day_clear_act_data(Type, SubType) ->
	Sql = io_lib:format(<<"delete from custom_act_data  where type = ~p  and  subtype = ~p">>,
		[Type, SubType]),
	db:execute(Sql),
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_recharge_one, day_clear_act_data, [Type, SubType]) || E <- OnlineRoles].



day_clear_act_data(PS, Type, SubType) ->
	#player_status{status_custom_act = CustomAct} = PS,
	#status_custom_act{data_map = Map} = CustomAct,
	NewMap = maps:remove({Type, SubType}, Map),
	NewCustomAct = CustomAct#status_custom_act{data_map = NewMap},
	PS#player_status{status_custom_act = NewCustomAct}.


































































