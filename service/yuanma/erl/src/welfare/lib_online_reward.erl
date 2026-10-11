%% ---------------------------------------------------------------------------
%% @doc 在线福利
%% @author xlh
%% @since  2018-10-26
%% @deprecated
%% ---------------------------------------------------------------------------

-module(lib_online_reward).

-include("welfare.hrl").
-include("common.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("investment.hrl").

-compile(export_all).

login(Ps) ->
	#player_status{id = RoleId, figure = Figure, last_login_time = LoginTime} = Ps,
	RoleLv = Figure#figure.lv,
	RewardL = get_reward_id(RoleLv),
	case RewardL of
		[] ->
			?ERR("online_reward RoleLv:~p~n",[RoleLv]),
			NewOnlineS = Ps#player_status.online_reward;
		_ ->
			case db_select(RoleId) of
			 	[RewardState, OnlineTime, Utime] ->
			 		IsSameDay = utime_logic:is_logic_same_day(Utime, LoginTime), %%是否是同一天 
			 		if
						IsSameDay == false ->  %%刷新数据
							NewRewardState = db_insert(RoleId, RewardL),
							NewOnlineS = #status_online_reward{login_time = LoginTime, online_time = 0, time = LoginTime,
								reward = NewRewardState};
						true ->
							NewRewardState = calc_reward_state(RewardState, RoleId, RoleLv, OnlineTime, RewardState),
							NewOnlineS = #status_online_reward{login_time = LoginTime, online_time = OnlineTime,
			 					time = LoginTime, reward = NewRewardState}
					end;
			 	_ ->
			 		NewRewardState = db_insert(RoleId, RewardL),
					NewOnlineS = #status_online_reward{login_time = LoginTime, online_time = 0, 
						 time = LoginTime, reward = NewRewardState}
			 end
			
	end,
	NewPs = Ps#player_status{online_reward = NewOnlineS},
	NewPs.

gm_reset() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_online_reward, gm_reset_helper, []) || E <- OnlineRoles].

