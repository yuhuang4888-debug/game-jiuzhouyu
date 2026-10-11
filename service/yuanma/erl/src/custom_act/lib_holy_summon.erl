%%%-----------------------------------
%%% @Module      : lib_holy_summon
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 18. 六月 2019 14:41
%%% @Description : 文件摘要  神圣召唤(抽奖活动)
%%%-----------------------------------
-module(lib_holy_summon).
-author("chenyiming").

-include("holy_summon.hrl").
-include("common.hrl").
-include("custom_act.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("def_module.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("server.hrl").
%% API
-compile(export_all).


login(PS) ->
	Sql = io_lib:format(?select_role_act_holy_summon, [PS#player_status.id]),
	List = db:get_all(Sql),
	ActList = [#role_act_holy_summon{key = {Type, SubType}, 
									type = Type, 
									sub_type = SubType, 
									draw_times = DrawTimes, 
									reward_status = util:bitstring_to_term(DbRewardStatus)
									,rare_draw = RareDraw
									,act_rare_draw = TotalRareDraw} || 
			[Type, SubType, DrawTimes, DbRewardStatus, RareDraw, TotalRareDraw] <- List],
	PS#player_status{holy_summon = #role_holy_summon{act_list = ActList}}.

%% 33221
info(Player, Type, SubType) ->
	#player_status{holy_summon = HolySummon, sid = Sid, id = RoleId} = Player,
	RarePool = get_rare_pool(Type, SubType),
	Pool = get_pool(Type, SubType),
	PoolGradeIds = get_show_grade(Pool),
	RarePoolGradeList = get_show_grade(RarePool),
	ShowList = construct_reward_list_for_client(Player, Type, SubType, PoolGradeIds),
	RarePoolShowList = construct_reward_list_for_client(Player, Type, SubType, RarePoolGradeList),
	GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	GradeIds = PoolGradeIds ++ RarePoolGradeList,
	TotalList = lists:subtract(GradeIdList, GradeIds),
	case HolySummon of
		#role_holy_summon{act_list = ActList} ->
			case lists:keyfind({Type, SubType}, #role_act_holy_summon.key, ActList) of
				#role_act_holy_summon{draw_times = DrawTimes, reward_status = RewardStatus, rare_draw = RareDraw} ->
					ok;
				_ ->
					DrawTimes = 0,
					RareDraw = 0,
					RewardStatus = []
			end;
		_ ->
			DrawTimes = 0,
			RareDraw = 0,
			RewardStatus = []
	end,
	FreeTimes = get_role_free_times(RoleId, Type, SubType),
	TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, DrawTimes, RewardStatus),
%%	?MYLOG("cym", "HolySummon ~p ~n", [HolySummon]),
%%	?MYLOG("cym", "~p ~n", [{Type, SubType, ?SUCCESS, DrawTimes, FreeTimes, ShowList, TotalShowList}]),
	lib_server_send:send_to_sid(Sid, pt_332, 33221, [Type, SubType, ?SUCCESS, DrawTimes, FreeTimes, ShowList, TotalShowList, RarePoolShowList, RareDraw]).

get_show_grade(Pool) ->
	Fun = fun({_, GradeId}, Acc) ->
		[GradeId | Acc]
	end,
	lists:foldl(Fun, [], Pool).

%% 组装抽中奖励数据发送给客户端
construct_reward_list_for_client(Player, Type, SubType, GradeIds) ->
	Fun = fun(GradeId, Acc) ->
		#custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
		ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
		Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
%%		IsRare = get_conditions(is_rare, Conditions),
		IsShow = get_conditions(is_show, Conditions),
		[{GradeId, IsShow, Reward} | Acc]
	end,
	lists:reverse(lists:foldl(Fun, [], GradeIds)).

get_conditions(Key, Conditions) ->
	case lists:keyfind(Key, 1, Conditions) of
		{Key, Times} ->
			skip;
		_ ->
			Times = 0
	end,
	Times.

judge_open_day(OpenDay, Conditions) ->
	case lists:keyfind(open_day, 1, Conditions) of
		{open_day, OpenDayCfg} when is_integer(OpenDayCfg) andalso OpenDayCfg =< OpenDay -> OpendaySatisfy = true;
		{open_day, OpenDayList} when is_list(OpenDayList) ->
			F = fun({DayMin, DayMax}) ->
                OpenDay >= DayMin andalso OpenDay =< DayMax
            end,
            case ulists:find(F, OpenDayList) of
                {ok, _} ->
                    OpendaySatisfy = true;
                _ ->
                    OpendaySatisfy = false
            end;
        {open_day, _} ->
        	OpendaySatisfy = false;
        _ ->
        	OpendaySatisfy = true
	end,
	OpendaySatisfy.

%% 获取可被抽取的奖励的配置
get_pool(Type, SubType) ->
	GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	WorldLv = util:get_world_lv(),
	OpenDay = util:get_open_day(),
	Fun = fun(GradeId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
			#custom_act_reward_cfg{condition = Conditions} ->
				IsRarePool = get_conditions(rare_pool, Conditions),
				Wlv = get_conditions(wlv, Conditions),
				OpendaySatisfy = judge_open_day(OpenDay, Conditions),
				if
					OpendaySatisfy == false ->
						Acc;
					Wlv > WorldLv ->
						Acc;
					IsRarePool == 1 ->
						Acc;
					true ->
						case lists:keyfind(weight, 1, Conditions) of
							{weight, Weight} ->
								[{Weight, GradeId} | Acc];
							_ ->
								Acc
						end
				end;
			_ ->
				?ERR("custom_act, condition:weight miss! Type:~p SubType:~p, GradeId:~p~n", [Type, SubType, GradeId]),
				Acc
		end
	end,
	lists:foldl(Fun, [], GradeIdList).

get_rare_pool(Type, SubType) ->
	GradeIdList = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	WorldLv = util:get_world_lv(),
	OpenDay = util:get_open_day(),
	Fun = fun(GradeId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
			#custom_act_reward_cfg{condition = Conditions} ->
				IsRarePool = get_conditions(rare_pool, Conditions),
				Wlv = get_conditions(wlv, Conditions),
				OpendaySatisfy = judge_open_day(OpenDay, Conditions),
				if
					OpendaySatisfy == false ->
						Acc;
					Wlv > WorldLv ->
						Acc;
					IsRarePool == 1 ->	
						case lists:keyfind(weight, 1, Conditions) of
							{weight, Weight} ->
								[{Weight, GradeId} | Acc];
							_ ->
								Acc
						end;
					true ->
						Acc
				end;
			_ ->
				?ERR("custom_act, condition:weight miss! Type:~p SubType:~p, GradeId:~p~n", [Type, SubType, GradeId]),
				Acc
		end
	end,
	lists:foldl(Fun, [], GradeIdList).

%% 累计抽奖次数奖励状态数据处理  TotalTime抽奖总次数   GradeState [{累积次数, 领取状态}]
construct_reward_list_for_client(Player, Type, SubType, GradeIds, TotalTimes, RewardStatus) ->
	OpenDay = util:get_open_day(),
	Fun = fun(GradeId, Acc) ->
		#custom_act_reward_cfg{condition = Conditions} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
		ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
		Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
		NeedTimes = get_conditions(total, Conditions),
		OpendaySatisfy = judge_open_day(OpenDay, Conditions),
		if
			OpendaySatisfy == false -> 
				Acc;
			NeedTimes > 0 ->
				Status = get_total_status(NeedTimes, RewardStatus, TotalTimes),
				[{GradeId, NeedTimes, Reward, Status} | Acc];
			true -> 
				Acc
		end		
	end,
	lists:foldl(Fun, [], GradeIds).

get_total_status(NeedTimes, RewardStatus, DrawTimes) ->
	case lists:keyfind(NeedTimes, 1, RewardStatus) of
		{NeedTimes, Status} ->  %%数据库有数据用数据库的，
			Status;
		_ ->
			if
				DrawTimes >= NeedTimes ->
					?HAS_ACHIEVE;
				true ->
					?CAN_NOT_RECIEVE
			end
	end.


%% 检测玩家等级是否满足要求
check_role_lv(Type, SubType, RoleLv) ->
	case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
		#custom_act_cfg{condition = Conditions} ->
			LimitLv = get_conditions(role_lv, Conditions),
			if
				LimitLv =< RoleLv andalso RoleLv > 0 ->
					true;
				true ->
					{false, ?ERRCODE(err331_lv_not_enougth)}
			end;
		true ->
			{false, ?ERRCODE(err331_lv_not_enougth)}
	end.



draw_reward(Player, Type, SubType, Times, AutoBuy) ->
%%	?MYLOG("cym", "draw_reward~n", []),
	#player_status{sid = Sid, holy_summon = HolySummon, id = RoleId} = Player,
	#role_holy_summon{act_list = ActList} = HolySummon,
	Act =
		case lists:keyfind({Type, SubType}, #role_act_holy_summon.key, ActList) of
			#role_act_holy_summon{} = _Act ->
				_Act;
			_ ->
				#role_act_holy_summon{key = {Type, SubType}, type = Type, sub_type = SubType}
		end,
	if
		Times == 1 orelse Times == 10 orelse Times == 50 ->
			case lib_custom_act_api:is_open_act(Type, SubType) of
				true ->
					?MYLOG("cym", "draw_reward~n", []),
					case get_cost(Type, SubType, Times) of
						{true, CostList} ->
							Res = if
								AutoBuy == 1 ->
									lib_goods_api:cost_objects_with_auto_buy(Player, CostList, holy_summon_draw_reward, "");
								true ->
									case lib_goods_api:cost_object_list_with_check(Player, CostList, holy_summon_draw_reward, "") of
										{true, TmpNewPlayer} ->
											{true, TmpNewPlayer, CostList};
										Other ->
											Other
									end
							end,
							case Res of
								{true, NewPlayer, Cost} ->
									{ok, NewPS, GradeIds, AllTimes, NewAct} = do_draw_reward(NewPlayer, Type, SubType, Cost, Times, AutoBuy, Act),
									save_act_db(RoleId, NewAct),
									NewActList = lists:keystore({Type, SubType}, #role_act_holy_summon.key, ActList, NewAct),
									SendList = construct_reward_list_for_client(Player, Type, SubType, GradeIds),
									FreeTimes = get_role_free_times(RoleId, Type, SubType),
									RealSendList = real_send_list(SendList, Type, SubType, []),
%%									?MYLOG("cym", "SendList ~p~n", [SendList]),
									lib_server_send:send_to_sid(Sid, pt_331, 33191, [?SUCCESS, Type, SubType, AllTimes, FreeTimes, RealSendList, 0]),
									{ok, NewPS#player_status{holy_summon = HolySummon#role_holy_summon{act_list = NewActList}}};
								{false, Error, _NewPlayer} ->
%%									?MYLOG("cym", "draw_reward ~p~n", [Error]),
									lib_server_send:send_to_sid(Sid, pt_331, 33191, [Error, Type, SubType, 0, 0, [], 0])
							end;
						{false, ErrorCode} ->
%%							?MYLOG("cym", "draw_reward  ~p~n", [ErrorCode]),
							lib_server_send:send_to_sid(Sid, pt_331, 33191, [ErrorCode, Type, SubType, 0, 0, [], 0])
					end;
				false ->
%%					?MYLOG("cym", "draw_reward  ~p~n", [err331_act_closed]),
					lib_server_send:send_to_sid(Sid, pt_331, 33191, [?ERRCODE(err331_act_closed), Type, SubType, 0, 0, [], 0])
			end;
		true ->
			lib_server_send:send_to_sid(Sid, pt_331, 33191, [?ERRCODE(err331_error_data), Type, SubType, 0, 0, [], 0])
	end.

%% 有个奖励是稀有奖励抽奖次数所以发{0，0，Num}格式数据给客户端
real_send_list([], _, _, NewAcc) -> lists:reverse(NewAcc);
real_send_list([{GradeId, IsShow, Reward}|T], Type, SubType, Acc) ->
	NewAcc = if
		Reward == [] ->
			#custom_act_reward_cfg{condition = Conditions} = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
			AddRareDraw = get_conditions(rare_draw, Conditions),
			[{GradeId, IsShow, [{0,0,AddRareDraw}]}|Acc];
		true ->
			[{GradeId, IsShow, Reward}|Acc]
	end,
	real_send_list(T, Type, SubType, NewAcc).


get_cost(Type, SubType, Times) ->
	case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
		#custom_act_cfg{condition = Conditions} ->
			if
				Times =:= 1 ->
					case lists:keyfind(one_cost, 1, Conditions) of
						{one_cost, Cost} ->
							{true, Cost};
						_ ->
							{false, ?MISSING_CONFIG}
					end;
				Times =:= 10 ->
					case lists:keyfind(ten_cost, 1, Conditions) of
						{ten_cost, Cost} ->
							{true, Cost};
						_ ->
							{false, ?MISSING_CONFIG}
					end;
				Times =:= 50 ->
					case lists:keyfind(fifty_cost, 1, Conditions) of
						{fifty_cost, Cost} ->
							{true, Cost};
						_ ->
							{false, ?MISSING_CONFIG}
					end;
				true ->
					{false, ?ERRCODE(err331_error_data)}
			end;
		_ ->
			{false, ?MISSING_CONFIG}
	end.

do_draw_reward(Player, Type, SubType, _Cost, Times, _AutoBuy, Act) ->
	#role_act_holy_summon{draw_times = OldDrawTimes, rare_draw = RareDraw} = Act,
	#player_status{id = RoleId, figure = #figure{name = _RoleName}} = Player,
	RoleName = lib_player:get_wrap_role_name(Player),
	{NewAllTimes, GradeIds} = do_draw_reward_help(RoleId, OldDrawTimes, get_pool(Type, SubType), Type, SubType, Times, []),
	{Rewards, NewRareDraw} = handle_reward(Player, GradeIds, Type, SubType, [], RoleName, RoleId, RareDraw), %%传闻处理
%%	?MYLOG("cym", "Rewards ~p~n", [Rewards]),
	if
		Rewards == [] ->
			[GradeId|_] = GradeIds,
			lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, []);
		true ->
			Produce = #produce{type = holy_summon_draw, subtype = SubType, reward = Rewards},
			lib_goods_api:send_reward_with_mail(RoleId, Produce),
			lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, Rewards)
	end,
	{ok, Player, GradeIds, NewAllTimes, Act#role_act_holy_summon{draw_times = NewAllTimes, rare_draw = NewRareDraw}}.

%%
save_act_db(RoleId, Act) ->
	#role_act_holy_summon{draw_times = DrawTimes, type = Type, sub_type = SubType, reward_status = RewardStatus, 
		rare_draw = RareDraw, act_rare_draw = TotalRareDraw} = Act,

	Sql = io_lib:format(?save_into_role_act_holy_summon, [RoleId, Type, SubType, DrawTimes, 
		util:term_to_bitstring(RewardStatus), RareDraw, TotalRareDraw]),
	db:execute(Sql).



get_role_free_times(RoleId, Type, SubType) ->
	FreeTimes = get_act_free_times(Type, SubType),
	FreeDrawTimes = mod_daily:get_count(RoleId, ?MOD_AC_CUSTOM, Type, SubType),
	FreeTimes - FreeDrawTimes.

get_act_free_times(Type, SubType) ->
	case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(free_times, 1, Condition) of
				{_, Times} ->
					Times;
				_ ->
					0
			end;
		_ ->
			0
	end.


do_draw_reward_help(_RoleId, AllTimes, _Pool, _Type, _SubType, 0, GradeIds) ->
	{AllTimes, GradeIds};
do_draw_reward_help(RoleId, AllTimes, Pool, Type, SubType, Times, GradeIds) ->
	RealPool = do_draw_core(Pool, AllTimes),
	GradeId = urand:rand_with_weight(RealPool),  %%奖池里面的大奖id一定是有配置的
	do_draw_reward_help(RoleId, AllTimes + 1, Pool, Type, SubType, Times - 1, [GradeId | GradeIds]).


%% 奖池，{StartTimes, EndTimes, Weight, SpecialWeight} 在StartTimes 与 EndTimes 之间权重增加（Weight+SpecialWeight）
%% 若抽奖次数没达到StartTimes,该大奖不会入奖池， 抽奖次数大于EndTimes使用Weight来抽奖
do_draw_core(Pool, AllTimes) ->
	Fun = fun({{StartTimes, EndTimes, Weight, SpecialWeight}, GradeId}, RealPool) ->
		if
			StartTimes =:= EndTimes ->
				[{Weight, GradeId} | RealPool];
			AllTimes < StartTimes ->
				RealPool;
			AllTimes > StartTimes andalso AllTimes =< EndTimes ->
				[{Weight + SpecialWeight, GradeId} | RealPool];
			true ->
				[{Weight, GradeId} | RealPool]
		end
	end,
	lists:foldl(Fun, [], Pool).

draw_special_reward(Player, Type, SubType) ->
	#player_status{sid = Sid, holy_summon = HolySummon, id = RoleId} = Player,
	#role_holy_summon{act_list = ActList} = HolySummon,
	Act =
		case lists:keyfind({Type, SubType}, #role_act_holy_summon.key, ActList) of
			#role_act_holy_summon{rare_draw = RareDraw} = _Act ->
				_Act;
			_ ->
				RareDraw = 0,
				#role_act_holy_summon{key = {Type, SubType}, type = Type, sub_type = SubType, rare_draw = RareDraw}
		end,
	IsOpen = lib_custom_act_api:is_open_act(Type, SubType),
	case lib_custom_act_util:get_act_cfg_info(Type, SubType) of
		#custom_act_cfg{condition = Conditions} ->
			{_, CostList} = ulists:keyfind(rare_draw_cost, 1, Conditions, {rare_draw_cost, []});
		_ ->
			CostList = []
	end,
	case ?IF(CostList =/= [], lib_goods_api:check_object_list(Player, CostList), {false, ?MISSING_CONFIG}) of
	 	true ->
	 		ErrorCode = 1,
	 		Enougth = true;
	 	{false, ErrorCode} ->
	 		Enougth = ?IF(ErrorCode == ?MISSING_CONFIG, ok, false)
	end,
	if
		IsOpen == false ->
			lib_server_send:send_to_sid(Sid, pt_332, 33222, [?ERRCODE(err331_act_closed), Type, SubType, RareDraw, []]);
		Enougth == true andalso CostList =/= [] ->
			case lib_goods_api:cost_object_list_with_check(Player, CostList, holy_summon_draw_reward, "") of
				{true, TmpNewPlayer} ->
					{ok, NewPS, GradeIds, NewRareDraw, NewAct} = do_draw_special_reward(TmpNewPlayer, Type, SubType, Act),
					save_act_db(RoleId, NewAct),
					NewActList = lists:keystore({Type, SubType}, #role_act_holy_summon.key, ActList, NewAct),
					SendList = construct_reward_list_for_client(NewPS, Type, SubType, GradeIds),
%%									?MYLOG("cym", "SendList ~p~n", [SendList]),
					lib_server_send:send_to_sid(Sid, pt_332, 33222, [?SUCCESS, Type, SubType, NewRareDraw, SendList]),
					{ok, NewPS#player_status{holy_summon = HolySummon#role_holy_summon{act_list = NewActList}}};
				{false, Code, _} ->
					lib_server_send:send_to_sid(Sid, pt_332, 33222, [Code, Type, SubType, RareDraw, []])
			end;
		Enougth == ok andalso RareDraw > 0 ->
			{ok, NewPS, GradeIds, NewRareDraw, NewAct} = do_draw_special_reward(Player, Type, SubType, Act#role_act_holy_summon{rare_draw = RareDraw-1}),
			save_act_db(RoleId, NewAct),
			NewActList = lists:keystore({Type, SubType}, #role_act_holy_summon.key, ActList, NewAct),
			SendList = construct_reward_list_for_client(NewPS, Type, SubType, GradeIds),
%%									?MYLOG("cym", "SendList ~p~n", [SendList]),
			lib_server_send:send_to_sid(Sid, pt_332, 33222, [?SUCCESS, Type, SubType, NewRareDraw, SendList]),
			{ok, NewPS#player_status{holy_summon = HolySummon#role_holy_summon{act_list = NewActList}}};
		true ->
			Code = ?IF(Enougth == false, ErrorCode, ?ERRCODE(err331_rare_draw_times_not_enougth)),
			lib_server_send:send_to_sid(Sid, pt_332, 33222, [Code, Type, SubType, 0, []])
	end.
			

do_draw_special_reward(Player, Type, SubType, Act) ->
	#role_act_holy_summon{rare_draw = RareDraw, act_rare_draw = TotalRareDraw} = Act,
	#player_status{id = RoleId, figure = #figure{name = _RoleName}} = Player,
	RoleName = lib_player:get_wrap_role_name(Player),
	{NewTotalRareDraw, GradeIds} = do_draw_reward_help(RoleId, TotalRareDraw, get_rare_pool(Type, SubType), Type, SubType, 1, []),
	{Rewards, NewRareDraw} = handle_reward(Player, GradeIds, Type, SubType, [], RoleName, RoleId, RareDraw), %%传闻处理
%%	?MYLOG("cym", "Rewards ~p~n", [Rewards]),
	if
		Rewards == [] ->
			[GradeId|_] = GradeIds,
			lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, []);
		true ->
			Produce = #produce{type = holy_summon_draw, subtype = SubType, reward = Rewards},
			lib_goods_api:send_reward_with_mail(RoleId, Produce),
			lib_log_api:log_custom_act_reward(RoleId, Type, SubType, 0, Rewards)
	end,
	{ok, Player, GradeIds, NewRareDraw, Act#role_act_holy_summon{act_rare_draw = NewTotalRareDraw, rare_draw = NewRareDraw}}.


%% 处理需要发传闻的奖励
handle_reward(_Player, [], _, _, Rewards, _, _, RareDraw) ->
	{Rewards, RareDraw};
handle_reward(Player, [GradeId | GradeIds], Type, SubType, Rewards, RoleName, RoleId, RareDraw) ->
	#custom_act_reward_cfg{condition = Conditions, reward = CfgReward} = RewardCfg = lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId),
	case CfgReward == [] of
		false ->
			ActInfo = lib_custom_act_util:get_custom_act_open_info(Type, SubType),
			Reward = lib_custom_act_util:count_act_reward(Player, ActInfo, RewardCfg),
			case Reward of
				[{Gtype, GoodsTypeId, _GNum} | _] ->
					case lists:keyfind(is_tv, 1, Conditions) of
						{_, IsTv} -> TvId = 36, Mod = ?MOD_AC_CUSTOM;
						{_, Mod, TvId} -> IsTv = 1;
						_ -> IsTv = 0, TvId = 36, Mod = ?MOD_AC_CUSTOM
					end,
					% IsTv = get_conditions(is_tv, Conditions),
					IsRare = get_conditions(is_rare, Conditions),
					RealGtypeId = get_real_goods_type_id(GoodsTypeId, Gtype),
					?IF(IsTv == 1, lib_chat:send_TV({all}, Mod, TvId, [RoleName, RoleId, RealGtypeId, Type, SubType]), skip),
					%%添加全服记录
					?IF(IsRare >= 1, mod_custom_act_record:cast({save_log_and_notice, RoleId, Type, SubType, RoleName, Reward}), skip),
					handle_reward(Player, GradeIds, Type, SubType, Reward ++ Rewards, RoleName, RoleId, RareDraw);
				_ ->
					handle_reward(Player, GradeIds, Type, SubType, Rewards, RoleName, RoleId, RareDraw)
			end;
		true ->
			AddRareDraw = get_conditions(rare_draw, Conditions),
			handle_reward(Player, GradeIds, Type, SubType, Rewards, RoleName, RoleId, RareDraw + AddRareDraw)
	end.
	

get_real_goods_type_id(GoodsTypeId, Gtype) ->
	if
		GoodsTypeId =/= 0 ->
			GoodsTypeId;
		true ->
			if
				Gtype == 1 ->
					?GOODS_ID_GOLD;
				Gtype == 2 ->
					?GOODS_ID_BGOLD;
				Gtype == 3 ->
					?GOODS_ID_COIN;
				true ->
					0
			end
	end.




get_stage_reward(Type, SubType, GradeId, Player) ->
	#player_status{id = RoleId, sid = Sid, holy_summon = HolySummon} = Player,
	#role_holy_summon{act_list = ActList} = HolySummon,
	case lib_custom_act_api:is_open_act(Type, SubType) of
		true ->
			TotalList = [GradeId],
			case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
				#custom_act_reward_cfg{condition = Conditions, reward = Reward} ->
					NeedTimes = get_conditions(total, Conditions),
					case lists:keyfind({Type, SubType}, #role_act_holy_summon.key, ActList) of
						#role_act_holy_summon{reward_status = RewardStatus, draw_times = DrawTimes} = Act when NeedTimes > 0 ->
							case get_total_status(NeedTimes, RewardStatus, DrawTimes) of
								?CAN_NOT_RECIEVE ->
									TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, DrawTimes, RewardStatus),
									lib_server_send:send_to_sid(Sid, pt_331, 33192, [?ERRCODE(err331_draw_times_limit), Type, SubType, TotalShowList]);
								?HAS_ACHIEVE ->
									%%更新内存
									NewRewardStatus = lists:keystore(NeedTimes, 1, RewardStatus, {NeedTimes, ?HAS_RECIEVE}),
									NewAct = Act#role_act_holy_summon{reward_status = NewRewardStatus},
									save_act_db(RoleId, NewAct),
									NewActList = lists:keystore({Type, SubType}, #role_act_holy_summon.key, ActList, NewAct),
									TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, DrawTimes, NewRewardStatus),
									lib_server_send:send_to_sid(Sid, pt_331, 33192, [?SUCCESS, Type, SubType, TotalShowList]),
									%% 发放奖励
									Produce = #produce{type = holy_stage_reward, subtype = SubType, reward = Reward},
									lib_goods_api:send_reward_with_mail(RoleId, Produce),
									%% 日志
									lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, Reward),
									{ok, Player#player_status{holy_summon = HolySummon#role_holy_summon{act_list = NewActList}}};
								?HAS_RECIEVE ->
									TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, DrawTimes, RewardStatus),
									lib_server_send:send_to_sid(Sid, pt_331, 33192, [?ERRCODE(err331_has_recieve), Type, SubType, TotalShowList])
							end;
						_ ->
							TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, 0, []),
							lib_server_send:send_to_sid(Sid, pt_331, 33192, [?ERRCODE(err331_draw_times_limit), Type, SubType, TotalShowList])
					end;
				_ ->
					TotalShowList = construct_reward_list_for_client(Player, Type, SubType, TotalList, 0, []),
					lib_server_send:send_to_sid(Sid, pt_331, 33192, [?ERRCODE(err331_has_recieve), Type, SubType, TotalShowList])
			end;
		_ ->
			lib_server_send:send_to_sid(Sid, pt_331, 33192, [?MISSING_CONFIG, Type, SubType, []])
	end.


day_clear_act_data(Type, SubType) ->
	Sql = io_lib:format(<<"DELETE from role_act_holy_summon where type = ~p and sub_type = ~p">>,
		[Type, SubType]),
	db:execute(Sql),
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
	[lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_holy_summon, day_clear_act_data, [Type, SubType]) || E <- OnlineRoles].


day_clear_act_data(PS, Type, SubType) ->
	#player_status{holy_summon = HolySummon} = PS,
	#role_holy_summon{act_list = ActList} = HolySummon,
	NewActList = lists:keydelete({Type, SubType}, #role_act_holy_summon.key, ActList),
	PS#player_status{holy_summon = HolySummon#role_holy_summon{act_list = NewActList}}.


%% ============================= 秘籍 =============================
%% 运营配置失误导致活动数据被清理
%% 补全玩家活动数据
gm_role_completion(Type, SubType) ->	
	spawn(fun() ->
		case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
			#act_info{stime = STime, etime = ETime} ->
				ok;
			_ ->
				STime = 0, ETime = 0
		end,
		RewardSql = io_lib:format(<<"select player_id, reward from log_custom_act_reward where type = ~p and subtype = ~p and reward_id = 0 and time >= ~p and time <= ~p">>, [Type, SubType, STime, ETime]),
		case db:get_all(RewardSql) of
			[] ->
				skip;
			RewardList ->
				?INFO("RewardList:~p",[RewardList]),
				RarePool = get_rare_pool(Type, SubType),
				RareRewardF = fun({_, GradeId}, FRewardL) ->
					case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
						#custom_act_reward_cfg{reward = [{_, RareGoodsTypeId, _}]} ->
							[RareGoodsTypeId |FRewardL];
						_ ->
							FRewardL
					end
				end,
				%% 获得珍稀物品id列表
				RareRewardIds = lists:foldl(RareRewardF, [], RarePool),


				CollectF = fun([RoleId, RewardStr], FCollectMap) ->
					Reward = util:bitstring_to_term(RewardStr),
					{NormalTimes, RareTimes} = maps:get(RoleId, FCollectMap, {0, 0}),
					RewardLen = length(Reward),
					{NewNormalTimes, NewRareTimes} = case RewardLen == 1 of 
						true -> %% 奖励列表长度为1的有可能珍稀奖励
							case Reward of
								[{_, RareId, _}] ->
									case lists:member(RareId, RareRewardIds) of 
										true ->
											{NormalTimes, RareTimes + 1};
										_ ->
											{NormalTimes + 1, RareTimes}
									end;
								_ ->
									{NormalTimes, RareTimes}
							end;
						_ ->
							{NormalTimes + RewardLen, RareTimes}
					end,
					maps:put(RoleId, {NewNormalTimes, NewRareTimes}, FCollectMap)
				end,
				%% #{RoleId => {普通奖励次数, 珍稀奖励次数}}
				CollectMap = lists:foldl(CollectF, #{}, RewardList),

				DbF = fun(RoleId, {NormalTimes, RareTimes}, FDbList) ->
					[[RoleId, Type, SubType, NormalTimes, util:term_to_bitstring([]), 0, RareTimes] | FDbList]
				end,
				DbList = maps:fold(DbF, [], CollectMap),
				case DbList =/= [] of 
			        true ->
			            Sql = usql:replace(role_act_holy_summon, [role_id, type, sub_type, draw_times, reward_status, rare_draw, act_rare_draw], DbList),
			            db:execute(Sql);
			        false -> skip
			    end,
			    [lib_player:apply_cast(Id, ?APPLY_CAST_SAVE, lib_holy_summon, gm_role_completion_refresh, [Type, SubType]) || Id <- lib_online:get_online_ids()]
		end
	end),
	ok.

gm_role_completion_refresh(Ps, Type, SubType) ->
	NewPs = login(Ps),
	pp_custom_act_list:handle(33221, NewPs, [Type, SubType]),
	{ok, NewPs}.


