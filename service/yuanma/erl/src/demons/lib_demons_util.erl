%%%--------------------------------------
%%% @Module  : lib_demons_util
%%% @Author  : lxl
%%% @Created : 2019.6.21
%%% @Description:  使魔
%%%--------------------------------------

-module (lib_demons_util).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("demons.hrl").
-include("predefine.hrl").
-include("skill.hrl").

-compile(export_all). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 初始化 status_demons
new_status_demons(RoleId, Lv) ->
	case db_select_demons_role_msg(RoleId) of 
		[DemonsIdBattle, PaintingListStr] -> PaintingList = util:bitstring_to_term(PaintingListStr);
		_ -> DemonsIdBattle = 0, PaintingList = []
	end,
	case db_select_demons_skill(RoleId) of 
		[] -> DemonsSkillMap = #{};
		DbSkillList ->
			FS = fun([DemonsId, SkillId, Level, Process, IsActive], Map) -> 
				maps:put(DemonsId, [#demons_skill{skill_id=SkillId, level=Level, process=Process, is_active=IsActive}|maps:get(DemonsId, Map, [])], Map)
			end,
			DemonsSkillMap = lists:foldl(FS, #{}, DbSkillList)
	end,
	case db_select_demons_slot(RoleId) of 
		[] -> DemonsSlotMap = #{};
		DbSlotList ->
			FSolt = fun([DemonsId, SkillId, Slot, Level], Map) -> 
				maps:put(DemonsId, [{SkillId, Slot, Level}|maps:get(DemonsId, Map, [])], Map)
			end,
			DemonsSlotMap = lists:foldl(FSolt, #{}, DbSlotList)
	end,
	case db_select_demons_all(RoleId) of 
		[] -> 
			%% 达到开放等级，默认解锁一个使魔
			case Lv >= ?demons_open_lv andalso ?demons_id_free > 0 of 
				true ->
					Demons = lib_demons:active_demons_free(RoleId, ?demons_id_free),
					IsFirstActiveDemons = true,
					DemonsList = [Demons];
				_ ->
					IsFirstActiveDemons = false,
					DemonsList = []
			end;
		DbDemonsList ->
			IsFirstActiveDemons = false,
			F = fun([DemonsId, Level, Exp, Star, SlotNum], Acc) ->
				NewSlotNum = get_slot_unlock_num(SlotNum, Star),
				Demons1 = #demons{demons_id=DemonsId, level=Level, exp=Exp, star = Star, slot_num = NewSlotNum},
				if
					NewSlotNum =/= SlotNum ->
						db_replace_demons(RoleId, Demons1);
					true ->
						skip
				end,
				LearnSkillList = maps:get(DemonsId, DemonsSkillMap, []),
				SlotSkillList = maps:get(DemonsId, DemonsSlotMap, []),
				SlotList = calc_slot_list(SlotSkillList),
				SkillList = refresh_demons_skill(Demons1, LearnSkillList),
				Demons2 = Demons1#demons{skill_list = SkillList, slot_list = SlotList},
				Demons = count_single_demons_attr(Demons2),
				[Demons|Acc]
			end,
			DemonsList = lists:foldl(F, [], DbDemonsList)
	end,	
	Fetters = refresh_fetters(DemonsList),
	DemonsShop = calc_shop_data(RoleId, Lv),
	NewDemonsIdBattle = ?IF(IsFirstActiveDemons == true, ?demons_id_free, DemonsIdBattle),
	StatusDemons = #status_demons{
		demons_id = NewDemonsIdBattle,
		painting_list = PaintingList,
		demons_list = DemonsList,
		demons_shop = DemonsShop,
		fetters_list = Fetters
	},
	case IsFirstActiveDemons of 
		true -> lib_demons_util:db_replace_demons_role_msg(RoleId, StatusDemons);
		_ -> ok
	end,
	StatusDemonsAfSkillStic = static_demons_skill_infos(StatusDemons),
	StatusDemonsAfDemons = count_demons_attr(?ATTR_TYPE_DEMONS, StatusDemonsAfSkillStic),
	StatusDemonsAfFetters = count_demons_attr(?ATTR_TYPE_FETTERS, StatusDemonsAfDemons),
	StatusDemonsAfPainting = count_demons_attr(?ATTR_TYPE_PAINTING, StatusDemonsAfFetters),
	NewStatusDemonsAfSkillAttr = count_demons_attr(?ATTR_TYPE_SKILL, StatusDemonsAfPainting),
	% NewStatusDemonsAfSlotAttr = count_demons_attr(?ATTR_TYPE_SLOT_SKILL, NewStatusDemonsAfSkillAttr),
	NewStatusDemonsAfSkillPower = count_demons_skill_power(NewStatusDemonsAfSkillAttr),
	LastStatusDemons = count_slot_skill_power(NewStatusDemonsAfSkillPower),
	LastStatusDemons.

refresh_fetters(DemonsList) ->
	FettersAll = data_demons:get_all_fetters(),
	refresh_fetters(DemonsList, FettersAll).
refresh_fetters(DemonsList, FettersAll) ->
	refresh_fetters(DemonsList, FettersAll, []).
refresh_fetters(DemonsList, FettersCheckList, ActiveFetters) ->
	F = fun(FettersId, Acc) ->
		#base_demons_fetters{demons_ids = DemonsIds} = data_demons:get_fetters_cfg(FettersId),
		IsActive = length([1 ||DemonsId <- DemonsIds, lists:keymember(DemonsId, #demons.demons_id, DemonsList) == false]) == 0,
		?IF(IsActive, [FettersId|lists:delete(FettersId, Acc)], Acc)
	end,
	NewActiveFetters = lists:foldl(F, ActiveFetters, FettersCheckList),
	NewActiveFetters.

refresh_demons_skill(Demons, LearnSkillList) ->
	#demons{demons_id=DemonsId, star = Star} = Demons,
	DemonsSkillList = data_demons:get_skill_by_demons_id(DemonsId),
	SkillList = [{SkillId, SkType}||{SkillId, StarNeed, SkType} <- DemonsSkillList, Star >= StarNeed],
	F = fun({SkillId, SkType}, List) ->
		case lists:keyfind(SkillId, #demons_skill.skill_id, List) of  
			#demons_skill{} = DemonsSkill ->
				lists:keyreplace(SkillId, #demons_skill.skill_id, List, DemonsSkill#demons_skill{sk_type = SkType});
			_ ->
				IsActive = ?IF(SkType == ?DEMONS_SKILL_TYPE_LIFE, 0, 1),
				DemonsSkill = #demons_skill{skill_id=SkillId, level=1, sk_type=SkType, is_active = IsActive},
				[DemonsSkill|List]
		end
	end,
	NewSkillList = lists:foldl(F, LearnSkillList, SkillList),
	NewSkillList.

need_refresh_demons_skill(DemonsId, OldStar, NewStar) ->
	DemonsSkillList = data_demons:get_skill_by_demons_id(DemonsId),
	OldSkillList = [SkillId||{SkillId, StarNeed, _SkType} <- DemonsSkillList, OldStar >= StarNeed],
	NewSkillList = [SkillId||{SkillId, StarNeed, _SkType} <- DemonsSkillList, NewStar >= StarNeed],
	length(NewSkillList) =/= length(OldSkillList).

calc_slot_list(SlotSkillList) ->
	Fun = fun({SkillId, Slot, Level}, Acc) ->
		case data_demons:get_skill_info(SkillId) of
			#base_demons_skill_add{quality = Quality, sort = Sort} -> 
				SlotSkill = #slot_skill{skill_id = SkillId, slot = Slot, level = Level, quality = Quality, sort = Sort},
				[SlotSkill|Acc];
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, [], SlotSkillList).

calc_shop_data(RoleId, RoleLv) ->
	NowTime = utime:unixtime(),
	case db_select_demons_shop(RoleId) of
		[RefreshTimes, _Goods, Stime] ->
			IsSameDay = utime:is_same_day(Stime, NowTime),
			if
				IsSameDay == true ->
					Goods = util:bitstring_to_term(_Goods),
					DemonsShop = #demons_shop{refresh_times = RefreshTimes, stime = Stime, goods = Goods};
				true ->
					DemonsShop = calc_shop(RoleId, RefreshTimes, NowTime)
			end;
		_ ->
			case RoleLv >= ?demons_open_lv of 
				true ->
					DemonsShop = calc_shop(RoleId, 0, NowTime);
				_ ->
					DemonsShop = undefined
			end
	end,
	DemonsShop.

calc_shop_data(RoleId, _RoleLv, OldDemonsShop) when is_record(OldDemonsShop, demons_shop) ->
	#demons_shop{stime = Stime} = OldDemonsShop,
	NowTime = utime:unixtime(),
	IsSameDay = utime:is_same_day(Stime, NowTime),
	if
		IsSameDay == true ->
			OldDemonsShop;
		true ->
			calc_shop(RoleId, 0, NowTime)
	end;
calc_shop_data(RoleId, _RoleLv, _) ->
	calc_shop(RoleId, 0, utime:unixtime()).
			
calc_shop(RoleId, RefreshTimes, NowTime) ->
	RangeList = data_demons:get_refresh_range(),
	Fun = fun({Min, Max}) ->
		RefreshTimes >= Min andalso RefreshTimes =< Max
	end,
	case ulists:find(Fun, RangeList) of
		{ok, {Ma, Mi}} ->
			WeightList = data_demons:get_all_shop_id(Ma, Mi),
			ShopNum = ?shop_num,
			ShopIdL = urand:list_rand_by_weight(WeightList, ShopNum),
			Fun1 = fun(ShopId, Acc) ->
				[{ShopId, 0}|Acc]
			end,
			Goods = lists:foldl(Fun1, [], ShopIdL);
		_ ->
			Goods = []
	end,
	DemonsShop = #demons_shop{refresh_times = RefreshTimes, stime = NowTime, goods = Goods, is_dirty = 1},
	%db_replace_demons_shop(RoleId, DemonsShop),
	DemonsShop.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算使魔属性
count_demons_attr(?ATTR_TYPE_DEMONS, StatusDemons) ->
	#status_demons{demons_list = DemonsList, attr_list = AttrList} = StatusDemons,
	DemonsAttrList = lib_player_attr:add_attr(list, [Attr ||#demons{attr_list = Attr} <- DemonsList]),
	NewAttrList = lists:keystore(?ATTR_TYPE_DEMONS, 1, AttrList, {?ATTR_TYPE_DEMONS, DemonsAttrList}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusDemons#status_demons{attr_list = NewAttrList, total_attr = TotalAttr};
count_demons_attr(?ATTR_TYPE_FETTERS, StatusDemons) ->
	#status_demons{fetters_list = FettersList, attr_list = AttrList} = StatusDemons,
	FettersAttr = get_demons_type_attr(?ATTR_TYPE_FETTERS, FettersList),
	NewAttrList = lists:keystore(?ATTR_TYPE_FETTERS, 1, AttrList, {?ATTR_TYPE_FETTERS, FettersAttr}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusDemons#status_demons{attr_list = NewAttrList, total_attr = TotalAttr};
count_demons_attr(?ATTR_TYPE_PAINTING, StatusDemons) ->
	#status_demons{painting_list = PaintingList, demons_list = DemonsList, attr_list = AttrList} = StatusDemons,
	PaintingStarList = [Star ||#demons{star = Star} <- DemonsList, Star >= ?painting_star],
	PaintingNum = lists:sum([0|PaintingStarList]),
	PaintingAttr = get_demons_type_attr(?ATTR_TYPE_PAINTING, PaintingList),
	NewAttrList = lists:keystore(?ATTR_TYPE_PAINTING, 1, AttrList, {?ATTR_TYPE_PAINTING, PaintingAttr}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusDemons#status_demons{painting_num = PaintingNum, attr_list = NewAttrList, total_attr = TotalAttr};
count_demons_attr(?ATTR_TYPE_SKILL, StatusDemons) ->
	#status_demons{skill_passive = SkillPassive, attr_list = AttrList} = StatusDemons,
	SkillAttr = get_demons_type_attr(?ATTR_TYPE_SKILL, SkillPassive),
	NewAttrList = lists:keystore(?ATTR_TYPE_SKILL, 1, AttrList, {?ATTR_TYPE_SKILL, SkillAttr}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusDemons#status_demons{attr_list = NewAttrList, total_attr = TotalAttr};
% count_demons_attr(?ATTR_TYPE_SLOT_SKILL, StatusDemons) ->
% 	#status_demons{slot_skill = SlotSkillPassive, attr_list = AttrList} = StatusDemons,
% 	SlotAttr = get_demons_type_attr(?ATTR_TYPE_SLOT_SKILL, SlotSkillPassive),
% 	NewAttrList = lists:keystore(?ATTR_TYPE_SLOT_SKILL, 1, AttrList, {?ATTR_TYPE_SLOT_SKILL, SlotAttr}),
% 	?MYLOG("xlh_attr", "AttrList:~p~n, NewAttrList:~p~n",[AttrList, NewAttrList]),
% 	TotalAttr = statistic_total_attr(NewAttrList),
% 	StatusDemons#status_demons{attr_list = NewAttrList, total_attr = TotalAttr};
count_demons_attr(_, StatusDemons) ->
	StatusDemons.

count_single_demons_attr(Demons) ->
	Attr = get_demons_type_attr(?ATTR_TYPE_DEMONS, Demons),
	SlotSkillAttr = calc_slot_skill_attr(Demons#demons.slot_list),
	LifeSkillAttr = calc_life_skill_attr(Demons),
	TotalAttr = ulists:kv_list_plus_extra([Attr,SlotSkillAttr,LifeSkillAttr]),
	NewDemons = Demons#demons{attr_list = TotalAttr},
	NewDemons.

statistic_total_attr(AttrList) ->
	NewAttrList = [Attrs ||{_, Attrs} <- AttrList],
	ulists:kv_list_plus_extra(NewAttrList).
	% lib_player_attr:add_attr(list, NewAttrList).

get_demons_type_attr(?ATTR_TYPE_DEMONS, Demons) ->
	#demons{demons_id = DemonsId, level = Level, star = Star} = Demons,
	case get_demons_level_cfg(DemonsId, Level) of 
		#base_demons_level{attr = LevelAttr} -> ok;
		_ -> LevelAttr = []
	end,
	case data_demons:get_demons_star_cfg(DemonsId, Star) of 
		#base_demons_star{attr = StarAttr} -> ok;
		_ -> StarAttr = []
	end,
	lib_player_attr:add_attr(list, [LevelAttr, StarAttr]);
get_demons_type_attr(?ATTR_TYPE_FETTERS, FettersList) ->
	F = fun(FettersId, Acc) ->
		case data_demons:get_fetters_cfg(FettersId) of 
			#base_demons_fetters{attr = Attr} ->
				lib_player_attr:add_attr(list, [Acc, Attr]);
			_ -> 
				Acc
		end
	end,
	lists:foldl(F, [], FettersList);
get_demons_type_attr(?ATTR_TYPE_SKILL, SkillList) ->
	SkillAttr = lib_skill_api:get_skill_attr2mod(0, SkillList), %% 获取技能全局属性
	SkillAttr;
get_demons_type_attr(?ATTR_TYPE_SLOT_SKILL, SkillList) ->
	SlotAttr = lib_skill_api:get_skill_attr2mod(0, SkillList), %% 获取技能全局属性
	?PRINT("SlotAttr:~p~n",[SlotAttr]),
	SlotAttr;
get_demons_type_attr(?ATTR_TYPE_PAINTING, PaintingList) ->
	case PaintingList of 
		[] -> [];
		_ ->
			PaintingId = lists:max(PaintingList),
			case data_demons:get_painting_cfg(PaintingId) of 
				#base_demons_painting{attr = Attr} ->
					Attr;
				_ ->
					[]
			end
	end;
	% PaintingAttrList = data_demons:get_painting_attr_all(),
	% case ulists:find(fun({Num, _Attr}) -> PaintingNum >= Num end, PaintingAttrList) of 
	% 	{ok, {_Num, AttrList}} -> AttrList;
	% 	_ -> []
	% end;
get_demons_type_attr(_, _) ->
	[].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 使魔战力计算
count_demons_power(PS, Demons) ->
	#player_status{original_attr = OriginalAttr, status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle} = StatusDemons,
	#demons{demons_id = DemonsId, attr_list = DemonsAttr, skill_list = SkillList, slot_list = SlotSkill} = Demons,
	SkillPower = get_demons_skill_power(SkillList, DemonsId == DemonsIdBattle),
	SlotSkillPower = get_slot_skill_power(SlotSkill),
	DemonsPower = lib_player:calc_partial_power(OriginalAttr, SkillPower+SlotSkillPower, DemonsAttr),
	DemonsPower.

count_all_demons_power(Ps) ->
	#player_status{status_demons = StatusDemons} = Ps,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	F = fun(Demons, FunPower) ->
		FunPower + count_demons_power(Ps, Demons)
	end,
	lists:foldl(F, 0, DemonsList).

count_demons_expact_power(PS, Demons) ->
	#player_status{original_attr = OriginalAttr, status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle} = StatusDemons,
	#demons{demons_id = DemonsId, attr_list = DemonsAttr, skill_list = SkillList} = Demons,
	SkillPower = get_demons_skill_power(SkillList, DemonsId == DemonsIdBattle),
	DemonsPower = lib_player:calc_expact_power(OriginalAttr, SkillPower, DemonsAttr),
	DemonsPower.

count_demons_skill_power(StatusDemons) ->
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList} = StatusDemons,
	F = fun(#demons{demons_id = DemonsId, skill_list = SkillList}, AccPower) ->
		IsInBattle = DemonsId == DemonsIdBattle,
		ValuePower = get_demons_skill_power(SkillList, IsInBattle),
		ValuePower + AccPower
	end,
	SkillPower = lists:foldl(F, 0, DemonsList),
	StatusDemons#status_demons{skill_power = SkillPower}.

get_demons_skill_power(SkillList, IsInBattle) ->
	F = fun(#demons_skill{skill_id = SkillId, level = SkillLv, sk_type = _SkType}, Acc) ->
		case data_demons:get_skill_map(SkillId) of 
			[{SkillFollow, SkillUnfollow, _PassTarget}] -> 
				SkillIdValid = ?IF(IsInBattle, SkillFollow, SkillUnfollow),
				lib_skill_api:get_skill_power(SkillIdValid, SkillLv) + Acc;
			_ ->
				Acc
		end
	end,
	SkillPower= lists:foldl(F, 0, SkillList),
	SkillPower.

count_slot_skill_power(StatusDemons) -> %% 统计天赋技能战力的部分战力
	#status_demons{slot_skill = SlotSkillPassive} = StatusDemons,
	SkillPower = get_slot_skill_power(SlotSkillPassive),
	StatusDemons#status_demons{slot_skill_power = SkillPower}.

get_slot_skill_power(SkillList) when is_list(SkillList) ->
	F = fun({SkillIdValid, SkillLv}, Acc) ->
			lib_skill_api:get_skill_power(SkillIdValid, SkillLv) + Acc;
		(#slot_skill{skill_id = SkillIdValid, level = SkillLv}, Acc) ->
			lib_skill_api:get_skill_power(SkillIdValid, SkillLv) + Acc;
		(_, Acc) ->
			Acc
	end,
	SkillPower= lists:foldl(F, 0, SkillList),
	SkillPower;
get_slot_skill_power(_) -> 0.

calc_slot_skill_attr(SkillList) when is_list(SkillList) andalso SkillList =/= [] ->
	F = fun({SkillIdValid, SkillLv}, Acc) ->
			[{SkillIdValid, SkillLv}|Acc];
		(#slot_skill{skill_id = SkillIdValid, level = SkillLv}, Acc) ->
			[{SkillIdValid, SkillLv}|Acc];
		(_, Acc) ->
			Acc
	end,
	SkillIdLvList = lists:foldl(F, [], SkillList),
	SlotAttr = lib_skill_api:get_skill_attr2mod(0, SkillIdLvList),
	SlotAttr;
calc_slot_skill_attr(_) -> [].

calc_life_skill_attr(Demons) ->
	#demons{demons_id = DemonsId, skill_list = SkillList} = Demons,
	F = fun(#demons_skill{skill_id = SkillId, level = Level, sk_type = SkType, process = Process, is_active = IsActive}, Acc) ->
		case SkType == ?DEMONS_SKILL_TYPE_LIFE of 
			true ->
				case data_demons:get_demons_skill_upgrade_cfg(SkillId, Level) of 
					#base_demons_skill_upgrade{usage = Usage} when Process > 0  ->
						#base_demons_skill{usage = Conditions} = data_demons:get_demons_skill_cfg(DemonsId, SkillId),
						case lists:keyfind(start_calc, 1, Conditions) of 
							{_, StartValue, GapValue} ->
								Cnt = max(0, (Process - StartValue) div max(1, GapValue));
							_ -> %% 没配置，不加属性
								Cnt = 0
						end,
						{_, AttrList} = ulists:keyfind(attr, 1, Usage, {attr, []}),
						NewAttrList = [{K, V*Cnt} ||{K, V} <- AttrList],
						case IsActive == 1 of 
							true ->
								case data_demons:get_skill_map(SkillId) of 
									[{MapSkillId, _, _}] ->
										SkillAttr = lib_skill_api:get_skill_attr2mod(0, [{MapSkillId, Level}]),
										lib_player_attr:add_attr(list, [Acc, SkillAttr, NewAttrList]);
									_ ->
										lib_player_attr:add_attr(list, [Acc, NewAttrList])
								end;
							_ ->
								lib_player_attr:add_attr(list, [Acc, NewAttrList])
						end;
					_ ->
						Acc
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(F, [], SkillList).

static_demons_skill_infos(StatusDemons) ->
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList} = StatusDemons,
	F = fun(#demons{demons_id = DemonsId, skill_list = SkillList, slot_list = SlotList}=Demons, {Acc1, Acc2, TemAcc}) -> 
		Fun = fun(#slot_skill{skill_id = SlotSkillId, level = SlotSkillLv}, TemAcc1) ->
			[{SlotSkillId, SlotSkillLv}|TemAcc1]
		end,
		NewTemAcc = lists:foldl(Fun, TemAcc, SlotList),
		case DemonsId == DemonsIdBattle of 
			true -> %% 上阵使魔，获取主动战斗技能和被动上阵技能
				FI = fun(#demons_skill{skill_id = SkillId, sk_type = SkType, level = Level}, {Acc3, Acc4}) ->
					case SkType of 
						?DEMONS_SKILL_TYPE_BATTLE -> 
							case data_demons:get_skill_map(SkillId) of 
								[{SkillFollow, _SkillUnfollow, _PassTarget}] -> 
									{[{SkillFollow, Level}|Acc3], Acc4};
								_ ->
									{Acc3, Acc4}
							end;
						?DEMONS_SKILL_TYPE_PASSIVE ->
							case data_demons:get_skill_map(SkillId) of 
								[{SkillFollow, _SkillUnfollow, PassTarget}] -> 
									?IF(PassTarget==0, {[{SkillFollow, Level}|Acc3], Acc4}, {Acc3, [{SkillFollow, Level}|Acc4]});
								_ ->
									{Acc3, Acc4}
							end;
						_ -> {Acc3, Acc4}
					end
				end,
				{SkillForDemons, SkillForRole} = lists:foldl(FI, {[], []}, SkillList),	
				NewDemons = Demons#demons{skill_for_role = SkillForRole, skill_for_demons = SkillForDemons},
				{[NewDemons|Acc1], SkillForRole ++ Acc2, NewTemAcc};
			_ -> %% 不是上阵使魔，获取所有被动的下阵技能(主动技能不生效)
				FI = fun(#demons_skill{skill_id = SkillId, sk_type = SkType, level = Level}, Acc4) ->
					case SkType == ?DEMONS_SKILL_TYPE_PASSIVE of 
						true -> 
							case data_demons:get_skill_map(SkillId) of 
								[{_SkillFollow, SkillUnfollow, _PassTarget}] -> 
									[{SkillUnfollow, Level}|Acc4];
								_ ->
									Acc4
							end;
						_ -> Acc4
					end
				end,
				SkillForRole = lists:foldl(FI, [], SkillList),
				NewDemons = Demons#demons{skill_for_role = SkillForRole},
				{[NewDemons|Acc1], SkillForRole ++ Acc2, NewTemAcc}
		end
	end,
	{NewDemonsList, SkillPassive, SlotSkillPassive} = lists:foldl(F, {[], [], []}, DemonsList),
	StatusDemons#status_demons{demons_list = NewDemonsList, skill_passive = SkillPassive, slot_skill = SlotSkillPassive}.
	
static_demons_skill_infos(StatusDemons, DemonsId) ->
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList} = StatusDemons,
	case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
		#demons{skill_list = SkillList} = Demons ->
			IsInBattle = DemonsIdBattle == DemonsId,
			F = fun(#demons_skill{skill_id = SkillId, sk_type = SkType, level = Level}, {Acc1, Acc2}) ->
				case SkType of 
					?DEMONS_SKILL_TYPE_BATTLE -> 
						case data_demons:get_skill_map(SkillId) of 
							[{SkillFollow, _SkillUnfollow, _PassTarget}] -> 
								?IF(IsInBattle, {[{SkillFollow, Level}|Acc1], Acc2}, {Acc1, Acc2});
							_ ->
								{Acc1, Acc2}
						end;
					?DEMONS_SKILL_TYPE_PASSIVE ->
						case data_demons:get_skill_map(SkillId) of 
							[{SkillFollow, SkillUnfollow, PassTarget}] -> 
								if
									IsInBattle andalso PassTarget == 0 -> %% 上阵作用于使魔
										{[{SkillFollow, Level}|Acc1], Acc2};
									IsInBattle -> %% 上阵作用于玩家
										{Acc1, [{SkillFollow, Level}|Acc2]};
									true -> %% 其他情况作用于玩家
										{Acc1, [{SkillUnfollow, Level}|Acc2]}
								end;
							_ ->
								{Acc1, Acc2}
						end;
					_ -> {Acc1, Acc2}
				end
			end,
			{SkillForDemons, SkillForRole} = lists:foldl(F, {[], []}, SkillList),
			NewDemons = Demons#demons{skill_for_role = SkillForRole, skill_for_demons = SkillForDemons},
			NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
			F2 = fun(#demons{skill_for_role = DSkillForRole}, Acc) -> DSkillForRole ++ Acc end,
			AllPassiveSkillList = lists:foldl(F2, [], NewDemonsList),
			StatusDemons#status_demons{demons_list = NewDemonsList, skill_passive = AllPassiveSkillList};
		_ ->
			StatusDemons
	end.

static_demons_slot_skill_infos(StatusDemons) ->
	#status_demons{demons_list = DemonsList} = StatusDemons,
	F = fun(#demons{slot_list = SlotList}, Acc) -> 
		Fun = fun(#slot_skill{skill_id = SlotSkillId, level = SlotSkillLv}, TemAcc) ->
			[{SlotSkillId, SlotSkillLv}|TemAcc]
		end,
		lists:foldl(Fun, Acc, SlotList)
	end,
	SlotSkillPassive = lists:foldl(F, [], DemonsList),
	StatusDemons#status_demons{slot_skill = SlotSkillPassive}.

get_demons_upgrade_goods(DemonsId) ->
	case data_demons:get_demons_cfg(DemonsId) of 
		#base_demons{realm = Realm} ->
			case lists:keyfind(Realm, 1, ?upgrade_demons_goods) of 
				{_, GoodsList} -> GoodsList;
				_ -> []
			end;
		_ ->
			[]
	end.

get_demons_level_cfg(DemonsId, Level) ->
	case data_demons:get_demons_cfg(DemonsId) of 
		#base_demons{realm = Realm} ->
			data_demons:get_demons_level_cfg(Realm, Level);
		_ ->
			[]
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% db 函数

db_select_demons_all(RoleId) ->
	Sql = io_lib:format(?sql_select_demons_all, [RoleId]),
	db:get_all(Sql).

db_replace_demons(RoleId, Demons) ->
	#demons{
		demons_id = DemonsId
		, level = Level, exp = Exp 
		, star = Star, slot_num = Slot
	} = Demons,
	Sql = io_lib:format(?sql_replace_demons, [RoleId, DemonsId, Level, Exp, Star, Slot]),
	db:execute(Sql).

update_demons_level(RoleId, Demons) ->
	#demons{
		demons_id = DemonsId
		, level = Level, exp = Exp 
	} = Demons,
	Sql = io_lib:format(?sql_update_demons_level, [Level, Exp, RoleId, DemonsId]),
	db:execute(Sql).

update_demons_star(RoleId, Demons) ->
	#demons{
		demons_id = DemonsId
		, star = Star 
	} = Demons,
	Sql = io_lib:format(?sql_update_demons_star, [Star, RoleId, DemonsId]),
	db:execute(Sql).

update_demons_battle_state(RoleId, DemonsId, InBattle) ->
	Sql = io_lib:format(?sql_update_demons_battle_state, [InBattle, RoleId, DemonsId]),
	db:execute(Sql).

db_select_demons_role_msg(RoleId) ->
	Sql = io_lib:format(?sql_select_demons_role_msg, [RoleId]),
	db:get_row(Sql).

db_replace_demons_role_msg(RoleId, StatusDemons) ->
	#status_demons{
		demons_id = DemonsId
		, painting_list = PaintingList
	} = StatusDemons,
	Sql = io_lib:format(?sql_replace_demons_role_msg, [RoleId, DemonsId, util:term_to_bitstring(PaintingList)]),
	db:execute(Sql).

db_select_demons_skill(RoleId) ->
	Sql = io_lib:format(?sql_select_demons_skill, [RoleId]),
	db:get_all(Sql).

db_replace_demons_skill(RoleId, DemonsId, DemonsSkill) ->
	#demons_skill{skill_id = SkillId, level = Level, process = Process, is_active = IsActive} = DemonsSkill,
	Sql = io_lib:format(?sql_replace_demons_skill, [RoleId, DemonsId, SkillId, Level, Process, IsActive]),
	db:execute(Sql).

db_select_demons_slot(RoleId) ->
	Sql = io_lib:format(?sql_select_demons_slot, [RoleId]),
	db:get_all(Sql).

db_replace_demons_slot(RoleId, DemonsId, SkillId, Slot, Level) ->
	Sql = io_lib:format(?sql_replace_demons_slot, [RoleId, DemonsId, SkillId, Slot, Level]),
	db:execute(Sql).

db_delete_demons_slot(RoleId, DemonsId, SkillId) ->
	Sql = io_lib:format(?sql_delete_demons_slot, [RoleId, DemonsId, SkillId]),
	db:execute(Sql).

db_select_demons_shop(RoleId) ->
	Sql = io_lib:format(?sql_select_demons_shop, [RoleId]),
	db:get_row(Sql).

db_replace_demons_shop(RoleId, DemonsShop) ->
	#demons_shop{refresh_times = RefreshTimes, stime = Stime, goods = Goods} = DemonsShop,
	Sql = io_lib:format(?sql_replace_demons_shop, [RoleId, RefreshTimes, util:term_to_bitstring(Goods), Stime]),
	db:execute(Sql).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 检查函数
%% 激活检查
check_active_demons(PS, DemonsId) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
		false -> %% 激活
			DemonsCfg = data_demons:get_demons_cfg(DemonsId),
			DemonsStarCfg = data_demons:get_demons_star_cfg(DemonsId, 1),
			CheckList = [
				{check_config, DemonsCfg, base_demons}
				, {check_config, DemonsStarCfg, base_demons_star}
				, {check_goods_enough, PS, DemonsStarCfg}
			],
			case checklist(CheckList) of 
				true ->
					NewSlotNum = get_slot_unlock_num(?DEMONS_SLOT_BEGIN, 0),
					NewDemons = #demons{demons_id = DemonsId, star = 0, slot_num = NewSlotNum},
					SkillList = refresh_demons_skill(NewDemons, []),
					NewDemonsAfSkill = NewDemons#demons{skill_list = SkillList},
					NewDemonsAfAttr = count_single_demons_attr(NewDemonsAfSkill),
					{active, NewDemonsAfAttr, DemonsCfg, DemonsStarCfg};
				Res ->
					Res
			end;
		Demons ->
			#demons{star = Star, skill_list = OldSkillList, slot_num = SlotNum} = Demons,
			DemonsCfg = data_demons:get_demons_cfg(DemonsId),
			DemonsStarCfg = data_demons:get_demons_star_cfg(DemonsId, Star+1),
			CheckList = [
				{check_config, DemonsCfg, base_demons}
				, {check_config, DemonsStarCfg, base_demons_star}
				, {check_goods_enough, PS, DemonsStarCfg}
			],
			case checklist(CheckList) of 
				true ->
					NewSlotNum = get_slot_unlock_num(SlotNum, Star+1),
					NewDemons = Demons#demons{star = Star+1, slot_num = NewSlotNum},
					SkillList = refresh_demons_skill(NewDemons, OldSkillList),
					NewDemonsAfSkill = NewDemons#demons{skill_list = SkillList},
					NewDemonsAfAttr = count_single_demons_attr(NewDemonsAfSkill),
					{up_star, NewDemonsAfAttr, DemonsCfg, DemonsStarCfg};
				Res ->
					Res
			end
	end.

check_upgrade_demons(PS, DemonsId) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	Demons = lists:keyfind(DemonsId, #demons.demons_id, DemonsList),
	CheckList = [
		{demons_is_active, Demons}
	],
	case checklist(CheckList) of 
		true ->
			{true, Demons};
		Res ->
			Res
	end.

upgrade_demons_skill_level(PS, DemonsId, SkillId) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	Demons = lists:keyfind(DemonsId, #demons.demons_id, DemonsList),
	CheckList = [
		{demons_is_active, Demons}
		, {demons_skill_is_active, Demons, SkillId}
	],
	case checklist(CheckList) of 
		true ->
			#demons{skill_list = SkillList} = Demons,
			DemonsSkill = #demons_skill{level = OldLevel} = lists:keyfind(SkillId, #demons_skill.skill_id, SkillList),
			NewLevel = OldLevel + 1,
			case data_demons:get_demons_skill_upgrade_cfg(SkillId, NewLevel) of 
				#base_demons_skill_upgrade{cost = Cost} ->
					case checklist([{check_goods_enough, PS, Cost}]) of 
						true ->
							NewDemonsSkill = DemonsSkill#demons_skill{level = NewLevel},
							NewSkillList = lists:keyreplace(SkillId, #demons_skill.skill_id, SkillList, NewDemonsSkill),
							NewDemons = Demons#demons{skill_list = NewSkillList},
							{ok, NewDemons, NewDemonsSkill, Cost};
						Res -> 
							Res
					end;
				_ ->
					{false, ?MISSING_CONFIG}
			end;
		Res ->
			Res
	end.

demons_slot_skill(PS, DemonsId, GoodsTypeId, Slot) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	Demons = lists:keyfind(DemonsId, #demons.demons_id, DemonsList),
	CheckList = [
		{demons_is_active, Demons}
		, {demons_slot_is_active, Demons, Slot}
		, {goods_is_slot_skill_thing, GoodsTypeId}
	],
	case checklist(CheckList) of 
		true ->
			#demons{slot_list = SlotList} = Demons,
			SkillId = data_demons:get_skill_id_by_goods(GoodsTypeId),
			case lists:keyfind(Slot, #slot_skill.slot, SlotList) of 
				#slot_skill{skill_id = OldSkillId, level = OldLevel} = SlotSkill -> %% 升级、替换
					if
						SkillId == OldSkillId -> %% 升级
							case data_skill:get_lv_data(SkillId, OldLevel+1) of
								#skill_lv{condition = Conditions} ->
									case lists:keyfind(goods, 1, Conditions) of
										{goods, CostGoodsTypeId, CostNum} ->
											Cost = [{0, CostGoodsTypeId, CostNum}],
											NewSlotList = lists:keyreplace(Slot, #slot_skill.slot, SlotList, SlotSkill#slot_skill{level = OldLevel+1}),
											if
												NewSlotList =/= SlotList ->
													NewDemons = Demons#demons{slot_list = NewSlotList},
													{ok, NewDemons, Cost, {OldSkillId, OldLevel}, SlotSkill#slot_skill{level = OldLevel+1}};
												true ->
													{false, ?ERRCODE(err183_demons_slot_skill_not_have)}
											end;
										_ ->
											{false, ?MISSING_CONFIG}
									end;
								_ ->
									{false, ?MISSING_CONFIG}
							end;
						true -> %% 替换
							case lists:keyfind(SkillId, #slot_skill.skill_id, SlotList) of
								#slot_skill{} -> {false, ?ERRCODE(err183_demons_slot_skill_have)};
								_ ->
									#base_demons_skill_add{quality = Quality, sort = Sort} = data_demons:get_skill_info(SkillId),
									case check_same_sort_and_quality(SlotList, Quality, Sort) of 
										true ->
											case data_skill:get_lv_data(SkillId, 1) of
												#skill_lv{condition = Conditions} ->
													case lists:keyfind(goods, 1, Conditions) of
														{goods, CostGoodsTypeId, CostNum} ->
															Cost = [{0, CostGoodsTypeId, CostNum}],
															NewSlotSkill = #slot_skill{level = 1, skill_id = SkillId, slot = Slot, quality = Quality, sort = Sort},
															NewSlotList = lists:keyreplace(Slot, #slot_skill.slot, SlotList, NewSlotSkill),
															if
																NewSlotList =/= SlotList ->
																	NewDemons = Demons#demons{slot_list = NewSlotList},
																	{ok, NewDemons, Cost, {OldSkillId, OldLevel}, NewSlotSkill};
																true ->
																	{false, ?ERRCODE(err183_demons_slot_skill_not_have)}
															end;
														_ ->
															{false, ?MISSING_CONFIG}
													end;
												_ ->
													{false, ?MISSING_CONFIG}
											end;
										_ ->
											{false, ?ERRCODE(err183_same_slot_skill_sort)}
									end
							end
					end;
				_ -> %% 镶嵌
					case lists:keyfind(SkillId, #slot_skill.skill_id, SlotList) of
						#slot_skill{} -> {false, ?ERRCODE(err183_demons_slot_skill_have)};
						_ ->
							#base_demons_skill_add{quality = Quality, sort = Sort} = data_demons:get_skill_info(SkillId),
							case check_same_sort_and_quality(SlotList, Quality, Sort) of 
								true ->
									case data_skill:get_lv_data(SkillId, 1) of
										#skill_lv{condition = Conditions} ->
											case lists:keyfind(goods, 1, Conditions) of
												{goods, CostGoodsTypeId, CostNum} ->
													Cost = [{0, CostGoodsTypeId, CostNum}],
													NewSlotSkill = #slot_skill{level = 1, skill_id = SkillId, slot = Slot, quality = Quality, sort = Sort},
													NewSlotList = lists:keystore(Slot, #slot_skill.slot, SlotList, NewSlotSkill),
													NewDemons = Demons#demons{slot_list = NewSlotList},
													{ok, NewDemons, Cost, {0,0}, NewSlotSkill};
												_ ->
													{false, ?MISSING_CONFIG}
											end;
										_ ->
											{false, ?MISSING_CONFIG}
									end;
								_ ->
									{false, ?ERRCODE(err183_same_slot_skill_sort)}
							end
					end
			end;	
		Res ->
			Res
	end.

check({check_config, Config, Aton}) ->
	case is_record(Config, Aton) of 
		true -> true;
		_ -> {false, ?MISSING_CONFIG}
	end;
check({demons_is_active, Demons}) ->
	case is_record(Demons, demons) of 
		true -> true;
		_ -> {false, ?ERRCODE(err183_demons_not_active)}
	end;
check({demons_skill_is_active, Demons, SkillId}) ->
	case lists:keyfind(SkillId, #demons_skill.skill_id, Demons#demons.skill_list) of 
		false -> {false, ?ERRCODE(err183_demons_skill_not_active)};
		_ -> true
	end;

check({check_goods_enough, PS, DemonsStarCfg}) when is_record(DemonsStarCfg, base_demons_star) ->
	#base_demons_star{cost = CostList} = DemonsStarCfg,
	check({check_goods_enough, PS, CostList});
check({check_goods_enough, PS, DemonsCfg}) when is_record(DemonsCfg, base_demons) ->
	#base_demons{cost = CostList} = DemonsCfg,
	check({check_goods_enough, PS, CostList});

check({check_goods_enough, PS, CostList}) when is_list(CostList) ->
	case lib_goods_api:check_object_list(PS, CostList) of 
		true -> true;
		Res -> Res
	end;

check({demons_slot_is_active, Demons, Slot}) when is_integer(Slot) ->
	UnLockSlot = Demons#demons.slot_num,
	if
		UnLockSlot < Slot ->
			{false, ?ERRCODE(err183_demons_slot_not_active)};
		true ->
			true
	end;
check({goods_is_slot_skill_thing, GoodsTypeId}) ->
	case data_demons:get_skill_id_by_goods(GoodsTypeId) of
		SkillId when is_integer(SkillId) ->
			case data_demons:get_skill_info(SkillId) of
				#base_demons_skill_add{} -> true;
				_ ->
					{false, ?MISSING_CONFIG}
			end;
		_ ->
			{false, ?ERRCODE(err183_demons_goods_not_skill)}
	end;
check(_) ->
	{false, ?FAIL}.

%% helper function
checklist([]) -> true;
checklist([H | T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.

check_same_sort_and_quality([], _Quality, _Sort) -> true;
check_same_sort_and_quality([#slot_skill{sort = OldSort, quality = OldQuality}|SlotList], Quality, Sort) ->
	if
		OldSort == Sort andalso Quality == OldQuality ->
			false;
		true ->
			check_same_sort_and_quality(SlotList, Quality, Sort)
	end.


get_slot_unlock_num(_SlotNum, Star) ->
	Conditions = ?skill_slot_unlock3,
	UnlockList = [Slot ||{Slot, {star, NeedStar}} <- Conditions, Star >= NeedStar],
	SlotNum = lists:max([?DEMONS_SLOT_BEGIN|UnlockList]),
	SlotNum.

get_role_slot_skill_info(PS) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{slot_skill = SlotSkillList} = StatusDemons,
	Fun = fun({SkillId, _}, Acc) ->
		case data_demons:get_skill_info(SkillId) of
			#base_demons_skill_add{quality = Quality, sort = _Sort} ->
				case lists:keyfind(Quality, 1, Acc) of
					{Quality, Num} -> lists:keystore(Quality, 1, Acc, {Quality, Num+1});
					_ -> lists:keystore(Quality, 1, Acc, {Quality, 1})	
				end;
			_ ->
				Acc
		end
	end,
	lists:foldl(Fun, [], SlotSkillList).