gm_reset_helper(Ps) ->
	#player_status{id = RoleId, figure = Figure, last_login_time = LoginTime, online_reward = OnlineS} = Ps,
	RoleLv = Figure#figure.lv,
	#status_online_reward{login_time = LoginTime, online_time = OnlineTime, reward = RewardState} = OnlineS,
	NewRewardState = calc_reward_state(RewardState, RoleId, RoleLv, OnlineTime, RewardState),
	get_info(Ps#player_status{online_reward = OnlineS#status_online_reward{reward = NewRewardState}}).

calc_reward_state([], _RoleId, RoleLv, _OnlineTime, []) ->
	RewardL = get_reward_id(RoleLv),
	Fun = fun(RewardId, Acc) ->
		[{RewardId, 0}|Acc]
	end,
	lists:foldl(Fun, [], RewardL);
calc_reward_state([], _RoleId, _RoleLv, _OnlineTime, RewardState) -> RewardState;
calc_reward_state([{Id, _}|RewardState], RoleId, RoleLv, OnlineTime, NewRewardState) ->
	case data_welfare:get_online_reward(Id) of
		#online_reward_cfg{} ->
			calc_reward_state(RewardState, RoleId, RoleLv, OnlineTime, NewRewardState);
		_ ->
			RewardL = get_reward_id(RoleLv),
			Fun = fun(RewardId, Acc) ->
				[{RewardId, 0}|Acc]
			end,
			RealRewardState = lists:foldl(Fun, [], RewardL),
			db_updata(RealRewardState, RoleId, OnlineTime),
			calc_reward_state([], RoleId, RoleLv, OnlineTime, RealRewardState)
	end.
	
logout(Ps) ->
	NowTime = utime:unixtime(),
	OnlineS = Ps#player_status.online_reward,
	RoleId = Ps#player_status.id,
	#status_online_reward{online_time = OnlineTime, time = Time, reward = RewardState} = OnlineS,
	if
		Time == 0 orelse RewardState == [] ->
			skip;
		true ->
			NewTime = NowTime - Time + OnlineTime,
			db_updata(RewardState, RoleId, NewTime)
	end,
	Ps#player_status{online_reward = OnlineS#status_online_reward{online_time = 0, time = NowTime, reward = []}}.

get_info(Ps) ->
    NowTime = utime:unixtime(),
    #player_status{id = RoleId, figure = Figure, online_reward = OnlineS} = Ps,
	RoleLv = Figure#figure.lv,
	#status_online_reward{login_time = LoginTime, online_time = OnlineTime, time = Time, reward = RewardState} = OnlineS,
	IsSameDay = utime_logic:is_logic_same_day(NowTime, Time),
	%?PRINT("@@@@@@@@@@@ NowTime:~p,Time:~p~n",[NowTime,Time]),
	if
		IsSameDay == true ->
			NewTime = NowTime - Time + OnlineTime,
			NewRewardState = calc_reward_state(RewardState, RoleId, RoleLv, OnlineTime, RewardState),
			NewOnlineS = OnlineS#status_online_reward{reward = NewRewardState},
			{ok, BinData} = pt_417:write(41715, [NewTime, LoginTime, RewardState]);
		true ->
			RewardL = get_reward_id(RoleLv),
			NRewardState = db_insert(RoleId, RewardL),
		 	Four = utime:unixdate(NowTime)+4*3600,
		 	% Four = Zero+?DAY_LOGIC_OFFSET_HOUR*3600,
			NewOnlineS = #status_online_reward{login_time = Four, online_time = 0, time = Four,reward = NRewardState},
			NewTime = NowTime -Four + 0,
			%?PRINT("@@@@@@@@@@@ Four:~p,Time:~p,NewTime:~p~n",[Four,Time,NewTime]),
			{ok, BinData} = pt_417:write(41715, [NewTime, Four, NRewardState])
	end,
	lib_server_send:send_to_uid(RoleId, BinData),
	NewPs = Ps#player_status{online_reward = NewOnlineS},
    {ok,NewPs}.

send_reward(Ps, GetId) when GetId == 0 ->
	#player_status{id = RoleId, online_reward = OnlineS} = Ps,
	#status_online_reward{online_time = OnlineTime, time = TIME, reward = RewardState} = OnlineS,
	NowTime = utime:unixtime(),
	Fun = fun
		({Id, State}, {Acc, Acc1, Acc2}) when State == 0 ->
			case data_welfare:get_online_reward(Id) of
				#online_reward_cfg{online_time = LimTime,reward = RewardL} ->
					Res = (NowTime - TIME) + OnlineTime >= LimTime,
					AddRewardL = month_vip_addition(Ps, RewardL),
					if
						Res == true ->
							{[{Id, 2}|Acc], AddRewardL ++ RewardL ++ Acc1, [{Id, RewardL, AddRewardL}|Acc2]};
						true ->
							{[{Id, 0}|Acc], Acc1, Acc2}
					end;
				_ ->
					{[{Id, 0}|Acc], Acc1, Acc2}
			end;
		({Id, State}, {Acc, Acc1, Acc2}) ->
			{[{Id, State}|Acc], Acc1, Acc2}
	end,
	{NRewardState, RewardList, SendList} = lists:foldl(Fun, {[], [], []}, RewardState),
	if
		SendList =/= [] ->
			Produce = #produce{type = online_reward, subtype = 0, reward = RewardList, remark = "", show_tips = 0},
		    NewPs = lib_goods_api:send_reward(Ps, Produce),
			NewTime = NowTime - TIME + OnlineTime,
			db_updata(NRewardState, RoleId, NewTime),
			lib_log_api:log_online_reward(RoleId, RewardList, NewTime),
			IsSameDay = utime_logic:is_logic_same_day(NowTime, TIME),
			if
				IsSameDay == true ->
					NewOnlineS = OnlineS#status_online_reward{reward = NRewardState, time = NowTime, online_time = NewTime};
				true ->
					NewOnlineS = OnlineS#status_online_reward{reward = [], time = NowTime, online_time = 0}
			end,
			Code = 1,
			LastPs = NewPs#player_status{online_reward = NewOnlineS},
			{ok, BinData} = pt_417:write(41716, [Code, SendList]),
		    lib_server_send:send_to_uid(Ps#player_status.id, BinData);
		true ->
			Code = ?ERRCODE(err417_online_time_not_enougth),
			LastPs = Ps,
			{ok, BinData} = pt_417:write(41716, [Code, []]),
		    lib_server_send:send_to_uid(Ps#player_status.id, BinData)
	end,
    LastPs;
send_reward(Ps, Id) ->
	#player_status{id = RoleId, online_reward = OnlineS} = Ps,
	#status_online_reward{online_time = OnlineTime, time = TIME, reward = RewardState} = OnlineS,
	NowTime = utime:unixtime(),
	case data_welfare:get_online_reward(Id) of
		#online_reward_cfg{online_time = LimTime,reward = BaseRewardL} ->
			AddRewardL = month_vip_addition(Ps, BaseRewardL),
      RewardL = AddRewardL ++ BaseRewardL,
			Res = (NowTime - TIME) + OnlineTime >= LimTime,
			if
				Res == true ->
					case lists:keyfind(Id, 1, RewardState) of
						{Id, State} when State == 0 ->
							Produce = #produce{type = online_reward, subtype = 0, 
								reward = RewardL, remark = "", show_tips = 0},
                            NewPs = lib_goods_api:send_reward(Ps, Produce),
							NRewardState = lists:keyreplace(Id, 1, RewardState, {Id, 2}),
							NewTime = NowTime - TIME + OnlineTime,
							db_updata(NRewardState, RoleId, NewTime),
							lib_log_api:log_online_reward(RoleId, RewardL, NewTime),
							IsSameDay = utime_logic:is_logic_same_day(NowTime, TIME),
							if
								IsSameDay == true ->
									NewOnlineS = OnlineS#status_online_reward{reward = NRewardState, time = NowTime, online_time = NewTime};
								true ->
									NewOnlineS = OnlineS#status_online_reward{reward = [], time = NowTime, online_time = 0}
							end,
							Code = 1,
							LastPs = NewPs#player_status{online_reward = NewOnlineS};
						{Id, State} when State == 2 ->
							Code = ?ERRCODE(err417_checkin_gift_has_received),
							LastPs = Ps;
						_ ->
							?ERR("NO SUCH cfg ID:<<~p>>~n",[Id]),
							Code = ?ERRCODE(data_error),
							LastPs = Ps
					end;
				true ->
					Code = ?ERRCODE(err417_online_time_not_enougth),
					LastPs = Ps
			end;
		_ ->
			BaseRewardL = [],
			AddRewardL = [],
			Code = ?ERRCODE(err417_total_rewards_empty),
			LastPs = Ps
	end,
	{ok, BinData} = pt_417:write(41716, [Code, [{Id, BaseRewardL, AddRewardL}]]),
    lib_server_send:send_to_uid(Ps#player_status.id, BinData),
    LastPs.

get_reward_limit_lv(Lv, LvArry) ->
    Fun = fun({LvMin, LvMax}) ->
        Lv >= LvMin andalso Lv =< LvMax
    end,
    ulists:find(Fun, LvArry).

get_reward_id(RoleLv) ->
	LvLimitArry = data_welfare:get_limit_lv(),
	WldLvLimitArry = data_welfare:get_limit_world_lv(),
	WorldLv = util:get_world_lv(),
	case get_reward_limit_lv(RoleLv, LvLimitArry) of
		{ok, {Min, Max}} ->
			case get_reward_limit_lv(WorldLv, WldLvLimitArry) of
				{ok, {WldMin, WldMax}} ->
					data_welfare:get_reward_id_by_limit(Min,Max,WldMin,WldMax);
				_ ->
					?ERR("data_welfare ERROR cfg:~p~n",[1]),
					[]
			end;
		_ ->
			?ERR("data_welfare ERROR cfg:~p~n",[1]),
			[]
	end.

gm_clean_time(Ps) ->
	NowTime = utime:unixtime(),
	#player_status{id = RoleId, figure = Figure} = Ps,
	RoleLv = Figure#figure.lv,
	RewardL = get_reward_id(RoleLv),
	RewardState = db_insert(RoleId, RewardL),
	% ?PRINT("NowTime:~p,RewardState:~p~n",[NowTime, RewardState]),
	NewOnlineS = #status_online_reward{login_time = NowTime, online_time = 0, time = NowTime,
		reward = RewardState},
	{ok, BinData} = pt_417:write(41715, [0, NowTime, RewardState]),
	lib_server_send:send_to_uid(RoleId, BinData),
	NewPs = Ps#player_status{online_reward = NewOnlineS},
	NewPs.

gm_add_online_time(Ps, AddTime) ->
	#player_status{id = RoleId, online_reward = OnlineS} = Ps,
	#status_online_reward{online_time = OnlineTime, login_time = LoginTime, reward = RewardState} = OnlineS,
	NewOnlineS = OnlineS#status_online_reward{online_time = OnlineTime+AddTime},
	{ok, BinData} = pt_417:write(41715, [OnlineTime+AddTime, LoginTime, RewardState]),
	lib_server_send:send_to_uid(RoleId, BinData),
	Ps#player_status{online_reward = NewOnlineS}.

%% 0:00清理数据
refresh(_DelaySec) ->
    util:rand_time_to_delay(1000, lib_online_reward, refresh_data, []).

refresh_data() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_online_reward, get_info, []) || E <- OnlineRoles],
	db:execute(io_lib:format(?sql_refresh_online, [])).

