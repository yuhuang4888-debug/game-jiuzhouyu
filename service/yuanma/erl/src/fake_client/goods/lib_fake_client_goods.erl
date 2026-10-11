%% ---------------------------------------------------------------------------
%% @doc lib_fake_client_goods.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 
%% ---------------------------------------------------------------------------
-module(lib_fake_client_goods).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("guild.hrl").
-include("figure.hrl").
-include("fake_client.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("activity_onhook.hrl").
-include("def_fun.hrl").
-compile(export_all).

-define(split_onhook_goods(RewardList), 
	lists:partition(fun(Item) ->
		case Item of 
			{Type, _, _} when Type == ?TYPE_GOODS orelse Type == ?TYPE_GOLD orelse Type == ?TYPE_BGOLD orelse Type == ?TYPE_BIND_GOODS -> true;
			{Type, _, _, _} when Type == ?TYPE_GOODS orelse Type == ?TYPE_ATTR_GOODS -> true;
			_ -> false
		end
	end, RewardList)
	).

spilt_reward_when_onhook(PS, Produce) ->
	#player_status{fake_client = #fake_client{in_module = ModuleId}} = PS,
	#produce{type = Type, reward = RewardList} = Produce,
	{RewardsOnhook, LeftRewardList} = split_with_module(ModuleId, Type, RewardList),
	case RewardsOnhook == [] of 
		true -> {PS, Produce};
		_ ->
			PS1 = send_reward(PS, Produce#produce{reward = RewardsOnhook}),
			{PS1, Produce#produce{reward = LeftRewardList}}
	end.

record_cost_when_onhook(PS, CostList, Type) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{in_module = ModuleId, cost_info = {Gold, BGold, Coin}} = FakeClient,
	{AddGold, AddBGold, AddCoin} = split_cost_with_module(ModuleId, Type, CostList),
	NewFakeClient = FakeClient#fake_client{cost_info = {Gold + AddGold, BGold + AddBGold, Coin + AddCoin}},
	PS#player_status{fake_client = NewFakeClient}.

record_exp_when_onhook(PS, AddExp) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{add_exp = Exp} = FakeClient,
	NewFakeClient = FakeClient#fake_client{add_exp = Exp + AddExp},
	PS#player_status{fake_client = NewFakeClient}.

send_reward(PS, Produce) ->
	#player_status{fake_client = FakeClient} = PS,
	#fake_client{module_rewards = ModuleRewards} = FakeClient,
	#produce{reward = RewardList} = Produce,
	NewModuleRewards = RewardList ++ ModuleRewards,
	NewFakeClient = FakeClient#fake_client{module_rewards = NewModuleRewards},
	%?MYLOG("lxl_goods", "send_reward NewModuleRewards: ~p~n", [NewModuleRewards]),
	PS#player_status{fake_client = NewFakeClient}.



close_fake_client(PS, _Msg) ->
	if
	 	_Msg == enter_fail -> PS;
		true ->
			%% 活动期间获得的道具发邮件
			#player_status{id = Id, fake_client = FakeClient} = PS,
			#fake_client{
				in_module = ModuleId, in_sub_module = SubMod, module_rewards = ModuleRewards,
				add_exp = AddExp, cost_info = {CostGold, CostBGold, CostCoin}, begin_hook_coin = BeginCoin
			} = FakeClient,
			%?MYLOG("lxl_goods", "close_fake_client ModuleRewards: ~p~n", [ModuleRewards]),
			EndCoin = mod_daily:get_count(Id, ?MOD_ACT_ONHOOK, ?MOD_ACT_ONHOOK_COIN_DAILY_CONSUME),
			CostHookCoin = max(0, EndCoin - BeginCoin),
			#base_activity_onhook_module{cost_min = CostMin} = data_activity_onhook:get_module(ModuleId, SubMod),
			HookMin = CostHookCoin div CostMin,
			case get_reward_mail_title(ModuleId, SubMod, [HookMin, CostHookCoin, CostGold, CostBGold, CostCoin]) of
				false -> PS;
				{Title, Content} ->
					Reward = ?IF(AddExp == 0, ModuleRewards, [{?TYPE_EXP, 0, AddExp}|ModuleRewards]),
					lib_mail_api:send_sys_mail([Id], Title, Content, lib_goods_api:make_reward_unique(Reward)),
					PS#player_status{fake_client = FakeClient#fake_client{module_rewards = []}}
			end
	end.

get_reward_mail_title(?MOD_NINE, _, Args) ->
	{utext:get(1920001), utext:get(1920005, Args)};
get_reward_mail_title(?MOD_MIDDAY_PARTY, _, Args) ->
	{utext:get(1920001), utext:get(1920006, Args)};
get_reward_mail_title(?MOD_DRUMWAR, _, Args) ->
	{utext:get(1920001), utext:get(1920007, Args)};
get_reward_mail_title(?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY, Args) ->
	{utext:get(1920001), utext:get(1920008, Args)};
get_reward_mail_title(?MOD_TOPPK, _, Args) ->
	{utext:get(1920001), utext:get(1920009, Args)};
get_reward_mail_title(?MOD_TERRITORY, _, Args) ->
	{utext:get(1920001), utext:get(1920010, Args)};
get_reward_mail_title(?MOD_HOLY_SPIRIT_BATTLEFIELD, _, Args) ->
	{utext:get(1920001), utext:get(1920011, Args)};
get_reward_mail_title(?MOD_TERRITORY_WAR, _, Args) ->
	{utext:get(1920001), utext:get(1920012, Args)};
get_reward_mail_title(_, _, _) ->
	false.


%%% 只过滤道具和金钱，其他的正常发放
split_with_module(?MOD_NINE, ProduceType, RewardList) ->
	case ProduceType == role_nine of 	
		true ->
			?split_onhook_goods(RewardList);
		_ -> {[], RewardList}
	end;
split_with_module(?MOD_MIDDAY_PARTY, ProduceType, RewardList) ->
	case ProduceType == midday_party of 	
		true ->
			?split_onhook_goods(RewardList);
		_ -> {[], RewardList}
	end;
split_with_module(?MOD_DRUMWAR, ProduceType, RewardList) -> 
	case ProduceType == drumwar_sign orelse ProduceType == drumwar_live orelse ProduceType == drumwar of 	
		true ->
			?split_onhook_goods(RewardList);
		_ -> {[], RewardList}
	end;
split_with_module(?MOD_GUILD_ACT, ProduceType, RewardList) ->
	case ProduceType == guild_feast_fire orelse ProduceType == guild_feast_boss orelse ProduceType == guild_feast orelse ProduceType == gboss of 	
		true ->
			?split_onhook_goods(RewardList);
		_ -> {[], RewardList}
	end;
split_with_module(_, _, RewardList) ->
	{[], RewardList}.


split_cost_with_module(Module, ProduceType, CostList) ->
	split_cost_with_module(Module, ProduceType, CostList, 0, 0, 0).

split_cost_with_module(?MOD_GUILD_ACT, guild_act_buy_food, CostList, Gold, BGold, Coin) ->
	do_split_cost_with_module(CostList, Gold, BGold, Coin);
split_cost_with_module(?MOD_TOPPK, top_pk_buy_cost, CostList, Gold, BGold, Coin) ->
	do_split_cost_with_module(CostList, Gold, BGold, Coin);
split_cost_with_module(_, _, _CostList, Gold, BGold, Coin) ->
	{Gold, BGold, Coin}.

do_split_cost_with_module([{_, ?GOODS_ID_GOLD, AddGold}|T], Gold, BGold, Coin) ->
	do_split_cost_with_module(T, AddGold + Gold, BGold, Coin);
do_split_cost_with_module([{?TYPE_GOLD, _, AddGold}|T], Gold, BGold, Coin) ->
	do_split_cost_with_module(T, AddGold + Gold, BGold, Coin);
do_split_cost_with_module([{_, ?GOODS_ID_BGOLD, AddBGold}|T], Gold, BGold, Coin) ->
	do_split_cost_with_module(T, Gold, AddBGold + BGold, Coin);
do_split_cost_with_module([{?TYPE_BGOLD, _, AddGold}|T], Gold, BGold, Coin) ->
	do_split_cost_with_module(T, Gold, AddGold + BGold, Coin);
do_split_cost_with_module([{_, ?GOODS_ID_COIN, AddCoin}|T], Gold, BGold, Coin) ->
	do_split_cost_with_module(T, Gold, BGold, AddCoin + Coin);
do_split_cost_with_module([{?TYPE_COIN, _, AddCoin}|T], Gold, BGold, Coin) ->
	do_split_cost_with_module(T, Gold, BGold, AddCoin + Coin);
do_split_cost_with_module([_|T], Gold, BGold, Coin) ->
	do_split_cost_with_module(T, Gold, BGold, Coin);
do_split_cost_with_module(_, Gold, BGold, Coin) ->
	{Gold, BGold, Coin}.
