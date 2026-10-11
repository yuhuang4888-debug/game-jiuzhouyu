%%%-----------------------------------------------------------------------------
%%%	@Module  : lib_partner_do
%%% @Author  : liuxl
%%% @Email   : liuxingli@suyougame.com
%%% @Created : 2016-12-13
%%% @Description : 伙伴
%%%-----------------------------------------------------------------------------
-module(lib_partner_do).
% -include("server.hrl").
% -include("skill.hrl").
% -include("partner.hrl").
% -include("common.hrl").
% -include("attr.hrl").
% -include("def_fun.hrl").
% -include("daily.hrl").
% -include("def_daily.hrl").
% -include("def_module.hrl").
% -include("errcode.hrl").
% -include("scene.hrl").

% -compile(export_all).

% get_partner_status() ->
%     get({?MODULE, player_partner_status}).

% set_partner_status(PartnerSt) ->
%     put({?MODULE, player_partner_status}, PartnerSt),
%     ok.

% init_data(PartnerStatus) ->
% 	set_partner_status(PartnerStatus),
%     ok.

% % 登陆初始化 #partner_status{}
% select_player_status(PlayerId, PartnerMap) ->
% 	NowTime = utime:unixtime(),
% 	Sql = io_lib:format(?SQL_PLAYER_PARTNER_SELECT, [PlayerId]),
% 	PartnerSt = db:get_row(Sql),
% 	case PartnerSt of
% 		[] -> 
% 			RecEmbattle = #rec_embattle{key={?BATTLE_SIGN_PLAYER,PlayerId}, pos=?PLAYER_EMBATTLE_POS,type=?BATTLE_SIGN_PLAYER,id=PlayerId,partner_id=0,lv=0},
% 			#partner_status{pid = PlayerId, partners = PartnerMap, embattle = [RecEmbattle]};
% 		[CoinTms, CoinEt, GoldTms, GoldEt, Embattle_B, RecruitList_B] ->
% 			NewCoinEt = ?IF(CoinEt<NowTime, 0, CoinEt),
% 			NewGoldEt = ?IF(GoldEt<NowTime, 0, GoldEt),
% 			Embattle = util:bitstring_to_term(Embattle_B),
% 			RecruitList = util:bitstring_to_term(RecruitList_B),
% 			if
% 				Embattle == [] -> 
% 					RecEmbattle = #rec_embattle{key={?BATTLE_SIGN_PLAYER,PlayerId}, pos=?PLAYER_EMBATTLE_POS,type=?BATTLE_SIGN_PLAYER,id=PlayerId,partner_id=0,lv=0},
% 					NewEmbattle = [RecEmbattle];
% 				true -> 
% 					EmbattleList = lib_partner_util:conver_to_rec_embattle(PartnerMap, Embattle, []),
% 					NewEmbattle = lib_partner_api:get_partner_embattle_2_core(PlayerId, EmbattleList)
% 			end,
% 			#partner_status{
% 				pid = PlayerId,
% 				recruit_type1 = {CoinTms, NewCoinEt},
% 				recruit_type2 = {GoldTms, NewGoldEt},
% 				partners = PartnerMap,
% 				embattle = NewEmbattle,
% 				recruit_list = RecruitList
% 			}
% 	end.

