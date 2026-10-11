%%%-----------------------------------
%%% @Module      : lib_feast_cost_rank
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 08. 十二月 2018 9:56
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_feast_cost_rank).
-author("chenyiming").


%% API
-compile(export_all).

-include("feast_cost_rank.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("def_goods.hrl").
-include("rec_event.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").


handle_event(#player_status{id = RoleId, figure = F} = Player, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data}) ->
	#callback_money_cost{cost = Gold, money_type = MoneyType, consume_type = ConsumeType} = Data,
%%	?MYLOG("cym", "~p~n", [ConsumeType]),
	case lib_consume_data:is_consume_for_act(ConsumeType) of
		true ->
			case MoneyType of
				?GOLD ->
					case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK) of
						false ->
							skip;
						true ->
							#figure{name = Name, lv = Lv} = F,
							RoleRank = #role_rank{role_id = RoleId, role_name = Name, cost = Gold, refresh_time = utime:unixtime(), lv = Lv},
							mod_feast_cost_rank:refresh_rank(RoleRank)
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	{ok, Player};

handle_event(#player_status{id = RoleId, figure = F} = Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
	#figure{name = Name, lv = Lv} = F,
	RoleRank = #role_rank{role_id = RoleId, role_name = Name, cost = 0, refresh_time = utime:unixtime(), lv = Lv},
	mod_feast_cost_rank:refresh_rank(RoleRank),
	{ok, Player}.


%%刷新榜单
refresh_rank(#role_rank{role_id = RoleId, cost = AddCost, lv = RoleLv} = RoleRank,
	#feast_cost_state{rank_list = RankList, limit_cost = LimitCost, length = Length, min_cost = MinCost} = State) ->
	case lists:keyfind(RoleId, #role_rank.role_id, RankList) of
		false ->
			NewRoleRank =
				case get_role_rank_by_id_from_db(RoleId) of
					[] ->
						RoleRank;
					#role_rank{cost = _Cost} ->
						RoleRank#role_rank{cost = _Cost + AddCost}
				end,
			save_role_rank_to_db(NewRoleRank),
			LimitLv = get_limit_lv(),
			LimitLength = get_limit_length(),
			if
				Length >= LimitLength andalso NewRoleRank#role_rank.cost > MinCost andalso RoleLv >= LimitLv ->  %%榜单长度够了， 进榜，最后一名挤下来
					NewRoleRankList = lists:keystore(RoleId, #role_rank.role_id, RankList, NewRoleRank),
					NewRoleList = sort(NewRoleRankList, lib_feast_cost_rank:get_limit_length()),
					[TempRank] = lists:sublist(NewRoleList, length(NewRoleList), 1),
					?MYLOG("cym", "NewRoleList ~p ~n", [NewRoleList]),
					State#feast_cost_state{rank_list = NewRoleList, length = length(NewRoleList), min_cost = TempRank#role_rank.cost};
				Length < LimitLength andalso NewRoleRank#role_rank.cost >= LimitCost andalso RoleLv >= LimitLv ->  %%长度不够， 满足阀值，满足等级 进榜
					NewRoleRankList = lists:keystore(RoleId, #role_rank.role_id, RankList, NewRoleRank),
					NewRoleList = sort(NewRoleRankList, lib_feast_cost_rank:get_limit_length()),
					case  NewRoleList of
						[] ->
							State;
						_ ->
							?MYLOG("cym", "NewRoleList ~p ~n", [NewRoleList]),
							[TempRank] = lists:sublist(NewRoleList, length(NewRoleList), 1),
							State#feast_cost_state{rank_list = NewRoleList, length = length(NewRoleList), min_cost = TempRank#role_rank.cost}
					end;
				true ->
%%					?MYLOG("cym", "null ~n", []),
					State
			end;
		#role_rank{cost = OldCost} ->
			NewRoleRank = RoleRank#role_rank{cost = OldCost + AddCost},
			NewRoleRankList = lists:keystore(RoleId, #role_rank.role_id, RankList, NewRoleRank),
			save_role_rank_to_db(NewRoleRank),
			NewRoleList = sort(NewRoleRankList, lib_feast_cost_rank:get_limit_length()),
			[TempRank] = lists:sublist(NewRoleList, length(NewRoleList), 1),
			State#feast_cost_state{rank_list = NewRoleList, length = length(NewRoleList), min_cost = TempRank#role_rank.cost}
	end.


%%排序
sort(RoleRankList, LimitLength) ->
	F = fun(A, B) ->
		if
			is_record(A, role_rank) ->
				if
					A#role_rank.cost > B#role_rank.cost ->
						true;
					A#role_rank.cost == B#role_rank.cost ->
						A#role_rank.refresh_time =< B#role_rank.refresh_time;
					true ->
						false
				end;
			true ->
				false
		end
	end,
	NewList = lists:sort(F, RoleRankList),
	Length = length(NewList),
	Lists1 =
		if
			Length > LimitLength ->
				TempList = lists:sublist(NewList, LimitLength),  %%截断列表
				TempList;
			Length =< LimitLength ->
				NewList;
			true ->
				NewList
		end,
	LastList = set_rank(Lists1),
	LastList.

%%更新数据库
save_role_rank_to_db(#role_rank{role_name = RoleName, role_id = RoleId, refresh_time = RefreshTime, cost = Cost, lv = Lv}) ->
	Sql = io_lib:format(?save_feast_cost_rank, [RoleId, util:fix_sql_str(RoleName), Cost, RefreshTime, Lv]),
%%	?MYLOG("cym", "Sql ~s~n", [Sql]),
	db:execute(Sql).


%%清理榜单的数据
del_list() ->
	Sql = io_lib:format(?delete_feast_cost_rank, []),
	db:execute(Sql).

set_rank([]) ->
	[];
set_rank(RankList) ->
	SubType =  get_sub_type(),
	GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_FEAST_COST_RANK,  SubType),
	F = fun(Grade, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK,  SubType,  Grade) of
			#custom_act_reward_cfg{condition = Condition} ->
				{MinRank, MaxRank} = get_rank_by_condition(Condition),
				LimitCost          = get_limit_cost_by_condition(Condition),
				[{LimitCost,  MinRank, MaxRank} | Acc];
			_ ->
				Acc
		end
	end,
	LimitList = lists:reverse(lists:foldl(F, [], GradeList)),
	set_rank(RankList,  0,  [], LimitList).

set_rank(_, -1,  Res,  _LimitList) ->
	lists:reverse(Res);
set_rank([], _, Res, _LimitList) ->
	lists:reverse(Res);
set_rank([RoleRank | T], RankNum,  Res, LimitList) ->
	#role_rank{cost = Cost} = RoleRank,
	RightRankNum = get_right_rank_num(RankNum, Cost, LimitList),
	case   RightRankNum of
		-1 -> %%-1代表不符合， 后面的列表也不符合条件了
			set_rank(T,  -1,   Res, LimitList);
		_ ->
			set_rank(T, RightRankNum, [RoleRank#role_rank{rank = RightRankNum} | Res], LimitList)
	end.
	

%%等级限制
get_limit_lv() ->
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK),
	if
		IsOpen == true ->
			SubTypeId =  hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK)),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubTypeId) of
				[] ->
					0;
				#custom_act_cfg{condition = Conditon} ->
					case lists:keyfind(role_lv, 1, Conditon) of
						false ->
							0;
						{_, LimitLv} ->
							LimitLv
					end
			end;
		true ->
			0
	end.
%%排行榜长度
get_limit_length() ->
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK),
	if
		IsOpen == true ->
			SubTypeId =  hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK)),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubTypeId) of
				[] ->
					ok;
				#custom_act_cfg{condition = Conditon} ->
					case lists:keyfind(rank_len, 1, Conditon) of
						false ->
							0;
						{_, LimitLength} ->
							LimitLength
					end
			end;
		true ->
			0
	end.
	

%%活动全局最低的钻石消耗
get_limit_cost() ->
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK),
	if
		IsOpen == true ->
			SubTypeId =  hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK)),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubTypeId) of
				[] ->
					ok;
				#custom_act_cfg{condition = Conditon} ->
					case lists:keyfind(rank_limit, 1, Conditon) of
						false ->
							0;
						{_, LimitCost} ->
							LimitCost
					end
			end;
		true ->
			0
	end.
	



