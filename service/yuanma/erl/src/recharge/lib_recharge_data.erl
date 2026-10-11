%% ---------------------------------------------------------------------------
%% @doc    充值系统数据处理
%% @author hek
%% @since  2016-11-14
%% @deprecated
%% ---------------------------------------------------------------------------

-module(lib_recharge_data).
-include("server.hrl").
-include("common.hrl").
-include("def_recharge.hrl").
-include("rec_recharge.hrl").
-include("def_cache.hrl").
-include("def_module.hrl").
-compile (export_all).

%% 取出所有未处理的充值记录
get_all_recharge() ->
	db:get_all(?sql_pay_fetch_all).

%% 取出玩家所有充值待处理记录
get_my_all_recharge(PlayerId) ->
	db:get_all(io_lib:format(?sql_pay_fetch_all_of_user, [PlayerId])).

%% 将充值记录标识为已经完成处理
finish_recharge(Id) ->
	db:execute(io_lib:format(?sql_pay_update_recharge, [Id])).

%% 获取充值总额
get_total(PlayerId) ->
	CacheKey = ?CACHE_KEY(?CACHE_TOTAL_RECHARGE, ?PAY_TOTAL_RECHARGE(PlayerId)),
	case mod_cache:get(CacheKey) of
		undefined ->
			Recharge = case db:get_one(io_lib:format(?sql_recharge_get_total, [PlayerId])) of
				Total when is_number(Total) ->
					round(Total);
				_ ->
					Recharge1 = case db:get_one(io_lib:format(?sql_get_pay_rmb_sum, [PlayerId, 0, utime:unixtime()])) of
						M when is_number(M) ->
							round(M * 10);
						_ ->
							0
					end,
					db:execute(io_lib:format(?sql_recharge_insert_total, [PlayerId, Recharge1, 0])),
					Recharge1
			end,
			mod_cache:put(CacheKey, Recharge),
			Recharge;
		Money ->
			Money
	end.

get_total_rmb(PlayerId) ->
	CacheKey = ?CACHE_KEY(?CACHE_TOTAL_RMB, PlayerId),
	case mod_cache:get(CacheKey) of
		undefined ->
			Recharge = case db:get_one(io_lib:format(?sql_get_pay_rmb_sum, [PlayerId, 0, utime:unixtime()])) of
				M when is_number(M) ->
					M;
				_ ->
					0
			end,
			mod_cache:put(CacheKey, Recharge),
			Recharge;
		Money ->
			Money
	end.

%% 更新充值金额 RMB
update_total_rmb(PlayerId, Rmb) ->
	CacheKey = ?CACHE_KEY(?CACHE_TOTAL_RMB, PlayerId),
	case mod_cache:get(CacheKey) of
		undefined ->
			skip;
		Money ->
			mod_cache:put(CacheKey, Money + Rmb)
	end.

%% 获取过去几天内玩家每天的充值总额，不包括今天， 只能在玩家进程获取 
%% return [{每天0点时间戳,{元宝总数，人民币总数}}]
get_my_daily_recharge_summaries(RoleId, DayCount) ->
	Cache = get_daily_recharge_detail(RoleId, DayCount),