% % 登陆初始化 伙伴列表
% select_player_partners(PlayerId) ->	
% 	Sql = io_lib:format(?SQL_PARTNER_ALL_SELECT, [PlayerId]),
% 	BasePartners = db:get_all(Sql),
% 	Sql1 = io_lib:format(?SQL_SK_ALL_SELECT, [PlayerId]),
% 	BaseSks = db:get_all(Sql1),
% 	SkMap = init_partner_sk(BaseSks, #{}),
% 	Sql2 = io_lib:format(?SQL_EQUIP_ALL_SELECT, [PlayerId]),
% 	BaseEquips = db:get_all(Sql2),
% 	EquipMap = init_partner_equip(BaseEquips, #{}),
% 	PartnerList = make_partners(BasePartners, PlayerId, SkMap, EquipMap, []),
% 	init_partners(PartnerList, #{}).

% updata_partners_logout([]) -> ok;
% updata_partners_logout([Partner|T]) ->
% 	#partner{id=Id, exp = Exp} = Partner,
% 	Sql = io_lib:format(<<"update `partner` set exp=~p where id=~p">>, [Exp, Id]),
% 	db:execute(Sql),
% 	updata_partners_logout(T).


% make_partners([], _PlayerId, _SkMap, _EquipMap, PartnerList) -> PartnerList;
% make_partners([H|T], PlayerId, SkMap, EquipMap, PartnerList) ->
% 	case H of
% 		[Id, PartnerId, Lv, Exp, BreakSt, Break_B, State, Pos, AttrQuality_B, TotalAttr_B, Prodigy, AptiTake_B, SkLearn_B] ->
% 			Break = util:bitstring_to_term(Break_B),
% 			AttrQuality = util:bitstring_to_term(AttrQuality_B),
% 			TotalAttr = util:bitstring_to_term(TotalAttr_B),
% 			AptiTake = util:bitstring_to_term(AptiTake_B),
% 			SkLearn = util:bitstring_to_term(SkLearn_B),
% 			SkList = case maps:find(Id, SkMap) of
% 				{ok, ListSk} -> ListSk;
% 				_ -> []
% 			end,
% 			WeaponSt = case maps:find(Id, EquipMap) of
% 				{ok, ListEquip} -> 
% 					case lists:keyfind(1, 1, ListEquip) of
% 						{1, WId} -> WId;
% 						_ -> 0
% 					end;
% 				_ -> 0
% 			end,
% 			case data_partner:get_partner_by_id(PartnerId) of
% 				PartnerCfg when is_record(PartnerCfg, base_partner), length(TotalAttr)>0, length(AttrQuality)>0 ->
% 					Partner = lib_partner_util:make_record({Id, PlayerId, PartnerId, Lv, Exp, BreakSt, Break, State, Pos, AttrQuality, TotalAttr, Prodigy, AptiTake, SkLearn, SkList, WeaponSt}, PartnerCfg),
% 					make_partners(T, PlayerId, SkMap, EquipMap, [Partner|PartnerList]);
% 				_ -> 
% 					make_partners(T, PlayerId, SkMap, EquipMap, PartnerList)
% 			end;
% 		_ ->
% 			make_partners(T, PlayerId, SkMap, EquipMap, PartnerList)
% 	end.

% init_partners([], Map) -> Map;
% init_partners([Partner|T], Map) ->
% 	ValueList = [
% 		{attribute},
% 		{combat_power}
% 	],
% 	NewPartner = lib_partner_util:set_partner_value(Partner, ValueList),
% 	NewMap = maps:put(NewPartner#partner.id, NewPartner, Map),
% 	init_partners(T, NewMap).

% % 初始化伙伴技能
% init_partner_sk([], Map) -> Map;
% init_partner_sk([H|T], Map) ->
% 	case H of
% 		[Id, SkId, Lv, Pos] -> 
% 			case maps:find(Id, Map) of
% 				{ok, List} ->
% 					case lists:keyfind(SkId, 1, List) of
% 						false -> 
% 							NewList = [{SkId, Lv, Pos}|List],
% 							NewMap = maps:put(Id, NewList, Map),
% 							init_partner_sk(T, NewMap);
% 						_ ->
% 							init_partner_sk(T, Map)
% 					end;
% 				_ ->
% 					NewList = [{SkId, Lv, Pos}],
% 					NewMap = maps:put(Id, NewList, Map),
% 					init_partner_sk(T, NewMap)
% 			end;
% 		_ ->
% 			init_partner_sk(T, Map)
% 	end.

% % 初始化伙伴专属武器
% init_partner_equip([], Map) -> Map;
% init_partner_equip([H|T], Map) ->
% 	case H of
% 		[Id, Type, Weapon] -> 
% 			case maps:find(Id, Map) of
% 				{ok, List} ->
% 					case lists:keyfind(Type, 1, List) of
% 						false -> 
% 							NewList = [{Type, Weapon}|List],
% 							NewMap = maps:put(Id, NewList, Map),
% 							init_partner_equip(T, NewMap);
% 						_ ->
% 							init_partner_equip(T, Map)
% 					end;
% 				_ ->
% 					NewList = [{Type, Weapon}],
% 					NewMap = maps:put(Id, NewList, Map),
% 					init_partner_equip(T, NewMap)
% 			end;
% 		_ ->
% 			init_partner_equip(T, Map)
% 	end.

% % 删除伙伴
% delete_partners(PartnerList) ->
% 	Fun = fun(Partner, {I, Acc}) when I==1 -> 
% 			{I+1, lists:append(Acc, integer_to_list(Partner#partner.id))};
% 		(Partner, {I, Acc}) ->
% 			{I+1, lists:append(Acc, ","++integer_to_list(Partner#partner.id))}
% 	end,
% 	{_I, IdList} = lists:foldl(Fun, {1, ""}, PartnerList),
% 	Sql = io_lib:format(?SQL_PARTNER_DELETE, [IdList]),
% 	db:execute(Sql),
% 	Sql1 = io_lib:format(?SQL_PARTNER_SK_DELETE, [IdList]),
% 	db:execute(Sql1),
% 	Sql2 = io_lib:format(?SQL_PARTNER_EQUIP_DELETE, [IdList]),
% 	db:execute(Sql2).

% % 新增伙伴
% add_partner(Partner) ->
% 	#partner{
% 		id = Id,
% 		player_id = PlayerId,
% 		partner_id = PartnerId,
% 		state = State,
% 		pos = Pos,				
% 		break_st = BreakSt,				
% 		break = BreakList,					
% 		lv = Lv,						
% 		exp = Exp,					
% 		apti_take = AptiTake,				 
% 		skill_learn = SkLearn,			
% 		attr_quality = AttrQuality,	
% 		total_attr = TotalAttr,		
% 		prodigy = Prodigy 	
% 	} = Partner,	
% 	BreakList_B = util:term_to_bitstring(BreakList),		
% 	AttrQuality_B = util:term_to_bitstring(AttrQuality),
% 	AptiTake_B = util:term_to_bitstring(AptiTake),
% 	TotalAttr_B = util:term_to_bitstring(TotalAttr),
% 	SkLearn_B = util:term_to_bitstring(SkLearn),
% 	Sql = io_lib:format(?SQL_PARTNER_INSERT, [Id, PlayerId,PartnerId,Lv,Exp,BreakSt,BreakList_B,State,Pos,AttrQuality_B,TotalAttr_B,Prodigy,AptiTake_B,SkLearn_B]),
% 	db:execute(Sql).

% % 更新伙伴列表的属性、技能、武器
% update_partner_list(PartnerList) when length(PartnerList)>0 ->
% 	update_partner_list_info(PartnerList),
% 	update_partner_sk_info(PartnerList),
% 	update_partner_equip_info(PartnerList);
% update_partner_list(_PartnerList) -> ok.

% % 更新玩家的伙伴状态
% update_player_partner(PartnerSt) ->
% 	#partner_status{
% 		pid = PlayerId,
% 		recruit_type1 = {CoinTms, CoinEt}, 
% 		recruit_type2 = {GoldTms, GoldEt}, 
% 		embattle = Embattle,
% 		recruit_list = RecruitList
% 	} = PartnerSt,
% 	EmbattleList = lib_partner_util:conver_to_embattle_list(Embattle, []),
% 	Embattle_B = util:term_to_bitstring(EmbattleList),
% 	RecruitList_B = util:term_to_bitstring(RecruitList),
	
% 	Sql = io_lib:format(?SQL_PLAYER_PARTNER_REPLACE, [PlayerId, CoinTms, CoinEt, GoldTms, GoldEt, Embattle_B, RecruitList_B]),
% 	%?PRINT("update_player_partner ~s~n", [Sql]),
% 	db:execute(Sql).

% % 更新四围属性
% update_partner_attr(Partner) ->
% 	#partner{id = Id, total_attr = Attr} = Partner,
% 	AttrList_B = util:term_to_bitstring(Attr),	
% 	Sql = io_lib:format(<<"update `partner` set total_attr='~s' where id=~p ">>, [AttrList_B, Id]),
% 	%?PRINT("update_partner_attr ~s~n", [Sql]),
% 	db:execute(Sql).

% % 更新突破状态
% update_partner_break(BreakSt, BreakList, Partner) ->
% 	#partner{id = Id, total_attr = Attr} = Partner,
% 	BreakList_B = util:term_to_bitstring(BreakList),
% 	AttrList_B = util:term_to_bitstring(Attr),	
% 	Sql = io_lib:format(<<"update `partner` set break_st=~p, break='~s', total_attr='~s' where id=~p">>, [BreakSt, BreakList_B, AttrList_B, Id]),
% 	db:execute(Sql).

% % 更新伙伴的资质丹服用数量
% update_partner_promote(Partner) ->
% 	#partner{id = Id, player_id = PlayerId, apti_take = AptiTake, total_attr = Attr, skill = Sk} = Partner,
% 	update_partner_pos_sk(?ASSIST, Sk, Id, PlayerId),
% 	AptiTake_B = util:term_to_bitstring(AptiTake),	
% 	AttrList_B = util:term_to_bitstring(Attr),
% 	Sql = io_lib:format(<<"update `partner` set total_attr='~s', apti_take='~s' where id=~p">>, [AttrList_B, AptiTake_B, Id]),
% 	db:execute(Sql).

% % 更新伙伴学习的技能列表
% update_partner_learn_sk(Partner, Pos) ->
% 	#partner{id = Id, player_id = PlayerId, skill_learn = SkLearn, skill = Sk} = Partner,
% 	update_partner_pos_sk(Pos, Sk, Id, PlayerId),
% 	update_partner_pos_sk(?ASSIST, Sk, Id, PlayerId),
% 	SkLearn_B = util:term_to_bitstring(SkLearn),	
% 	Sql = io_lib:format(<<"update `partner` set skill_learn='~s' where id=~p">>, [SkLearn_B, Id]),
% 	%?PRINT("update_partner_learn_sk ~s~n", [Sql]),
% 	db:execute(Sql).

% % 更新伙伴上下阵状态
% update_partner_battle_sleep(Partner) ->
% 	?PRINT("update_partner_battle_sleep ~n", []),
% 	#partner{id = Id, state = State, pos = Pos} = Partner,
% 	Sql = io_lib:format(<<"update `partner` set state=~p, pos=~p where id=~p ">>, [State, Pos, Id]),
% 	%?PRINT("update_partner_battle_sleep ~s~n", [Sql]),
% 	db:execute(Sql).

% % 更新布阵
% update_partner_embattle(PartnerSt) ->
% 	#partner_status{pid = PlayerId, embattle = Embattle} = PartnerSt,
% 	EmbattleList = lib_partner_util:conver_to_embattle_list(Embattle, []),
% 	Embattle_B = util:term_to_bitstring(EmbattleList),
% 	Sql = io_lib:format(<<"update `player_partner` set embattle='~s' where id=~p ">>, [Embattle_B, PlayerId]),
% 	%?PRINT("update_partner_embattle ~s~n", [Sql]),

% %% 同步在线玩家布置信息 add by xiaoxiang 2017/04/13
% 	%% lib_online_api:set_online_info(PlayerId, [{embattle, EmbattleList}]),
	
% 	db:execute(Sql).

% % 更新伙伴专属武器
% update_partner_weapon(PlayerId, RecruitList, PartnerList) ->
% 	update_partner_equip_info(PartnerList),
% 	RecruitList_B = util:term_to_bitstring(RecruitList),
% 	Sql = io_lib:format(<<"update `player_partner` set recruit_list='~s' where id=~p ">>, [RecruitList_B, PlayerId]),
% 	db:execute(Sql).

% % 更新伙伴的技能
% update_partner_pos_sk(Pos, Sk, PartnerId, PlayerId) ->
% 	{SkId, Lv, Pos} = lists:keyfind(Pos, 3, Sk#partner_skill.skill_list),
% 	Sql = io_lib:format(<<"replace into `partner_sk` set id=~p, player_id=~p, sk_id=~p, lv=~p, pos=~p ">>, [PartnerId, PlayerId, SkId, Lv, Pos]),
% 	%?PRINT("update_partner_pos_sk ~s~n", [Sql]),
% 	db:execute(Sql).


% update_partner_list_info(PartnerList) ->
% 	SqlValues = format_partners_values(PartnerList, [], 1),
% 	Sql = ?SQL_BATCH_REPLACE_PARTNER ++ SqlValues,
% 	%?PRINT("update_partner_list_info ~s~n", [Sql]),
% 	db:execute(Sql).

% update_partner_sk_info(PartnerList) ->
% 	Fun = fun(Partner, {I, Acc}) when I==1 -> 
% 			{I+1, lists:append(Acc, integer_to_list(Partner#partner.id))};
% 		(Partner, {I, Acc}) ->
% 			{I+1, lists:append(Acc, ","++integer_to_list(Partner#partner.id))}
% 	end,
% 	{_I, IdList} = lists:foldl(Fun, {1, ""}, PartnerList),
% 	SqlDelete = io_lib:format(?SQL_PARTNER_SK_DELETE, [IdList]),
% 	db:execute(SqlDelete),
% 	SqlValues = format_sk_values(PartnerList, [], 1),
% 	Sql = ?SQL_PARTNER_SKILL_REPLACE ++ SqlValues,
% 	%?PRINT("update_partner_sk_info ~s~n", [Sql]),
% 	db:execute(Sql).


% update_partner_equip_info(PartnerList) ->
% 	case format_equip_values(PartnerList, [], 1) of
% 		SqlValues when length(SqlValues) > 0 ->
% 			Sql = ?SQL_PARTNER_EQUIP_REPLACE ++ SqlValues,
% 			%?PRINT("update_partner_equip_info ~s~n", [Sql]),
% 			db:execute(Sql);
% 		[] -> ok
% 	end.

% update_partners_pos(PartnerList) ->
% 	F = fun(Partner) ->
% 		Sql = io_lib:format(<<"update `partner` set pos=~p where id=~p ">>, [Partner#partner.pos, Partner#partner.id]),
% 		db:execute(Sql)
% 	end,
% 	lists:foreach(F, PartnerList).


% format_partners_values([], List, _Num) ->
% 	List;
% format_partners_values([Partner|T], List, Num) ->
% 	#partner{
% 		id = Id,
% 		player_id = PlayerId,
% 		partner_id = PartnerId,
% 		state = State,
% 		pos = Pos,				
% 		break_st = BreakSt,				
% 		break = BreakList,					
% 		lv = Lv,						
% 		exp = Exp,					
% 		apti_take = AptiTake,				 
% 		skill_learn = SkLearn,			
% 		attr_quality = AttrQuality,	
% 		total_attr = TotalAttr,	
% 		prodigy = Prodigy 	
% 	} = Partner,
% 	BreakList_B = util:term_to_bitstring(BreakList),		
% 	AttrQuality_B = util:term_to_bitstring(AttrQuality),
% 	TotalAttr_B = util:term_to_bitstring(TotalAttr),
% 	AptiTake_B = util:term_to_bitstring(AptiTake),
% 	SkLearn_B = util:term_to_bitstring(SkLearn),
% 	Value = io_lib:format(?SQL_BATCH_REPLACE_VALUES, [Id,PlayerId,PartnerId,Lv,Exp,BreakSt,BreakList_B,State,Pos,AttrQuality_B,TotalAttr_B,Prodigy,AptiTake_B,SkLearn_B]),
% 	if
% 		Num =:= 1 ->			
% 			NewList = Value ++ List;
% 		true ->
% 			NewList = Value ++ "," ++ List
% 	end,
% 	format_partners_values(T, NewList, Num+1).

% format_sk_values([], List, _Num) ->
% 	List;
% format_sk_values([Partner|T], List, Num) ->
% 	#partner{id = Id, player_id = PlayerId, skill = Sk} = Partner,
% 	SkList = Sk#partner_skill.skill_list,				
% 	F = fun({SkId, SkLv, SkPos}, {Values, Num1}) ->
% 		Value = io_lib:format(?SQL_BATCH_SKS_VALUES, [Id, PlayerId, SkId, SkLv, SkPos]),
% 		if
% 			Num1 =:= 1 ->			
% 				NewValues = Value ++ Values;
% 			true ->
% 				NewValues = Value ++ "," ++ Values
% 		end,
% 		{NewValues, Num1+1}
% 	end,
% 	{NewList, NewNum} = lists:foldl(F, {List, Num}, SkList),
% 	format_sk_values(T, NewList, NewNum).

% format_equip_values([], List, _Num) ->
% 	List;
% format_equip_values([Partner|T], List, Num) ->
% 	Id = Partner#partner.id,
% 	PlayerId = Partner#partner.player_id,
% 	WeaponSt = Partner#partner.equip#partner_equip.weapon_st,
% 	if
% 		Num =:= 1 andalso WeaponSt > 0 ->	
% 			Value = io_lib:format(?SQL_BATCH_EQUIPS_VALUES, [Id, PlayerId, 1, WeaponSt]),		
% 			NewList = Value,
% 			format_equip_values(T, NewList, Num+1);
% 		Num =:= 1 ->
% 			format_equip_values(T, List, Num);
% 		WeaponSt > 0 ->
% 			Value = io_lib:format(?SQL_BATCH_EQUIPS_VALUES, [Id, PlayerId, 1, WeaponSt]),
% 			NewList = Value ++ "," ++ List,
% 			format_equip_values(T, NewList, Num+1);
% 		true ->
% 			format_equip_values(T, List, Num+1)
% 	end.

% %% ---------------------------- 协议相关  ----------------------------

% % 获取伙伴列表
% get_player_partners(PartnerSt) ->
% 	PartnerList = maps:values(PartnerSt#partner_status.partners),
% 	get_player_partners(PartnerList, []).

% get_player_partners([] , Return) -> Return;
% get_player_partners([Partner|T] = Value, Return) when Value =/= [] ->
% 	Item = {
% 		Partner#partner.id,
% 		Partner#partner.partner_id,	
% 		Partner#partner.lv,
% 		Partner#partner.state,
% 		Partner#partner.pos,
% 		round(Partner#partner.combat_power),
% 		Partner#partner.prodigy,
% 		Partner#partner.equip#partner_equip.weapon_st
% 	},
% 	get_player_partners(T, [Item|Return]).

% % 获取伙伴基础信息
% get_partner_base_info(PartnerSt, Id) ->	
% 	case maps:find(Id, PartnerSt#partner_status.partners) of
% 		{ok, Partner} -> get_partner_base_info(Partner);
% 		_ -> [?ERRCODE(err412_partner_not_exist),0,0,0,0,0,0,[],[],0,0,0]
% 	end.

% get_partner_base_info(Partner) ->
% 	#partner{
% 		id = Id,
% 		partner_id = PartnerId,	
% 		%quality = Quality,		
% 		break_st = BreakSt,									
% 		lv = Lv,						
% 		exp = Exp,								
% 		skill = PartnerSk,	
% 		equip = Equip,	
% 		combat_power = CombatPower,
% 		prodigy = Prodigy 	
% 	} = Partner,
% 	#base_partner_upgrade{max_exp = MaxExp} = data_partner:get_lv_upgrade(Lv),
% 	%ClientGoodsL = get_wash_goods_list(Quality),
% 	ClientAttrL = get_rsp_attr_list(Partner),
% 	ClientSkL = get_rsp_sk_list(PartnerSk#partner_skill.skill_list, []),
% 	EquipSt = Equip#partner_equip.weapon_st,
% 	[1, Id, PartnerId, Lv, Exp, MaxExp, BreakSt, ClientAttrL, ClientSkL, EquipSt, round(CombatPower), Prodigy].

% get_rsp_attr_list(#partner{attr_quality = AttrQuality, total_attr = TotalAttr}) ->
% 	F = fun({Type, AttrQ}, {Attr, AttrList}) ->
% 		case lists:keyfind(Type, 1, Attr) of
% 			false -> {Attr, AttrList};
% 			{Type, CurVal, UpperVal} ->
% 				{Attr, [{Type, round(CurVal), round(UpperVal), AttrQ}|AttrList]}
% 		end
% 	end,
% 	{_, ClientAttrL} = lists:foldl(F, {TotalAttr, []}, AttrQuality),
% 	ClientAttrL.

% get_rsp_sk_list([], List) -> List;
% get_rsp_sk_list([{SkID, SkLv, ?COM_ATTACK}|T], List) ->
% 	get_rsp_sk_list(T, [{0, SkID, SkLv, ?COM_ATTACK}|List]);
% get_rsp_sk_list([{SkID, SkLv, ?ASSIST}|T], List) ->
% 	get_rsp_sk_list(T, [{0, SkID, SkLv, ?ASSIST}|List]);
% get_rsp_sk_list([{SkID, SkLv, ?TALENT}|T], List) ->
% 	get_rsp_sk_list(T, [{0, SkID, SkLv, ?TALENT}|List]);
% get_rsp_sk_list([{SkID, SkLv, Pos}|T], List) ->
% 	case data_partner:get_skill_by_skid(SkID) of
% 		[{SkBookId, _, _, _}|_L] -> 
% 			get_rsp_sk_list(T, [{SkBookId, SkID, SkLv, Pos}|List]);
% 		_ -> 
% 			get_rsp_sk_list(T, List)			
% 	end.

% send_msg_41209(Sid, TenRecruit, CostType, PartnerList, RewardList, Res) ->
% 	%PartRsp = lib_partner_do:get_player_partners(PartnerList, []),
% 	F = fun(Partner, List) -> 
% 		[{Partner#partner.id, Partner#partner.partner_id,
% 			Partner#partner.lv, Partner#partner.state,
% 			Partner#partner.pos, round(Partner#partner.combat_power),
% 			Partner#partner.prodigy, Partner#partner.equip#partner_equip.weapon_st}|List]
% 	end,
% 	PartRsp = lists:foldl(F, [], PartnerList),
% 	Rsp = [Res, TenRecruit, CostType, PartRsp, RewardList],
% 	{ok, BinData} = pt_412:write(41209, Rsp),
% 	lib_server_send:send_to_sid(Sid, BinData).

% wash_partner_rsp(Partner, NewPartner) ->
% 	#partner{																
% 		skill = PartnerSk1,	
% 		prodigy = Prodigy1,
% 		combat_power = Combat1 	
% 	} = Partner,
% 	#partner{																
% 		skill = PartnerSk2,	
% 		prodigy = Prodigy2,
% 		combat_power = Combat2 	
% 	} = NewPartner,
% 	ClientAttrL1 = get_rsp_attr_list(Partner),
% 	ClientAttrL2 = get_rsp_attr_list(NewPartner),
% 	ClientSkL1 = get_rsp_sk_list(PartnerSk1#partner_skill.skill_list, []),
% 	ClientSkL2 = get_rsp_sk_list(PartnerSk2#partner_skill.skill_list, []),
% 	Partners = [{0, round(Combat1), Prodigy1, ClientAttrL1, ClientSkL1}, 
% 		{1, round(Combat2), Prodigy2, ClientAttrL2, ClientSkL2}],
% 	[1, Partners].


% send_daily_recruit_times(PlayerStatus, TenRecruit) ->
% 	#base_daily{limit = Limit} = data_daily:get_id(?MOD_PARTNER, ?DAILY_RECRUIT_TIMES),
% 	#player_status{id = RoleId, sid = Sid} = PlayerStatus,
% 	if 
% 		TenRecruit >= 1 -> 
% 			mod_daily:plus_count(RoleId, ?MOD_PARTNER, ?DAILY_RECRUIT_TIMES, 10);		
% 		true ->
% 			mod_daily:plus_count(RoleId, ?MOD_PARTNER, ?DAILY_RECRUIT_TIMES, 1)
% 	end,
% 	RecruitTimes = mod_daily:get_count(RoleId, ?MOD_PARTNER, ?DAILY_RECRUIT_TIMES),
% 	{ok, BinData} = pt_412:write(41240, [Limit, RecruitTimes]),
% 	lib_server_send:send_to_sid(Sid, BinData).

