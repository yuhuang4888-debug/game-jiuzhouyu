%%%--------------------------------------
%%% @Module  : 
%%% @Author  : 
%%% @Created : 
%%% @Description:  
%%%--------------------------------------
-module(lib_kf_cloud_buy).
-export([

    ]).
-compile(export_all).
-include("server.hrl").
-include("common.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("level_mail.hrl").
-include("figure.hrl").
-include("kf_cloud_buy.hrl").
-include("def_module.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("goods.hrl").

%%=================================== 活动界面信息
send_cld_act_info(PS, Type, SubType) ->
	#player_status{id = RoleId, sid = Sid, server_id = ServerId} = PS,
	Node = mod_disperse:get_clusters_node(),
	mod_clusters_node:apply_cast(mod_kf_cloud_buy, send_cld_act_info, [[Type, SubType, RoleId, Sid, ServerId, Node]]).

%%=================================== 活动奖励记录
send_cld_act_tv_records(PS, Type, SubType, StartPos, EndPos) ->
	#player_status{id = RoleId, sid = Sid, server_id = ServerId} = PS,
	Node = mod_disperse:get_clusters_node(),
	mod_clusters_node:apply_cast(mod_kf_cloud_buy, send_cld_act_tv_records, [[Type, SubType, StartPos, EndPos, RoleId, Sid, ServerId, Node]]).

%%=================================== 活动大奖记录
send_cld_act_big_records(PS, Type, SubType) ->
	#player_status{id = RoleId, sid = Sid, server_id = ServerId} = PS,
	Node = mod_disperse:get_clusters_node(),
	mod_clusters_node:apply_cast(mod_kf_cloud_buy, send_cld_act_big_records, [[Type, SubType, RoleId, Sid, ServerId, Node]]).

%%=================================== 购买
draw_rewards(PS, Type, SubType, Times) ->
	#player_status{
		id = RoleId, server_id = ServerId, server_num = ServerNum,
		gold = Gold, bgold = BGold, figure = #figure{name = Name, vip_type = VipType, vip = VipLv}} = PS,
	NowTime = utime:unixtime(),
	InRestriction = check_is_in_restriction_time(NowTime),
	VipCountLimit = lib_vip_api:get_vip_privilege(?MODULE_CLOUD_BUY, 1, VipType, VipLv),
	MoneyArgs = [Gold, BGold],
	Args = [Type, SubType, Times, RoleId, Name, ServerId, ServerNum, InRestriction, VipCountLimit, MoneyArgs],
	case catch mod_clusters_node:apply_call(mod_kf_cloud_buy, draw_rewards, [Args]) of 
		{ok, _GradeId, NewGradeCount, NewSelfCount, NewSelfTotalCount, RewardList, CostList} ->	
			?PRINT("draw_rewards reply#1 GradeId: ~p~n", [_GradeId]),
			%?PRINT("draw_rewards reply#1 {GradeCount, SelfCount, SelfTotalCount}: ~w~n", [{NewGradeCount, NewSelfCount, NewSelfTotalCount}]),
			case lib_goods_api:cost_object_list(PS, CostList, kf_cloud_buy, "") of 
				{true, PS1} ->
					Produce = #produce{type = kf_cloud_buy, reward = RewardList, show_tips = ?SHOW_TIPS_3},
					NewPS = lib_goods_api:send_reward(PS1, Produce),
					{ok, NewPS, NewGradeCount, NewSelfCount, NewSelfTotalCount, RewardList};
				{false, Res, _} ->
					?ERR("draw_rewards#3 Res: ~p~n", [{Res, CostList, RewardList}]),
					{false, Res}
			end;
		{false, Res} -> 
			{false, Res};
		_Err ->	
			?ERR("draw_rewards#1 err: ~p~n", [_Err]),
			{false, ?ERRCODE(system_busy)}
	end.

%%=================================== 领取阶段奖励
get_stage_reward(PS, Type, SubType, StageCount) ->
	#player_status{id = RoleId, sid = Sid, server_id = ServerId} = PS,
	Node = mod_disperse:get_clusters_node(),
	mod_clusters_node:apply_cast(mod_kf_cloud_buy, get_stage_reward, [[Type, SubType, StageCount, RoleId, Sid, ServerId, Node]]).

get_stage_reward_result(Code, Type, SubType, StageCount, RoleId, Rewards) ->
	lib_server_send:send_to_uid(RoleId, pt_512, 51206, [Code, Type, SubType, StageCount, Rewards]),
	case Rewards == [] of 
		true -> skip;
		_ ->
			Produce = #produce{type = kf_cloud_buy, reward = Rewards, show_tips = ?SHOW_TIPS_3},
			lib_goods_api:send_reward_with_mail(RoleId, Produce)
	end.

send_stage_reward_with_reset(Type, SubType, RoleList) ->
	spawn(fun() -> send_stage_reward_with_reset_do(Type, SubType, RoleList) end),
	ok.
send_stage_reward_with_reset_do(Type, SubType, RoleList) ->
	Title = utext:get(5120003),
	Content = utext:get(5120004),
	F = fun({RoleId, StageList}, Acc) ->
		Acc rem 20 == 0 andalso timer:sleep(500),
		RewardList = lists:flatten([get_stage_reward_list(Type, StageCount, Wlv) ||{StageCount, Wlv} <- StageList]),
		lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList),
		Acc + 1
	end,
	lists:foldl(F, 1, RoleList).

%%=================================== 发送大奖
send_big_reward_to_role(RoleId, _Type, _SubType, _GradeId, Rewards) ->
	Title = utext:get(5120001),
	Content = utext:get(5120002),
	lib_mail_api:send_sys_mail([RoleId], Title, Content, Rewards).

%%===================================== 结束购买
end_buy() ->
	SendList = pack_open_act_list(),
	{ok, Bin} = pt_512:write(51201, [SendList]),
	lib_server_send:send_to_all(Bin).

%%=================================== 刷新下一轮本服处理
broadcast_next_loop(Type, SubType, GradeId, GradeCount, SelfCount) ->
	case check_open_in_local(Type, SubType) of 
		true ->
			%?PRINT("broadcast_next_loop:~p~n", [{GradeId, GradeCount, SelfCount}]),
			{ok, Bin} = pt_512:write(51207, [Type, SubType, GradeId, GradeCount, SelfCount]),
			lib_server_send:send_to_all(Bin);
		_ ->
			skip
	end.

%%=================================== 活动重置本服处理
act_reset(Type, SubType, StartTime, EndTime, BuyEndTime, ResetTime, GradeId, GradeCount, SelfCount, SelfTotalCount, StageRewards) ->
	case check_open_in_local(Type, SubType) of 
		true ->
			% ?PRINT("act_reset StartTime:~p~n", [utime:unixtime_to_localtime(StartTime)]),
			% ?PRINT("act_reset EndTime:~p~n", [utime:unixtime_to_localtime(EndTime)]),
			% ?PRINT("act_reset ResetTime:~p~n", [utime:unixtime_to_localtime(ResetTime)]),
			% ?PRINT("act_reset BuyEndTime:~p~n", [utime:unixtime_to_localtime(BuyEndTime)]),
			% ?PRINT("act_reset Args:~p~n", [{GradeId, GradeCount, SelfCount, SelfTotalCount, StageRewards}]),
			{ok, Bin} = pt_512:write(51208, [Type, SubType, StartTime, EndTime, BuyEndTime, ResetTime, GradeId, GradeCount, 
				SelfCount, SelfTotalCount, StageRewards]),
			lib_server_send:send_to_all(Bin);
		_ ->
			skip
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% check
check_act_open(Type, SubType) ->
	NowTime = utime:unixtime(),
	case data_kf_cloud_buy:get_act_cfg(Type, SubType) of 
		#base_cld_buy_act{start_time = StartTime, end_time = EndTime} when NowTime >= StartTime andalso NowTime < EndTime ->
			check_open_in_local(Type, SubType);
		_ ->
			false
	end.

check_open_in_local(Type, SubType) ->
	case data_kf_cloud_buy:get_act_cfg(Type, SubType) of 
		#base_cld_buy_act{op_days = OpenDays, merge_days = MergeDays} ->
			OpenDay = util:get_open_day(),
			MergeDay = util:get_merge_day(),
			InOpenDay = ?IF(OpenDays == [], true, length([1 ||{Min, Max} <- OpenDays, OpenDay>=Min, OpenDay=<Max]) > 0),
			InMergeDay = ?IF(MergeDays == [], true, length([1 ||{Min, Max} <- MergeDays, MergeDay>=Min, MergeDay=<Max]) > 0),
			InOpenDay andalso InMergeDay;
		_ ->
			false
	end.

check_is_in_restriction_time(NowTime) ->
	%% 当前时间是否是下午两点之前
	RestrictionTime = utime:unixdate(NowTime) + 14*?ONE_HOUR_SECONDS,
	NowTime < RestrictionTime.

check_grade_cost(MoneyArgs, GradeId, Times) ->
	case get_grade_cost(GradeId) of 
		{ok, CostSingle} ->
			CostList = [{GType, GTypeId, GNum*Times} ||{GType, GTypeId, GNum} <- CostSingle],
			[Gold, BGold] = MoneyArgs,
            {GoldNeed, BGoldNeed} = split_cost(CostList),
            if
                Gold < GoldNeed -> {false, ?GOLD_NOT_ENOUGH};
                BGold < BGoldNeed andalso (BGold+Gold-GoldNeed < BGoldNeed) -> {false, ?BGOLD_NOT_ENOUGH};
                true -> {ok, CostList}
            end;
		Res ->
			Res
	end.

split_cost(CostList) ->
    F = fun({GType, _, Num}, {GoldNeed, BGoldNeed}) ->
        case GType of 
            ?TYPE_GOLD -> {GoldNeed+Num, BGoldNeed};
            ?TYPE_BGOLD -> {GoldNeed, BGoldNeed+Num}
        end
    end,
    lists:foldl(F, {0, 0}, CostList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% data
pack_open_act_list() ->
	NowTime = utime:unixtime(),
    OpenList = lib_kf_cloud_buy:get_openning_cloud_act(NowTime),
    F = fun({Type, SubType, StartTime, EndTime}, Acc) ->
    	case lib_kf_cloud_buy:check_open_in_local(Type, SubType) of 
    		true ->
    			{BuyEndTime, ResetTime} = lib_kf_cloud_buy:get_reset_and_buy_endtime(Type, SubType, StartTime, EndTime, NowTime),
    			[{Type, SubType, StartTime, EndTime, BuyEndTime, ResetTime}|Acc];
    		_ ->
    			Acc
    	end
    end,
    SendList = lists:foldl(F, [], OpenList),
    SendList.

%% return:[{type,subtype,starttime,endtime}]
get_openning_cloud_act() ->
	NowTime = utime:unixtime(),
	get_openning_cloud_act(NowTime).

get_openning_cloud_act(NowTime) ->
	ActList = data_kf_cloud_buy:get_act_list(),
	F = fun({Type, SubType}, Acc) ->
		case data_kf_cloud_buy:get_act_cfg(Type, SubType) of 
			#base_cld_buy_act{start_time = StartTime, end_time = EndTime} ->
				case NowTime >= StartTime andalso NowTime < EndTime of 
					true ->
						[{Type, SubType, StartTime, EndTime}|Acc];
					_ -> Acc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], ActList).