get_role_rank_by_id_from_db(RoleId) ->
	Sql = io_lib:format(?select_feast_cost_rank, [RoleId]),
	case db:get_row(Sql) of
		[] ->
			[];
		[RoleId, RoleName, Cost, RefreshTime, Lv] ->
			#role_rank{role_id = RoleId, role_name = RoleName, cost = Cost, refresh_time = RefreshTime, lv = Lv}
	end.


%%发送排行榜信息
send_to_client(RoleId, #feast_cost_state{rank_list = RankList}) ->
	MyRank =
		case lists:keyfind(RoleId, #role_rank.role_id, RankList) of
			false ->
				case get_role_rank_by_id_from_db(RoleId) of
					[] ->
						#role_rank{};
					_Rank ->
						_Rank
				end;
			_Rank ->
				_Rank
		end,
	SendRankList = [{_roleId, binary_to_list(_roleName), _rank, _cost} ||
		#role_rank{role_id = _roleId, role_name = _roleName, rank = _rank, cost = _cost} <- RankList],
	{ok, Bin} = pt_331:write(33188, [MyRank#role_rank.rank, MyRank#role_rank.cost, SendRankList]),
	?MYLOG("cym", "send Msg ~p~n", [{MyRank#role_rank.rank, MyRank#role_rank.cost, SendRankList}]),
	lib_server_send:send_to_uid(RoleId, Bin).


%%发送奖励列表给客户端 ， 原因 客户端不想读配置表
send_reward_to_client(RoleId, SubType) ->
	GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubType),
	F = fun(Grade, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubType, Grade) of
			#custom_act_reward_cfg{reward = Reward, condition = Condition} ->
				{MinRank, MaxRank} = get_rank_by_condition(Condition),
				LimitCost          = get_limit_cost_by_condition(Condition),
				[{Grade, LimitCost,  MinRank, MaxRank, Reward} | Acc];
			_ ->
				Acc
		end
	end,
	ResList = lists:reverse(lists:foldl(F, [], GradeList)),
	{ok, Bin} = pt_331:write(33189, [SubType, ResList]),
%%	?MYLOG("cym",  "SubType ~p ResList ~p  GradeList ~p~n",  [SubType, ResList, GradeList]),
	lib_server_send:send_to_uid(RoleId, Bin).

%%奖励对应的排名限制
get_rank_by_condition(Condition) ->
	case lists:keyfind(rank, 1, Condition) of
		{rank, {MinRank, MaxRank}} ->
			{MinRank, MaxRank};
		_ ->
			{0, 0}
	end.
%%奖励的最低消耗钻石
get_limit_cost_by_condition(Condition) ->
	case lists:keyfind(limit_cost, 1, Condition) of
		{limit_cost, LimitCost} ->
			LimitCost;
		_ ->
			0
	end.

act_end(#feast_cost_state{rank_list = RankList} = _State, SubType) ->
	GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubType),
	F = fun(Grade, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubType, Grade) of
			#custom_act_reward_cfg{reward = Reward, condition = Condition} ->
				{MinRank, MaxRank} = get_rank_by_condition(Condition),
				[{Grade,  MinRank, MaxRank, Reward} | Acc];
			_ ->
				Acc
		end
	end,
	ResList = lists:reverse(lists:foldl(F, [], GradeList)),
	[send_reward_with_mail(RoleRank, ResList) || RoleRank <- RankList],
	del_list(),
	mod_feast_cost_rank:init().
%%	State#feast_cost_state{rank_list = [], min_cost = 0}.

send_reward_with_mail(#role_rank{rank = Rank, role_id = RoleId}, ResList) ->
	Reward =  get_reward_by_rank(Rank,  ResList),
	Title =  data_language:get(3310040),
	Content = utext:get(3310041, [Rank]),
	SubTypeIdList = lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK),
	case  SubTypeIdList of
		[] ->
			ok;
		_ ->
			SubTypeId = hd(SubTypeIdList),
			lib_log_api:log_custom_act_reward(RoleId, ?CUSTOM_ACT_TYPE_FEAST_COST_RANK, SubTypeId, 0, Reward)
	end,
	lib_mail_api:send_sys_mail([RoleId],   Title,  Content,  Reward).

%%获取奖励，通过排名
get_reward_by_rank(_Rank, []) ->
	[];
get_reward_by_rank(Rank, [{_Grade, MinRank, MaxRank, Reward} | T]) ->
	if
		Rank >= MinRank  andalso  Rank =< MaxRank ->
			Reward;
		true ->
			get_reward_by_rank(Rank, T)
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  修正排名
%% @param    参数      RankNum   上一个排名   Cost 当前消耗     LimitList 限制列表
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_right_rank_num(_RankNum, _Cost,  []) ->
	-1;
get_right_rank_num(RankNum, Cost, [ {LimitCost, MinRank, MaxRank} | LimitList]) ->
	case Cost >= LimitCost of
		true ->
			if
				RankNum  <  MinRank ->    %% RankNum在这个区间前面，  则从这区间开始算
					MinRank;
				RankNum  >=  MinRank andalso  RankNum < MaxRank  ->   %% RankNum在这个区间内，但是没有到最后一名 [ )
					RankNum + 1;
				RankNum  >=  MaxRank ->  %%上一个排名已经是这个区间的最后一名
					get_right_rank_num(RankNum,  Cost,   LimitList);
				true ->
					get_right_rank_num(RankNum,  Cost,   LimitList)
			end;
		false ->
			get_right_rank_num(RankNum, Cost,   LimitList)
	end.

act_start(_State, _SubType) ->
%%	?MYLOG("cym2", "Act_start +++++++++++~n", []),
	Sql = io_lib:format(?select_feast_cost_rank_all, [lib_feast_cost_rank:get_limit_lv(),
		lib_feast_cost_rank:get_limit_cost(),   lib_feast_cost_rank:get_limit_length()]),
	List = db:get_all(Sql),
	RoleRankList =  [#role_rank{role_id = RoleId, role_name = RoleName, cost = Cost, refresh_time = RefreshTime, lv = Lv}
		|| [RoleId, RoleName, Cost, RefreshTime, Lv] <- List],
	Length = length(RoleRankList),
	MinCost = case  RoleRankList of
		[] ->
			0;
		_ ->
			[#role_rank{cost = Cost}] = lists:sublist(RoleRankList, Length, 1),
			Cost
	end,
	LastRoleRankList = lib_feast_cost_rank:set_rank(RoleRankList),
	#feast_cost_state{rank_list = LastRoleRankList, length = Length, limit_cost = lib_feast_cost_rank:get_limit_cost(), min_cost = MinCost}.

get_sub_type() ->
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK),
	if
		IsOpen == true ->
			SubTypeId =  hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK)),
			SubTypeId;
		true ->
			1
	end.