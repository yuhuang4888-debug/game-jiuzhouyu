%%%--------------------------------------
%%% @Module  : 
%%% @Author  : 
%%% @Created : 
%%% @Description:  
%%%--------------------------------------
-module(lib_boss_rotary).
-export([

    ]).
-compile(export_all).
-include("server.hrl").
-include("boss.hrl").
-include("boss_rotary.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("def_module.hrl").
-include("errcode.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").
login(PS) ->
	#player_status{id = RoleId} = PS,
	case db_select_boss_rotary(RoleId) of 
		[] -> PS#player_status{boss_rotary = #boss_rotary{}};
		DbList ->
			NowTime = utime:unixtime(),
			F = fun([RotaryId, BossType, BossRewardLevel, Wlv, BossId, IsAbandon, RewardGetStr, RewardShowStr, Time], Acc) ->
				case utime_logic:is_logic_same_day(NowTime, Time) of
					true ->
						RotaryInfo = #rotary_info{
							rotary_id = RotaryId, boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId, is_abandon = IsAbandon,
							reward_get = util:bitstring_to_term(RewardGetStr), reward_show = util:bitstring_to_term(RewardShowStr), time = Time
						},
						[RotaryInfo|Acc];
					_ ->
						Acc
				end
			end,
			RotaryList = lists:foldl(F, [], DbList),
			%?PRINT("login RotaryList:~p~n", [RotaryList]),
			PS#player_status{boss_rotary = #boss_rotary{rotary_list = RotaryList}}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 每日清理
daily_clear() ->
    util:rand_time_to_delay(1000, lib_boss_rotary, daily_clear_do, []).