get_reset_and_buy_endtime(Type, SubType, StartTime, EndTime, NowTime) ->
	case data_kf_cloud_buy:get_act_cfg(Type, SubType) of 
		#base_cld_buy_act{reset_type = ResetType, buy_endtime = BuyEndTimeCfg} ->
			StartUnixDate = utime:unixdate(StartTime),
			case BuyEndTimeCfg of 
				[{Hour, Min, Sec}|_] -> ok;
				_ -> Hour = 23, Min = 0, Sec = 0
			end,
			case ResetType of 
				1 -> % 0点
					ResetDeviation = ?ONE_DAY_SECONDS;
				_ -> % 4点
					ResetDeviation = ?ONE_DAY_SECONDS + ?ONE_HOUR_SECONDS * 4
			end,
			BuyEndTimeDeviation = Hour * ?ONE_HOUR_SECONDS + Min * ?ONE_MIN + Sec,
			get_reset_and_buy_endtime_do(StartUnixDate, StartTime, EndTime, NowTime, ResetDeviation, BuyEndTimeDeviation);
		_ ->
			{EndTime, EndTime}
	end.

get_reset_and_buy_endtime_do(StartUnixDate, StartTime, EndTime, NowTime, ResetDeviation, BuyEndTimeDeviation) when StartUnixDate < EndTime ->
	ResetTime = StartUnixDate + ResetDeviation,
	BuyEndTime = StartUnixDate + BuyEndTimeDeviation,
	if
		StartTime >= BuyEndTime andalso StartTime < ResetTime -> %% 活动开启时间介于购买结束和重置时间之间，计算下一次的购买结束时间和重置时间
			get_reset_and_buy_endtime_do(StartUnixDate+?ONE_DAY_SECONDS, StartTime, EndTime, NowTime, ResetDeviation, BuyEndTimeDeviation);
	 	NowTime < BuyEndTime -> {min(BuyEndTime, EndTime), min(ResetTime, EndTime)};
		BuyEndTime =< NowTime andalso NowTime < ResetTime -> {min(BuyEndTime, EndTime), min(ResetTime, EndTime)};
		true -> 
			get_reset_and_buy_endtime_do(StartUnixDate+?ONE_DAY_SECONDS, StartTime, EndTime, NowTime, ResetDeviation, BuyEndTimeDeviation)
	end;