%%	?MYLOG("cym", "Cache ~p~n",  [Cache]),
	[{Time, {Gold, Rmb}} || #daily_recharge{zero_time = Time, total_gold = Gold, total_rmb = Rmb} <- Cache].



get_daily_recharge_detail(RoleId, DayCount) when DayCount >= 0 ->
	IsAlive = misc:is_process_alive(misc:get_player_process(RoleId)),
%%	StartTime = utime:standard_unixdate(utime:unixdate() - DayCount * ?ONE_DAY_SECONDS),
	%% 几天前的0点
	StartTime = utime:get_diff_day_standard_unixdate(DayCount, 0),
	case IsAlive of
		true ->
			case get({?MOD_RECHARGE_ACT, daily_recharge_detail}) of
				Cache when is_list(Cache) ->
					case all_daily_recharge_in_cache(Cache, StartTime) of
						true ->
							[X || #daily_recharge{zero_time = Time} = X <- Cache, Time >= StartTime];
						UnLoadedList ->
							NewCache = refresh_daily_recharge_cache(RoleId, Cache, UnLoadedList),
							put({?MOD_RECHARGE_ACT, daily_recharge_detail}, NewCache),
							[X || #daily_recharge{zero_time = Time} = X <- NewCache, Time >= StartTime]
					end;
				_ ->
					NewCache = refresh_daily_recharge_cache(RoleId, [], [{StartTime, utime:unixtime()}]),
					put({?MOD_RECHARGE_ACT, daily_recharge_detail}, NewCache),
					NewCache
				% [{Time, {Gold, Rmb}} || #daily_recharge{zero_time = Time, total_gold = Gold, total_rmb = Rmb} <- NewCache]
			end;
		false ->
			refresh_daily_recharge_cache(RoleId, [], [{StartTime, utime:unixtime()}])
	end;

get_daily_recharge_detail(_RoleId, _DayCount) ->
	[].

%% 玩家进程使用
get_my_recharge_between(RoleId, StartTime, EndTime) when StartTime =< EndTime ->
	DiffDay = utime:diff_day(StartTime),
	Cache = get_daily_recharge_detail(RoleId, DiffDay),
	HisSum = lists:sum([G || #daily_recharge{detail = Details} <- Cache, [CTime, G | _] <- Details, StartTime =< CTime andalso CTime =< EndTime]),
	HisSum;
get_my_recharge_between(_RoleId, _StartTime, _EndTime) ->
	0.

%% 玩家进程使用
get_my_recharge_rmb_between(RoleId, StartTime, EndTime) when StartTime =< EndTime ->
	DiffDay = utime:diff_day(StartTime),
	Cache = get_daily_recharge_detail(RoleId, DiffDay),
	HisSum = lists:sum([Rmb || #daily_recharge{detail = Details} <- Cache, [CTime, _G, Rmb | _] <- Details, StartTime =< CTime andalso CTime =< EndTime]),
	HisSum;
get_my_recharge_rmb_between(_RoleId, _StartTime, _EndTime) ->
	0.

%% 更新总充值统计数
update_total_recharge(PlayerId, TotalRecharge) ->
	db:execute(io_lib:format(?sql_recharge_update_total, [TotalRecharge, PlayerId])),
	CacheKey = ?CACHE_KEY(?CACHE_TOTAL_RECHARGE, ?PAY_TOTAL_RECHARGE(PlayerId)),
	mod_cache:put(CacheKey, TotalRecharge).

%% 获取玩家当天充值量
get_today_pay_gold(RoleId) ->
	case get_daily_recharge_detail(RoleId, 0) of
		[#daily_recharge{total_gold = Gold} | _] ->
			Gold;
		_ ->
			0
	end.

%% 获取玩家当天充值量
get_today_pay_rmb(RoleId) ->
	case get_daily_recharge_detail(RoleId, 0) of
		[#daily_recharge{total_rmb = Rmb} | _] ->
			case is_float(Rmb) of
				true ->
					erlang:round(Rmb);
				false ->
					Rmb
			end;
		_ ->
			0
	end.

%% 每日充值的金额只更新缓存就行了
%% 这个时间用的是充值到账的时间
update_daily_recharge(_RoleId, NowTime, Gold, Rmb) when Gold > 0 orelse Rmb > 0 ->
	case get({?MOD_RECHARGE_ACT, daily_recharge_detail}) of
		Cache when is_list(Cache) ->
			ZeroTime = utime:standard_unixdate(NowTime),
			Detail = [NowTime, Gold, Rmb],
			NewCache
				= case lists:keyfind(ZeroTime, #daily_recharge.zero_time, Cache) of
				#daily_recharge{total_gold = G, total_rmb = R, detail = D} = DailyRec ->
					NewDailyRec = DailyRec#daily_recharge{total_gold = G + Gold, total_rmb = R + Rmb, detail = [Detail | D]},
					lists:keystore(ZeroTime, #daily_recharge.zero_time, Cache, NewDailyRec);
				_ ->
					Cache ++ [#daily_recharge{zero_time = ZeroTime, total_gold = Gold, total_rmb = Rmb, detail = [Detail]}]
			end,
			put({?MOD_RECHARGE_ACT, daily_recharge_detail}, NewCache);
		_ ->
			ok
	end;

update_daily_recharge(_RoleId, _NowTime, _Money, _Rmb) ->
	ok.

all_daily_recharge_in_cache([], StartTime) ->
	[{StartTime, utime:unixtime()}];
all_daily_recharge_in_cache([#daily_recharge{zero_time = CacheStartTime} | _], StartTime) ->
	if
		CacheStartTime =< StartTime ->
			true;
		true ->
			[{StartTime, CacheStartTime}]
	end.

refresh_daily_recharge_cache(RoleId, Cache, UnLoadedList) ->
	%% 条件放松两个小时
	BetweenStr = ulists:list_to_string([io_lib:format("(`time` >= ~p AND `time` <= ~p)", [StartTime - ?ONE_HOUR_SECONDS * 2, EndTime]) || {StartTime, EndTime} <- UnLoadedList], " OR "),
	SQL = io_lib:format("SELECT `time`, `gold`, `money` FROM `recharge_log` WHERE `player_id`=~p AND ~s", [RoleId, BetweenStr]),
	All = db:get_all(SQL),
	LoadedList = init_daily_rechage_cache(UnLoadedList, All, []),
	FullList = lists:keysort(1, LoadedList ++ Cache),
	Length = length(FullList),
	{_, SlimList} = lists:foldl(fun
		(#daily_recharge{total_gold = Gold, total_rmb = Rmb} = X, {Count, Acc}) when Gold > 0 orelse Rmb > 0 orelse Count == 1 orelse Count == Length ->
			{Count + 1, [X | Acc]};
		(_, {Count, Acc}) ->
			{Count + 1, Acc}
	end, {1, []}, FullList),
	lists:reverse(SlimList).



%% -----------------------------------------------------------------
%% @desc     功能描述   获取在一段时间内玩家充值信息
%% @param    参数       UnLoadedList::lists()  [{StartTime, EndTime}]
%% @return   返回值     map()  RoleId  => [#daily_recharge{}]
%% @history  修改历史
%% -----------------------------------------------------------------
daily_recharge_map_from_db(UnLoadedList) ->
	%% 条件放松两个小时
	BetweenStr = ulists:list_to_string([io_lib:format("(`time` >= ~p AND `time` <= ~p)", [StartTime - ?ONE_HOUR_SECONDS * 2, EndTime]) || {StartTime, EndTime} <- UnLoadedList], " OR "),
	SQL = io_lib:format("SELECT `player_id`, `time`, `gold`, `money` FROM `recharge_log` WHERE ~s", [BetweenStr]),
%%	?MYLOG("cym2", "SQL ~p~n", [SQL]),
	All = db:get_all(SQL),
	RoleIds = [RoleId ||[RoleId | _] = _Data <-All],
%%	?MYLOG("cym2", "RoleIds ~p~n", [RoleIds]),
	F = fun(RoleId, AccMap) ->
			RoleDataList = [LeftData ||[RoleIdTemp | LeftData ] = _Data <-All, RoleIdTemp == RoleId],
%%			?MYLOG("cym2", "RoleDataList ~p~n", [RoleDataList]),
			ResList = init_daily_rechage_cache(UnLoadedList, RoleDataList, []),
%%			?MYLOG("cym2", "ResList ~p~n", [ResList]),
			Length = length(ResList),
			{_, SlimList} = lists:foldl(fun
			                            (#daily_recharge{total_gold = Gold, total_rmb = Rmb} = X, {Count, Acc}) when Gold > 0 orelse Rmb > 0 orelse Count == 1 orelse Count == Length ->
				                            {Count + 1, [X | Acc]};
			                            (_, {Count, Acc}) ->
				                            {Count + 1, Acc}
		                            end, {1, []}, ResList),
			maps:put(RoleId, lists:reverse(SlimList), AccMap)
		end,
	ResMap = lists:foldl(F, #{}, RoleIds),
	ResMap.




init_daily_rechage_cache([], _, Acc) ->
	Acc;
init_daily_rechage_cache([{StartTime, EndTime} | T], DataList, Acc) ->
	DateTimeList = splite_date_time(utime:standard_unixdate(StartTime), EndTime, []),
	DailyCacheList
		= lists:foldl(fun
		(ZeroTime, List) ->
%%			NextDateTime = ZeroTime + ?ONE_DAY_SECONDS,
			NextDateTime = utime:get_diff_day_standard_unixdate(ZeroTime, 1, 1),
			TodayList = [Data || [CTime | _] = Data <- DataList, CTime >= ZeroTime andalso CTime < NextDateTime],
			TodayGold = lists:sum([Gold || [_, Gold, _] <- TodayList]),
			TodayRMB = lists:sum([RMB || [_, _, RMB] <- TodayList]),
			[#daily_recharge{zero_time = ZeroTime, total_gold = TodayGold, total_rmb = TodayRMB, detail = TodayList} | List]
	end, [], DateTimeList),
	NewDataList = [Data || [CTime | _] = Data <- DataList, CTime < StartTime orelse EndTime =< CTime],
	init_daily_rechage_cache(T, NewDataList, DailyCacheList ++ Acc);

init_daily_rechage_cache([_ | T], DataList, Acc) ->
	init_daily_rechage_cache(T, DataList, Acc).
%% -----------------------------------------------------------------
%% @desc     功能描述     切割0点，
%% @param    参数        StartTime::integer() 开始的0点时间  EndTime::integer() 结束时间  Acc::lists() 返回列表
%% @return   返回值      Acc::lists()  [零点时间, 零点时间...]
%% @history  修改历史
%% -----------------------------------------------------------------
splite_date_time(StartTime, EndTime, Acc) when StartTime < EndTime ->
%%	splite_date_time(StartTime + ?ONE_DAY_SECONDS, EndTime, [StartTime | Acc]);
	%% 一天之后的 0点
	splite_date_time(utime:get_diff_day_standard_unixdate(StartTime, 1, 1), EndTime, [StartTime | Acc]);
splite_date_time(_, _, Acc) ->
	Acc.


%% 插入充值记录
%% Type 1:充钱 2:元宝卡
db_insert_recharge_log(PS, Type, ProductId, Money, Gold, RealGold, Time) ->
	#player_status{accid = AccId, accname = AccName, id = PlayerId} = PS,
	Sql = io_lib:format(?sql_insert_recharge_log, [AccId, AccName, PlayerId, Type, ProductId, Money, Gold, RealGold, Time]),
	db:execute(ulists:list_to_bin(Sql)).
db_insert_recharge_log(AccId, AccName, PlayerId, Type, ProductId, Money, Gold, RealGold, Time) ->
	Sql = io_lib:format(?sql_insert_recharge_log, [AccId, AccName, PlayerId, Type, ProductId, Money, Gold, RealGold, Time]),
	db:execute(ulists:list_to_bin(Sql)).

%% 删除订单
db_delete_recharge_log(PlayerId, RechargeLogId) ->
	Sql = io_lib:format(?sql_delete_recharge_log, [PlayerId, RechargeLogId]),
	db:execute(Sql).

%% 更新更新同账号的总充值金额
db_update_acc_total_charge(AccId, AccName, Gold) ->
	Sql = io_lib:format(?sql_acc_charge_update_total, [Gold, AccId, AccName]),
	db:execute(ulists:list_to_bin(Sql)).

%% 更新玩家最后充值时间
db_update_player_last_pay_time(PlayerId, LastPayTime) ->
	Sql = io_lib:format(?sql_update_last_pay_time, [LastPayTime, PlayerId]),
	db:execute(Sql).

%% 获取某个时间段内的所有充值记录
db_get_all_recharge_log_between_time(StartTime, EndTime) ->
	Sql = io_lib:format(<<"select player_id, sum(gold) as sg from recharge_log where time >= ~p AND time < ~p group by player_id having sg>0 ">>, [StartTime, EndTime]),
	db:get_all(Sql).


gm_change_zero() ->
	OnlineList = ets:tab2list(?ETS_ONLINE),
	IdList = [PlayerId || #ets_online{id = PlayerId} <- OnlineList],
	[lib_player:apply_cast(RoleId, 3, lib_recharge_data, gm_change_zero, []) || RoleId <- IdList].

gm_change_zero(PS) ->
	put({?MOD_RECHARGE_ACT, daily_recharge_detail}, undefined),
	{ok, PS}.


	
