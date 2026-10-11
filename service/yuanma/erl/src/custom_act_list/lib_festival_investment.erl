%% ---------------------------------------------------------------------------
%% @doc lib_festival_investment.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_festival_investment).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("custom_act_list.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("def_module.hrl").

handle_event(PS, #event_callback{type_id = ?EVENT_LOGIN_CAST}) ->
    NewPS = load_data(PS),
    {ok, NewPS};
handle_event(PS, _) ->
    {ok, PS}.

refresh_midnight() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [load_data(E#ets_online.id)|| E <- OnlineRoles].

login(PS) ->
	#player_status{id = RoleId} = PS,
    Sql = usql:select(fest_investment_info, [type, subtype, lv, buy_time, get_time, day_utime, login_days, rewards], [{role_id, RoleId}]),
    FestInvestmentList = init_data(db:get_all(Sql), []),
    NewPS = PS#player_status{fest_investment = FestInvestmentList},
    NewPS1 = update_login_days(NewPS),
    ?PRINT("login## :~p~n", [NewPS1#player_status.fest_investment]),
    NewPS1.

load_data(RoleId) when is_integer(RoleId) ->
	lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?MODULE, load_data, []); 
load_data(PS) -> 
    NewPS = update_login_days(PS),
    NewPS.

init_data([], Return) -> Return;
init_data([[Type, SubType, Lv, BuyTime, GetTime, DayUTime, LoginDays, Rewardstr]|DBList], Return) ->
	FestInvestment = #fest_investment{
		key = {Type, SubType, Lv},
		type = Type, subtype = SubType, lv = Lv,
		buy_time = BuyTime, get_time = GetTime, days_utime = DayUTime, login_days = LoginDays,
		rewards = util:bitstring_to_term(Rewardstr)
	},
	init_data(DBList, [FestInvestment|Return]).

update_login_days(PS) ->
    #player_status{id = RoleId, fest_investment = FestInvestmentList} = PS,
    NowDate = utime:unixdate(),
    F = fun(Item = #fest_investment{type = Type, subtype = SubType, days_utime = DaysUtime, login_days = LoginDays}, Acc) ->
        case NowDate == utime:unixdate(DaysUtime) orelse lv_reward_finish(Item) of
            true -> [Item|Acc];
            false ->
				case lib_custom_act_api:is_open_act(Type, SubType) of
					true ->
						NewItem = Item#fest_investment{days_utime = NowDate, login_days = LoginDays+1},
						update_login_days(RoleId, NewItem),
						[NewItem|Acc];
					_ ->
						[Item|Acc]
				end
        end
    end,
    NewFestInvestmentList = lists:foldl(F, [], FestInvestmentList),
    PS#player_status{fest_investment = NewFestInvestmentList}.

%% 查看购买了的投资列表
send_festival_investment_list(PS, ActInfo) ->
	#player_status{id = _RoleId, sid = Sid, fest_investment = FestInvestmentList} = PS,
	#act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
	%SendList = gen_fest_investment_send_list(FestInvestmentList),
	TypeFestInvestmentList = get_type_fest_investment(Type, SubType, STime, ETime, FestInvestmentList),
	IsAllGet = length([1 ||Item <- TypeFestInvestmentList, lv_reward_finish(Item) == true]) == length(TypeFestInvestmentList),
	case IsAllGet of
		true -> SendList = [];
		_ ->
			SendList = [Lv || #fest_investment{lv = Lv} <- TypeFestInvestmentList]
	end,
	%?PRINT("investment_list## :~p~n", [SendList]),
	#custom_act_cfg{start_time = StartTime, condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
	{_, BuyDay} = ulists:keyfind(buy_day, 1, Condition, {buy_day, 3}),
	BuyEndTime = BuyDay * 86400 +  StartTime,
	lib_server_send:send_to_sid(Sid, pt_332, 33211, [Type, SubType, SendList, BuyEndTime]).

%% 查看奖励状态
send_reward_status(PS, ActInfo) ->
	#act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
	#player_status{id = _RoleId, sid = Sid, fest_investment = FestInvestmentList} = PS,
	TypeFestInvestmentList = get_type_fest_investment(Type, SubType, STime, ETime, FestInvestmentList),
	IsBuyExpire = is_buy_expire(Type, SubType, STime),
	if
		TypeFestInvestmentList == [] andalso IsBuyExpire ->	%% 没购买过并且已经过了购买期
			skip;
		true -> %% 购买过
			SendList = get_reward_status(PS, Type, SubType, TypeFestInvestmentList),
			%?PRINT("reward_status## :~p~n", [[{Grade,Status,Condition} ||{Grade, _, Status, _, _, _, Condition, _} <- SendList]]),
			{ok, BinData} = pt_331:write(33104, [Type, SubType, SendList]),
    		lib_server_send:send_to_sid(Sid, BinData)
	end.

%% 购买投资
buy(PS, ActInfo, Lv) ->
	#player_status{id = RoleId, sid = _Sid, fest_investment = FestInvestmentList} = PS,
	#act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
	IsBuyExpire = is_buy_expire(Type, SubType, STime),
	CustomActCfg = lib_custom_act_util:get_act_cfg_info(Type, SubType),
	if
	 	IsBuyExpire -> {false, ?ERRCODE(err332_invest_buy_expire)};
		is_record(CustomActCfg, custom_act_cfg) == false -> {false, ?MISSING_CONFIG}; 
		true ->
			case lists:keyfind({Type, SubType, Lv}, #fest_investment.key, FestInvestmentList) of 
				#fest_investment{buy_time = BuyTime} when BuyTime>=STime andalso BuyTime<ETime -> 
					{false, ?ERRCODE(err332_invest_is_buy)};
				_ ->
					#custom_act_cfg{condition = Condition} = CustomActCfg,
					{_, InvestCostList} = ulists:keyfind(invest_cost, 1, Condition, {invest_cost, []}),
					case lists:keyfind(Lv, 1, InvestCostList) of 
						{_, RealCostList, _} ->
							case lib_goods_api:cost_object_list_with_check(PS, RealCostList, fest_investment, ulists:concat([SubType, "-", Lv])) of
        						{true, CostPS} ->
        							lib_log_api:log_custom_act_cost(RoleId, Type, SubType, RealCostList, [Lv]),
        							NewFestinvestment = #fest_investment{
        								key = {Type, SubType, Lv}, type = Type, subtype = SubType, lv = Lv,
        								buy_time = utime:unixtime(), days_utime = utime:unixdate(), login_days = 1
        							},
        							save_fest_investment(RoleId, NewFestinvestment),
        							NewFestInvestmentList = lists:keystore({Type, SubType, Lv}, #fest_investment.key, FestInvestmentList, NewFestinvestment),
        							HandleArgs = get_handle_buy_fest_args(PS, ActInfo, CustomActCfg, Lv),
        							NewPS = handle_buy_fest_investment(CostPS#player_status{fest_investment = NewFestInvestmentList}, ActInfo, Lv, HandleArgs),
        							{_, BuyReward} = ulists:keyfind(buy_reward, 1, HandleArgs, {buy_reward, []}),
        							send_buy_tv(PS, ActInfo, Lv),
        							?PRINT("buy## :~p~n", [NewFestInvestmentList]),
        							{ok, NewPS, 1, BuyReward};
        						{false, Res, _} ->
        							{false, Res}
        				    end;
						_ -> 
							{false, ?MISSING_CONFIG}
					end
			end
	end.

get_handle_buy_fest_args(PS, ActInfo, _CustomActCfg, Lv) ->
	RewardList = get_buy_reward(PS, ActInfo, Lv),
	[{buy_reward, RewardList}].

handle_buy_fest_investment(PS, _ActInfo, _Lv, []) -> PS;
handle_buy_fest_investment(PS, ActInfo, Lv, [{buy_reward, RewardList}|HandleArgs]) ->
	#act_info{key = {Type, SubType}} = ActInfo,
	%% 发放购买奖励
	lib_log_api:log_custom_act_reward(PS#player_status.id, Type, SubType, Lv, RewardList),
    {ok, NewPS} = lib_goods_api:send_reward_with_mail(PS, #produce{type = fest_investment, reward = RewardList, remark = ulists:concat([SubType, "-", Lv])}),
    handle_buy_fest_investment(NewPS, ActInfo, Lv, HandleArgs).

get_buy_reward(PS, ActInfo, Lv) ->
	#act_info{key = {Type, SubType}} = ActInfo,
	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(RewardId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
			#custom_act_reward_cfg{
                condition = Condition
            } = RewardCfg ->
            	case lib_custom_act_check:check_act_condtion([buy_reward, investment_lv], Condition) of
        			[1, Lv] -> 
        				RewardList = lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg),
        				RewardList ++ Acc;
        			_ -> Acc
            	end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], RewardIdAll).

%% 领取奖励
receive_reward(PS, ActInfo, GradeId) ->
	#player_status{id = RoleId, sid = _Sid, fest_investment = FestInvestmentList} = PS,
	#act_info{key = {Type, SubType}} = ActInfo,
	case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of 
		#custom_act_reward_cfg{
            condition = Condition
        } = RewardCfg ->
        	case lib_custom_act_check:check_act_condtion([investment_lv, login_days], Condition) of
        		[Lv, LoginDaysCon] ->
        			case lists:keyfind({Type, SubType, Lv}, #fest_investment.key, FestInvestmentList) of 
        				#fest_investment{login_days = LoginDays, rewards = OldRewards} = FestInvestment ->
        					case lists:member(GradeId, OldRewards) of 
        						false ->
		        					case check_receive(PS, [{login_days, LoginDays, LoginDaysCon}]) of 
		        						true ->
		        							RewardList = lib_custom_act_util:count_act_reward(PS, ActInfo, RewardCfg),
		        							NewFestinvestment = FestInvestment#fest_investment{get_time = utime:unixtime(), rewards = [GradeId|lists:delete(GradeId, OldRewards)]},
		        							NewFestInvestmentList = lists:keystore({Type, SubType, Lv}, #fest_investment.key, FestInvestmentList, NewFestinvestment),
		        							lib_log_api:log_custom_act_reward(RoleId, Type, SubType, GradeId, RewardList),
		        							update_invest_rewards_get(RoleId, NewFestinvestment),
		        							PS1 = PS#player_status{fest_investment = NewFestInvestmentList},
		        							{ok, NewPS} = lib_goods_api:send_reward_with_mail(PS1, #produce{type = fest_investment, reward = RewardList, remark = ulists:concat([SubType, "-", GradeId])}),
		    								?PRINT("receive_reward## RewardList:~p~n", [RewardList]),
		    								?PRINT("receive_reward## NewFestInvestmentList:~p~n", [NewFestInvestmentList]),
		    								{true, NewPS, RewardList, RewardCfg};
		        						Res ->
		        							Res
		        					end;
		        				_ ->
		        					{false, ?ERRCODE(err332_invest_not_buy)}
		        			end;
        				_ ->
        					?PRINT("receive_reward## :~p~n", [?ERRCODE(err332_invest_not_buy)]),
        					{false, ?ERRCODE(err332_invest_not_buy)}
        			end;
        		_ ->
        			{false, ?MISSING_CONFIG}
        	end;
        _ ->
        	{false, ?MISSING_CONFIG}
	end.

check_receive(_PS, []) -> true;
check_receive(PS, [{login_days, LoginDays, LoginDaysCon}|L]) ->
	case LoginDays >= LoginDaysCon of 
		true ->
			check_receive(PS, L);
		_ ->
			{false, ?ERRCODE(err332_invest_login_days)}
	end.

%% 获取投资列表信息
% gen_fest_investment_send_list(FestInvestmentList) ->
% 	gen_fest_investment_send_list(FestInvestmentList, #{}).

% gen_fest_investment_send_list([], Return) ->
% 	F = fun(Key, TypeFestInvestmentList, List) ->
% 		case is_display_expire(Key, TypeFestInvestmentList) of 
% 			true -> List;
% 			_ ->
% 				gen_fest_investment_send_list_do(Key, TypeFestInvestmentList, List)
% 		end
% 	end,
% 	maps:fold(F, [], Return);
% gen_fest_investment_send_list([FestInvestment|FestInvestmentList], Return) ->
% 	#fest_investment{
% 		type = Type, subtype = SubType
% 	} = FestInvestment,
% 	OldList = maps:get({Type, SubType}, Return, []),
% 	gen_fest_investment_send_list(FestInvestmentList, maps:put({Type, SubType}, [FestInvestment|OldList], Return)).

% gen_fest_investment_send_list_do({Type, SubType}, TypeFestInvestmentList, Return) ->
% 	#custom_act_cfg{condition = Condition} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
% 	ConditionStr = util:term_to_string(Condition),
% 	F = fun(FestInvestment, List) ->
% 		#fest_investment{
% 			lv = Lv, buy_time = BuyTime, get_time = GetTime, login_days = LoginDays, rewards = Rewards
% 		} = FestInvestment,
% 		[{Lv, BuyTime, GetTime, LoginDays, Rewards}|List]
% 	end,
% 	List = lists:foldl(F, [], TypeFestInvestmentList),
% 	[{Type, SubType, ConditionStr, List}|Return].

is_all_get({Type, SubType}, TypeFestInvestmentList) ->
	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	RewardsGet = [Rewards ||#fest_investment{rewards = Rewards} <- TypeFestInvestmentList],
	length(RewardIdAll -- lists:flatten(RewardsGet)) == 0.

lv_reward_finish(FestInvestment) ->
	#fest_investment{
		type = Type, subtype = SubType, lv = Lv, rewards = Rewards
	} = FestInvestment,
	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(RewardId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
			#custom_act_reward_cfg{condition = Condition} ->
				case lib_custom_act_check:check_act_condtion([investment_lv, login_days], Condition) of
        			[Lv, _LoginDaysCon] ->
		            	[RewardId|Acc];
		            _ ->
		            	Acc
		        end;
			_ ->
				Acc
		end
	end,
	LvRewardIdList = lists:foldl(F, [], RewardIdAll),
	length(LvRewardIdList -- Rewards) == 0.

is_display_expire(Key, TypeFestInvestmentList) ->
	case is_all_get(Key, TypeFestInvestmentList) of 
		false -> false;
		_ ->
			LastGetTime = lists:max([GetTime ||#fest_investment{get_time = GetTime} <- TypeFestInvestmentList]),
			utime:is_same_day(LastGetTime) == false
	end.

get_type_fest_investment(Type, SubType, STime, ETime, FestInvestmentList) ->
	get_type_fest_investment(Type, SubType, STime, ETime, FestInvestmentList, []).

get_type_fest_investment(_Type, _SubType, _STime, _ETime, [], Return) -> Return;
get_type_fest_investment(Type, SubType, STime, ETime, [FestInvestment|FestInvestmentList], Return) ->
	#fest_investment{type = Type1, subtype = SubType1, buy_time = BuyTime} = FestInvestment,
	case Type == Type1 andalso SubType1 == SubType andalso BuyTime >= STime andalso BuyTime < ETime of 
		true ->
			get_type_fest_investment(Type, SubType, STime, ETime, FestInvestmentList, [FestInvestment|Return]);
		_ -> 
			get_type_fest_investment(Type, SubType, STime, ETime, FestInvestmentList, Return)
	end.

%% 是否已过购买期
is_buy_expire(Type, SubType, _STime) ->
	#custom_act_cfg{condition = Condition, start_time = StartTime} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
	{_, BuyDay} = ulists:keyfind(buy_day, 1, Condition, {buy_day, 3}),
	utime:diff_days(StartTime) >= BuyDay.

%% 获取奖励状态
get_reward_status(PS, Type, SubType, TypeFestInvestmentList) ->
	#player_status{original_attr = OriginAttr} = PS,
	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(RewardId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
			#custom_act_reward_cfg{
				name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
            	%% 计算奖励的领取状态
                case count_reward_status(TypeFestInvestmentList, RewardCfg) of 
                	{false, _} -> Acc;
                	{Status, ReceiveTimes} ->
						ConditionStr =
							case lists:keyfind(fight, 1, Condition) of
								{fight, AttrS} ->
									Prower = lib_player:calc_expact_power(OriginAttr, 0, AttrS),
									Condition2 = lists:keystore(fight, 1, Condition, {fight, Prower}),
									util:term_to_string(Condition2);
								_ ->
									util:term_to_string(Condition)
							end,

		                RewardStr = util:term_to_string(Reward),
		                [{RewardId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc]
		        end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], RewardIdAll).

%% 计算奖励状态
count_reward_status(TypeFestInvestmentList, RewardCfg) ->
	#custom_act_reward_cfg{
		type = Type, subtype = SubType,
		grade = RewardId, condition = Condition
    } = RewardCfg,
    case lib_custom_act_check:check_act_condtion([investment_lv], Condition) of
        [InvestmentLv] ->
            case lists:keyfind({Type, SubType, InvestmentLv}, #fest_investment.key, TypeFestInvestmentList) of 
            	#fest_investment{login_days = LoginDays, rewards = RewardsGet} ->
            		case lists:keyfind(login_days, 1, Condition) of 
						{login_days, LoginDaysCon} ->
		            		case lists:member(RewardId, RewardsGet) of 
		            			true -> {2, 1};
		            			_ when LoginDays >= LoginDaysCon -> {1, 0};
		            			_ -> {0, 0}
		            		end;
		            	_ ->
		            		case lists:keyfind(buy_reward, 1, Condition) of 
		            			{_, 1} ->
		            				{2, 1};
		            			_ ->
		            				{0, 0}
		            		end
		            end;
            	_ ->
            		{0, 0}
            end;
        _ -> 
        	{false, ?ERRCODE(err_config)}
    end.

%% 传闻
send_buy_tv(PS, ActInfo, Lv) ->
	#player_status{id = RoleId, figure = #figure{name = RoleName}} = PS,
	#act_info{key = {Type, SubType}} = ActInfo,
	#custom_act_cfg{name = ActName} = lib_custom_act_util:get_act_cfg_info(Type, SubType),
	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(RewardId, {RewardName, Acc}) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
			#custom_act_reward_cfg{
				name = Name,
				condition = Condition
            } ->
            	case lists:keyfind(investment_lv, 1, Condition) of 
            		{_, Lv} ->
		            	case lists:keyfind(buy_reward, 1, Condition) of 
		            		{_, 1} -> NewRewardName = Name;
		            		_ -> NewRewardName = RewardName
		            	end,
		            	case lists:keyfind(login_days, 1, Condition) of 
		            		{_, LoginDaysCon} -> NewAcc = [LoginDaysCon|Acc];
		            		_ -> NewAcc = Acc
		            	end,
		            	{NewRewardName, NewAcc};
		            _ ->
		            	{RewardName, Acc}
		        end;
			_ ->
				{RewardName, Acc}
		end
	end,
	{RewardName, LoginDaysList} = lists:foldl(F, {"", [0]}, RewardIdAll),
	MaxLoginDays = lists:max(LoginDaysList),
	lib_chat:send_TV({all}, ?MOD_AC_CUSTOM, 35, [RoleName, RoleId, util:make_sure_binary(ActName), util:make_sure_binary(RewardName), MaxLoginDays, Type, SubType]).

%% 活动结束，清理，发奖励
act_clear(Type, SubType, STime, ETime, ActWlv) ->
	Sql = io_lib:format("select role_id, lv, buy_time, get_time, day_utime, login_days, rewards from fest_investment_info where type=~p and subtype=~p", [Type, SubType]),
	case db:get_all(Sql) of 
		[] -> ok;
		List ->
			%% 先分组
			F = fun([RoleId, Lv, BuyTime, GetTime, DayUTime, LoginDays, RewardStr], Map) ->
				case BuyTime >= STime andalso BuyTime < ETime of 
					true ->
						Festinvestment = #fest_investment{
							key = {Type,SubType,Lv}, type = Type, subtype = SubType, lv = Lv, buy_time = BuyTime, 
							get_time = GetTime, days_utime = DayUTime, login_days = LoginDays, rewards = util:bitstring_to_term(RewardStr)
						},
						L = maps:get(RoleId, Map, []),
						maps:put(RoleId, [Festinvestment|L], Map);
					_ ->
						Map
				end
			end,
			GroupMap = lists:foldl(F, #{}, List),
			%?PRINT("act_clear## GroupMap:~p~n", [GroupMap]),
			%% 计算每个玩家还没领取的奖励
			F1 = fun(RoleId, TypeFestInvestmentList, RoleList) ->
				IsAllGet = length([1 ||Item <- TypeFestInvestmentList, lv_reward_finish(Item) == true]) == length(TypeFestInvestmentList),
				case IsAllGet of 
					true -> RoleList;
					_ ->
						RewardIdList = find_not_get_reward(Type, SubType, TypeFestInvestmentList),
						case RewardIdList == [] of 
							true -> RoleList;
							_ ->
								RewardLvList = group_by_lv(Type, SubType, RewardIdList),
								[{RoleId, RewardLvList}|RoleList]
						end
				end 
			end,
			RoleList = maps:fold(F1, [], GroupMap),
			%% 发放奖励
			F2 = fun({RoleId, RewardLvList}, Acc) ->
				Acc rem 30 == 0 andalso timer:sleep(1000),
				case lib_player:get_alive_pid(RoleId) of 
					false ->
						TypeFestInvestmentList = maps:get(RoleId, GroupMap, []),
						send_reward_with_clear(RoleId, Type, SubType, ActWlv, TypeFestInvestmentList, RewardLvList, auto);
					Pid ->
						lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, act_clear_in_ps, [Type, SubType, STime, ETime, ActWlv, RewardLvList, auto])
				end,
				Acc + 1
			end,
			lists:foldl(F2, 1, RoleList)
	end.

find_not_get_reward(Type, SubType, TypeFestInvestmentList) ->
	RewardIdAll = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	RewardIdGot = lists:flatten([Item#fest_investment.rewards || Item <- TypeFestInvestmentList]),
	F = fun(RewardId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
			#custom_act_reward_cfg{condition = Condition} ->
            	case lib_custom_act_check:check_act_condtion([investment_lv], Condition) of
			        [InvestmentLv] ->
			        	case lists:keymember({Type, SubType, InvestmentLv}, #fest_investment.key, TypeFestInvestmentList) == true
			        		andalso lists:member(RewardId, RewardIdGot) == false
			            of 
			            	true ->
								 case lists:keyfind(login_days, 1, Condition) of
									 {login_days, CheckLoginDay} ->
										 #fest_investment{login_days = LoginDays} = lists:keyfind({Type, SubType, InvestmentLv}, #fest_investment.key, TypeFestInvestmentList),
										 case LoginDays >= CheckLoginDay of
											 true ->
												 [RewardId|Acc];
											 _ -> Acc
										 end;
									 _ -> Acc
								 end;
			            	_ ->
			            		Acc
			            end;
			        _ -> 
			        	Acc
			    end;
			_ -> Acc
		end
	end,
	RewardIdList = lists:foldl(F, [], RewardIdAll),
	RewardIdList.

group_by_lv(Type, SubType, RewardIdList) ->
	F = fun(RewardId, Acc) ->
		case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
			#custom_act_reward_cfg{condition = Condition} ->
            	case lists:keyfind(investment_lv, 1, Condition) of 
            		{_, Lv} ->
            			{_, OL} = ulists:keyfind(Lv, 1, Acc, {Lv, []}),
            			lists:keystore(Lv, 1, Acc, {Lv, [RewardId|OL]});
            		_ -> Acc
            	end;
			_ -> Acc
		end
	end,
	lists:foldl(F, [], RewardIdList).

act_clear_in_ps(PS, Type, SubType, STime, ETime, WLv, RewardLvList, ClearType) ->
	#player_status{fest_investment = FestInvestmentList} = PS,
	TypeFestInvestmentList = get_type_fest_investment(Type, SubType, STime, ETime, FestInvestmentList),
	NewTypeFestInvestmentList = send_reward_with_clear(PS, Type, SubType, WLv, TypeFestInvestmentList, RewardLvList, ClearType),
	F = fun(Festinvestment, List) ->
		[Festinvestment|lists:keydelete(Festinvestment#fest_investment.key, #fest_investment.key, List)]
	end,
	NewFestInvestmentList = lists:foldl(F, FestInvestmentList, NewTypeFestInvestmentList),
	NewPS = PS#player_status{fest_investment = NewFestInvestmentList},
	%% 活动手动结束后，推一次33211
	case ClearType == manual of 
		true ->
			send_festival_investment_list(NewPS, #act_info{key = {Type, SubType}, stime = STime, etime = ETime});
		_ ->
			skip
	end,
	{ok, NewPS}.

send_reward_with_clear(RoleId, Type, SubType, WLv, TypeFestInvestmentList, RewardLvList, ClearType) when is_integer(RoleId) ->
	#figure{lv = RoleLv, career = Career, sex = Sex} = lib_role:get_role_figure(RoleId),
	RewardParam = lib_custom_act:make_rwparam(RoleLv, Sex, WLv, Career),
	send_reward_with_clear_do(RoleId, RewardParam, Type, SubType, TypeFestInvestmentList, RewardLvList, ClearType);
send_reward_with_clear(PS, Type, SubType, WLv, TypeFestInvestmentList, RewardLvList, ClearType) ->
	#player_status{id = RoleId, figure = #figure{lv = RoleLv, career = Career, sex = Sex}} = PS,
	RewardParam = lib_custom_act:make_rwparam(RoleLv, Sex, WLv, Career),
	NewTypeFestInvestmentList = send_reward_with_clear_do(RoleId, RewardParam, Type, SubType, TypeFestInvestmentList, RewardLvList, ClearType),
	NewTypeFestInvestmentList.

send_reward_with_clear_do(RoleId, RewardParam, Type, SubType, TypeFestInvestmentList, RewardLvList, auto) ->
	NowTime = utime:unixtime(),
	F = fun({Lv, RewardIdList}, List) ->
		case lists:keyfind({Type, SubType, Lv}, #fest_investment.key, List) of 
			#fest_investment{rewards = Rewards} = Festinvestment ->
				SendRewardIdList = [RewardId ||RewardId <- RewardIdList, lists:member(RewardId, Rewards) == false],
				NewRewards = SendRewardIdList ++ Rewards,
				NewFestinvestment = Festinvestment#fest_investment{get_time = NowTime, rewards = NewRewards},
				update_invest_rewards_get(RoleId, NewFestinvestment),
				FI = fun(RewardId, Acc) ->
					case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
						#custom_act_reward_cfg{} = RewardCfg ->
	        				RewardList = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
	        				[{RewardId, RewardList}|Acc];
						_ ->
							Acc
					end
				end,
				RewardInfoList = lists:foldl(FI, [], SendRewardIdList),
				case RewardInfoList of 
					[] -> ok;
					_ ->
						[lib_log_api:log_custom_act_reward(RoleId, Type, SubType, RewardId, RewardListone) ||{RewardId, RewardListone} <- RewardInfoList],
						RewardList = lists:flatten([RewardListone ||{_RewardId, RewardListone} <- RewardInfoList]),
						Title = utext:get(3310056),
						Content = utext:get(3310057),
						lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList)
				end,
				lists:keystore({Type, SubType, Lv}, #fest_investment.key, List, NewFestinvestment);
			_ -> List
		end
	end,
	lists:foldl(F, TypeFestInvestmentList, RewardLvList);
send_reward_with_clear_do(RoleId, RewardParam, Type, SubType, TypeFestInvestmentList, RewardLvList, manual) ->
	NowTime = utime:unixtime(),
	F = fun({Lv, RewardIdList}, List) ->
		case lists:keyfind({Type, SubType, Lv}, #fest_investment.key, List) of 
			#fest_investment{rewards = Rewards} = Festinvestment ->
				SendRewardIdList = [RewardId ||RewardId <- RewardIdList, lists:member(RewardId, Rewards) == false],
				NewRewards = SendRewardIdList ++ Rewards,
				NewFestinvestment = Festinvestment#fest_investment{buy_time = 0, get_time = NowTime, rewards = NewRewards},
				save_fest_investment(RoleId, NewFestinvestment),
				FI = fun(RewardId, Acc) ->
					case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of 
						#custom_act_reward_cfg{} = RewardCfg ->
	        				RewardList = lib_custom_act_util:count_act_reward(RewardParam, RewardCfg),
	        				[{RewardId, RewardList}|Acc];
						_ ->
							Acc
					end
				end,
				RewardInfoList = lists:foldl(FI, [], SendRewardIdList),
				case RewardInfoList of 
					[] -> ok;
					_ ->
						[lib_log_api:log_custom_act_reward(RoleId, Type, SubType, RewardId, RewardListone) ||{RewardId, RewardListone} <- RewardInfoList],
						RewardList = lists:flatten([RewardListone ||{_RewardId, RewardListone} <- RewardInfoList]),
						Title = utext:get(3310067),
						Content = utext:get(3310068),
						lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList)
				end,
				lists:keystore({Type, SubType, Lv}, #fest_investment.key, List, NewFestinvestment);
			_ -> List
		end
	end,
	lists:foldl(F, TypeFestInvestmentList, RewardLvList).

act_clear_manual(Type, SubType) ->
	NowTime = utime:unixtime(),
	case lib_custom_act_util:get_custom_act_open_info(Type, SubType) of
        #act_info{wlv = ActWlv, stime = STime, etime = ETime} when NowTime < ETime ->
        	spawn(fun() -> act_clear_manual_do(Type, SubType, STime, ETime, ActWlv) end),
        	ok;
        _ ->
        	skip
    end.

act_clear_manual(Type, SubType, OldStartTime, OldEndTime) ->
	ActWlv = util:get_world_lv(),
	spawn(fun() -> act_clear_manual_do(Type, SubType, OldStartTime, OldEndTime, ActWlv) end),
	ok.

act_clear_manual_do(Type, SubType, STime, ETime, ActWlv) ->
	Sql = io_lib:format("select role_id, lv, buy_time, get_time, day_utime, login_days, rewards from fest_investment_info where type=~p and subtype=~p", [Type, SubType]),
	case db:get_all(Sql) of 
		[] -> ok;
		List ->
			%% 先分组
			F = fun([RoleId, Lv, BuyTime, GetTime, DayUTime, LoginDays, RewardStr], Map) ->
				case BuyTime >= STime andalso BuyTime < ETime of 
					true ->
						Festinvestment = #fest_investment{
							key = {Type,SubType,Lv}, type = Type, subtype = SubType, lv = Lv, buy_time = BuyTime, 
							get_time = GetTime, days_utime = DayUTime, login_days = LoginDays, rewards = util:bitstring_to_term(RewardStr)
						},
						L = maps:get(RoleId, Map, []),
						maps:put(RoleId, [Festinvestment|L], Map);
					_ ->
						Map
				end
			end,
			GroupMap = lists:foldl(F, #{}, List),
			?PRINT("act_clear_manual## GroupMap:~p~n", [GroupMap]),
			%% 计算每个玩家还没领取的奖励
			F1 = fun(RoleId, TypeFestInvestmentList, RoleList) ->
				IsAllGet = length([1 ||Item <- TypeFestInvestmentList, lv_reward_finish(Item) == true]) == length(TypeFestInvestmentList),
				case IsAllGet of 
					true -> RoleList;
					_ -> %% 没领取的全部发放
						RewardIdList = find_not_get_reward(Type, SubType, TypeFestInvestmentList),
						case RewardIdList == [] of 
							true -> RoleList;
							_ ->
								RewardLvList = group_by_lv(Type, SubType, RewardIdList),
								[{RoleId, RewardLvList}|RoleList]
						end
				end 
			end,
			RoleList = maps:fold(F1, [], GroupMap),
			?PRINT("act_clear_manual## RoleList:~p~n", [RoleList]),
			%% 发放奖励
			F2 = fun({RoleId, RewardLvList}, Acc) ->
				Acc rem 30 == 0 andalso timer:sleep(1000),
				case lib_player:get_alive_pid(RoleId) of 
					false ->
						TypeFestInvestmentList = maps:get(RoleId, GroupMap, []),
						send_reward_with_clear(RoleId, Type, SubType, ActWlv, TypeFestInvestmentList, RewardLvList, manual);
					Pid ->
						lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, act_clear_in_ps, [Type, SubType, STime, ETime, ActWlv, RewardLvList, manual])
				end,
				Acc + 1
			end,
			lists:foldl(F2, 1, RoleList)
	end,
	ok.



%%============================= db
save_fest_investment(RoleId, Festinvestment) ->
	#fest_investment{
		type = Type, subtype = SubType, lv = Lv, buy_time = BuyTime, get_time = GetTime, days_utime = DayUTime, login_days = LoginDays,
		rewards = RewardsGet
	} = Festinvestment,
	Sql = usql:replace(fest_investment_info, [role_id, type, subtype, lv, buy_time, get_time, day_utime, login_days, rewards], 
		[[RoleId, Type, SubType, Lv, BuyTime, GetTime, DayUTime, LoginDays, util:term_to_string(RewardsGet)]]),
    db:execute(Sql).

update_login_days(RoleId, #fest_investment{type = Type, subtype = SubType, lv = Lv, days_utime = DaysUtime, login_days = LoginDays}) ->
    SQL = usql:update(fest_investment_info, [{day_utime, DaysUtime}, {login_days, LoginDays}], [{role_id, RoleId}, {type, Type}, {subtype, SubType}, {lv, Lv}]),
    db:execute(SQL).

update_invest_rewards_get(RoleId, Festinvestment) ->
	#fest_investment{
		type = Type, subtype = SubType, lv = Lv, get_time = GetTime, 
		rewards = RewardsGet
	} = Festinvestment,
	SQL = usql:update(fest_investment_info, [{get_time, GetTime}, {rewards, util:term_to_string(RewardsGet)}], [{role_id, RoleId}, {type, Type}, {subtype, SubType}, {lv, Lv}]),
    db:execute(SQL).

%% gm
gm_delete_investment(PS, Type, SubType, Lv) ->
	#player_status{id = RoleId, fest_investment = FestInvestmentList} = PS,
	NewFestInvestmentList = lists:keydelete({Type, SubType, Lv}, #fest_investment.key, FestInvestmentList),
	db:execute(io_lib:format("delete from fest_investment_info where role_id=~p and type=~p and subtype=~p and lv=~p", [RoleId, Type, SubType, Lv])),
	PS#player_status{fest_investment = NewFestInvestmentList}.