get_reset_and_buy_endtime_do(_StartUnixDate, _StartTime, EndTime, _NowTime, _ResetDeviation, _BuyEndTimeDeviation) ->
	{EndTime, EndTime}.


get_cld_buy_reset_type(Type, SubType) ->
	case data_kf_cloud_buy:get_act_cfg(Type, SubType) of 
		#base_cld_buy_act{reset_type = ResetType} ->
			ResetType;
		_ ->
			1
	end.

get_big_reward_list(Type, SubType, AvgWlv) ->
	case data_kf_cloud_buy:get_act_cfg(Type, SubType) of 
		#base_cld_buy_act{big_rewards = BigRewardsCfg} ->
			Var = [{Wlv, List} ||{Wlv, List} <- BigRewardsCfg, AvgWlv >= Wlv],
			case lists:reverse(lists:keysort(1, Var)) of 
				[{_, BigRewardIdList}|_] -> BigRewardIdList;
				_ -> [0]
			end;
		_ ->
			[0]
	end.

get_grade_max_count(GradeId) ->
	case data_kf_cloud_buy:get_act_grade_cfg(GradeId) of 
		#base_cld_buy_big_reward{all_count = AllCount} ->
			AllCount;
		_ ->
			0
	end.

get_grade_cost(GradeId) ->
	case data_kf_cloud_buy:get_act_grade_cfg(GradeId) of 
		#base_cld_buy_big_reward{costs = CostList} ->
			{ok, CostList};
		_ ->
			{false, ?MISSING_CONFIG}
	end.