db_insert(RoleId, RewardL) ->
	Fun = fun(RewardId, Acc) ->
		[{RewardId, 0}|Acc]
	end,
	RewardState = lists:foldl(Fun, [], RewardL),
	NRewardState = util:term_to_string(RewardState),
	db:execute(io_lib:format(?sql_replace_online, [NRewardState, 0, RoleId, utime:unixtime()])),
	RewardState.

db_select(RoleId) ->
	case db:get_row(io_lib:format(?sql_select_online, [RoleId])) of
		[RewardState, OnlineTime, Utime] ->
			NRewardState = util:bitstring_to_term(RewardState),
			[NRewardState, OnlineTime, Utime];
		_ ->
			[]
	end.

db_updata(RewardState, RoleId, OnlineTime) ->
	NRewardState = util:term_to_string(RewardState),
	db:execute(io_lib:format(?sql_update_online, [NRewardState, OnlineTime, utime:unixtime(), RoleId])).

month_vip_addition(Ps, RewardL) ->
	AddRate = lib_investment:get_month_card_addition(Ps, ?MONTH_CARD_VIP_DOUBLE_REWARD),
	case AddRate of
		0 -> [];
		_ ->
			[{Other, GoodsId, umath:ceil(Num * max(0, AddRate - 1))} || {Other, GoodsId, Num} <- RewardL]
	end.
