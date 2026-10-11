%%%-----------------------------------------------------------------------------
%%%	@Module  : lib_partner_check
%%% @Author  : liuxl
%%% @Email   : liuxingli@suyougame.com
%%% @Created : 2016-12-13
%%% @Description : 伙伴
%%%-----------------------------------------------------------------------------
-module(lib_partner_check).
% -include("server.hrl").
% -include ("errcode.hrl").
% -include ("predefine.hrl").
% -include ("def_fun.hrl").
% -include ("partner.hrl").
% -include ("def_goods.hrl").
% -include ("common.hrl").
% -include ("figure.hrl").
% -include ("goods.hrl").
% -include ("skill.hrl").
% -compile(export_all).



% recruit(PS, PartnerSt, RecruitType, TenRecuit) ->
% 	RecruitCfg = data_partner:get_recuit(RecruitType),
% 	CheckList = [
% 			{check_is_record, base_partner_recruit, RecruitCfg}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			case check_get_recruit_cost(PS, PartnerSt, RecruitType, TenRecuit, RecruitCfg) of
% 				{true, ObjectList, IsFree} -> 
% 					{true, ObjectList, IsFree, RecruitCfg};
% 				{false, Res1} -> {false, Res1}
% 			end;				
% 		{false, Res} -> {false, Res}
% 	end.

% partner_callback(PartnerSt, PartnerId) ->
% 	PartnerCfg = data_partner:get_partner_by_id(PartnerId),
% 	CheckList = [
% 			{check_is_callbacked, PartnerSt, PartnerId},
% 			{check_is_record, base_partner, PartnerCfg}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			CallBackCfg = data_partner:get_callback(PartnerCfg#base_partner.quality),
% 			CheckList1 = [
% 				{check_is_record, base_partner_callback, CallBackCfg},
% 				{check_goods_enough, CallBackCfg}
% 			],
% 			case checklist(CheckList1) of
% 				true -> {true, PartnerCfg, CallBackCfg};
% 				{false, Res} -> {false, Res}
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% add_partner(PartnerId) ->
% 	PartnerCfg = data_partner:get_partner_by_id(PartnerId),
% 	CheckList = [
% 			{check_is_record, base_partner, PartnerCfg}
% 		],
% 	case checklist(CheckList) of
% 		true -> {true, PartnerCfg};
% 		{false, Res} -> {false, Res}
% 	end.

% wash_partner(PS, PartnerSt, Id) ->
% 	PartnerMap = PartnerSt#partner_status.partners,
% 	Value = maps:find(Id, PartnerMap),
% 	CheckList = [
% 			{check_partner_exist, Value}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, Partner} = Value,
% 			WashCfg = data_partner:get_wash_cfg(Partner#partner.quality),
% 			CheckList1 = [%{check_partner_state, ?STATE_SLEEP, Partner},
% 					{check_wash_goods, PS, WashCfg}
% 				],
% 			case checklist(CheckList1) of 
% 				true -> {true, Partner, WashCfg};
% 				{false, Res} -> {false, Res} 
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% wash_replace(PartnerSt) ->
% 	WashPartner = PartnerSt#partner_status.wash_partner,
% 	PartnerMap = PartnerSt#partner_status.partners,
% 	CheckList = [
% 			{check_is_record, partner, WashPartner},
% 			{check_wash_replace, WashPartner, PartnerMap}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, OldPartner} = maps:find(WashPartner#partner.id, PartnerMap),
% 			% 返回资质丹
% 			AptiTakeList = OldPartner#partner.apti_take,
% 			{DisbandCfgList, _State2} = lists:foldl(fun lib_partner_util:sk_convert_disband/2,
% 						{[], true}, OldPartner#partner.skill_learn),
% 			DiscountGoods = lib_partner:get_discount_goods(DisbandCfgList, []),
% 			AwardList = AptiTakeList ++ DiscountGoods,
% 			NewAwardList = lib_goods_check:combine_goods_num_list(AwardList),
% 			{true, OldPartner, WashPartner, NewAwardList};				
% 		{false, Res} -> {false, Res}

% 	end.

% add_exp(PS, Partner, Exp) ->
% 	PlayerLv = PS#player_status.figure#figure.lv,
% 	#partner{lv = PartnerLv, exp = CurExp} = Partner,
% 	BreakList = data_partner:get_break_lv(Partner#partner.quality),
% 	CheckList = [
% 			{check_partner_lv, PlayerLv, PartnerLv, CurExp}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			BreakedL = Partner#partner.break,
% 			UnBreakL = BreakList -- BreakedL,
% 			{NewLv, LeftExp} = lib_partner:calc_partner_upgrade(PlayerLv, PartnerLv, CurExp + Exp),
% 			if
% 				NewLv > PartnerLv -> 
% 					BreakSt = case UnBreakL == [] of
% 						true -> 0;
% 						false -> ?IF(lists:min(UnBreakL) =< NewLv, 1, 0)
% 					end,
% 					{BreakSt, true, NewLv, LeftExp};
% 				true -> 	
% 					BreakSt = case UnBreakL == [] of
% 						true -> 0;
% 						false -> ?IF(lists:min(UnBreakL) =< PartnerLv, 1, 0)
% 					end,
% 					{BreakSt, false, PartnerLv, LeftExp}
% 			end;
% 		{false, Res} -> {false, Res}
% 	end.

% partner_break(PartnerSt, Id) ->
% 	Value = maps:find(Id, PartnerSt#partner_status.partners),
% 	CheckList = [
% 			{check_partner_exist, Value}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, Partner} = Value,
% 			Quality = Partner#partner.quality,
% 			Lv = Partner#partner.lv,
% 			BreakList = data_partner:get_break_lv(Partner#partner.quality),
% 			BreakedL = Partner#partner.break,
% 			UnBreakL = BreakList -- BreakedL,
% 			BreakLv = ?IF(UnBreakL =/= [], lists:min(UnBreakL), 0),
% 			BreakCfg = data_partner:get_break(Quality, BreakLv),
% 			CheckList1 = [{check_partner_break, Lv, BreakLv},
% 						{check_is_record, base_partner_break, BreakCfg}	
% 				],
% 			case checklist(CheckList1) of 
% 				true -> {true, Partner, BreakCfg, UnBreakL};
% 				{false, Res} -> {false, Res}
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% partner_learn_skill(PS, PartnerSt, Id, GoodId) ->	
% 	GS = lib_goods_do:get_goods_status(),
% 	GoodsList = lib_goods_util:get_type_goods_list(PS#player_status.id, GoodId, ?GOODS_LOC_BAG, GS#goods_status.dict),
% 	Value = maps:find(Id, PartnerSt#partner_status.partners),	
% 	CheckList = [
% 			{check_partner_exist, Value},
% 			{check_sk_book_exist, GoodsList}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, Partner} = Value,
% 			SkillCfg = data_partner:get_skill_by_id(GoodId),
% 			PosL = lib_partner_util:get_unused_skill_pos(Partner),
% 			CheckList1 = [
% 					{check_is_record, base_partner_sk, SkillCfg},
% 					{check_learn_skill_pos, PosL},
% 					{check_learn_skill_id, Partner, SkillCfg}	
% 				],
% 			case checklist(CheckList1) of 
% 				true -> 
% 					[GoodsInfo|_T] = lists:keysort(#goods.num, GoodsList),
% 					[Pos|_L] = PosL,
% 					{true, Partner, SkillCfg, GoodsInfo, Pos};
% 				{false, Res} -> {false, Res}
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% partner_skill_replace(PS, PartnerSt, Id, GoodId, Pos) ->
% 	GS = lib_goods_do:get_goods_status(),
% 	GoodsList = lib_goods_util:get_type_goods_list(PS#player_status.id, GoodId, ?GOODS_LOC_BAG, GS#goods_status.dict),
% 	Value = maps:find(Id, PartnerSt#partner_status.partners),	
% 	CheckList = [
% 			{check_partner_exist, Value},
% 			{check_sk_book_exist, GoodsList}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, Partner} = Value,
% 			SkillCfg = data_partner:get_skill_by_id(GoodId),
% 			CheckList1 = [
% 					{check_is_record, base_partner_sk, SkillCfg},
% 					{check_replace_skill_pos, Partner, Pos},
% 					{check_learn_skill_id, Partner, SkillCfg}
% 				],
% 			case checklist(CheckList1) of 
% 				true -> 
% 					{RepalceId, _, _} = lists:keyfind(Pos, 3, Partner#partner.skill#partner_skill.skill_list),
% 					[GoodsInfo|_T] = lists:keysort(#goods.num, GoodsList),
% 					{true, Partner, SkillCfg, GoodsInfo, RepalceId};
% 				{false, Res} -> {false, Res}
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% partner_battle(PS, PartnerSt, Id) ->
% 	PlayerLv = PS#player_status.figure#figure.lv,
% 	Value = maps:find(Id, PartnerSt#partner_status.partners),
% 	UnusedList = lib_partner_util:get_unused_battle_slot(PartnerSt),
% 	CheckList = [
% 			{check_partner_exist, Value},
% 			{check_unused_slot, UnusedList}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, Partner} = Value,
% 			UnusedSlot = lists:nth(1, UnusedList),
% 			CheckList1 = [
% 					{check_slot, UnusedSlot, PlayerLv},
% 					{check_partner_state, ?STATE_SLEEP, Partner},
% 					{check_battle_partner_exist, PartnerSt, Partner#partner.partner_id}
% 				],
% 			case checklist(CheckList1) of
% 				true -> {true, Partner, UnusedSlot};
% 				{false, Res} -> {false, Res}
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% partner_sleep(_PS, PartnerSt, Id) ->
% 	Value = maps:find(Id, PartnerSt#partner_status.partners),
% 	CheckList = [
% 			{check_partner_exist, Value}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, Partner} = Value,
% 			CheckList1 = [
% 					{check_partner_state, ?STATE_BATTLE, Partner}
% 				],
% 			case checklist(CheckList1) of
% 				true -> {true, Partner, Partner#partner.pos};
% 				{false, Res} -> {false, Res}
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% change_battle_pos(PartnerSt, Src, Dst) ->
% 	SrcPartner = lib_partner_util:get_partner_by_pos(PartnerSt, Src),
% 	DstPartner = lib_partner_util:get_partner_by_pos(PartnerSt, Dst),
% 	if 
% 		Src < 1 orelse Src > ?MAX_BATTLE orelse Dst < 1 orelse Dst > ?MAX_BATTLE -> {false, ?ERRCODE(err412_battle_err3)};
% 		is_record(SrcPartner, partner) == false -> {false, ?ERRCODE(err412_partner_not_exist)};
% 		is_record(DstPartner, partner) == false -> {true, SrcPartner, undefined};
% 		true ->	{true, SrcPartner, DstPartner}
% 	end.

% change_embattle(PartnerSt, SrcPos, DesPos) ->
% 	Embattle = PartnerSt#partner_status.embattle,
% 	Value = lists:keyfind(SrcPos, #rec_embattle.pos, Embattle),
% 	CheckList = [
% 			{check_src_pos, Value},
% 			{check_dst_pos, DesPos}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			case lists:keyfind(DesPos, #rec_embattle.pos, Embattle) of 
% 				false -> {true, Embattle, Value, {none, DesPos}};
% 				Value1 -> {true, Embattle, Value, Value1}
% 			end;
% 		{false, Res} -> {false, Res}
% 	end.

% equip_weapon(_PS, PartnerSt, GoodsInfo) ->
% 	GoodsTypeId = GoodsInfo#goods.goods_id,
% 	WeaponCfg = data_partner:get_weapon_by_id(GoodsTypeId),
% 	case equip_weapon_do(PartnerSt, WeaponCfg) of 
% 		{true, PartnerList} -> 
% 			{true, WeaponCfg, PartnerList};
% 		{false, Res} -> {false, Res}
% 	end.


% partner_disband(PartnerSt, IdList) ->
% 	case get_disband_partners(PartnerSt, IdList) of 
% 		{_, PartnerList, true} ->
% 			F = fun(#partner{id = Id, skill_learn = Sk} = Partner, {Map, RList}) ->
% 				{DisbandCfgList1, _} = lib_partner_util:partner_convert_disband(Partner, {[],true}),
% 				{DisbandCfgList2, _} = lists:foldl(fun lib_partner_util:sk_convert_disband/2,
% 				{[], true}, Sk),
% 				ExpBookL = lib_partner:get_diaband_exp_book([Partner], 0),
% 				AptiTakeList = lib_partner:get_partner_apti([Partner], []),
% 				DiscountGoods = lib_partner:get_discount_goods(DisbandCfgList1 ++ DisbandCfgList2, []),
% 				AwardList = ExpBookL ++ (AptiTakeList ++ DiscountGoods),
% 				NewAwardList = lib_goods_check:combine_goods_num_list(AwardList),
% 				{maps:put(Id, NewAwardList, Map), NewAwardList++RList}
% 			end,
% 			{RewardMap, TotalReward} = lists:foldl(F, {#{}, []}, PartnerList),
% 			NewTotalReward = lib_goods_check:combine_goods_num_list(TotalReward),
% 			{true, PartnerList, NewTotalReward, RewardMap};
% 		{_, _, false_nopartner} -> {false, ?ERRCODE(err412_partner_not_exist)};
% 		{_, _, false_in_battle} -> {false, ?ERRCODE(err412_disband_err)}
% 	end.


% equip_weapon_do(PartnerSt, WeaponCfg) when is_record(WeaponCfg, base_partner_weapon) ->
% 	PartnerList = lib_partner_util:get_partner_by_id(PartnerSt, WeaponCfg#base_partner_weapon.partner_id),
% 	CheckList = [
% 			{check_weapon_actived, WeaponCfg#base_partner_weapon.partner_id, PartnerSt}
% 		],
% 	case checklist(CheckList) of
% 		true -> {true, PartnerList};
% 		{false, Res} -> {false, Res}
% 	end;
% equip_weapon_do(_PartnerSt, _WeaponCfg) ->
% 	{false, ?ERRCODE(err412_cfg_not_exist)}.

% get_disband_partners(PartnerSt, IdList) ->
% 	PartnerMap = PartnerSt#partner_status.partners,
% 	F = fun(Id, {Map, List, State}) ->
% 		case maps:find(Id, Map) of
% 			{ok, Partner} when Partner#partner.state == ?STATE_SLEEP -> 
% 				{Map, [Partner|List], State};
% 			{ok, _} -> 
% 				{Map, List, false_in_battle};
% 			_ -> 
% 				{Map, List, false_nopartner}
% 		end
% 	end,
% 	lists:foldl(F, {PartnerMap, [], true}, IdList).

% get_promote_times(PS, PartnerSt, PartberId, Type, GoodsList) ->
% 	Value = maps:find(PartberId, PartnerSt#partner_status.partners),	
% 	CheckList = [
% 			{check_partner_exist, Value}
% 		],
% 	case checklist(CheckList) of
% 		true -> 
% 			{ok, Partner} = Value,
% 			PromoteCfg = data_partner:get_promote(Partner#partner.quality, Partner#partner.prodigy),
% 			CheckList1 = [
% 					{check_is_record, base_partner_promote, PromoteCfg},
% 					{check_attr_limit, Type, Partner}
% 				],
% 			case checklist(CheckList1) of 
% 				true -> 
% 					case check_promote(PS, GoodsList, PromoteCfg) of
% 						{true, Times, SingleCost} -> 
% 							{true, Partner, PromoteCfg, Times, SingleCost};
% 						{false, Res1} -> {false, Res1}
% 					end;
% 				{false, Res} -> {false, Res}
% 			end;
% 		{false, Res1} -> {false, Res1}
% 	end.

% check({check_is_record, CfgName, Cfg}) ->
% 	case is_record(Cfg, CfgName) of
% 		true -> true;
% 		false -> {false, ?ERRCODE(err412_cfg_not_exist)}
% 	end;

% check({check_sk_book_exist, GoodsList}) ->
% 	case length(GoodsList) > 0 of 
% 		true -> true;
% 		false -> {false, ?ERRCODE(goods_not_enough)}
% 	end;

% check({check_learn_skill_pos, PosL}) ->
% 	case PosL == [] of
% 		false -> true;
% 		true -> {false, ?ERRCODE(err412_learn_sk_err1)}
% 	end;

% check({check_learn_skill_id, Partner, SkillCfg}) ->
% 	case lists:keyfind(SkillCfg#base_partner_sk.skill_id, 1, Partner#partner.skill#partner_skill.skill_list) of
% 		false -> true;
% 		_ -> {false, ?ERRCODE(err412_learn_sk_err3)}
% 	end;

% check({check_replace_skill_pos, Partner, Pos}) when 0 < Pos andalso Pos =< 5->
% 	case lists:keyfind(Pos, 3, Partner#partner.skill#partner_skill.skill_list) of
% 		false -> {false, ?ERRCODE(err412_replace_sk_err1)};
% 		{_, _, Pos} -> true
% 	end;
% check({check_replace_skill_pos, _Partner, _Pos}) ->
% 	{false, ?ERRCODE(err412_learn_sk_err2)};


% check({check_skbooks_num, GoodsList}) ->
% 	if
% 		GoodsList =/= [] -> true;
% 		true -> {false, ?ERRCODE(err412_no_sk_book)}
% 	end;

% check({check_enough_money, PS, Type, RecuitCost}) ->
% 	MoneyType = ?IF(Type == ?RECRUIT_TYPE1, ?COIN, ?BGOLD_AND_GOLD),
% 	case lib_goods_util:is_enough_money(PS, RecuitCost, MoneyType) of
%         false -> ?IF(Type == ?RECRUIT_TYPE1, {false, ?COIN_NOT_ENOUGH}, {false, ?GOLD_NOT_ENOUGH});
%         true -> true
%     end;

% check({check_partner_exist, Value}) ->
% 	case Value of
% 		{ok, _Partner} -> true;
% 		_ -> {false, ?ERRCODE(err412_partner_not_exist)}
% 	end;

% check({check_wash_goods, PS, WashCfg}) ->
% 	if
% 		is_record(WashCfg, base_partner_wash) ->
% 			GoodsList = WashCfg#base_partner_wash.goods,
% 			case check_goods_num(PS, GoodsList) of
% 		        1 -> true;
% 		        0 -> {false, ?ERRCODE(err412_wash_goods_err1)}
% 		    end;
% 		true ->
% 			{false, ?ERRCODE(err412_cfg_not_exist)}
% 	end;

% check({check_partner_state, State, Partner}) ->
% 	if
% 		Partner#partner.state =:= State -> true;
% 		true -> {false, ?ERRCODE(err412_partner_state_err)}
% 	end;

% check({check_partner_lv, PlayerLv, PartnerLv, CurExp}) ->
% 	if
% 		PartnerLv < PlayerLv -> true;
% 		PartnerLv == PlayerLv ->
% 			case data_partner:get_lv_upgrade(PartnerLv) of
% 				#base_partner_upgrade{max_exp = MaxExp} when CurExp >= MaxExp -> 
% 					{false, ?ERRCODE(err412_upgrade_lv_err)};
% 				#base_partner_upgrade{} -> true;
% 				_ -> {false, ?ERRCODE(err412_cfg_not_exist)}
% 			end;
% 		true -> {false, ?ERRCODE(err412_upgrade_lv_err)}
% 	end;

% check({check_wash_replace, WashPartner, PartnerMap}) ->
% 	case maps:find(WashPartner#partner.id, PartnerMap) of
% 		{ok, _Partner} -> true;
% 		_ -> {false, ?ERRCODE(err412_wash_replace_err)}
% 	end;

% check({check_partner_break, Lv, BreakLv}) ->
% 	if
% 		BreakLv =:= 0 -> {false, ?ERRCODE(err412_break_err)};
% 		Lv >= BreakLv -> true;
% 		true -> {false, ?ERRCODE(err412_break_err)}
% 	end;

% check({check_attr_limit, Type, Partner}) ->
% 	TotalAttr = Partner#partner.total_attr,
% 	case lists:keyfind(Type, 1, TotalAttr) of
% 		{_, CurVal, UpperVal} when CurVal < UpperVal ->
%             true;
%         _ ->
%             {false, ?ERRCODE(err412_promote_err)}
% 	end;

% check({check_unused_slot, UnusedList}) ->
% 	case UnusedList of 
% 		[] -> {false, ?ERRCODE(err412_battle_err1)};
% 		_ -> true
% 	end;

% check({check_slot, UnusedSlot, PlayerLv}) ->
% 	case data_partner:get_lv_limit_by_slot(UnusedSlot) of 
% 		Lv when is_integer(Lv), Lv =< PlayerLv -> true;
% 		Lv when is_integer(Lv) -> {false, ?ERRCODE(err412_battle_err2)};
% 		_ -> {false, ?ERRCODE(err412_battle_err2)}
% 	end;

% check({check_src_pos, Value}) ->
% 	case Value of 
% 		false -> {false, ?ERRCODE(err412_embattle_err1)};
% 		_ -> true
% 	end;

% check({check_dst_pos, DesPos}) ->
% 	case DesPos > 0 andalso DesPos =< ?MAX_EMBATTLE of 
% 		true -> true;
% 		false -> {false, ?ERRCODE(err412_embattle_err2)}
% 	end;

% check({check_goods_enough, CallBackCfg}) ->
% 	GoodsCost =  CallBackCfg#base_partner_callback.goods,
% 	GoodsList = change_format(GoodsCost, []),
% 	case lib_goods_do:check_num(GoodsList) of
% 		1 -> true;
% 		0 -> {false, ?ERRCODE(goods_not_enough)}
% 	end;

% check({check_common_goods, PS, GS, Id, Num}) ->
% 	case lib_goods_check:check_use_goods(PS, Id, Num, GS) of
%         {fail, Res} ->  {false, Res};
%         {ok, _GoodsInfo, _GiftInfo} -> true
%     end;

% check({check_weapon_actived, PartnerId, PartnerSt}) ->
% 	case lists:keyfind(PartnerId, 1, PartnerSt#partner_status.recruit_list) of 
% 		{PartnerId, 1} -> {false, ?ERRCODE(err412_weapon_err1)};
% 		{PartnerId, 0} -> true;
% 		false -> {false, ?ERRCODE(err412_weapon_err2)}
% 	end;

% check({check_is_callbacked, PartnerSt, PartnerId}) ->
% 	%?PRINT("partner_callback list: ~p~n", [PartnerSt#partner_status.recruit_list]),
% 	case lists:keyfind(PartnerId, 1, PartnerSt#partner_status.recruit_list) of 
% 		{PartnerId, _} -> true;
% 		false -> {false, ?ERRCODE(err412_callback_err)}
% 	end;
% check({check_battle_partner_exist, PartnerSt, PartnerId}) ->
% 	PartnerMap = PartnerSt#partner_status.partners,
% 	PartnerMap1 = maps:filter(fun(_, Partner) -> Partner#partner.state =:= ?STATE_BATTLE end, PartnerMap),
% 	Fun = fun({_, Value}, State) ->		 
% 		case Value#partner.partner_id == PartnerId of
% 			true -> true;
% 			false -> State
% 		end
% 	end,
% 	MapList = maps:to_list(PartnerMap1),
% 	State = lists:foldl(Fun, false, MapList),
% 	case State of 
% 		true -> {false, ?ERRCODE(err412_partner_is_battle)};
% 		false -> true
% 	end;
% check(_) ->
%     false.


% checklist([]) -> true;
% checklist([H|T]) ->
%     case check(H) of
%         true -> checklist(T);
%         {false, Res} -> {false, Res}
%     end.

% check_get_recruit_cost(PS, PartnerSt, Type, TenRecuit, RecruitCfg) ->
% 	#player_status{bgold = BGold} = PS,
% 	NowTime = utime:unixtime(),
% 	[{_, _, RecuitCost}|_T] =  ?IF(TenRecuit == 0, RecruitCfg#base_partner_recruit.single_recruit, RecruitCfg#base_partner_recruit.ten_recruit),
% 	#partner_status{recruit_type1 = {_CoinTms, CoinEt}, recruit_type2 = {_GoldTms, GoldEt}} = PartnerSt,
% 	{IsFree, MoneyType} = if
% 		Type == ?RECRUIT_TYPE1, NowTime < CoinEt -> {false, ?COIN};
% 		Type == ?RECRUIT_TYPE2, NowTime < GoldEt -> {false, ?BGOLD_AND_GOLD};
% 		Type == ?RECRUIT_TYPE1 -> {true, ?COIN};
% 		true -> {true, ?BGOLD_AND_GOLD}
% 	end,
% 	MoneyCost = if 
% 		TenRecuit == 1 -> RecuitCost;
% 		TenRecuit == 0 andalso IsFree =:= true -> 0;
% 		TenRecuit == 0 andalso IsFree =:= false -> RecuitCost;
% 		true -> RecuitCost
% 	end,
% 	case lib_goods_util:is_enough_money(PS, MoneyCost, MoneyType) of
%         false -> ?IF(Type == ?RECRUIT_TYPE1, {false, ?COIN_NOT_ENOUGH}, {false, ?GOLD_NOT_ENOUGH});
%         true -> 
%         	ObjectList = if
% 				Type == ?RECRUIT_TYPE1 -> [{?TYPE_COIN, 0, MoneyCost}];
% 				true ->
% 					case BGold >= MoneyCost of 
% 						true -> [{?TYPE_BGOLD, 0, MoneyCost}];
% 						false when BGold =/= 0 ->
% 							[{?TYPE_BGOLD, 0, BGold}, {?TYPE_GOLD, 0, MoneyCost-BGold}];
% 						false -> 
% 							[{?TYPE_GOLD, 0, MoneyCost}]
% 					end
% 			end,
% 			{true, ObjectList, IsFree}
%     end.



% check_promote(PS, List, PromoteCfg) ->
% 	{GoodsCost, OtherCost} = split_promote(PromoteCfg#base_partner_promote.goods, [], []),	
% 	ConsumeList = change_format(List, []),
% 	case lib_goods_do:check_num(ConsumeList) of
% 		1 -> 
% 			case check_promote_goods(GoodsCost, ConsumeList, 10000) of
% 				{true, CanPromote} -> 
% 					case check_promote_money(PS, OtherCost, CanPromote) of
% 						{true, CanPromote1} ->
% 							{true, CanPromote1, PromoteCfg#base_partner_promote.goods};
% 						{false, Err1} -> {false, Err1}

% 					end;
% 				{false, Err2} -> {false, Err2}
% 			end;
% 		0 -> {false, ?ERRCODE(goods_not_enough)}
% 	end.

% check_promote_goods([], _GoodsList, Min) ->
% 	{true, Min};
% check_promote_goods([{?TYPE_GOODS, GTypeId, NumNeed}|T], GoodsList, Min) ->
% 	case lists:keyfind(GTypeId, 1, GoodsList) of
% 		{_, NumConsume} when NumConsume >= NumNeed ->
% 			Times = NumConsume div NumNeed,
% 			PromTimes = ?IF(Times < Min, Times, Min),
% 			check_promote_goods(T, GoodsList, PromTimes);
% 		{_, _NumConsume} ->
% 			{false, ?ERRCODE(goods_not_enough)};
% 		false ->
% 			{false, ?ERRCODE(goods_not_enough)}
% 	end.

% check_promote_money(_PS, [], CanPromote) when CanPromote > 0 ->
% 	{true, CanPromote};
% check_promote_money(_PS, [], CanPromote) when CanPromote == 0 ->	
% 	{false, ?ERRCODE(goods_not_enough)};
% check_promote_money(PS, [Value|T], CanPromote) ->
% 	case Value of
% 		{?TYPE_GOLD, _, Num} -> 
% 			PSGold = PS#player_status.gold + PS#player_status.bgold,
% 			Times = PSGold div Num,
% 			Min = ?IF(Times < CanPromote, Times, CanPromote),
% 			check_promote_money(PS, T, Min);
% 		{?TYPE_COIN, _, Num} ->
% 			PSCoin = PS#player_status.coin + PS#player_status.bcoin,
% 			Times = PSCoin div Num,
% 			Min = ?IF(Times < CanPromote, Times, CanPromote),
% 			check_promote_money(PS, T, Min);
% 		_ -> check_promote_money(PS, T, CanPromote)
% 	end.


% check_goods_num(PS, GoodsList) ->
% 	NewGoodsList = change_format(GoodsList, []),
% 	lib_goods_api:check_goods_num(PS, NewGoodsList).

% split_promote([], GoodsCost, OtherCost) ->
% 	{GoodsCost, OtherCost};
% split_promote([Value|T], GoodsCost, OtherCost) ->
% 	case Value of
% 		{?TYPE_GOODS, _, _} ->
% 			NewGoodsCost = [Value|GoodsCost],
% 			split_promote(T, NewGoodsCost, OtherCost);
% 		_ ->
% 			NewOtherCost = [Value|OtherCost],
% 			split_promote(T, GoodsCost, NewOtherCost)
% 	end.

% change_format([], List) -> List;
% change_format([H|T], List) ->
% 	case H of
% 		{_Type, GoodsTypeID, Num} -> change_format(T, [{GoodsTypeID, Num}|List]);
% 		{GoodsTypeID, Num} -> change_format(T, [{GoodsTypeID, Num}|List]);
% 		_ -> change_format(T, List)
% 	end.

% change_to_obj_list([], List) -> List;
% change_to_obj_list([H|T], List) ->
% 	case H of
% 		{goods, GoodsTypeID, Num} -> change_to_obj_list(T, [{?TYPE_GOODS, GoodsTypeID, Num}|List]);
% 		{?TYPE_GOODS, GoodsTypeID, Num} -> change_to_obj_list(T, [{?TYPE_GOODS, GoodsTypeID, Num}|List]);
% 		{GoodsTypeID, Num} when GoodsTypeID > 0 -> change_to_obj_list(T, [{?TYPE_GOODS, GoodsTypeID, Num}|List]);
% 		_ -> change_to_obj_list(T, List)
% 	end.