get_grade_big_reward(GradeId) ->
	case data_kf_cloud_buy:get_act_grade_cfg(GradeId) of 
		#base_cld_buy_big_reward{rewards = Rewards} ->
			Rewards;
		_ ->
			[]
	end.

get_grade_reward(GradeId, SelfCount, Times) ->
	case data_kf_cloud_buy:get_act_grade_cfg(GradeId) of 
		#base_cld_buy_big_reward{pool_id = PoolId} ->
			get_grade_reward(PoolId, SelfCount, 1, Times, []);
		_ ->
			[]
	end.

get_grade_reward(_PoolId, _CurrentCount, Acc, Times, Return) when Acc > Times ->
	Return;
get_grade_reward(PoolId, CurrentCount, Acc, Times, Return) ->
	PoolList = data_kf_cloud_buy:get_reward_pool_list(PoolId),
	Var = CurrentCount+Acc,
	F = fun({RewardId, StartCount, EndCount, Weight, WeightExtra, Rewards}, List) ->
		case Var >= StartCount andalso Var =< EndCount of 
			true -> [{RewardId, Weight+WeightExtra, Rewards}|List];
			_ -> [{RewardId, Weight, Rewards}|List]
		end
	end,
	WeightList = lists:foldl(F, [], PoolList),
	{RewardId, _, Rewards} = util:find_ratio(WeightList, 2),
	get_grade_reward(PoolId, CurrentCount, Acc+1, Times, [{RewardId, Rewards}|Return]).

