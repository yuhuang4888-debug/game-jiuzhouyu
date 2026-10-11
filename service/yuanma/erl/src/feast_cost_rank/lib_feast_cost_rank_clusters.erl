%%%-----------------------------------
%%% @Module      : lib_feast_cost_rank_clusters
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 08. 十二月 2018 9:56
%%% @Description : 文件摘要
%%%-----------------------------------
-module(lib_feast_cost_rank_clusters).
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


handle_event(#player_status{id = RoleId, figure = F, server_id = ServerId} = Player, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data}) ->
	#callback_money_cost{cost = Gold, money_type = MoneyType, consume_type = ConsumeType} = Data,
	case lib_consume_data:is_consume_for_act(ConsumeType) of
		true ->
			case MoneyType of
				?GOLD ->
					#figure{name = Name, lv = Lv} = F,
					case lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2) of
						false ->
%%							?MYLOG("cost_rank", "cost_rank ~n", []),
							skip;
						true ->
%%							?MYLOG("cost_rank", "cost_rank ~n", []),
							#figure{name = Name, lv = Lv} = F,
							RoleRank = #role_rank_clusters{role_id = RoleId, role_name = Name, cost = Gold, refresh_time = utime:unixtime(), lv = Lv,
								server_id = ServerId, server_num = config:get_server_num(), server_name = util:get_server_name()},
							mod_clusters_node:apply_cast(mod_feast_cost_rank_clusters, refresh_rank, [RoleRank])
					end;
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	{ok, Player};

handle_event(#player_status{id = RoleId, figure = F, server_id = ServerId} = Player, #event_callback{type_id = ?EVENT_LV_UP}) ->
	#figure{name = Name, lv = Lv} = F,
%%	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	RoleRank = #role_rank_clusters{role_id = RoleId, role_name = Name, cost = 0, refresh_time = utime:unixtime(), lv = Lv,
		server_id = ServerId, server_num = config:get_server_num(), server_name = util:get_server_name()},
	mod_clusters_node:apply_cast(mod_feast_cost_rank_clusters, refresh_rank, [RoleRank]),
%%	mod_feast_cost_rank_clusters:refresh_rank(RoleRank),
	{ok, Player}.


