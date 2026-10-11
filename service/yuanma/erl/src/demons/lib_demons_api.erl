%%%--------------------------------------
%%% @Module  : lib_demons_api
%%% @Author  : lxl
%%% @Created : 2020-8-4
%%% @Description:  使魔
%%%--------------------------------------

-module (lib_demons_api).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("dungeon.hrl").
-include("def_fun.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("demons.hrl").
-include("predefine.hrl").
-include("def_module_buff.hrl").
-include("race_act.hrl").
-include("boss.hrl").
-include("def_module.hrl").
-compile(export_all).

%% 副本通关
handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_SUCCESS, data = Data}) ->
    #callback_dungeon_succ{dun_type = DunType, count = _Count} = Data,
    if
     	DunType == ?DUNGEON_TYPE_VIP_PER_BOSS ->
    		{_, NewPS} = boss_be_kill(PS, ?BOSS_TYPE_VIP_PERSONAL, 0),
    		{ok, NewPS};
    	true ->
    		{ok, PS}
    end;
% %% 副本失败
% handle_event(PS, #event_callback{type_id = ?EVENT_DUNGEON_FAIL, data = Data}) ->
%     #callback_dungeon_fail{dun_type = DunType, count = Count} = Data,
%     if
%      	DunType == ?DUNGEON_TYPE_EXP_SINGLE ->
%     		{NewPS, _} = upgrade_demons_skill_process(PS, exp_dungeon, Count),
%     		{ok, NewPS};
%     	DunType == ?DUNGEON_TYPE_EQUIP ->
%     		{NewPS, _} = upgrade_demons_skill_process(PS, equip_dungeon, Count),
%     		{ok, NewPS};
%     	true ->
%     		{ok, PS}
%     end;
% %% 参与托管
% handle_event(PS, #event_callback{type_id = ?EVENT_FAKE_CLIENT}) ->
%     {NewPS, _} = upgrade_demons_skill_process(PS, activity_onhook, 1),
%     {ok, NewPS};

handle_event(PS, #event_callback{type_id = ?EVENT_RECHARGE, data = #callback_recharge_data{gold = Gold, recharge_product = Product}}) ->
	RealGold = lib_recharge_api:special_recharge_gold(Product, Gold),
    {NewPS, _} = upgrade_demons_skill_process(PS, recharge, RealGold),
    {ok, NewPS};
handle_event(PS, #event_callback{type_id = ?EVENT_MONEY_CONSUME, data = Data})  ->
    #callback_money_cost{consume_type = ConsumeType, money_type = MoneyType, cost = Cost} = Data,
    case lib_consume_data:is_consume_for_act(ConsumeType) == true andalso MoneyType =:= ?GOLD of
        true ->
            {NewPS, _} = upgrade_demons_skill_process(PS, consume, Cost),
            {ok, NewPS};
        _ -> {ok, PS}
    end;
handle_event(PS, _) ->
    {ok, PS}.

%% 参加九天争霸
% join_nine(RoleId) when is_integer(RoleId) ->
% 	case lib_player:get_alive_pid(RoleId) of
% 		false -> ok;
% 		Pid ->
% 			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, join_nine, [])
% 	end;
% join_nine(PS) ->
% 	{NewPS, _} = upgrade_demons_skill_process(PS, nine_war, 1),
% 	{ok, NewPS}.

%% 符文寻宝
% rune_hunt(PS, AddVal) ->
% 	{NewPS, _} = upgrade_demons_skill_process(PS, rune_hunt, AddVal),
% 	NewPS.
% %% 装备寻宝
% treasure_hunt(PS, AddVal) ->
% 	{NewPS, _} = upgrade_demons_skill_process(PS, treasure_hunt, AddVal),
% 	NewPS.

%% 祈愿
% pray(PS) ->
% 	{NewPS, _} = upgrade_demons_skill_process(PS, pray, 1),
% 	NewPS.

%% 出航
% sea_treasure(PS) ->
% 	{NewPS, _} = upgrade_demons_skill_process(PS, sea_treasure, 1),
% 	NewPS.

%% 装备吞噬
% equip_fusion(PS, GoodsList) ->
% 	AddNum = lists:sum([Num ||{_, Num} <- GoodsList]),
% 	{NewPS, _} = upgrade_demons_skill_process(PS, equip_fusion, AddNum),
% 	NewPS.

%% 装备洗练
% equip_wash(PS) ->
% 	{NewPS, _} = upgrade_demons_skill_process(PS, equip_wash, 1),
% 	NewPS.

%% 合成
% equip_compose(PS) ->
% 	{NewPS, _} = upgrade_demons_skill_process(PS, equip_compose, 1),
% 	NewPS.

%% 击杀boss
boss_be_kill(RoleId, BossType, _BossId) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of
		false -> ok;
		Pid ->
			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, boss_be_kill, [BossType, _BossId])
	end;
boss_be_kill(PS, BossType, _BossId)	->
	{NewPS, _} = upgrade_demons_skill_process(PS, kill_boss, {BossType, 1}),
	{ok, NewPS}.

%% 活跃度达到150
add_liveness(RoleId, OldLive, NewLive) when is_integer(RoleId) ->
	case find_life_skill_belong(liveness, {{OldLive, NewLive}, 1}) of
		{0, 0} -> skip;
		_ ->
			case lib_player:get_alive_pid(RoleId) of
				false -> %% 处理离线情况
					upgrade_demons_skill_process_off(RoleId, liveness, {{OldLive, NewLive}, 1});
				Pid ->
					lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, add_liveness, [OldLive, NewLive])
			end
	end;
add_liveness(PS, OldLive, NewLive) ->
	{NewPS, _} = upgrade_demons_skill_process(PS, liveness, {{OldLive, NewLive}, 1}),
	{ok, NewPS}.

%% 参与竞榜, lib_race_act_mod:rank_reward
race_act_end(RoleId, Type, SubType, Score, Rank, _RewardList) when is_integer(RoleId)  ->
	case lib_player:get_alive_pid(RoleId) of
		false -> %% 处理离线情况
			case upgrade_demons_skill_process_off(RoleId, race_act, {{0, Score}, 1}) of
				is_active -> %% 竞榜额外奖励
					#base_race_act_info{name = ActName} = data_race_act:get_act_info(Type, SubType),
					{_, SkillId} = find_life_skill_belong(race_act, {{0, Score}, 1}),
					#base_demons_skill_upgrade{usage = Usage} = data_demons:get_demons_skill_upgrade_cfg(SkillId, 1),
					case lists:keyfind(buff, 1, Usage) of
						{_, ?RACE_ACT_REWARD_BUFF, RankReward} -> ok;
						_ -> RankReward = []
					end,
					F = fun({rank, Rank1, Rank2, Num}) ->
							case Rank >= Rank1 andalso Rank =< Rank2 of
								true ->
									Title = utext:get(3380003),
									Content = utext:get(3380004, [ActName]),
									RewardList = [{T, TGId, Num} ||{T, TGId, _} <- _RewardList],
									lib_mail_api:send_sys_mail([RoleId], Title, Content, RewardList);
								_ -> ok
							end;
						(_) -> ok
					end,
					lists:foreach(F, RankReward);
				_ -> ok
			end;
		Pid ->
			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, race_act_end, [Type, SubType, Score, Rank, _RewardList])
	end;