get_stage_reward_list(Type, StageCount, Wlv) ->
	WlvList = data_kf_cloud_buy:get_stage_count_wlv_list(Type, StageCount),
    StageWlv = get_stage_wlv(WlvList, Wlv),
    data_kf_cloud_buy:get_stage_reward_list(Type, StageCount, StageWlv).

get_stage_wlv([], _Wlv) -> 0;
get_stage_wlv([StageWlv|L], Wlv) ->
    case Wlv >= StageWlv of 
        true -> StageWlv;
        _ -> get_stage_wlv(L, Wlv)
    end.
	
make(cld_buy_role, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, BigRewardsCount, TotalCount, StageRewards]) ->
	#cld_buy_role{
		role_id = RoleId
		, type = Type
		, subtype = SubType
		, zone_id = ZoneId
		, name = Name 
		, server_id = ServerId
		, server_num = ServerNum
		, big_rewards_count = BigRewardsCount
		, total_count = TotalCount
		, stage_rewards = StageRewards
	};
make(cld_zone, [ZoneId, Type, SubType, Wlv, Loop, BigRewards]) ->
	#cld_zone{
		zone_id = ZoneId
		, type = Type
		, subtype = SubType
		, wlv = Wlv
		, loop = Loop
		, big_rewards = BigRewards
	};
make(big_rewards_record, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, GradeId, Count, Time]) ->
	#big_rewards_record{
		role_id = RoleId
		, type = Type
		, subtype = SubType
		, zone_id = ZoneId
		, name = Name
		, server_id = ServerId
		, server_num = ServerNum
		, grade_id = GradeId
		, count = Count
		, time = Time
	};
make(tv_record, [RoleId, Type, SubType, ZoneId, Name, ServerId, ServerNum, Rewards, Time]) ->
	#tv_record{
		role_id = RoleId, 
		type = Type, 
		subtype = SubType, 
		zone_id = ZoneId, 
		name = Name, 
		server_id = ServerId, 
		server_num = ServerNum, 
		rewards = Rewards, 
		time = Time
	}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% db
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #cld_buy_act{}
db_replace_cloud_buy_act([]) -> ok;
db_replace_cloud_buy_act(CloudBuyActList) ->
	DbList = [
		[Type, SubType, StartTime, EndTime] || #cld_buy_act{type = Type, subtype = SubType, start_time = StartTime, end_time = EndTime} <- CloudBuyActList
	],
	Sql = usql:replace(kf_cloud_buy_act, [type, subtype, start_time, end_time], DbList),
	db:execute(Sql).

