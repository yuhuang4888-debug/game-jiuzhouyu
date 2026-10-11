%%%-----------------------------------
%%% @Module      : lib_local_chrono_rift_act
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 05. 十二月 2019 11:42
%%% @Description : 时空裂缝相关活动
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_local_chrono_rift_act).
-author("carlos").
-include("chrono_rift.hrl").
-include("server.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("common.hrl").
-include("rec_event.hrl").
-include("def_event.hrl").
-include("rec_recharge.hrl").
-include("def_recharge.hrl").
-include("def_module.hrl").
%% API
-export([]).



handle_event(Player, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{recharge_product = Product, gold = Gold}}) ->
	#player_status{id = RoleId} = Player,
	IsTrigger = lib_recharge_api:is_trigger_recharge_act(Product),
	RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
	if
		IsTrigger, RealGold > 0 -> lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_RECHARGE, 1, Gold);
		true -> skip
	end,
	{ok, Player};


handle_event(#player_status{id = RoleId} = Player, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data}) ->
	#callback_money_cost{cost = Gold, money_type = MoneyType, consume_type = ConsumeType} = Data,
	case lib_consume_data:is_consume_for_act(ConsumeType) of
		true ->
			case MoneyType of
				?GOLD ->
					lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_GOODS, 1, Gold),
					lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_GOODS, 2, Gold),
					lib_local_chrono_rift_act:role_success_finish_act(RoleId, ?MOD_GOODS, 3, Gold);
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	{ok, Player}.



login(PS) ->
	#player_status{id = RoleId} = PS,
	case lib_chrono_rift_data:db_get_status_role(RoleId) of
		[Values, ActList, TodayValue, CastleId, TodayReward, SeasonReward] ->
			RoleChronoRift = #chrono_rift_in_ps{scramble_value = Values, today_reward_list = util:bitstring_to_term(TodayReward),
				season_reward = util:bitstring_to_term(SeasonReward),
				act_list = util:bitstring_to_term(ActList), today_value = TodayValue, castle_id = CastleId};
		_ ->
			RoleChronoRift = #chrono_rift_in_ps{}
	end,
%%	?MYLOG("choron", "RoleChronoRift ~p~n", [RoleChronoRift]),
	PS#player_status{chrono_rift = RoleChronoRift}.




%% -----------------------------------------------------------------
%% @desc     功能描述    完成某项任务  只能在线完成
%% @param    参数       RoleId::玩家id  Mod:模块id,  SubMod::子模块id  Count::完成次数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
role_success_finish_act(RoleId, Mod, SubMod, Count) when is_integer(RoleId) ->
%%	?PRINT("++++++++++++++++++ ~p ~n", [{RoleId, Mod, SubMod, Count}]),
	lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_local_chrono_rift_act, role_success_finish_act2, [Mod, SubMod, Count]).


role_success_finish_act2(PS, Mod, SubMod, Count) ->
%%	?MYLOG("chrono", "{Mod, SubMod} ~p~n", [{Mod, SubMod}]),
	#player_status{chrono_rift = ChronoRift, id = RoleId, figure = F} = PS,
	#chrono_rift_in_ps{act_list = ActList, today_value = OldTodayValue, scramble_value = ScrambleValue, castle_id = CastleId} = ChronoRift,
	#figure{lv = RoleLv} = F,
	LvLimit = ?CR_ROLE_LV,
	NeedOpenDay = ?CR_OPEN_DAY,
	OpenDay = util:get_open_day(),
%%	?PRINT("LvLimit ~p,  RoleLv ~p~n ", [LvLimit, RoleLv]),
	if
		OpenDay < NeedOpenDay ->
%%			?MYLOG("chrono", "{Mod, SubMod} ~p~n", [{Mod, SubMod}]),
			PS;
		RoleLv >=  LvLimit ->
			case check_act(Mod, SubMod) of
				#chrono_act_cfg{count = NeedCount, max_value = MaxValue, value = Value, type = ActType} ->
					case lists:keyfind({Mod, SubMod}, 1, ActList) of
						{_, OldCount} ->  %%