race_act_end(PS, Type, SubType, Score, Rank, _RewardList) ->
	{NewPS, IsActive} = upgrade_demons_skill_process(PS, race_act, {{0, Score}, 1}),
	case IsActive of
		is_active -> %% 竞榜额外奖励
			#base_race_act_info{name = ActName} = data_race_act:get_act_info(Type, SubType),
			{_, SkillId} = find_life_skill_belong(race_act, {{0, Score}, 1}),
			#base_demons_skill_upgrade{usage = Usage} = data_demons:get_demons_skill_upgrade_cfg(SkillId, 1),
			case lists:keyfind(buff, 1, Usage) of
				{_, ?RACE_ACT_REWARD_BUFF, RankReward} -> ok;
				_ -> RankReward = []
			end,
			F = fun({rank, Rank1, Rank2, Num}) ->
					case Rank >= Rank1 andalso Rank =< Rank2 of
						true ->
							Title = utext:get(3380003),
							Content = utext:get(3380004, [ActName]),
							RewardList = [{T, TGId, Num} ||{T, TGId, _} <- _RewardList],
							lib_mail_api:send_sys_mail([PS#player_status.id], Title, Content, RewardList);
						_ -> ok
					end;
				(_) -> ok
			end,
			lists:foreach(F, RankReward);
		_ -> ok
	end,
	{ok, NewPS}.

%% 参与活动, lib_activitycalen:role_success_end_activity
role_success_end_activity(PS, Module, ModuleSub, Count, _Times) ->
	ModuleList = [
		?MOD_NINE, ?MOD_DRUMWAR, ?MOD_HOLY_SPIRIT_BATTLEFIELD, ?MOD_KF_SANCTUM, ?MOD_TOPPK,
		?MOD_MIDDAY_PARTY, ?MOD_TERRITORY_WAR, ?MOD_KF_1VN, ?MOD_KF_3V3, ?MOD_BEINGS_GATE,
        ?MOD_NIGHT_GHOST
	],
	ModuleList2 = [
		{?MOD_GUILD_ACT, ?MOD_GUILD_ACT_PARTY}
	],
	Times = mod_daily:get_count(PS#player_status.id, ?MOD_DEMONS, 1, Module * 1000 + ModuleSub),  %%
	%?PRINT("role_success_end_activity : ~p~n", [{Module, Times}]),
	case Times == 0 andalso (lists:member(Module, ModuleList) orelse lists:member({Module, ModuleSub}, ModuleList2) ) of
		true ->
			{NewPS, IsActive} = upgrade_demons_skill_process(PS, activity, Count),
			case IsActive of
				is_active -> ok;
				_ ->
					mod_daily:plus_count_offline(PS#player_status.id, ?MOD_DEMONS, 1, Module * 1000 + ModuleSub, Count)  %%完成次数
			end,
			NewPS;
		_ ->
			PS
	end.

%% 领取每日首冲奖励30块那档, lib_recharge_cumulation:receive_reward
daily_charge_reward(PS, GradeId) ->
	{NewPS, _} = upgrade_demons_skill_process(PS, daily_charge_reward, {GradeId, 1}),
	NewPS.

%% 装备评分: 装备穿戴时更新
dress_equip(PS) ->
	EquipRating = lib_equip_api:get_all_equip_rating(PS),
	{NewPS, _} = upgrade_demons_skill_process(PS, equip_rating, EquipRating),
	NewPS.

%% 龙纹等级
dragon_up_lv(PS) ->
	DragonLevel = lib_dragon_equip:get_dragon_lv(PS),
	{NewPS, _} = upgrade_demons_skill_process(PS, dragon_level, DragonLevel),
	NewPS.

%% 降神星数
god_up_star(PS) ->
	GodStar = lib_god:get_god_all_star(PS),
	{NewPS, _} = upgrade_demons_skill_process(PS, god_star, GodStar),
	NewPS.

%% 神庭装备
god_court_equip(PS) ->
	EquipList = lib_god_court:get_equip_by_color(PS, ?RED),
	{NewPS, _} = upgrade_demons_skill_process(PS, god_court, length(EquipList)),
	NewPS.

constellation_forge_lv(PS) ->
	List = data_constellation_equip:get_all_constellation(),
	LvList = [lib_constellation_forge_api:get_constellation_item_strength_lv(PS#player_status.constellation, Type)||Type<- List],
	Lv = lists:sum(LvList),
	{NewPS, _} = upgrade_demons_skill_process(PS, constellation_forge_lv, Lv),
	NewPS.

%% 在线处理
upgrade_demons_skill_process(PS, TriggerKey, TriggerVal) ->
	upgrade_demons_skill_process(PS, TriggerKey, TriggerVal, []).
upgrade_demons_skill_process(PS, TriggerKey, TriggerVal, CheckList) ->
	{DemonsId, SkillId} = find_life_skill_belong(TriggerKey, TriggerVal),
	case check_trigger(DemonsId, SkillId, CheckList) of
		true ->
			lib_demons:upgrade_demons_skill_process(PS, DemonsId, SkillId, TriggerVal);
		_ -> skip
	end.

%% 离线处理
upgrade_demons_skill_process_off(RoleId, TriggerKey, TriggerVal) ->
	upgrade_demons_skill_process_off(RoleId, TriggerKey, TriggerVal, []).
upgrade_demons_skill_process_off(RoleId, TriggerKey, TriggerVal, CheckList) ->
	case find_life_skill_belong(TriggerKey, TriggerVal) of
		{0, 0} -> skip;
		{DemonsId, SkillId} ->
			case check_trigger(DemonsId, SkillId, CheckList) of
				true ->
					lib_demons:upgrade_demons_skill_process_off(RoleId, DemonsId, SkillId, TriggerKey, TriggerVal);
				_ ->
					skip
			end
	end.

find_life_skill_belong(TriggerKey, TriggerVal) ->
	List = data_demons:get_skill_by_sktype(?DEMONS_SKILL_TYPE_LIFE),
	find_life_skill_belong_do(List, TriggerKey, TriggerVal).

find_life_skill_belong_do([], _TriggerKey, _TriggerVal) -> {0, 0};
find_life_skill_belong_do([{DemonsId, SkillId}|List], TriggerKey, TriggerVal) ->
	#base_demons_skill{usage = Conditions} = data_demons:get_demons_skill_cfg(DemonsId, SkillId),
	{_, Key, ProcessNeed} = ulists:keyfind(process, 1, Conditions, {process, undefined, 0}),
	case lib_demons:is_belong_life_skill(TriggerKey, TriggerVal, Key, ProcessNeed) of
		true -> {DemonsId, SkillId};
		_ ->
			find_life_skill_belong_do(List, TriggerKey, TriggerVal)
	end.

check_trigger(_DemonsId, _SkillId, []) -> true;

check_trigger(DemonsId, SkillId, [_|CheckList]) ->
	check_trigger(DemonsId, SkillId, CheckList).

%% 自动触发生活技能进度条
auto_upgrade_demons_skill_process(RoleId, DemonsId) ->
	List = data_demons:get_skill_by_sktype(?DEMONS_SKILL_TYPE_LIFE),
	case lists:keyfind(DemonsId, 1, List) of
		{DemonsId, SkillId} ->
			#base_demons_skill{usage = Conditions} = data_demons:get_demons_skill_cfg(DemonsId, SkillId),
			case lists:keyfind(process, 1, Conditions) of
				{process, equip_rating, _} ->
					lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_demons_api, dress_equip, []);
				{process, dragon_level, _} ->
					lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_demons_api, dragon_up_lv, []);
				{process, god_star, _} ->
					lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_demons_api, god_up_star, []);
				{process, god_court, _} ->
					lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_demons_api, god_court_equip, []);
				{process, constellation_forge_lv, _} ->
					lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, lib_demons_api, constellation_forge_lv, []);
				_ -> ok
			end;
		_ -> ok
	end.