db_select_cloud_buy_act() ->
	db:get_all(io_lib:format(<<"select type, subtype, start_time, end_time from kf_cloud_buy_act">>, [])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #cld_zone{}
db_replace_cld_zone_list([]) -> ok;
db_replace_cld_zone_list(CldZoneList) ->
	DbList = [
		[ZoneId, Type, SubType, Wlv, Loop, util:term_to_bitstring(BigRewards)] || #cld_zone{zone_id = ZoneId, type = Type, subtype = SubType, wlv = Wlv, loop = Loop, big_rewards = BigRewards} <- CldZoneList
	],
	Sql = usql:replace(cld_buy_zone, [zone_id, type, subtype, wlv, act_loop, big_rewards], DbList),
	db:execute(Sql).

db_replace_cld_zone(CldZone) ->
	#cld_zone{
		zone_id = ZoneId
		, type = Type
		, subtype = SubType
		, wlv = Wlv
		, loop = Loop
		, big_rewards = BigRewards
	} = CldZone,
	db:execute(io_lib:format(<<"replace into cld_buy_zone set zone_id=~p, type=~p, subtype=~p, wlv=~p, act_loop=~p, big_rewards='~s'">>, 
		[ZoneId, Type, SubType, Wlv, Loop, util:term_to_bitstring(BigRewards)])).

db_update_cld_zone_big_rewards(ZoneId, Type, SubType, BigRewards) ->
	db:execute(io_lib:format(<<"update cld_buy_zone set big_rewards='~s' where zone_id=~p and type=~p and subtype=~p ">>, [util:term_to_bitstring(BigRewards), ZoneId, Type, SubType])).

db_update_cld_zone_loop(ZoneId, Type, SubType, NextLoop) ->
	db:execute(io_lib:format(<<"update cld_buy_zone set act_loop=~p where zone_id=~p and type=~p and subtype=~p ">>, [NextLoop, ZoneId, Type, SubType])).

db_update_cld_zone_big_rewards_and_loop(ZoneId, Type, SubType, BigRewards, Loop) ->
	db:execute(io_lib:format(<<"update cld_buy_zone set big_rewards='~s', act_loop=~p where zone_id=~p and type=~p and subtype=~p ">>, [util:term_to_bitstring(BigRewards), Loop, ZoneId, Type, SubType])).

db_select_cld_zone() ->
	db:get_all(io_lib:format(<<"select zone_id, type, subtype, wlv, act_loop, big_rewards from cld_buy_zone">>, [])).

db_clear_cld_zone(Type, SubType) ->
	db:execute(io_lib:format(<<"delete from cld_buy_zone where type=~p and subtype=~p">>, [Type, SubType])).
	
db_clear_cld_zone(_Type, _SubType, []) -> ok;
db_clear_cld_zone(Type, SubType, DelZoneIds) ->
	DelZoneIdStr = ulists:list_to_string(DelZoneIds, ","),
	db:execute(io_lib:format(<<"delete from cld_buy_zone where type=~p and subtype=~p and zone_id in (~s)">>, [Type, SubType, DelZoneIdStr])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 大奖记录 #big_rewards_record{}
db_relace_big_reward_record(BigRewardRecord) ->
	#big_rewards_record{
		role_id = RoleId
		, type = Type
		, subtype = SubType
		, zone_id = ZoneId
		, name = Name
		, server_id = ServerId
		, server_num = ServerNum
		, grade_id = GradeId
		, count = Count
		, time = Time
	} = BigRewardRecord,
	db:execute(io_lib:format(
		<<"replace into big_reward_record set role_id=~p, type=~p, subtype=~p, zone_id=~p, name='~s', server_id=~p, server_num=~p, grade_id=~p, count=~p, time=~p">>, 
		[RoleId, Type, SubType, ZoneId, util:fix_sql_str(Name), ServerId, ServerNum, GradeId, Count, Time])).

db_select_big_reward_record() ->
	db:get_all(io_lib:format(<<"select role_id, type, subtype, zone_id, name, server_id, server_num, grade_id, count, time from big_reward_record">>, [])).