%%					        ?MYLOG("chrono", "{Mod, SubMod} ~p~n", [{Mod, SubMod}]),
							MaxCount = trunc(MaxValue / Value * NeedCount),    %% 最大完成次数
							OldGoalCount = trunc(OldCount / NeedCount),       %% 旧的完成任务次数
							NewCount = min(Count + OldCount, MaxCount),       %% 新的完成数值
							NewGoalCount = trunc(NewCount / NeedCount);        %% 新的完成任务次数
						_ ->  %% 第一次完成
							MaxCount = trunc(MaxValue / Value * NeedCount),    %% 最大完成次数
							OldGoalCount = 0,                                 %% 旧的完成任务次数
							NewCount = min(Count, MaxCount),                  %% 新的完成数值
							NewGoalCount = trunc(NewCount / NeedCount)         %% 新的完成任务次数
					end,
					if
						NewGoalCount > OldGoalCount ->
							%%注入争夺值
							AddValue = Value * (NewGoalCount - OldGoalCount),
							if
								ActType == 3 ->  %% 钻石类型的争夺值
									Msg = [?goal3, config:get_server_id(), config:get_server_num(), util:get_server_name(), AddValue],
									mod_clusters_node:apply_cast(mod_kf_chrono_rift,
										add_goal_value, [config:get_server_id(), Msg]);
								true ->
									skip
							end,
							lib_chrono_rift:add_scramble_value(RoleId, F#figure.name, CastleId, AddValue, ScrambleValue + AddValue, OldTodayValue, Mod, SubMod, Count, NewCount);
						true ->
							lib_chrono_rift:add_scramble_value(RoleId, F#figure.name, CastleId, 0, ScrambleValue , OldTodayValue, Mod, SubMod, Count, NewCount)
					end,
					PS;
				_ ->
					PS
			end;
		true ->
			PS
	end.




check_act(Mod, SubMod) ->
	case data_chrono_rift:get_act(Mod, SubMod) of
		#chrono_act_cfg{} = Cfg ->
			Cfg;
		_ ->
			false
	end.

%% 每日清理
day_trigger() ->
	Sql = io_lib:format("update   chrono_rift_role  set   today_scramble_value = 0 ,  act_list = '[]', today_reward_list = '[]'", []),
	db:execute(Sql),
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, ?HAND_OFFLINE, lib_local_chrono_rift_act, day_trigger, []) || RoleId <- IdList].


day_trigger(PS) ->
	#player_status{chrono_rift = ChronoRift, id = RoleId} = PS,
	#chrono_rift_in_ps{today_reward_list = TodayList, today_value = TodayValue} = ChronoRift,
	NewChronoRift = ChronoRift#chrono_rift_in_ps{today_reward_list = [], today_value = 0, act_list = []},
    lib_chrono_rift_data:db_save_status_role(RoleId, NewChronoRift),
	StageList = data_chrono_rift:get_stage_list(),
	F = fun({StageId, NeedValue}, AccReward) ->
		if
			TodayValue >= NeedValue ->
				case lists:keyfind(StageId, 1, TodayList) of
					{_, 2} ->  %% 已经领取了
						AccReward;
					_ ->
						Reward = data_chrono_rift:get_stage_reward(StageId),
						Reward ++ AccReward
				end;
			true ->
				AccReward
		end
	    end,
	AllReward = lists:foldl(F, [], StageList),
	if
		AllReward == []->
			skip;
		true ->
			Title = utext:get(2040005),
			Content = utext:get(2040006),
			lib_mail_api:send_sys_mail([RoleId], Title, Content, AllReward)
	end,
	NewPS = PS#player_status{chrono_rift = NewChronoRift},
	pp_chrono_rift:handle(20405, NewPS, []),
	NewPS.


is_season_day() ->
	Day = utime:day_of_month(),
	if
		Day == 16 orelse Day == 1 ->
			true;
		true ->
			false
	end.