daily_clear_do() ->
	db:execute(io_lib:format(<<"truncate table boss_rotary">>, [])),
    RefreshList = ets:tab2list(?ETS_ONLINE),
    [clear_boss_rotary(OnlineRole#ets_online.id) || OnlineRole <- RefreshList].

clear_boss_rotary(RoleId) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, clear_boss_rotary, []);
clear_boss_rotary(PS) ->
	PS#player_status{boss_rotary = #boss_rotary{}}.

gm_clear_boss_rotary(PS) ->
	#player_status{id = RoleId, boss_rotary = _BossRotary} = PS,
	db:execute(io_lib:format(<<"delete from boss_rotary where role_id=~p">>, [RoleId])),
	PS#player_status{boss_rotary = #boss_rotary{}}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 断开连接
% handle_event(PS, #event_callback{type_id = ?EVENT_DISCONNECT_HOLD_END}) when is_record(PS, player_status) ->
% 	#player_status{id = RoleId, boss_rotary = BossRotary} = PS,
% 	#boss_rotary{rotary_list = OldRotaryList} = BossRotary,
% 	NowTime = utime:unixtime(),
% 	F = fun(RotaryInfo, {List, List2, List3}) ->
% 		#rotary_info{
% 			rotary_id = RotaryId, boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId, 
% 			is_abandon = IsAbandon, reward_get = RewardGet
% 		} = RotaryInfo,
% 		case rotary_complete(IsAbandon, RewardGet) of 
% 			false -> 
% 				NList3 = [[RoleId, 3, RotaryId, BossType, BossRewardLevel, Wlv, BossId, util:term_to_bitstring(RewardGet), NowTime]|List3],
% 				{[RotaryInfo#rotary_info{is_abandon = 1}|List], [RotaryId|List2], NList3};
% 			_ ->
% 				{[RotaryInfo|List], List2, List3}
% 		end
% 	end,
% 	{NewRotaryList, UpList, LogList} = lists:foldl(F, {[], [], []}, OldRotaryList),
% 	%?PRINT("EVENT_DISCONNECT_HOLD_END UpList ~p~n", [UpList]),
% 	case UpList of 
% 		[] -> skip;
% 		_ ->
% 			lib_log_api:log_boss_rotary_event(LogList),
% 			Sql = io_lib:format(<<"update boss_rotary set is_abandon=1 where role_id=~p and rotary_id in (~s)">>, [RoleId, ulists:list_to_string(UpList, ",")]),
% 			db:execute(Sql)
% 	end,
% 	{ok, PS#player_status{boss_rotary = BossRotary#boss_rotary{rotary_list = NewRotaryList}}};
%% 在转盘过程中断线，处理一下传闻  ### skip
% handle_event(PS, #event_callback{type_id = ?EVENT_DISCONNECT}) when is_record(PS, player_status) ->
% 	#player_status{id = RoleId, boss_rotary = BossRotary} = PS,
% 	#boss_rotary{rotary_list = OldRotaryList} = BossRotary,
% 	F = fun(RotaryInfo, List) ->
% 		#rotary_info{
% 			rotary_id = _RotaryId, boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId, 
% 			is_abandon = IsAbandon, reward_get = RewardGet
% 		} = RotaryInfo,
% 		case IsAbandon == 0 of
% 			true ->
% 				case [{PoolId1, RewardId1} || {PoolId1, RewardId1, IsGet, IsEnd} <- lists:reverse(RewardGet), IsGet == 1, IsEnd == 0] of 
% 					[{PoolId, RewardId}|_] ->
% 						case data_boss_rotary:get_reward_cfg(BossType, BossRewardLevel, Wlv, PoolId, RewardId) of 
% 							#base_boss_rotary{rewards = Rewards, is_tv = IsTv} -> ok;
% 							_ -> Rewards = [], IsTv = 0
% 						end,
% 						send_reward_tv(PS, BossType, BossId, Rewards, IsTv),
% 						NewRotaryInfo = update_rotary(RoleId, RotaryInfo, {PoolId, RewardId, 1, 1}),
% 						[NewRotaryInfo|List];
% 					_ ->
% 						[RotaryInfo|List]
% 				end;
% 			_ ->
% 				[RotaryInfo|List]
% 		end
% 	end,
% 	NewRotaryList = lists:foldl(F, [], OldRotaryList),
% 	{ok, PS#player_status{boss_rotary = BossRotary#boss_rotary{rotary_list = NewRotaryList}}};
handle_event(PS, _EventCallback) ->
	{ok, PS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% boss击杀触发转盘  ###skip
boss_be_kill(_RoleId, _BossType, _BossId) -> ok.
% boss_be_kill(RoleId, BossType, BossId) when is_integer(RoleId) -> 
% 	lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, boss_be_kill, [BossType, BossId]);
% boss_be_kill(PS, BossType, BossId) ->
% 	#player_status{id = RoleId, sid = Sid, boss_rotary = BossRotary, figure = #figure{lv = Lv}} = PS,
% 	case data_mon:get(BossId) of 
% 		#mon{lv = BossLevel} -> ok;
% 		_ -> BossLevel = 0
% 	end,
% 	BossCountCfg = data_boss_rotary:get_key(?BOSS_ROTARY_KEY_1),
% 	{_, BossCountLimit, RandWeightList} = ulists:keyfind(BossType, 1, BossCountCfg, {BossType, 0, []}),
% 	WorldLevel = util:get_world_lv(),
% 	BossRewardLevel = get_boss_reward_level(BossType, BossLevel),
% 	Wlv = get_reward_wlv(BossType, WorldLevel),
% 	OpenLv = data_boss_rotary:get_key(?BOSS_ROTARY_KEY_3),
% 	?PRINT("boss_be_kill {BossCountLimit, BossRewardLevel} ~p~n", [{BossCountLimit, BossLevel, BossRewardLevel, Wlv}]),
% 	if
% 		Lv < OpenLv -> CanTrigger = {false, 1};
% 		RandWeightList == [] -> CanTrigger = {false, 2};
% 		BossRewardLevel == 0 orelse Wlv == -1 -> CanTrigger = {false, 3};
% 		true ->
% 			Count = mod_daily:get_count(RoleId, ?MODULE_BOSS_ROTARY, 1, BossType),
% 			NextCount = Count + 1,
% 			{_, RandWeight} = ulists:keyfind(NextCount, 1, RandWeightList, {NextCount, 0}),
% 			RandSucc = urand:rand(1, 10000) =< RandWeight,
% 			?PRINT("boss_be_kill {NextCount, RandSucc} ~p~n", [{NextCount, RandSucc}]),
% 			if
% 				NextCount > BossCountLimit -> CanTrigger = {false, 4};
% 			 	RandSucc == false -> CanTrigger = {false, 5};
% 				true ->
% 					CanTrigger = true
% 					%IsExist = exist_not_complete_rotary(BossType, BossRotary#boss_rotary.rotary_list),
% 					%CanTrigger = ?IF(IsExist, {false, 6}, true)		
% 			end
% 	end,
% 	?PRINT("boss_be_kill CanTrigger ~p~n", [CanTrigger]),
% 	case CanTrigger of
% 		true ->
% 			#boss_rotary{rotary_list = OldRotaryList} = BossRotary,
% 			RotaryId = get_rotary_id(BossRotary),
% 			AlreadyRankRewardIdList = get_already_rand_reward_list(BossType, BossRewardLevel, Wlv, OldRotaryList),
% 			{RewardGet, RewardShow} = rand_rotary_reward(BossType, BossRewardLevel, Wlv, AlreadyRankRewardIdList),
% 			NewRotaryInfo = #rotary_info{
% 				rotary_id = RotaryId, boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId,
% 				reward_get = RewardGet, reward_show = RewardShow, time = utime:unixtime()
% 			},
% 			%% db
% 			db_replace_boss_rotary(RoleId, NewRotaryInfo),
% 			%% 推送
% 			RewardInfoList = pack_reward(BossType, BossRewardLevel, Wlv, RewardGet++RewardShow),
% 			{ok, Bin} = pt_510:write(51002, [RotaryId, BossType, BossRewardLevel, BossId, RewardInfoList]),
% 			lib_server_send:send_to_sid(Sid, Bin),
% 			NewRotaryList = [NewRotaryInfo|OldRotaryList],
% 			?PRINT("boss_be_kill NewRotaryInfo ~p~n", [NewRotaryInfo]),
% 			mod_daily:increment(RoleId, ?MODULE_BOSS_ROTARY, 1, BossType),
% 			lib_log_api:log_boss_rotary_event([[RoleId, 1, RotaryId, BossType, BossRewardLevel, Wlv, BossId, util:term_to_bitstring(RewardGet), utime:unixtime()]]),
% 			{ok, PS#player_status{boss_rotary = BossRotary#boss_rotary{rotary_list = NewRotaryList}}};
% 		{false, _R} ->
% 			{ok, PS}
% 	end.

send_rotary_list(PS) ->
	#player_status{sid = Sid, boss_rotary = BossRotary} = PS,
	#boss_rotary{rotary_list = RotaryList} = BossRotary,
	InfoList = pack_rotary_list(RotaryList),
	?PRINT("send_rotary_list InfoList:~p~n", [InfoList]),
	lib_server_send:send_to_sid(Sid, pt_510, 51001, [InfoList]).

abandon_rotary(PS, RotaryId) ->
	#player_status{id = RoleId, boss_rotary = BossRotary} = PS,
	#boss_rotary{rotary_list = RotaryList} = BossRotary,
	case lists:keyfind(RotaryId, #rotary_info.rotary_id, RotaryList) of 
		#rotary_info{boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId, reward_get = RewardGet} = RotaryInfo ->
			NewRotaryInfo = RotaryInfo#rotary_info{is_abandon = 1},
			db:execute(io_lib:format(<<"update boss_rotary set is_abandon=~p where role_id=~p and rotary_id=~p ">>, [1, RoleId, RotaryId])),
			NewRotaryList = lists:keyreplace(RotaryId, #rotary_info.rotary_id, RotaryList, NewRotaryInfo),
			lib_log_api:log_boss_rotary_event([[RoleId, 2, RotaryId, BossType, BossRewardLevel, Wlv, BossId, util:term_to_bitstring(RewardGet), utime:unixtime()]]),
			{ok, PS#player_status{boss_rotary = BossRotary#boss_rotary{rotary_list = NewRotaryList}}};
		_ ->
			{ok, PS}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 转盘抽奖
get_rotary_reward(PS, RotaryId) ->
	#player_status{id = RoleId, boss_rotary = BossRotary} = PS,
	#boss_rotary{rotary_list = RotaryList} = BossRotary,
	case lists:keyfind(RotaryId, #rotary_info.rotary_id, RotaryList) of 
		#rotary_info{boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, is_abandon = 0, reward_get = RewardGot} = RotaryInfo ->
			case find_reward_id(RewardGot, 1) of 
				{ok, PoolId, RewardId, GotTimes} ->
					case data_boss_rotary:get_reward_cfg(BossType, BossRewardLevel, Wlv, PoolId, RewardId) of 
						#base_boss_rotary{rewards = Rewards, is_tv = _IsTv} ->
							case get_cost(GotTimes) of 
								{ok, CostList} ->
									Remark = util:link_list([BossType, BossRewardLevel, Wlv, PoolId, RewardId]),
									case lib_goods_api:cost_objects_with_auto_buy(PS, CostList, boss_rotary, Remark) of
										{true, PS1, NewObjectList} ->
											lib_log_api:log_boss_rotary_reward(RoleId, RotaryId, BossType, BossRewardLevel, Wlv, PoolId, RewardId, NewObjectList, Rewards),
											NewRotaryInfo = update_rotary(RoleId, RotaryInfo, {PoolId, RewardId, 1, 0}),
											NewRotaryList = lists:keyreplace(RotaryId, #rotary_info.rotary_id, RotaryList, NewRotaryInfo),
											PS2 = PS1#player_status{boss_rotary = BossRotary#boss_rotary{rotary_list = NewRotaryList}},
											Produce = #produce{type = boss_rotary, reward = Rewards, remark = Remark},
											{ok, NewPS} = lib_goods_api:send_reward_with_mail(PS2, Produce),
											?PRINT("get_rotary_reward Rewards:~p~n", [Rewards]),
											?PRINT("get_rotary_reward NewRotaryInfo:~p~n", [NewRotaryInfo]),
											{ok, NewPS, PoolId, RewardId, Rewards};
										{false, Res, _} ->
											{false, Res}
									end;
								_ ->
									{false, ?MISSING_CONFIG}
							end;
						_ -> {false, ?MISSING_CONFIG}
					end;
				_ ->
					{false, ?ERRCODE(err510_all_got)}
			end;
		#rotary_info{} ->
			{false, ?ERRCODE(err510_had_abandon)};
		_ ->
			{false, ?ERRCODE(err510_no_rotary)}
	end.

%% 转盘结束后续处理
rotary_end(PS, RotaryId) ->
	#player_status{id = RoleId, boss_rotary = BossRotary} = PS,
	#boss_rotary{rotary_list = RotaryList} = BossRotary,
	case lists:keyfind(RotaryId, #rotary_info.rotary_id, RotaryList) of 
		#rotary_info{boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId, is_abandon = 0, reward_get = RewardGot} = RotaryInfo ->
			case [{PoolId1, RewardId1} || {PoolId1, RewardId1, IsGet, IsEnd} <- RewardGot, IsGet == 1, IsEnd == 0] of 
				[{PoolId, RewardId}|_] ->
					case data_boss_rotary:get_reward_cfg(BossType, BossRewardLevel, Wlv, PoolId, RewardId) of 
						#base_boss_rotary{rewards = Rewards, is_tv = IsTv} -> ok;
						_ -> Rewards = [], IsTv = 0
					end,
					send_reward_tv(PS, BossType, BossId, Rewards, IsTv),
					NewRotaryInfo = update_rotary(RoleId, RotaryInfo, {PoolId, RewardId, 1, 1}),
					NewRotaryList = lists:keyreplace(RotaryId, #rotary_info.rotary_id, RotaryList, NewRotaryInfo),
					%?PRINT("rotary_end NewRotaryInfo:~p~n", [NewRotaryInfo]),
					NewPS = PS#player_status{boss_rotary = BossRotary#boss_rotary{rotary_list = NewRotaryList}},
					{ok, NewPS};
				_ ->
					ok
			end;
		_ ->
			ok
	end.


update_rotary(RoleId, RotaryInfo, {PoolId, RewardId, IsGet, IsEnd}) ->
	#rotary_info{rotary_id = RotaryId, reward_get = RewardGot} = RotaryInfo,
	NewRewardGot = update_reward_got(RewardGot, {PoolId, RewardId, IsGet, IsEnd}, []),
	NewRotaryInfo = RotaryInfo#rotary_info{reward_get = NewRewardGot},
	db:execute(io_lib:format(<<"update boss_rotary set reward_get = '~s' where role_id=~p and rotary_id=~p ">>, [util:term_to_bitstring(NewRewardGot), RoleId, RotaryId])),
	NewRotaryInfo.

update_reward_got([], _, Return) -> lists:reverse(Return);
update_reward_got([{P1, R1, S1, S2}|RewardGot], {PoolId, RewardId, _IsGet, _IsEnd} = Item, Return) ->
	case P1 == PoolId andalso R1 == RewardId of 
		true ->
			update_reward_got(RewardGot, Item, [Item|Return]);
		_ ->
			update_reward_got(RewardGot, Item, [{P1, R1, S1, S2}|Return])
	end.


pack_rotary_list(RotaryList) ->
	pack_rotary_list(RotaryList, []).

pack_rotary_list([], Return) -> Return;
pack_rotary_list([RotaryInfo|RotaryList], Return) ->
	#rotary_info{
		rotary_id = RotaryId, boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId, is_abandon = IsAbandon,
		reward_get = RewardGet, reward_show = RewardShow
	} = RotaryInfo,
	case rotary_complete(IsAbandon, RewardGet) of 
		false ->
			RewardInfoList = pack_reward(BossType, BossRewardLevel, Wlv, RewardGet++RewardShow),
			pack_rotary_list(RotaryList, [{RotaryId, BossType, BossRewardLevel, BossId, RewardInfoList}|Return]);
		_ ->
			pack_rotary_list(RotaryList, Return)
	end.

pack_reward(BossType, BossRewardLevel, Wlv, List) ->
	F = fun({PoolId, RewardId, IsGet, _IsEnd}, AccList) ->
		case data_boss_rotary:get_reward_cfg(BossType, BossRewardLevel, Wlv, PoolId, RewardId) of 
			#base_boss_rotary{rare = Rare, rewards = Rewards} ->
				[{PoolId, RewardId, Rare, IsGet, Rewards}|AccList];
			_ -> AccList
		end
	end,
	ReturnList = lists:foldl(F, [], List),
	%ulists:list_shuffle(ReturnList).
	lists:sort(fun({P1, R1, _, _, _}, {P2, R2, _, _, _}) -> 
		if
			P1 < P2 -> true;
			P1 == P2 -> R1 < R2;
			true -> false
		end
	end, ReturnList).


get_rotary_id(BossRotary) ->
	#boss_rotary{rotary_list = RotaryList} = BossRotary,
	get_rotary_id(RotaryList, 1).

get_rotary_id([], MaxRotaryId) -> MaxRotaryId + 1;
get_rotary_id([#rotary_info{rotary_id = RotaryId}|RotaryList], MaxRotaryId) ->
	get_rotary_id(RotaryList, max(MaxRotaryId, RotaryId)).


get_already_rand_reward_list(BossType, BossRewardLevel, Wlv, OldRotaryList) ->
	NowTime = utime:unixtime(),
	F = fun(#rotary_info{boss_type = BossType1, boss_reward_lv = BossRewardLevel1, wlv = Wlv1, reward_get = RewardGot, time = Time}, Acc) ->
		case 
			BossType1 == BossType andalso BossRewardLevel1 == BossRewardLevel andalso
			Wlv1 == Wlv andalso utime_logic:is_logic_same_day(NowTime, Time) of 
			true ->
				F2 = fun({PoolId, RewardId, _, _}, Acc2) ->
					{_, List} = ulists:keyfind(PoolId, 1, Acc2, {PoolId, []}),
					lists:keystore(PoolId, 1, Acc2, {PoolId, [RewardId|List]})
				end,
				lists:foldl(F2, Acc, RewardGot);
			_ -> Acc
		end
	end,
	lists:foldl(F, [], OldRotaryList).

rand_rotary_reward(BossType, BossRewardLevel, Wlv, AlreadyRankRewardIdList) ->
	PoolIdList = data_boss_rotary:get_pool_id_list(BossType, BossRewardLevel, Wlv),
	{RewardGet, LeftList} = rand_rotary_reward_helper(PoolIdList, BossType, BossRewardLevel, Wlv, AlreadyRankRewardIdList, [], []),
	RewarsShow = rand_reward_show(LeftList),
	{RewardGet, RewarsShow}.

rand_rotary_reward_helper([], _BossType, _BossRewardLevel, _Wlv, _AlreadyRankRewardIdList, Return1, Return2) ->
	{lists:reverse(Return1), Return2};
rand_rotary_reward_helper([PoolId|PoolIdList], BossType, BossRewardLevel, Wlv, AlreadyRankRewardIdList, Return1, Return2) ->
	PoolRewardList = data_boss_rotary:get_rotary_reward_list(BossType, BossRewardLevel, Wlv, PoolId),
	NewPoolRewardList = filter_reward_id(PoolId, PoolRewardList, AlreadyRankRewardIdList),
	case NewPoolRewardList of 
		[] -> rand_rotary_reward_helper(PoolIdList, BossType, BossRewardLevel, Wlv, AlreadyRankRewardIdList, Return1, Return2);
		_ ->
			{_, RewardId, _, _} = util:find_ratio(NewPoolRewardList, 3),
			NewReturn1 = [{PoolId, RewardId, 0, 0}|Return1],
			NewReturn2 = lists:keydelete(RewardId, 2, NewPoolRewardList) ++ Return2,
			rand_rotary_reward_helper(PoolIdList, BossType, BossRewardLevel, Wlv, AlreadyRankRewardIdList, NewReturn1, NewReturn2)
	end.

rand_reward_show(LeftList) ->
	rand_reward_show([{0, 1}, {1, 2}, {2, 2}], LeftList, []).

rand_reward_show([], _LeftList, Return) -> Return;
rand_reward_show([{RareNeed, Num}|RareNumList], LeftList, Return) ->
	{Satisfying, NotSatisfying} = lists:partition(fun({_, _, _, Rare}) -> Rare == RareNeed end, LeftList),
	RandList = ulists:list_shuffle(Satisfying),
	NewReturn = rand_reward_show_helper(RandList, 0, Num, Return),
	rand_reward_show(RareNumList, NotSatisfying, NewReturn).

rand_reward_show_helper(_, Num, Num, Return) -> Return;
rand_reward_show_helper([], _, _, Return) -> Return;
rand_reward_show_helper([{PoolId, RewardId, _, _}|RandList], Acc, Num, Return) ->
	rand_reward_show_helper(RandList, Acc+1, Num, [{PoolId, RewardId, 0, 0}|Return]).

filter_reward_id(PoolId, PoolRewardList, AlreadyRankRewardIdList) ->
	case lists:keyfind(PoolId, 1, AlreadyRankRewardIdList) of 
		{_, GotRewardIdList} ->
			[{PoolId1, RewardId, Weight, Rare} ||{PoolId1, RewardId, Weight, Rare} <- PoolRewardList, lists:member(RewardId, GotRewardIdList) == false];
		_ ->
			PoolRewardList
	end.

find_reward_id([], _) -> none;
find_reward_id([{PoolId, RewardId, IsGet, _IsEnd}|RewardGot], GotTimes) ->
	case IsGet == 0 of 
		true -> {ok, PoolId, RewardId, GotTimes};
		_ -> find_reward_id(RewardGot, GotTimes+1)
	end.

get_cost(GotTimes) ->
	CostConfig = data_boss_rotary:get_key(?BOSS_ROTARY_KEY_2),
	case lists:keyfind(GotTimes, 1, CostConfig) of 
		{_, GoodsTypeId, Num} ->
			{ok, ?IF(Num > 0, [{?TYPE_GOODS, GoodsTypeId, Num}], [])};
		_ -> none
	end.

get_boss_reward_level(BossType, BossLevel) -> 
	BossRewardLevelList = data_boss_rotary:get_boss_reward_level(BossType),
	ReverseBossRewardLevelList = lists:reverse(lists:sort(BossRewardLevelList)),
	get_boss_reward_level_do(ReverseBossRewardLevelList, BossLevel).

get_boss_reward_level_do([], _BossLevel) -> 0;
get_boss_reward_level_do([BossRewardLevel|BossRewardLevelList], BossLevel) ->
	case BossLevel >= BossRewardLevel of 
		true -> BossRewardLevel;
		_ -> get_boss_reward_level_do(BossRewardLevelList, BossLevel)
	end. 

get_reward_wlv(BossType, WorldLevel) ->
	WlvList = data_boss_rotary:get_reward_wlv(BossType),
	ReverseWlvList = lists:reverse(lists:sort(WlvList)),
	get_reward_wlv_do(ReverseWlvList, WorldLevel).

get_reward_wlv_do([], _WorldLevel) -> -1;
get_reward_wlv_do([Wlv|WlvList], WorldLevel) ->
	case WorldLevel >= Wlv of 
		true -> Wlv;
		_ -> get_reward_wlv_do(WlvList, WorldLevel)
	end. 

exist_not_complete_rotary(BossType, RotaryList) ->
	F = fun(#rotary_info{boss_type = BossType1, is_abandon = IsAbandon, reward_get = RewardGet}) ->
		case BossType1 == BossType of 
			true ->
				case rotary_complete(IsAbandon, RewardGet) of 
					false -> %% 存在没全部领完的转盘
						true;
					_ -> false
				end;
			_ -> false
		end
	end,
	case lists:filter(F, RotaryList) of 
		[] -> false;
		_ -> true
	end.

rotary_complete(IsAbandon, RewardGet) ->
	IsAbandon == 1 orelse reward_all_get(RewardGet).

reward_all_get(RewardGet) ->
	case length([1 ||{_, _, IsGet, _} <- RewardGet, IsGet == 0]) > 0 of 
		true -> %% 没全部领完
			false;
		_ -> true
	end.

send_reward_tv(PS, BossType, BossId, Rewards, 1) ->
	case Rewards of 
		[{?TYPE_GOODS, GoodsTypeId, Num}|_] -> 
			#player_status{id = RoleId} = PS,
			RoleName = lib_player:get_wrap_role_name(PS),
			BossTypeName = lib_boss_api:get_boss_type_name(BossType),
			#mon{name = BossName} = data_mon:get(BossId),
			JumpId = get_jump_id(BossType),
			lib_chat:send_TV({all}, 510, 1, [RoleName, RoleId, util:make_sure_binary(BossTypeName), util:make_sure_binary(BossName), GoodsTypeId, Num, JumpId]);
		_ -> ok
	end;
send_reward_tv(_PS, _BossType, _BossId, _Rewards, _) ->
	ok.

get_jump_id(?BOSS_TYPE_NEW_OUTSIDE) -> 26;
get_jump_id(?BOSS_TYPE_DOMAIN) -> 135;
get_jump_id(?BOSS_TYPE_KF_GREAT_DEMON) -> 135;
get_jump_id(_) -> 26.

db_replace_boss_rotary(RoleId, RotaryInfo) ->
	#rotary_info{
		rotary_id = RotaryId, boss_type = BossType, boss_reward_lv = BossRewardLevel, wlv = Wlv, boss_id = BossId, is_abandon = IsAbandon,
		reward_get = RewardGet, reward_show = RewardShow, time = Time
	} = RotaryInfo,
	Sql = usql:replace(boss_rotary, [role_id, rotary_id, boss_type, boss_reward_lv, wlv, boss_id, is_abandon, reward_get, reward_show, time], 
		[[RoleId, RotaryId, BossType, BossRewardLevel, Wlv, BossId, IsAbandon, util:term_to_bitstring(RewardGet), util:term_to_bitstring(RewardShow), Time]]),
	db:execute(Sql).

db_select_boss_rotary(RoleId) ->
	db:get_all(io_lib:format(<<"select rotary_id, boss_type, boss_reward_lv, wlv, boss_id, is_abandon, reward_get, reward_show, time from boss_rotary where role_id=~p">>, [RoleId])).