db_clear_big_reward_record(Type, SubType) ->
	db:execute(io_lib:format(<<"delete from big_reward_record where type=~p and subtype=~p">>, [Type, SubType])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #cld_buy_role{}
db_replace_cld_buy_role(CldBuyRole) ->
	#cld_buy_role{
		role_id = RoleId
		, type = Type
		, subtype = SubType
		, zone_id = ZoneId
		, name = Name 
		, server_id = ServerId
		, server_num = ServerNum
		, big_rewards_count = BigRewardsCount
		, total_count = TotalCount
		, stage_rewards = StageRewards
	} = CldBuyRole,
	db:execute(io_lib:format(
		<<"replace into cld_buy_role set role_id=~p, type=~p, subtype=~p, zone_id=~p, name='~s', server_id=~p, server_num=~p, big_rewards_count='~s', total_count=~p, stage_rewards='~s' ">>, 
		[RoleId, Type, SubType, ZoneId, util:fix_sql_str(Name), ServerId, ServerNum, util:term_to_bitstring(BigRewardsCount), TotalCount, util:term_to_bitstring(StageRewards)])).

db_update_cld_buy_role_big_rewards(RoleId, Type, SubType, BigRewardsCount, TotalCount) ->
	db:execute(io_lib:format(<<"update cld_buy_role set big_rewards_count='~s', total_count=~p where role_id=~p and type=~p and subtype=~p ">>, [util:term_to_bitstring(BigRewardsCount), TotalCount, RoleId, Type, SubType])).

db_update_cld_buy_role_stage_rewards(RoleId, Type, SubType, StageRewards) ->
	db:execute(io_lib:format(<<"update cld_buy_role set stage_rewards='~s' where role_id=~p and type=~p and subtype=~p ">>, [util:term_to_bitstring(StageRewards), RoleId, Type, SubType])).

db_update_cld_buy_role_big_rewards_batch(Type, SubType, UpRoleIdList, BigRewardsCount) ->
	case UpRoleIdList == [] of 
		true -> ok;
		_ ->
			IdStr = ulists:list_to_string(UpRoleIdList, ","),
			db:execute(io_lib:format(<<"update cld_buy_role set big_rewards_count='~s' where role_id in (~s) and type=~p and subtype=~p ">>, [util:term_to_bitstring(BigRewardsCount), IdStr, Type, SubType]))
	end.

db_select_cld_buy_role() ->
	db:get_all(io_lib:format(<<"select role_id, type, subtype, zone_id, name, server_id, server_num, big_rewards_count, total_count, stage_rewards from cld_buy_role">>, [])).

db_clear_cld_buy_role(Type, SubType) ->
	db:execute(io_lib:format(<<"delete from cld_buy_role where type=~p and subtype=~p">>, [Type, SubType])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #tv_record{}
db_replace_cld_buy_tv_record([]) -> ok;
db_replace_cld_buy_tv_record(TvRecordList) ->
	DbList = [
		[RoleId, Type, SubType, ZoneId, util:fix_sql_str(Name), ServerId, ServerNum, util:term_to_bitstring(Rewards), Time] 
		|| #tv_record{role_id=RoleId, type=Type, subtype=SubType, zone_id=ZoneId, name=Name, server_id=ServerId, server_num=ServerNum, rewards=Rewards, time=Time} <- TvRecordList
	],
	Sql = usql:replace(cld_buy_tv_record, [role_id, type, subtype, zone_id, name, server_id, server_num, rewards, time], DbList),
	db:execute(Sql).

db_select_cld_buy_tv_record(Type, SubType) ->
	db:get_all(io_lib:format(<<"select role_id, zone_id, name, server_id, server_num, rewards, time from cld_buy_tv_record where type=~p and subtype=~p">>, [Type, SubType])).

db_clear_cld_buy_tv_record(Type, SubType) ->
	db:execute(io_lib:format(<<"delete from cld_buy_tv_record where type=~p and subtype=~p">>, [Type, SubType])).

db_clear_cld_buy_tv_record(Type, SubType, ExpireTime) ->
	db:execute(io_lib:format(<<"delete from cld_buy_tv_record where type=~p and subtype=~p and time<=~p">>, [Type, SubType, ExpireTime])).

db_truncate_tv_records() ->
	db:execute(io_lib:format(<<"truncate table cld_buy_tv_record ">>, [])).