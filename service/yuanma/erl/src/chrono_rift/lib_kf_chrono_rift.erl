%%%-----------------------------------
%%% @Module      : lib_kf_chrono_rift
%%% @Author      : chenyiming
%%% @Email       : chenyiming@suyougame.com
%%% @Created     : 27. 十一月 2019 15:20
%%% @Description :
%%%-----------------------------------


%% API
-compile(export_all).

-module(lib_kf_chrono_rift).
-author("carlos").
-include("chrono_rift.hrl").
-include("common.hrl").
-include("clusters.hrl").
-include("predefine.hrl").
-include("server.hrl").
-include("def_fun.hrl").
%% API
-export([]).

%% 占领12个小时的定时器
send_timer(OldRef, Time, ServerId, CastleId) ->
	Now = utime:unixtime(),
	util:cancel_timer(OldRef),
	if
		Now =< Time ->
			erlang:send_after((Time - Now) * 1000, self(), {occupy_twelve, ServerId, CastleId});  %%   定时器
		true ->
			[]
	end.


get_castle_role_list(Id, ZoneId) ->
	List = lib_chrono_rift_data:db_get_castle_roles(Id, ZoneId),
	[#castle_role_msg{
		role_id = RoleId
		, role_name = binary_to_list(RoleName)
		, server_id = ServerId
		, server_num = ServerNum
		, server_name = binary_to_list(ServerName)
		, scramble_value = ScrambleValue
		, is_occupy = IsOccupy
		, zone_id = ZoneId
	}
		|| [RoleId, RoleName, ServerId, ServerNum, ServerName, ScrambleValue, IsOccupy] <- List].



sort_castle_role([]) ->
	[];