%%刷新榜单
refresh_rank(#role_rank_clusters{role_id = RoleId, cost = AddCost, lv = RoleLv, server_id = _ServerId, server_zone_id = ZoneId} = RoleRank,
	#feast_cost_clusters_state{rank_map = RankMap} = State) ->
	ZoneState = maps:get(ZoneId, RankMap, init_zone_state()),
	#feast_cost_zone_state{rank_list = RankList, min_cost = MinCost, length = Length, limit_cost = LimitCost} = ZoneState,
%%	?MYLOG("cym", "RoleRank ~p ~n", [RoleRank]),
	NewZoneState =
		case lists:keyfind(RoleId, #role_rank_clusters.role_id, RankList) of
			false ->
				NewRoleRank =
					case get_role_rank_clusters_by_id_from_db(RoleId) of
						[] ->
							RoleRank;
						#role_rank_clusters{cost = _Cost} ->
							RoleRank#role_rank_clusters{cost = _Cost + AddCost}
					end,
				save_role_rank_clusters_to_db(NewRoleRank),
				LimitLv = get_limit_lv(),
				LimitLength = get_limit_length(),
				if
					Length >= LimitLength andalso NewRoleRank#role_rank_clusters.cost > MinCost andalso RoleLv >= LimitLv ->  %%榜单长度够了， 进榜，最后一名挤下来
						NewRoleRankList = lists:keystore(RoleId, #role_rank_clusters.role_id, RankList, NewRoleRank),
						NewRoleList = sort(NewRoleRankList, lib_feast_cost_rank_clusters:get_limit_length()),
						[TempRank] = lists:sublist(NewRoleList, length(NewRoleList), 1),
%%						?MYLOG("cym", "NewRoleList ~p ~n", [NewRoleList]),
						ZoneState#feast_cost_zone_state{rank_list = NewRoleList, length = length(NewRoleList), min_cost = TempRank#role_rank_clusters.cost};
					Length < LimitLength andalso NewRoleRank#role_rank_clusters.cost >= LimitCost andalso RoleLv >= LimitLv ->  %%长度不够， 满足阀值，满足等级 进榜
						NewRoleRankList = lists:keystore(RoleId, #role_rank_clusters.role_id, RankList, NewRoleRank),
						NewRoleList = sort(NewRoleRankList, lib_feast_cost_rank_clusters:get_limit_length()),
%%						?MYLOG("cym", "NewRoleList ~p ~n", [NewRoleList]),
						case NewRoleList of
							[] ->
								ZoneState;
							_ ->
%%								?MYLOG("cym", "NewRoleList ~p ~n", [NewRoleList]),
								[TempRank] = lists:sublist(NewRoleList, length(NewRoleList), 1),
								ZoneState#feast_cost_zone_state{rank_list = NewRoleList, length = length(NewRoleList), min_cost = TempRank#role_rank_clusters.cost}
						end;
					true ->
%%						?MYLOG("cym", "null ~n", []),
						ZoneState
				end;
			#role_rank_clusters{cost = OldCost} ->
%%				?MYLOG("cym", "RoleRank ~p ~n", [RoleRank]),
				NewRoleRank = RoleRank#role_rank_clusters{cost = OldCost + AddCost},
				NewRoleRankList = lists:keystore(RoleId, #role_rank_clusters.role_id, RankList, NewRoleRank),
				save_role_rank_clusters_to_db(NewRoleRank),
				NewRoleList = sort(NewRoleRankList, lib_feast_cost_rank_clusters:get_limit_length()),
				[TempRank] = lists:sublist(NewRoleList, length(NewRoleList), 1),
				ZoneState#feast_cost_zone_state{rank_list = NewRoleList, length = length(NewRoleList), min_cost = TempRank#role_rank_clusters.cost}
		end,
	NewRankMap = maps:put(ZoneId, NewZoneState, RankMap),
	State#feast_cost_clusters_state{rank_map = NewRankMap}.


%%排序
sort(RoleRankList, LimitLength) ->
	F = fun(A, B) ->
		if
			is_record(A, role_rank_clusters) ->
				if
					A#role_rank_clusters.cost > B#role_rank_clusters.cost ->
						true;
					A#role_rank_clusters.cost == B#role_rank_clusters.cost ->
						A#role_rank_clusters.refresh_time =< B#role_rank_clusters.refresh_time;
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
save_role_rank_clusters_to_db(#role_rank_clusters{role_name = RoleName, role_id = RoleId, refresh_time = RefreshTime, cost = Cost,
	lv = Lv, server_id = ServerId, server_zone_id = ZoneId, server_num = ServerNum, server_name = ServerName}) ->
	Sql = io_lib:format(?save_feast_cost_rank_clusters, [RoleId, util:fix_sql_str(RoleName), Cost,
		RefreshTime, Lv, ServerId, ZoneId, ServerNum, ServerName]),
%%	?MYLOG("cym", "Sql ~s~n", [Sql]),
	db:execute(Sql).


%%清理榜单的数据
del_list() ->
	Sql = io_lib:format(?delete_feast_cost_rank_clusters, []),
	db:execute(Sql).

set_rank([]) ->
	[];
set_rank(RankList) ->
	SubType = get_sub_type(),
	GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType),
	F = fun(Grade, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType, Grade) of
			#custom_act_reward_cfg{condition = Condition} ->
				{MinRank, MaxRank} = get_rank_by_condition(Condition),
				LimitCost = get_limit_cost_by_condition(Condition),
				[{LimitCost, MinRank, MaxRank} | Acc];
			_ ->
				Acc
		end
	end,
	LimitList = lists:reverse(lists:foldl(F, [], GradeList)),
	set_rank(RankList, 0, [], LimitList).

set_rank(_, -1, Res, _LimitList) ->
	lists:reverse(Res);
set_rank([], _, Res, _LimitList) ->
	lists:reverse(Res);
set_rank([RoleRank | T], RankNum, Res, LimitList) ->
	#role_rank_clusters{cost = Cost} = RoleRank,
	RightRankNum = get_right_rank_num(RankNum, Cost, LimitList),
	case RightRankNum of
		-1 -> %%-1代表达不到最低要求， 后面的列表也不符合条件了,
			set_rank(T, -1, Res, LimitList);
		_ ->
			set_rank(T, RightRankNum, [RoleRank#role_rank_clusters{rank = RightRankNum} | Res], LimitList)
	end.


%%等级限制
get_limit_lv() ->
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2),
	if
		IsOpen == true ->
			SubTypeId = hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2)),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubTypeId) of
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
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2),
	if
		IsOpen == true ->
			SubTypeId = hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2)),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubTypeId) of
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
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2),
	if
		IsOpen == true ->
			SubTypeId = hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2)),
			case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubTypeId) of
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