sort_castle_role(RoleList) ->
	F = fun(#castle_role_msg{scramble_value = V1}, #castle_role_msg{scramble_value = V2}) ->
		V1 >= V2
	    end,
	lists:sort(F, RoleList).



%% 从数据构造出来的格式
make_server_scramble_value_from_db(ScrambleValueList) ->
%%%%	?MYLOG("cym", "ScrambleValueListDb ~p~n", [ScrambleValueList]),
%%	List = util:bitstring_to_term(ScrambleValueList),
%%	Res = is_list(List),
%%	if
%%		Res == true ->
%%			List2 = [#castle_server_msg{server_id = ServerId, server_name = ServerName, server_num = ServerNum, value = Value}
%%				|| {ServerId, ServerNum, ServerName, Value} <- List],
%%			sort_castle_server_list(List2);
%%		true ->
%%			[]
%%	end.
	[].

server_scramble_value_to_db(List) ->
	List2 = [{ServerId, ServerNum, ServerName, Value}
		|| #castle_server_msg{server_id = ServerId, server_name = ServerName, server_num = ServerNum, value = Value} <- List],
	List2.



sort_castle_server_list([]) ->
	[];
sort_castle_server_list(List) ->
	F = fun(#castle_server_msg{value = V1}, #castle_server_msg{value = V2}) ->
		V1 >= V2
	    end,
	lists:sort(F, List).


get_end_ref(OldRef) ->

	Now = utime:unixtime(),
	EndTime = get_end_time(),
%%	?PRINT("EndTime ~p~n", [EndTime]),
	%% 延迟10
	util:send_after(OldRef, (EndTime + 10 - Now) * 1000, self(), {act_end}).

get_end_time() -> %% todo 优化
	Day = utime:day_of_month(),
	{StartTime, EndTime} = utime:get_month_unixtime_range(),
	if
		Day > 15 -> %% 下半个月的赛季
			EndTime;
		true ->  %% 这个半月的赛季
			StartTime + 15 * ?ONE_DAY_SECONDS
	end.



get_default_castle_id(CastleList, ServerId) ->
	F = fun(Id, ResCastleId) ->
		case lists:keyfind(Id, #chrono_rift_castle.id, CastleList) of
			#chrono_rift_castle{base_server_id = ServerId} ->
				Id;
			_ ->
				ResCastleId
		end
	    end,
	lists:foldl(F, 1, ?base_castle_id).









alloc_base_castle(ZoneId, CastleList) ->
	case lists:keyfind(1, #chrono_rift_castle.id, CastleList) of
		#chrono_rift_castle{base_server_id = ServerId} when ServerId > 0 ->  %% 分配过了
			CastleList;
		_ ->
			%%分配
			ServerList = mod_zone_mgr:get_zone_server(ZoneId),
			if
				ZoneId == 1 ->
					?MYLOG("chrono", "ZoneId ~p , CastleList ~p  ServerList ~p~n", [ZoneId, CastleList, ServerList]);
				true ->
					ok
			end,
			NewCastleList = alloc_base_castle(ServerList, ?base_castle_id, CastleList),
			NewCastleList
	end.

alloc_base_castle(_, [], AccCastleList) ->
	AccCastleList;
alloc_base_castle([], _, AccCastleList) ->
	AccCastleList;
alloc_base_castle([#zone_base{server_id = ServerId, server_num = ServerNum, server_name = ServerName} | ServerList], [CastleId | T], AccCastleList) ->
	case lists:keyfind(CastleId, #chrono_rift_castle.id, AccCastleList) of
		#chrono_rift_castle{} = Castle ->
			NewCastle = Castle#chrono_rift_castle{base_server_id = ServerId, have_servers = [ServerId],
				current_server_num = ServerNum, current_server_name = ServerName, current_server_id = ServerId, occupy_count = 1},
			%%保存数据库
%%			if
%%				CastleId == 1 ->
%%					?MYLOG("chrono", "Castle ~p~n", [Castle]);
%%				true ->
%%					ok
%%			end,
			save_to_db_castle(NewCastle),
			NewAccCastleList = lists:keystore(CastleId, #chrono_rift_castle.id, AccCastleList, NewCastle),
			alloc_base_castle(ServerList, T, NewAccCastleList);
		_ ->
			AccCastleList
	end.




%%  基地转化值
get_scramble_value_with_ratio(Value, BaseServerId, BaseServerId, _) ->  %%   就是基地关联服占领的
	Value;
get_scramble_value_with_ratio(Value, _, BaseServerId, BaseServerId) ->  %%   被人家占领了  基地转化值
	trunc(Value * ?base_castle_ratio);
get_scramble_value_with_ratio(Value, _, _, _) ->  %%   被人家占领了  有比率加多
	Value.


%% -----------------------------------------------------------------
%% @desc     功能描述   增加争夺值后的归属问题, 以及任务完成
%% @param    参数      Castle::#castle_role_msg{}，
%%                    RoleMsg::#castle_role_msg{},
%%                    AddValue::integer() 增加的争夺值（转化后的），
%%                    OldHaveServerIds::[serverId] 曾经占领过的服务器ds
%%                    CastleList::[#chrono_rift_castle{}]  据点数据
%%					  OldServerMsgList::旧据点的服务器争夺值情况数据，主要用于写日志
%%                    OldAddValue::转化前的增加值，（基地转化值）
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
handle_af_add_scramble_value(Castle, RoleMsg, AddValue, CastleList, OldServerMsgList, OldAddValue) ->
	#chrono_rift_castle{occupy_count = Count, lv = Lv, scramble_value = ValueList, current_server_id = OldCurSerId, have_servers = OldServerS, id = CastleId,
		timer_ref = OldRef} = Castle,
	#castle_role_msg{server_id = ServerId, server_num = ServerNum, server_name = ServerName, role_id = RoleId} = RoleMsg,
	V1 = get_scramble_value_by_server_id(ValueList, ServerId),
	NextNeedValue = get_next_scramble_value(Count, RoleMsg#castle_role_msg.server_id, Lv),
	%% 前两名的serverId
	Pre2ServerIds = get_pre_server_ids(CastleList, 2),
	%%log
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	%%主动推 02
	[mod_clusters_center:apply_cast(TempServerId, lib_chrono_rift, update_castle_msg_to_local, [CastleId])
		|| #castle_server_msg{server_id = TempServerId} <- ValueList],
	if
		V1 >= NextNeedValue andalso ServerId == OldCurSerId -> %%  serverId 相同===> 进入下一个阶段
			NewCount = calc_occupy_num(V1, Count, RoleMsg#castle_role_msg.server_id, Lv),
			Castle#chrono_rift_castle{occupy_count = max(NewCount, Count)};
		V1 >= NextNeedValue andalso ServerId =/= OldCurSerId -> %% 改变归属 且serverId 不同===> 占领据点
			%% 完成任务1
			mod_kf_chrono_rift_goal:add_goal_value(?goal1, ServerId, ServerNum, ServerName, 1),
			%% 任务2
			case lists:member(ServerId, OldServerS) of
				true ->
					mod_kf_chrono_rift_goal:add_goal_value(?goal2, ServerId, ServerNum, ServerName, 1);
				_ ->
					skip
			end,
			%% 任务5
			case lists:member(OldCurSerId, Pre2ServerIds) of
				true ->  %% 抢夺了前2的据点
					%%
					mod_kf_chrono_rift_goal:add_goal_value(?goal5, ServerId, ServerNum, ServerName, 1);
				_ ->
					sikp
			end,
			EndTime = utime:unixtime() + 12 * ?ONE_HOUR_SECONDS,
%%			%%test
%%			EndTime = utime:unixtime() +  60,
			Ref = lib_kf_chrono_rift:send_timer(OldRef, EndTime, ServerId, CastleId),
			lib_log_api:log_chrono_rift_castle_add_value(RoleId, ZoneId, ServerId, ServerNum, CastleId, Count, OldCurSerId,
				ServerId, castle_server_msg_to_log(OldServerMsgList), castle_server_msg_to_log(ValueList), OldAddValue, AddValue),
			NewCount = calc_occupy_num(V1, Count, RoleMsg#castle_role_msg.server_id, Lv),
			Castle#chrono_rift_castle{current_server_id = ServerId, timer_ref = Ref, time = EndTime,
				current_server_name = ServerName, current_server_num = ServerNum, occupy_count = max(NewCount, Count), have_servers = [ServerId | lists:delete(ServerId, OldServerS)]};
		true ->
			lib_log_api:log_chrono_rift_castle_add_value(RoleId, ZoneId, ServerId, ServerNum, CastleId, Count, OldCurSerId,
				OldCurSerId, castle_server_msg_to_log(OldServerMsgList), castle_server_msg_to_log(ValueList), OldAddValue, AddValue),
			Castle
	end.


castle_server_msg_to_log(List) ->
	[{ServerId, Value} || #castle_server_msg{server_id = ServerId, value = Value} <- List].


%%  返回需要的争夺值  Count 当前被占领的次数
get_next_scramble_value(Count, _ServerId, Lv) ->
	StageList = data_chrono_rift:get_stage_by_lv(Lv),
	if
		StageList == [] ->  %% 容错
			0;
		true ->
			case lists:member(Count + 1, StageList) of
				true ->
					data_chrono_rift:get_next_scramble_v(Count + 1, Lv);
				_ ->  %% 超出范围
					LastCount = hd(lists:reverse(StageList)),
					data_chrono_rift:get_next_scramble_v(LastCount, Lv)
			end
	end.


%%同步数据库
save_to_db_castle(Castle) ->
	#chrono_rift_castle{
		role_list = RoleList
	} = Castle,
    lib_chrono_rift_data:db_save_castle(Castle),
    lib_chrono_rift_data:db_save_castle_roles(RoleList).

%%  同步本地的据点id
update_local_role_castle_id(Role, CastleId) ->
	#castle_role_msg{server_id = ServerId, role_id = RoleId} = Role,
	mod_clusters_center:apply_cast(ServerId, lib_chrono_rift, update_local_role_castle_id, [RoleId, CastleId]).




%% 获取争夺值
get_scramble_value_by_server_id(ValueList, ServerId) ->
	case lists:keyfind(ServerId, #castle_server_msg.server_id, ValueList) of
		#castle_server_msg{value = V} ->
			V;
		_ ->
			0
	end.

add_server_scramble_value(ValueList, {ServerId, ServerNum, ServerName, Value}) ->
	%% {ServerId, ServerNumOld, ServerNameOld, LastValueOld}
	case lists:keyfind(ServerId, #castle_server_msg.server_id, ValueList) of
		#castle_server_msg{server_id = ServerId, value = LastValueOld} = OldMsg ->
			lists:keystore(ServerId, #castle_server_msg.server_id, ValueList, OldMsg#castle_server_msg{value = LastValueOld + Value});
		_ ->
			lists:keystore(ServerId, #castle_server_msg.server_id, ValueList,
				#castle_server_msg{value = Value, server_num = ServerNum, server_name = ServerName, server_id = ServerId})
	end;
add_server_scramble_value(ValueList, _) ->
	ValueList.




%%前几名的serverIds
get_pre_server_ids(CastleList, Length) ->
	SeverMsgList = sort_server_by_castle_num(CastleList),
	List = lists:sublist(SeverMsgList, Length),
	[ServerId || {ServerId, _, _, _, _} <- List, ServerId =/= 0].



%% -----------------------------------------------------------------
%% @desc     功能描述   排序      占领据点多的，排前， 争夺值多的排前
%% @param    参数
%% @return   返回值              [{ServerId, ServerNum, ServerName, OccupyNum, ScrambleValue}]
%% @history  修改历史
%% -----------------------------------------------------------------
sort_server_by_castle_num(CastleList) ->
	F = fun(#chrono_rift_castle{current_server_id = ServerId, scramble_value = Value,
		current_server_num = CurrServerNum, current_server_name = CurrServerName}, AccList) ->
		NewAccList = acc_scramble(Value, AccList),
		if
			ServerId == 0 ->
				NewAccList;
			true ->
				case lists:keyfind(ServerId, 1, NewAccList) of
					{ServerId, ServerNum, ServerName, OccupyNum, ScrambleValue} ->
						lists:keystore(ServerId, 1, NewAccList, {ServerId, ServerNum, ServerName, OccupyNum + 1, ScrambleValue});
					_ ->
						lists:keystore(ServerId, 1, NewAccList, {ServerId, CurrServerNum, CurrServerName, 1, 0})
				end
		end
	    end,
	List1 = lists:foldl(F, [], CastleList),
	SortF = fun({_ServerId1, _ServerNum1, _ServerName1, OccupyNum1, ScrambleValue1},
		           {_ServerId2, _ServerNum2, _ServerName2, OccupyNum2, ScrambleValue2}) ->
		if
			OccupyNum1 > OccupyNum2 ->  %% 占据多的排前面
				true;
			OccupyNum1 == OccupyNum2 ->  %% 一样的，争夺值多的排前面
				ScrambleValue1 >= ScrambleValue2;
			true ->
				false
		end
	        end,
	lists:sort(SortF, List1).



%% -----------------------------------------------------------------
%% @desc     功能描述    收集各个服务器占领情况
%%
%% @param    参数       ValueList::[#castle_server_msg{}]
%%                     List::[{ServerId, ServerNum, ServerName, OccupyNum, ScrambleValue}]
%% @return   返回值     NewList
%% @history  修改历史
%% -----------------------------------------------------------------
acc_scramble(ValueList, List) ->
	%%{ServerId, ServerNum, ServerName, ScrambleV}
	F = fun(#castle_server_msg{server_id = ServerId, server_num = ServerNum, server_name = ServerName, value = ScrambleV}, AccList) ->
		case lists:keyfind(ServerId, 1, AccList) of
			{ServerId, _, _, OccupyNum, ScrambleValue} ->
				lists:keystore(ServerId, 1, AccList, {ServerId, ServerNum, ServerName, OccupyNum, ScrambleValue + ScrambleV});
			_ ->
				lists:keystore(ServerId, 1, AccList, {ServerId, ServerNum, ServerName, 0, ScrambleV})
		end
	    end,
	lists:foldl(F, List, ValueList).



get_init_zone_state(ZoneIds) ->
	OpZoneL = get_open_zone_list(),
	get_init_zone_state(ZoneIds, OpZoneL, []).


get_init_zone_state([], _OpZoneL, AccList) ->
	AccList;
get_init_zone_state([Id | ZoneIds], OpZoneL, AccList) ->
	Servers = mod_zone_mgr:get_zone_server(Id),
	OpenDayLimit = ?CR_OPEN_DAY,
	F = fun(#zone_base{world_lv = Lv, time = OpenTime}, {FunLv, Num}) ->
		OpenDay = util:get_open_day_in_center(OpenTime),
		if
			OpenDayLimit > OpenDay ->
				{FunLv, Num};
			true ->
				{FunLv + Lv, Num + 1}
		end
		end,
	{AllLv, Num} = lists:foldl(F, {0, 0}, Servers),
%%	Num = length(Servers),
	AvgLv = ?IF(Num =/= 0, round(AllLv / Num), 0),
	NeedLv = ?CR_WORLD_LV,
	Status = ?IF(AvgLv >= NeedLv orelse lists:member(Id, OpZoneL), ?act_open, ?act_close),
	ZoneMsg = #zone_msg{zone_id = Id, all_lv = AllLv, num = Num, status = Status},
	get_init_zone_state(ZoneIds, OpZoneL, [ZoneMsg | AccList]).


get_open_zone_list() ->
	Sql = io_lib:format(<<"select `info` from `module_info` where `module` = ~p and `sub_module` = ~p limit 1">>, [204, 0]),
	case db:get_row(Sql) of
		[OpZoneLStr] ->
			OpZoneL0 = util:bitstring_to_term(OpZoneLStr),
			OpZoneL = ?IF(is_list(OpZoneL0), OpZoneL0, []);
		_ ->
			OpZoneL = []
	end,
	OpZoneL.

save_open_zone_list(ZoneList) ->
	OpenZoneL = [ZoneId||#zone_msg{zone_id = ZoneId} <- ZoneList],
	Sql = io_lib:format(<<"replace into `module_info` (`module`, `sub_module`, `info`) values (204, 0, '~s')">>, [util:term_to_string(OpenZoneL)]),
	db:execute(Sql).

%% 重新计算全部区域状态(秘籍用)
recalc_zone_state(ZoneIds) ->
    recalc_zone_state(ZoneIds, []).

recalc_zone_state([], AccL) -> AccL;
recalc_zone_state([Id | ZoneIds], AccL) ->
    Servers = mod_zone_mgr:get_zone_server(Id),
	OpenDayLimit = ?CR_OPEN_DAY,
	F = fun(#zone_base{world_lv = Lv, time = OpenTime}, {FunLv, Num}) ->
		OpenDay = util:get_open_day_in_center(OpenTime),
		if
			OpenDayLimit > OpenDay ->
				{FunLv, Num};
			true ->
				{FunLv + Lv, Num + 1}
		end
		end,
	{AllLv, Num} = lists:foldl(F, {0, 0}, Servers),
	AvgLv = ?IF(Num =/= 0, round(AllLv / Num), 0),
	NeedLv = ?CR_WORLD_LV,
	Status = ?IF(AvgLv >= NeedLv, ?act_open, ?act_close),
	ZoneMsg = #zone_msg{zone_id = Id, all_lv = AllLv, num = Num, status = Status},
	recalc_zone_state(ZoneIds, [ZoneMsg | AccL]).

%% 活动是否开启
is_act_open(ServerId, ZoneList) ->
	ZoneId = lib_clusters_center_api:get_zone(ServerId),
	is_act_open2(ZoneId, ZoneList).

%% 活动是否开启
is_act_open2(ZoneId, ZoneList) ->
	case lists:keyfind(ZoneId, #zone_msg.zone_id, ZoneList) of
		#zone_msg{status = ?act_open} ->
			true;
		_ ->
			false
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  返回本服驻扎信息
%% @param    参数
%% @return   返回值  {本服驻扎人数, 本服提供过争夺值的人数}
%% @history  修改历史
%% -----------------------------------------------------------------
get_occupy_role_msg(RoleList, ServerId) ->
	get_occupy_role_msg(RoleList, ServerId, {0, 0}).

get_occupy_role_msg([], _ServerId, {V1, V2}) ->
	{V1, V2};
get_occupy_role_msg([#castle_role_msg{server_id = ServerId, is_occupy = IsOccupy, scramble_value = RoleValue} | RoleList], ServerId, {V1, V2}) ->
	NewV1 = ?IF(IsOccupy == ?is_occupy, V1 + 1, V1),
	NewV2 = ?IF(RoleValue > 0, V2 + 1, V2),
	get_occupy_role_msg(RoleList, ServerId, {NewV1, NewV2});
get_occupy_role_msg([_ | RoleList], ServerId, {V1, V2}) ->  %% 不同服务器
	get_occupy_role_msg(RoleList, ServerId, {V1, V2}).



%%获取服务器的争夺值
get_server_scramble_value(ServerId, ValueList) ->
%%	?MYLOG("chrono", "serverId ~p, Valuelist ~p~n", [ServerId, ValueList]),
	case lists:keyfind(ServerId, #castle_server_msg.server_id, ValueList) of
		#castle_server_msg{value = Value} ->
			Value;
		_ ->
			0
	end.



sort_scramble_value(ValueList) ->
	F = fun(#castle_server_msg{value = V1}, #castle_server_msg{value = V2}) ->
		V1 >= V2
	    end,
	lists:sort(F, ValueList).

send_to_uid(ServerId, RoleId, Bin) ->
	mod_clusters_center:apply_cast(ServerId, lib_server_send, send_to_uid, [RoleId, Bin]).


send_error(ServerId, RoleId, Error) ->
	{ok, Bin} = pt_204:write(20400, [Error]),
	send_to_uid(ServerId, RoleId, Bin).




get_connect_castle_ids(CastleId) ->
	case data_chrono_rift:get_castle(CastleId) of
		#cfg_chrono_rift_castle{connect_castle = List} ->
			List;
		_ ->
			[]
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  打包数值
%% @param    参数
%% @return   返回值    [{GoalId, Value, Status}]
%% @history  修改历史
%% -----------------------------------------------------------------
get_pack_goal_info(GoalList, Rank, SeasonReward) ->
	F = fun({Type, _Value}, AccList) ->
		Value =
			case lists:keyfind(Type, 1, GoalList) of
				{_, V} ->
					V;
				_ ->
					_Value
			end,
		GoalId = get_goal_id_by_type_rank(Type, Rank),
		NeedValue = data_chrono_rift:get_goal_value(GoalId),
		if
			NeedValue > Value ->
				Status = 0;
			true ->
				case lists:keyfind(Type, 1, SeasonReward) of
					{_, 2} -> %% 已经领取了
						Status = 2;
					_ -> %% 可以领取
						Status = 1
				end
		end,
		[{GoalId, Value, Status} | AccList]
	    end,
	lists:reverse(lists:foldl(F, [], ?goal_default_list)).


get_goal_id_by_type_rank(Type, Rank) ->
	DiffLv = get_lv_by_rank(Rank),
	data_chrono_rift:get_goal_id_by_lv_and_type(DiffLv, Type).




%% 通过排名获取难度
get_lv_by_rank(0) ->
	1;
get_lv_by_rank(Rank) ->
	LvList = ?CR_GOAL_LV_LIST,
	get_lv_by_rank(LvList, Rank).


get_lv_by_rank([], _Rank) ->
	1;
get_lv_by_rank([{MinRank, MaxRank, Lv} | T], Rank) ->
	if
		Rank >= MinRank andalso Rank =< MaxRank ->
			Lv;
		true ->
			get_lv_by_rank(T, Rank)
	end.

calc_occupy_num(V, CurrCount, ServerId, CastleLv) ->
	NeedValue = get_next_scramble_value(CurrCount, ServerId, CastleLv),  %% 下一个阶段的争夺值
%%	?MYLOG("chrono2", "NeedValue ~p, Count ~p~n", [NeedValue, CurrCount]),
	if
		V >= NeedValue ->
			calc_occupy_num(V, CurrCount + 1, ServerId, CastleLv);
		true ->
			CurrCount
	end.



gm_clear_castle_zone_id(ZoneId) ->
	Sql = io_lib:format("DELETE   from  chrono_rift_castle where  zone_id = ~p", [ZoneId]),
	Sql2 = io_lib:format("DELETE   from  chrono_rift_castle_role where  zone_id = ~p", [ZoneId]),
	db:execute(Sql),
	db:execute(Sql2),
	SeverList = mod_zone_mgr:get_zone_server(ZoneId),
%%	?PRINT("++++++++++ ~p~n", [SeverList]),
	F = fun(#zone_base{server_id = SeverId}) ->
			mod_clusters_center:apply_cast(SeverId, lib_kf_chrono_rift, gm_clear_castle_id, [0])
		end,
	lists:foreach(F, SeverList),
	mod_kf_chrono_rift:re_load().


gm_clear_castle_id(CastleId) ->
	Sql = io_lib:format("UPDATE chrono_rift_role  set castle_id = ~p", [CastleId]),
	db:execute(Sql),
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, ?APPLY_CAST_SAVE, lib_kf_chrono_rift, gm_clear_castle_id, [CastleId]) || RoleId <- IdList].


gm_clear_castle_id(PS, CastleId) ->
	#player_status{chrono_rift = Rift} = PS,
	case Rift of
		#chrono_rift_in_ps{} ->
%%			?PRINT("++++++++++ ~p~n", [CastleId]),
			PS#player_status{chrono_rift = Rift#chrono_rift_in_ps{castle_id = CastleId}};
		_ ->
			PS
	end.