get_role_rank_clusters_by_id_from_db(RoleId) ->
	Sql = io_lib:format(?select_feast_cost_rank_clusters, [RoleId]),
	case db:get_row(Sql) of
		[] ->
			[];
		[RoleId, RoleName, Cost, RefreshTime, Lv, ServerId, _ZoneId, ServerNum, ServerName] ->
			#role_rank_clusters{role_id = RoleId, role_name = RoleName, cost = Cost,
				refresh_time = RefreshTime, lv = Lv, server_id = ServerId,
				server_zone_id = 0, server_num = ServerNum, server_name = ServerName}
	end.


%%发送排行榜信息
send_to_client(RoleId, ServerId, #feast_cost_clusters_state{rank_map = Map}) ->
%%	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	ZoneId = 0,
%%	?MYLOG("cym", "send Msg ~p~n", [Map]),
	#feast_cost_zone_state{rank_list = RankList} = maps:get(ZoneId, Map, init_zone_state()),
	MyRank =
		case lists:keyfind(RoleId, #role_rank_clusters.role_id, RankList) of
			false ->
				case get_role_rank_clusters_by_id_from_db(RoleId) of
					[] ->
						#role_rank_clusters{};
					_Rank ->
						_Rank
				end;
			_Rank ->
				_Rank
		end,
	SendRankList = [{TempServerId, ServerNum, _roleId, binary_to_list(_roleName), _rank, _cost} ||
		#role_rank_clusters{role_id = _roleId, role_name = _roleName, rank = _rank, cost = _cost, server_id = TempServerId, server_num = ServerNum} <- RankList],
	{ok, Bin} = pt_332:write(33203, [MyRank#role_rank_clusters.rank, MyRank#role_rank_clusters.cost, SendRankList]),
	?MYLOG("cym", "send Msg ~p~n", [{MyRank#role_rank_clusters.rank, MyRank#role_rank_clusters.cost, SendRankList}]),
	send_to_uid(ServerId, RoleId, Bin).


%%发送奖励列表给客户端
send_reward_to_client(RoleId, SubType, _ServerId) ->
	GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType),
	F = fun(Grade, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType, Grade) of
			#custom_act_reward_cfg{reward = Reward, condition = Condition} ->
				{MinRank, MaxRank} = get_rank_by_condition(Condition),
				LimitCost = get_limit_cost_by_condition(Condition),
				TitleReward = get_title_by_condition(Condition),
				[{Grade, LimitCost, MinRank, MaxRank, TitleReward ++ Reward} | Acc];
			_ ->
				Acc
		end
	end,
	ResList = lists:reverse(lists:foldl(F, [], GradeList)),
	{ok, Bin} = pt_332:write(33204, [SubType, ResList]),
%%	?MYLOG("cym", "ResList ~p  GradeList ~p~n", [ResList, GradeList]),
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

act_end(#feast_cost_clusters_state{rank_map = RankMap} = _State, SubType) ->
	GradeList = lib_custom_act_util:get_act_reward_grade_list(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType),
	F = fun(Grade, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType, Grade) of
			#custom_act_reward_cfg{reward = Reward, condition = Condition} ->
				{MinRank, MaxRank} = get_rank_by_condition(Condition),
				TitleReward = get_title_by_condition(Condition),
				[{Grade, MinRank, MaxRank, Reward, TitleReward} | Acc];
			_ ->
				Acc
		end
	end,
	ResList = lists:reverse(lists:foldl(F, [], GradeList)),
	_SendMailList = [[
		send_reward_with_mail(RoleRank, ResList) || RoleRank <- RankList] || #feast_cost_zone_state{rank_list = RankList}
		<- maps:values(RankMap)],
	SendMailList = lists:flatten(_SendMailList),
%%	?MYLOG("cym", "SendMailList ~p~n", [SendMailList]),
	AllRoleMsg = get_all_role_msg(),
	%%发送安慰奖励
	ParticipateReward = get_participate_reward(SubType),
	RankLimit         = get_participate_limit(SubType),
	[send_participate_reward_with_mail(ServerId, RoleId, ParticipateReward) ||{{ServerId, RoleId}, Cost} <-AllRoleMsg,
		lists:member({ServerId, RoleId}, SendMailList) == false, Cost >= RankLimit],
	del_list(),
	#feast_cost_clusters_state{}.

%%返回[{ser}]
send_reward_with_mail(#role_rank_clusters{rank = Rank, role_id = RoleId, server_id = ServerId}, ResList) ->
	timer:sleep(100),
	{Reward, TitleReward} = get_reward_by_rank(Rank, ResList),
	Title = data_language:get(3310046),
	Content = utext:get(3310047, [Rank]),
%%	Content = data_language:get(3310041),
	mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, Reward]),
	case TitleReward of
		R when R =/= []-> %% 特殊称号奖励
			case data_designation:get_designation_id(R) of
				[DsgtId | _] ->
					mod_clusters_center:apply_cast(ServerId, lib_designation_api, active_dsgt_common, [RoleId, DsgtId]);
%%					lib_designation_api:active_dsgt_common(RoleId, DsgtId);
				_ ->
					skip
			end;
		_ ->
			skip
	end,
	case Reward of
		[] ->
			[];
		_ ->
			{ServerId, RoleId}
	end.
send_participate_reward_with_mail(_ServerId, _RoleId, []) ->
	skip;
send_participate_reward_with_mail(ServerId, RoleId, Reward) ->
	Title = data_language:get(3310052),
	Content = utext:get(3310053),
%%	?MYLOG("cym", "Reward ~p~n", [Reward]),
	mod_clusters_center:apply_cast(ServerId, lib_mail_api, send_sys_mail, [[RoleId], Title, Content, Reward]).

%%获取奖励，通过排名
get_reward_by_rank(_Rank, []) ->
	{[], []};
get_reward_by_rank(Rank, [{_Grade, MinRank, MaxRank, Reward, TitleReward} | T]) ->
	if
		Rank >= MinRank andalso Rank =< MaxRank ->
			{Reward, TitleReward};
		true ->
			get_reward_by_rank(Rank, T)
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  修正排名
%% @param    参数      RankNum::上一个排名   Cost::当前消耗     LimitList::限制列表
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_right_rank_num(_RankNum, _Cost, []) ->
	-1;
get_right_rank_num(RankNum, Cost, [{LimitCost, MinRank, MaxRank} | LimitList]) ->
	case Cost >= LimitCost of
		true ->
			if
				RankNum < MinRank ->    %% RankNum在这个区间前面，  则从这区间开始算
					MinRank;
				RankNum >= MinRank andalso RankNum < MaxRank ->   %% RankNum在这个区间内，但是没有到最后一名 [ )
					RankNum + 1;
				RankNum >= MaxRank ->  %%上一个排名已经是这个区间的最后一名
					get_right_rank_num(RankNum, Cost, LimitList);
				true ->
					get_right_rank_num(RankNum, Cost, LimitList)
			end;
		false ->
			get_right_rank_num(RankNum, Cost, LimitList)
	end.



init_zone_state() ->
	#feast_cost_zone_state{limit_cost = get_limit_cost()}.


send_to_uid(ServerId, RoleId, Bin) ->
	case lib_clusters_center:get_node(ServerId) of
		undefined ->
			lib_server_send:send_to_uid(RoleId, Bin);
		Node ->
			lib_server_send:send_to_uid(Node, RoleId, Bin)
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述 初始化各个区域的排行榜
%% @param    参数     ZoneIdlist::[ZoneId]
%% @return   返回值   #{ZoneId => }
%% @history  修改历史
%% -----------------------------------------------------------------
init_state_from_db_help([], ZoneMap) ->
	ZoneMap;
init_state_from_db_help([Id | ZoneList], ZoneMap) ->
	Sql = io_lib:format(?select_feast_cost_rank_all_clusters, [get_limit_lv(), get_limit_cost(), Id, get_limit_length()]),
	List = db:get_all(Sql),
	RoleRankList = [#role_rank_clusters{role_id = RoleId, role_name = RoleName, cost = Cost,
		refresh_time = RefreshTime, lv = Lv, server_id = ServerId, server_zone_id = 0, server_num = ServerNum, server_name = ServerName}
		|| [RoleId, RoleName, Cost, RefreshTime, Lv, ServerId, _ZoneId, ServerNum, ServerName] <- List],
	Length = length(RoleRankList),
%%	?MYLOG("cym", "RoleRankList ~p~n", [RoleRankList]),
	LastRoleRankList = set_rank(RoleRankList),
	MinCost = case LastRoleRankList of
		[] ->
			0;
		_ ->
			[#role_rank_clusters{cost = _Cost}] = lists:sublist(RoleRankList, Length, 1),
			_Cost
	end,
%%	?DEBUG("LastRoleRankList ~p~n", [LastRoleRankList]),
	ZoneRankState = #feast_cost_zone_state{rank_list = LastRoleRankList, length = Length, limit_cost = lib_feast_cost_rank_clusters:get_limit_cost(), min_cost = MinCost},
	NewZoneMap = maps:put(Id, ZoneRankState, ZoneMap),
	init_state_from_db_help(ZoneList, NewZoneMap).

zone_change(_State, _ServerId, _OldZone, _NewZone) ->  %%改为大跨服
%%	Sql = io_lib:format(?update_feast_cost_rank_clusters_zone, [NewZone, ServerId]),
%%	db:execute(Sql),
%%	State1 = mod_feast_cost_rank_clusters:init(),
	_State.

get_sub_type() ->
	IsOpen = lib_custom_act_api:is_open_act(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2),
	if
		IsOpen == true ->
			SubTypeId = hd(lib_custom_act_api:get_open_subtype_ids(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2)),
			SubTypeId;
		true ->
			1
	end.

act_start(_State, _SubType) ->
	State = mod_feast_cost_rank_clusters:init(),
	State.

%% -----------------------------------------------------------------
%% @desc     功能描述 获得所有的信息
%% @param    参数
%% @return   返回值  [{{server_id, role_id}, cost}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_all_role_msg() ->
	Sql = io_lib:format(?select_all_role, []),
	List = db:get_all(Sql),
	ResList = [{{ServerId, RoleId}, Cost} || [ServerId, RoleId, Cost] <- List],
	ResList.
%% -----------------------------------------------------------------
%% @desc     功能描述 获得参与奖励
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_participate_reward(SubType) ->
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(participate, 1, Condition) of
				{_, Reward} ->
					Reward;
				_ ->
					[]
			end;
		_ ->
			[]
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述 参与奖的消费下限
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_participate_limit(SubType) ->
	case lib_custom_act_util:get_act_cfg_info(?CUSTOM_ACT_TYPE_FEAST_COST_RANK2, SubType) of
		#custom_act_cfg{condition = Condition} ->
			case lists:keyfind(rank_limit, 1, Condition) of
				{_, RankLimit} ->
					RankLimit;
				_ ->
					0
			end;
		_ ->
			0
	end.

%% 1- 3名有称号奖励
get_title_by_condition(Condition) ->
	case lists:keyfind(title_gift, 1, Condition) of
		{title_gift, GoodsId} ->
			[{?TYPE_GOODS, GoodsId, 1}];
		_ ->
			[]
	end.

%% 前 Time 秒，消费是没有用的
get_pre_time(Conditon) ->
	case lists:keyfind(refresh_limit_time, 1, Conditon) of
		{refresh_limit_time, Time} ->
			Time;
		_ ->
			0
	end.