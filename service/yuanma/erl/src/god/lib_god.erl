%%%------------------------------------
%%% @Module  : lib_god
%%% @Author  : zengzy
%%% @Created : 2018-2-27
%%% @Description: 变身系统
%%%------------------------------------

-module(lib_god).

-export([

]).
-compile(export_all).
-include("god.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("predefine.hrl").
-include("relationship.hrl").
-include("def_module.hrl").
-include("rec_offline.hrl").
-include("def_event.hrl").
-include("def_fun.hrl").
-include("def_goods.hrl").
-include("attr.hrl").
-include("skill.hrl").

%% ---------------------------------- 登录加载 -----------------------------------
login(RoleId) ->
	case lib_god_util:db_role_select(RoleId) of
		[] ->
			StatusGod = #status_god{battle = [{1, 0}]},
			lib_god_util:db_role_replace(RoleId, StatusGod),
			StatusGod;
		[Battle, _Trans] ->
			TermBattle = util:bitstring_to_term(Battle),
			StatusGod = #status_god{battle = TermBattle}
	end,
	NewStatusGod = init_god_summon(StatusGod),
	init_db_god(NewStatusGod, RoleId).

reLogin(PS) ->
	#player_status{god = #status_god{summon = Summon}, id = RoleId}= PS,
	case lib_god_util:db_role_select(RoleId) of
		[] ->
			StatusGod = #status_god{battle = [{1, 0}]},
			lib_god_util:db_role_replace(RoleId, StatusGod),
			StatusGod;
		[Battle, _Trans] ->
			TermBattle = util:bitstring_to_term(Battle),
			StatusGod = #status_god{battle = TermBattle}
	end,
	StatusGod1 = StatusGod#status_god{summon = Summon},
	StatusGod2 = init_db_god(StatusGod1, RoleId),
	PS#player_status{god = StatusGod2}.


off_login(Ps) ->
	#player_status{id = RoleId, off = Off} = Ps,
	case lib_god_util:db_role_select(RoleId) of
		[] ->
			StatusGod = #status_god{battle = [{1, 0}]},
			lib_god_util:db_role_replace(RoleId, StatusGod),
			StatusGod;
		[Battle, _Trans] ->
			TermBattle = util:bitstring_to_term(Battle),
			StatusGod = #status_god{battle = TermBattle}
	end,
	NewStatusGod = init_god_summon(StatusGod),
	StatusGod1 = init_db_god(NewStatusGod, RoleId, Off#status_off.goods_status),
	Ps#player_status{god = StatusGod1}.


%%初始化元神召唤
init_god_summon(StatusGod) ->
	GodSummon = case lib_god_api:get_enter_battle(StatusGod) of
		[] ->
			#god_summon{start_time = utime:unixtime()};
		_ ->
			%%用于登录立即可以降神
			#god_summon{start_time = utime:unixtime()}  %%
	end,
	StatusGod#status_god{summon = GodSummon}.

%%元神初始化
init_db_god(StatusGod, RoleId, GoodsStatus) ->
	case lib_god_util:db_god_select(RoleId) of
		[] ->
%%			?MYLOG("cym", "StatusGod ~p~n", [StatusGod]),
			StatusGod#status_god{god_stren = #god_stren{}};
		List ->
%%			GoodsStatus = lib_goods_do:get_goods_status(),
			#goods_status{dict = GoodsDict} = GoodsStatus,
			EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_GOD2_EQUIP, GoodsDict),
			GodList = init_god(List, RoleId, [], EquipGoodsList),
			{Attr, _SkPower, NewGodList} = calc_power(GodList, 0, [], 0, []),
			StatusGod1 = StatusGod#status_god{god_list = NewGodList, attr = Attr},
			GodStren = init_god_stren(RoleId),
			StatusGod1#status_god{god_stren = GodStren}
%%			StatusGod2 = lib_god_api:get_god_scene_skill(StatusGod1),
%%			StatusGod2
	end.

%%元神初始化
init_db_god(StatusGod, RoleId) ->
	case lib_god_util:db_god_select(RoleId) of
		[] ->
%%			?MYLOG("cym", "StatusGod ~p~n", [StatusGod]),
			StatusGod#status_god{god_stren = #god_stren{}};
		List ->
			GoodsStatus = lib_goods_do:get_goods_status(),
			#goods_status{dict = GoodsDict} = GoodsStatus,
			EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_GOD2_EQUIP, GoodsDict),
			GodList = init_god(List, RoleId, [], EquipGoodsList),
			{Attr, _SkPower, NewGodList} = calc_power(GodList, 0, [], 0, []),
			StatusGod1 = StatusGod#status_god{god_list = NewGodList, attr = Attr},
			GodStren = init_god_stren(RoleId),
			StatusGod1#status_god{god_stren = GodStren}
%%			StatusGod2 = lib_god_api:get_god_scene_skill(StatusGod1),
%%			StatusGod2
	end.

%%组合元神
init_god([], _RoleId, GodList, _EquipGoodsList) ->
	GodList;
init_god([Info | T], RoleId, GodList, EquipGoodsList) ->
	[GodId, Lv, Exp, Grade, Star, Pos] = Info,
	EquipList = calc_equip_list(GodId, EquipGoodsList),
	EquipAttr = calc_equip_attr(EquipList),
	God = #god{id = GodId, lv = Lv, exp = Exp, grade = Grade, pos = Pos, star = Star, equip_list = EquipList, equip_attr = EquipAttr},
%%	{_, Power} = calc_god_power(0, God),
	init_god(T, RoleId, [God | GodList], EquipGoodsList).
%%	GodCfg = data_god:get_god(GodId),
%%	case is_record(GodCfg, base_god) of
%%		true->
%%			NGod = case lib_god_util:db_skill_select(RoleId,GodId) of
%%				[] -> calc_god_attr(God#god{skill=#god_skill{}});
%%				List ->
%%					Skill = init_skill(List,#god_skill{}),
%%					Skill1 = init_talent_skill(Skill, GodId, Grade),
%%					#base_god{skill=CfgSkill} = data_god:get_god(GodId),
%%					#god_skill{self_skill=SelfSkill} = Skill1,
%%					SortSelfSkill = sort_skill(CfgSkill,SelfSkill,[]),
%%					NSkill = Skill1#god_skill{self_skill=SortSelfSkill},
%%					calc_god_attr(God#god{skill=NSkill})
%%			end,
%%			init_god(T,RoleId,[NGod|GodList]);
%%		false-> init_god(T,RoleId,GodList)
%%	end.

%%技能初始化
init_skill([], GodSkill) ->
	GodSkill;
init_skill([[SkillId, Type, SkillLv, Exp] | T], #god_skill{talent_skill = _TSkill, self_skill = SSkill} = GodSkill) ->
	case Type =< 0 of
		true ->
			% NTSkill = [{SkillId,SkillLv,Exp}|TSkill],
			% init_skill(T,GodSkill#god_skill{talent_skill=NTSkill}),
			init_skill(T, GodSkill);
		false ->
			NSSkill = [{SkillId, SkillLv, Exp} | SSkill],
			init_skill(T, GodSkill#god_skill{self_skill = NSSkill})
	end.

%%天赋技能初始化
init_talent_skill(Skill, _GodId, Grade) when Grade < 0 ->
	Skill;
init_talent_skill(Skill, GodId, Grade) ->
	{NSkill, _} = talent_skill_active(GodId, Grade, Skill),
	init_talent_skill(NSkill, GodId, Grade - 1).

%%自身技能排序,根据配置（普攻-》技能1-》技能2。。。）
sort_skill([], _SelfSkill, SkillList) ->
	lists:reverse(SkillList);
sort_skill([SkillId | T], SelfSkill, SkillList) ->
	case lists:keyfind(SkillId, 1, SelfSkill) of
		false ->
			sort_skill(T, SelfSkill, [{SkillId, 1, 0} | SkillList]); %兼容配置
		{_SId, _SLv, _SExp} = Info ->
			sort_skill(T, SelfSkill, [Info | SkillList]);
		_ ->
			sort_skill(T, SelfSkill, [{SkillId, 1, 0} | SkillList]) %兼容配置
	end.

init_god_stren(RoleId) ->
	case lib_god_util:db_god_stren_select(RoleId) of 
		[] -> #god_stren{};
		DbList ->
			StrenList = [#god_stren_item{god_type = GodType, level = Level, exp = Exp} ||[GodType, Level, Exp] <- DbList],
			GodStren = #god_stren{stren_list = StrenList},
			count_god_stren_attr(GodStren)
	end.


%% ---------------------------------- 界面展示相关 -----------------------------------
%%元神列表
show_god_list(PS) ->
	#player_status{sid = Sid, god = StatusGod} = PS,
	#status_god{trans = _Trans, god_list = GodList, battle = Battle} = StatusGod,
%%	BattlePosList = [Pos || {Pos, _} <- Battle],
	SendList = show_god_list_help(GodList, Battle, [], PS),
%%	TransSkill = lib_god_api:get_trans_common_skills(Trans,[]),
%%	F = fun({SkillId,SkillLv,_Exp}, List)->
%%		case data_skill:get(SkillId, SkillLv) of
%%			#skill{type = Type} when Type == ?SKILL_TYPE_ACTIVE->
%%				[{SkillId,SkillLv}|List];
%%			_-> List
%%		end
%%	end,
%%	TmpActiveSkill = lists:foldl(F,[],TransSkill),
%%	ActiveSkill = case TmpActiveSkill == [] of
%%		true-> TmpActiveSkill;
%%		false ->
%%			{SkillId,SkillLv} = hd(TmpActiveSkill),
%%			[{SkillId,SkillLv}]
%%	end,
	% ?PRINT("~p:~p:~p~n",[Trans,ActiveSkill,SendList]),
%%	?MYLOG("cym", "SendList ~p~n", [SendList]),
	{ok, BinData} = pt_440:write(44000, [SendList]),
	lib_server_send:send_to_sid(Sid, BinData).

%%元神信息
show_god_info(PS, GodId) ->
	#player_status{sid = Sid, god = StatusGod} = PS,
	#status_god{battle = Battle, god_list = GodList} = StatusGod,
	case lists:keyfind(GodId, #god.id, GodList) of
		false ->
			skip;
		God ->
			[Info | _T] = show_god_list_help([God], Battle, [], PS),
			{IsBattle, GodId, Lv, Exp, Grade, Star, Power, EquipList} = Info,
			% ?PRINT("~p~n",[Info]),
			{ok, BinData} = pt_440:write(44001, [IsBattle, GodId, Lv, Exp, Grade, Star, Power, EquipList]),
			lib_server_send:send_to_sid(Sid, BinData)
	end.

show_god_list_help([], _Battle, List, _PS) ->
	List;
show_god_list_help([God | T], Battle, List, PS) ->
	#god{id = GodId, lv = Lv, exp = Exp, grade = Grade, skill = _Skill, star = Star, equip_list = EquipList} = God,
	SendEquipList = [{Pos, AutoId} || {Pos, AutoId, _GoodsId} <- EquipList],
	Power = get_god_power(PS, GodId),
%%	?MYLOG("cym", "GodId ~p  Power ~p~n", [GodId, Power]),
	Info = {is_battle(GodId, Battle), GodId, Lv, Exp, Grade, Star, Power, SendEquipList},
	show_god_list_help(T, Battle, [Info | List], PS).


%% ---------------------------------- 元神操作 -----------------------------------
%%激活元神
active_god(PS, GodId) ->
	#player_status{id = RoleId, figure = #figure{lv = Lv, name = Name}, god = StatusGod, sid = Sid} = PS,
	#status_god{trans = Trans, battle = _Battle, god_list = GodList} = StatusGod,
	GodCfg = data_god:get_god(GodId),
	CheckList = [
		{check_lv, Lv},
		{check_cfg, GodCfg, base_god},
		{check_active, GodId, GodList},
		{check_active_cost, GodCfg, PS},
		{check_active_lv, GodCfg, PS},
		{check_active_all_lv, GodCfg, PS}
	],
	case lib_god_util:checklist(CheckList) of
		true ->
			#base_god{skill = _Skill, name = GodName, condition = Cost, color = GodColor} = GodCfg,
			case lib_goods_api:cost_object_list(PS, Cost, god_active, "god_active") of
				{true, NPS} ->
					God = #god{id = GodId},
					NGodList = [God | GodList],
					{Attr, _SkPower, NGodList1} = calc_power(NGodList, Trans, [], 0, []),
					NStatusGod = StatusGod#status_god{god_list = NGodList1, attr = Attr},
%%					NStatusGod1 = lib_god_api:get_god_scene_skill(NStatusGod),
					NPS1 = NPS#player_status{god = NStatusGod},
					lib_god_util:db_god_replace(RoleId, God),
					LastPS = lib_player:count_player_attribute(NPS1),
					lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
%%					skill_update_to_scene(Pos, LastPS),
					Power = get_god_power(LastPS, GodId),
					{ok, BinData} = pt_440:write(44002, [?SUCCESS, Power, GodId]),
					lib_server_send:send_to_sid(Sid, BinData),
					mod_scene_agent:update(LastPS, [{battle_attr, LastPS#player_status.battle_attr}]),
					lib_chat:send_TV({all}, ?MOD_GOD, 1, [Name, GodColor, GodName]),
					%%如果是第一个激活的降神默认出战
					if
						GodList == [] ->
							case pp_god:handle(44006, LastPS, [1, GodId]) of
								{ok, LastPS1} ->
									ok;
								_ ->
									LastPS1 = LastPS
							end;
						true ->
							LastPS1 = LastPS
					end,
					lib_god_util:log_active(RoleId, GodId),
					{true, LastPS1};
				{false, Err, _} ->
					{false, Err}
			end;
		{false, Err} ->
			{false, Err}
	end.

%%喂养元神
feed(PS, _GodId, []) ->
	{true, PS};
feed(PS, GodId, [{GoodsId, CostExp} | GoodsList]) ->
	#player_status{figure = #figure{lv = _Lv}, god = StatusGod, sid = Sid, id = RoleId} = PS,
	#status_god{god_list = GodList} = StatusGod,
	case lists:keyfind(GodId, #god.id, GodList) of
		false ->
			{false, ?ERRCODE(err440_not_active)};
		#god{lv = GLv, exp = Exp, id = GodId} = God ->
			{Code, NewPlayer} =
				case lib_god_util:check_update_lv(GLv, GodId) of % 判断是否可以升级
					{true, MaxExp} ->
						[{_GoodsId, OwnNum}] = lib_goods_api:get_goods_num(PS, [GoodsId]),
						case OwnNum > 0 of
							true ->
%%								?MYLOG("cym", "MaxExp ~p  Exp ~p", [MaxExp, Exp]),
								NeedExp = MaxExp - Exp, % 升级所需的消耗数量
								{RealCostNum, NewLv, NewExp} = god_lv_cost(NeedExp, CostExp, OwnNum, GLv, Exp, MaxExp),
								Cost = [{?TYPE_GOODS, GoodsId, RealCostNum}],
								case lib_goods_api:cost_object_list_with_check(PS, Cost, god_lv_update, "") of
									{true, NewPlayerTmp} -> % 物品满足条件扣除
										{TempCode, TempPlayer, TempLv, TempExp} = do_upgrade_lv(NewPlayerTmp, NewLv, NewExp, God),
										lib_log_api:log_god_lv_up(RoleId, GodId, GLv, TempLv, Exp, TempExp, Cost),
										{TempCode, TempPlayer};
									{false, 1003, NewPlayerTmp} -> % 物品不足
										{?ERRCODE(err440_not_enough_cost), NewPlayerTmp};
									{false, ErrorCode, NewPlayerTmp} ->
										{ErrorCode, NewPlayerTmp}
								end;
							false ->
								{?ERRCODE(err440_not_enough_cost), PS}
						end;
					{fail, ErrorCode} ->
						{ErrorCode, PS}
				end,
			{LastLv, LastExp} = get_lv(GodId, NewPlayer), %%等级经验
			lib_god_util:db_god_update(?sql_god_lv_update, [LastLv, LastExp, RoleId, GodId]),
			case GLv =/= LastLv orelse Code =:= ?ERRCODE(err440_max_lv) of  %%没有升级
				true ->  %%当已经升级  或  达到最高等级、物品配置
					%%更新战力
					LastPS = update_god_power(NewPlayer),
					case is_integer(Code) of
						true ->
%%							?MYLOG("cym", "44003  ~p ~n", [GLv]),
%%							?MYLOG("cym", "44003  ~p ~n", [{Code, GodId, LastLv, LastExp}]),
							Power = get_god_power(LastPS, GodId),
%%							?MYLOG("cym", "44003  Power ~p ~n", [Power]),
							{ok, BinData1} = pt_440:write(44003, [Code, GodId, LastLv, LastExp, Power]),
							lib_server_send:send_to_sid(Sid, BinData1);
						false ->
							skip
					end,
					{true, LastPS};
				false -> % 当没有升级
%%					?MYLOG("cym", "44003  ~p ~n", [{Code, GodId, LastLv, LastExp, God#god.power}]),
					Power = get_god_power(NewPlayer, GodId),
					case GoodsList == [] orelse Code == ?SUCCESS of
						true ->
							{ok, BinData1} = pt_440:write(44003, [Code, GodId, LastLv, LastExp, Power]),
							lib_server_send:send_to_sid(Sid, BinData1);
						_ ->
							ok
					end,
					LastPS = update_god_power(NewPlayer),
					feed(LastPS, GodId, GoodsList)
			end
	end.

%%feed_god(AddExp, GoodId, Num, God, PS) ->
%%	#player_status{id = RoleId, figure = #figure{lv = Lv}, god = StatusGod, sid = Sid} = PS,
%%	#status_god{trans = Trans, god_list = GodList} = StatusGod,
%%	#god{id = GodId, lv = GLv, exp = Exp} = God,
%%	NowExp = AddExp * Num + Exp,
%%	{NewLv, NewExp} = lv_up(GLv, NowExp, Lv),
%%	NGod = God#god{lv = NewLv, exp = NewExp},
%%	case NewLv > GLv of
%%		true ->
%%			NGod1 = calc_god_attr(NGod),
%%			NGodList = lists:keystore(GodId, #god.id, GodList, NGod1),
%%			{Attr, SkPower} = calc_power(NGodList, Trans, [], 0),
%%			NStatusGod = StatusGod#status_god{god_list = NGodList, attr = Attr, sk_power = SkPower},
%%			NPS = PS#player_status{god = NStatusGod},
%%			lib_god_util:db_god_update(?sql_god_lv_update, [NewLv, NewExp, RoleId, GodId]),
%%			LastPS = lib_player:count_player_attribute(NPS),
%%			lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
%%			{ok, BinData} = pt_440:write(44003, [?SUCCESS, GodId, 1, NewExp]),
%%			lib_server_send:send_to_sid(Sid, BinData),
%%			lib_god_util:log_lv_up(RoleId, GodId, GLv, NewLv, NewExp, AddExp * Num, [{?TYPE_GOODS, GoodId, Num}]),
%%			LastPS;
%%		false ->
%%			NGod1 = calc_god_attr(NGod),
%%			NGodList = lists:keystore(GodId, #god.id, GodList, NGod1),
%%			NStatusGod = StatusGod#status_god{god_list = NGodList},
%%			lib_god_util:db_god_update(?sql_god_lv_update, [NewLv, NewExp, RoleId, GodId]),
%%			{ok, BinData} = pt_440:write(44003, [?SUCCESS, GodId, 0, NewExp]),
%%			lib_server_send:send_to_sid(Sid, BinData),
%%			lib_god_util:log_lv_up(RoleId, GodId, GLv, NewLv, NewExp, AddExp * Num, [{?TYPE_GOODS, GoodId, Num}]),
%%			PS#player_status{god = NStatusGod}
%%	end.

%%喂养升级
lv_up(GLv, Exp, Lv) ->
	NeedExp = data_god:get_lv(GLv),
	MaxLv = data_god:get_max_lv(),
	case Exp >= NeedExp of
		true ->
			case GLv >= MaxLv of
				true ->
					{GLv, 0};
				false ->
					lv_up(GLv + 1, Exp - NeedExp, Lv)
			end;
		false ->
			{GLv, Exp}
	end.

%%升阶
up_grade(PS, GodId) ->
	#player_status{id = RoleId, figure = Figure, god = StatusGod, sid = Sid} = PS,
	#figure{name = Name} = Figure,
	#status_god{trans = Trans, god_list = GodList} = StatusGod,
%%	MaxGrade = data_god:get_max_grade(GodId),
	case lists:keyfind(GodId, #god.id, GodList) of
		false ->
			{false, ?ERRCODE(err440_not_active)};
		#god{pos = _Pos, grade = Grade, skill = _Skill} = God ->
			Cost = data_god:get_stage_condition(GodId, Grade),
			if
				Cost == [] ->
					{false, ?ERRCODE(err440_max_stage)};
				true ->
					case lib_goods_api:cost_object_list_with_check(PS, Cost, god, "god_stage") of
						{true, NewPS} ->
							NGrade = Grade + 1,
%%							{NSkill, AddSkill} = talent_skill_active(GodId, NGrade, Skill),
							NGod = God#god{grade = NGrade},
%%							NGod1 = calc_god_attr(NGod),
							NGodList = lists:keystore(GodId, #god.id, GodList, NGod),
							{Attr, _SkPower, NGodList1} = calc_power(NGodList, Trans, [], 0, []),
							NStatusGod = StatusGod#status_god{god_list = NGodList1, attr = Attr},
%%							NStatusGod1 = lib_god_api:get_god_scene_skill(NStatusGod),
							NPS = NewPS#player_status{god = NStatusGod},
							lib_god_util:db_god_update(?sql_god_grade_update, [NGrade, RoleId, GodId]),
%%							lib_god_util:db_refresh_skill(AddSkill, RoleId, GodId, 0),
							LastPS = update_god_power(NPS),
%%							LastPS = lib_player:count_player_attribute(NPS),
%%							lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
%%							skill_update_to_scene(Pos, LastPS),  %%
							Power = get_god_power(LastPS, GodId),
							{ok, BinData} = pt_440:write(44004, [?SUCCESS, GodId, NGrade, Power]),
							lib_server_send:send_to_sid(Sid, BinData),
%%							lib_chat:send_TV({all}, ?MOD_GOD, 2, [Name, Q1, GodName, N1, Q2, N2]),
							lib_god_util:log_grade_up(RoleId, GodId, Grade, NGrade, Cost),
							case data_god:get_god(GodId) of
								#base_god{color = GodColor, name = GodName} ->
									lib_chat:send_TV({all}, ?MOD_GOD, 3, [Name, GodColor, GodName, NGrade]);
								_ ->
									ok
							end,
							{true, LastPS};
						{false, Err, _} ->
%%							?MYLOG("cym", "Cost ~p  Err ~p~n", [Cost, Err]),
							{false, Err}
					end
			end;
		_ ->
			{false, ?FAIL}
	end.

%%元神出战
enter_battle(PS, Pos, AGodId) ->
	#player_status{id = RoleId, god = StatusGod, sid = Sid} = PS,
	#status_god{trans = _Trans, battle = Battle, god_list = GodList, summon = GodSummon} = StatusGod,
%%	IsPosOpen = lists:keyfind(Pos, 1, Battle),
	AGod = lists:keyfind(AGodId, #god.id, GodList),
	if
		GodSummon#god_summon.god_id > 0 ->
			{false, ?ERRCODE(err440_trans_not_handle)};
		is_record(AGod, god) == false ->
			{false, ?ERRCODE(err440_not_active)};
%%		AGod#god.pos == Pos ->
%%			{false, ?ERRCODE(err440_in_same_pos)};
		true ->
%%			#god{pos = APos} = AGod,
%%			{_Pos, BGodId} = IsposOpen,
%%			case APos > 0 of
%%				true ->
%%					NBattle = lists:keyreplace(APos, 1, Battle, {APos, 0});
%%				false ->
%%					NBattle = Battle
%%			end,
%%			case BGodId > 0 of
%%				true ->
%%					case lists:keyfind(BGodId, #god.id, GodList) of
%%						false ->
%%							NGodList = GodList, NBattle1 = NBattle;
%%						BGod ->
%%							lib_god_util:db_god_update(?sql_god_pos_update, [APos, RoleId, BGodId]),
%%							NBattle1 = lists:keyreplace(APos, 1, NBattle, {APos, BGodId}),
%%							NGodList = lists:keyreplace(BGodId, #god.id, GodList, BGod#god{pos = APos})
%%					end;
%%				false ->
%%					NGodList = GodList, NBattle1 = NBattle
%%			end,
%%			AGod1 = AGod#god{pos = Pos},
%%			AGod1 = AGod,
%%			NGodList1 = lists:keyreplace(AGodId, #god.id, GodList, AGod1),
			NBattle2 = lists:keyreplace(Pos, 1, Battle, {Pos, AGodId}),
%%			{Attr, SkPower} = calc_power(NGodList1, Trans, [], 0),  %%出不出站不会影响战力
			NStatusGod = StatusGod#status_god{battle = NBattle2},
%%			NStatusGod1 = lib_god_api:get_god_scene_skill(NStatusGod),
%%			lib_god_util:db_god_update(?sql_god_pos_update, [Pos, RoleId, AGodId]),  不维护降神的位置
			lib_god_util:db_role_replace(RoleId, NStatusGod),
			NPS = PS#player_status{god = NStatusGod},
%%			skill_update_to_scene(Pos, NPS),
			{ok, BinData} = pt_440:write(44006, [?SUCCESS, AGodId]),
			lib_server_send:send_to_sid(Sid, BinData),
			{true, NPS}
	end.


%%更新技能到场景
skill_update_to_scene(Pos, PS) when Pos > 0 ->
	SkillL = lib_skill:get_sum_skill(PS),
	mod_scene_agent:update(PS, [{skill_list, SkillL}]);
skill_update_to_scene(_Pos, _PS) ->
	ok.

%%激活天赋技能
talent_skill_active(GodId, Grade, Skill) ->
	GradeCfg = data_god:get_grade(GodId, Grade),
	case is_record(GradeCfg, base_grade) of
		true ->
			#base_grade{talent = Talent} = GradeCfg,
			#god_skill{talent_skill = TSkill} = Skill,
			F = fun(SkillId, {TmpSkill, ASkill}) ->
				case lists:keyfind(SkillId, 1, TmpSkill) of
					false ->
						{[{SkillId, 1, 0} | TmpSkill], [{0, SkillId, 1, 0} | ASkill]};
					_ ->
						{TmpSkill, ASkill}
				end
			end,
			{NTSkill, AddSkill} = lists:foldl(F, {TSkill, []}, Talent),
			{Skill#god_skill{talent_skill = NTSkill}, AddSkill};
		false ->
			{Skill, []}
	end.

%%是否自动上阵
auto_into_battle([], _God, Battle, Pos) ->
	{Pos, Battle};
auto_into_battle([{Pos, Id} | T], God, Battle, P) ->
	GodId = God#god.id,
	case Id > 0 of
		true ->
			auto_into_battle(T, God, Battle, P);
		false ->
			NBattle = lists:keystore(Pos, 1, Battle, {Pos, GodId}),
			{Pos, NBattle}
	end.

%% ---------------------------------- 属性计算 -----------------------------------
%%计算单只元神属性
%%计算总属性和总技能战力（元神属性和转生属性）
calc_power([], _Trans, Attr, _SkPower, NewGodList) ->
	{util:combine_list(Attr), lib_player:calc_all_power(Attr), lists:reverse(NewGodList)};
calc_power([God | T], Trans, Attr, SkPower, NewGodList) ->
	{GodAttr, _Power} = calc_god_power(Trans, God),
	calc_power(T, Trans, GodAttr ++ Attr, SkPower, [God | NewGodList]).


%%计算单只元神总属性
calc_god_power(_Trans, God) ->
	#god{id = GodId, grade = Grade, lv = Lv, star = Star, equip_attr = EquipAttr} = God,
	LvAttr = data_god:get_lv_attr(GodId, Lv),
	GradeAttr = data_god:get_stage_attr(GodId, Grade),
	StarAttr = data_god:get_star_attr(GodId, Star),
	TempSkillAttr = get_god_skill_attr(GodId, Grade),
%%	?MYLOG("cym", "TempSkillAttr ~p~n", [TempSkillAttr]),
	SkillAttr = [{AttrId, Value} || {_FunId, AttrId, Value} <- TempSkillAttr],
	Attr = util:combine_list(LvAttr ++ GradeAttr ++ StarAttr ++ EquipAttr ++ SkillAttr),
%%	?MYLOG("cym", "SkillAttr ~p~n", [SkillAttr]),
	Power = lib_player:calc_all_power(Attr),

%%	?MYLOG("cym", "Power ~p~n", [Power]),
	{Attr, Power}.


%% ---------------------------------- gm操作 -----------------------------------
%%gm_active_god(NPS, GodId) ->
%%	#player_status{id = RoleId, figure = #figure{lv = Lv, name = Name}, god = StatusGod} = NPS,
%%	#status_god{trans = Trans, battle = Battle, god_list = GodList} = StatusGod,
%%	GodCfg = data_god:get_god(GodId),
%%	CheckList = [
%%		{check_lv, Lv},
%%		{check_cfg, GodCfg, base_god},
%%		{check_active, GodId, GodList}
%%	],
%%	case lib_god_util:checklist(CheckList) of
%%		true ->
%%			#base_god{skill = Skill, name = GodName, grade = Grade} = GodCfg,
%%			F = fun(SkillId, {Sk, DSk}) ->
%%				{[{SkillId, 1, 0} | Sk], [{1, SkillId, 1, 0} | DSk]}
%%			end,
%%			{SelfSkill, DbSSkill} = lists:foldr(F, {[], []}, Skill),
%%			GodSkill = #god_skill{self_skill = SelfSkill},
%%			{NGodSkill, AddSkill} = talent_skill_active(GodId, Grade, GodSkill),
%%			God = #god{id = GodId, grade = Grade, skill = NGodSkill},
%%			{Pos, NBattle} = auto_into_battle(lists:keysort(1, Battle), God, Battle, 0),
%%			NGod = calc_god_attr(God#god{pos = Pos}),
%%			NGodList = [NGod | GodList],
%%			{Attr, SkPower} = calc_power(NGodList, Trans, [], 0),
%%			NStatusGod = StatusGod#status_god{battle = NBattle, god_list = NGodList, attr = Attr, sk_power = SkPower},
%%			NStatusGod1 = lib_god_api:get_god_scene_skill(NStatusGod),
%%			NPS1 = NPS#player_status{god = NStatusGod1},
%%			?IF(Pos > 0, lib_god_util:db_role_replace(RoleId, NStatusGod1), ok),
%%			lib_god_util:db_god_replace(RoleId, NGod),
%%			lib_god_util:db_refresh_skill(DbSSkill ++ AddSkill, RoleId, GodId, 0),
%%			{ok, NPS2} = lib_player_event:dispatch(NPS1, ?EVENT_GOD_BATTLE, {Battle, NBattle}),
%%			LastPS = lib_player:count_player_attribute(NPS2),
%%			lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
%%			skill_update_to_scene(Pos, LastPS),
%%			{ok, BinData} = pt_440:write(44002, [?SUCCESS, GodId]),
%%			lib_server_send:send_to_uid(RoleId, BinData),
%%			lib_chat:send_TV({all}, ?MOD_GOD, 1, [Name, GodName]),
%%			lib_god_util:log_active(RoleId, GodId),
%%			LastPS;
%%		{false, Err} ->
%%			{ok, BinData} = pt_440:write(44002, [Err, GodId]),
%%			lib_server_send:send_to_uid(RoleId, BinData),
%%			NPS
%%	end.

is_battle(GodId, BattleList) ->
	case lists:keyfind(GodId, 2, BattleList) of
		{_, GodId} ->
			?is_battle;
		_ ->
			?not_battle
	end.

god_lv_cost(NeedExp, SingleExp, OwnNum, OldLv, OldExp, MaxExp) when NeedExp < 0 ->
	if
		OwnNum >= 1 ->
			{1, OldLv + 1, SingleExp * 1 + OldExp - MaxExp};
		true ->
			{OwnNum, OldLv + 1, SingleExp * OwnNum + OldExp - MaxExp}
	end;


god_lv_cost(NeedExp, SingleExp, OwnNum, OldLv, OldExp, MaxExp) ->
	Num = util:ceil(NeedExp / SingleExp),
%%	?MYLOG("cym", "44003  NeedExp ~p  SingleExp ~p ~n", [NeedExp, SingleExp]),
	if
		OwnNum >= Num -> %%足够消耗
			{Num, OldLv + 1, SingleExp * Num + OldExp - MaxExp};
		true ->
			{OwnNum, OldLv, SingleExp * OwnNum + OldExp}
	end.

do_upgrade_lv(PS, Lv, Exp, God) ->
	#player_status{god = StatusGod} = PS,
	#status_god{god_list = GodList} = StatusGod,
	{NewLv, NewExp} = repair_lv(Lv, Exp, God#god.id),
	NewGodList = lists:keystore(God#god.id, #god.id, GodList, God#god{lv = NewLv, exp = NewExp}),
	{?SUCCESS, PS#player_status{god = StatusGod#status_god{god_list = NewGodList}}, NewLv, NewExp}.

get_lv(GodId, PS) ->
	#player_status{god = StatusGod} = PS,
	#status_god{god_list = GodList} = StatusGod,
	case lists:keyfind(GodId, #god.id, GodList) of
		#god{lv = Lv, exp = Exp} ->
			{Lv, Exp};
		_ ->
			{0, 0}
	end.

update_god_power(PS) ->
	#player_status{god = StatusGod} = PS,
	#status_god{god_list = GodList} = StatusGod,
	{Attr, _SkPower, NewGodList} = calc_power(GodList, 0, [], 0, []),
	NewStatusGod = StatusGod#status_god{attr = Attr, god_list = NewGodList},
	LastPS = lib_player:count_player_attribute(PS#player_status{god = NewStatusGod}),
	lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
	mod_scene_agent:update(LastPS, [{battle_attr, LastPS#player_status.battle_attr}]),
	LastPS.

%% -----------------------------------------------------------------
%% @desc     功能描述  升星
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
up_star(PS, GodId) ->
	%%检查是否能升星
	#player_status{god = StatusGod} = PS,
	#status_god{god_list = GodList} = StatusGod,
	case lists:keyfind(GodId, #god.id, GodList) of
		#god{equip_list = EquipList, star = Star} = God ->
			{LimitColor, LimitStar} =
				case data_god:get_color_limit(Star) of
					{V1, V2} ->
						{V1, V2};
					_ ->
						{0, 0}
				end,
%%			?MYLOG("cym", "LimitColor ~p LimitStar ~p~n", [LimitColor, LimitStar]),
			CheckList = [
				{check_max_star, Star, GodId},
				{check_color_limit, LimitColor, LimitStar, EquipList},
				{check_equip_length, EquipList}
			],
			case lib_god_util:checklist(CheckList) of
				true ->
					do_up_star(PS, GodList, God);
				{false, Code} ->
					{false, Code}
			end;
		_ ->
			{false, ?ERRCODE(err440_not_exist_god_id)}
	end.


calc_equip_list(GodId, EquipGoodsList) ->
	lists:foldl(fun
		(#goods{id = Id, other = #goods_other{optional_data = OData}, subtype = Pos, goods_id = GoodsId}, Acc) ->
			case OData of
				[GodId] ->
					[{Pos, Id, GoodsId} | Acc];
				_ ->
					Acc
			end
	end, [], EquipGoodsList).

%% -----------------------------------------------------------------
%% @desc     功能描述  装备属性
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
calc_equip_attr(EquipList) ->
	F = fun({_Pos, _Id, GoodsID}, AccList) ->
		case data_god:get_equip(GoodsID) of
			#base_god_equip{attr = Attr} ->
				Attr ++ AccList;
			_ ->
				AccList
		end
	end,
	lists:foldl(F, [], EquipList).

do_up_star(PS, GodList, God) ->
%%	?MYLOG("cym", "up_star  ~n", []),
	#player_status{god = StatusGod, id = RoleId, sid = Sid, figure = Figure} = PS,
	#god{equip_list = EquipList, star = Star, id = GodId} = God,
	%%销毁装备
	delete_equip(PS, EquipList),
	%%改变星数
	NewGod = God#god{star = Star + 1, equip_list = [], equip_attr = []},
	NewGodList = lists:keystore(GodId, #god.id, GodList, NewGod),
	NewPS = PS#player_status{god = StatusGod#status_god{god_list = NewGodList}},
	LastPsTmp = update_god_power(NewPS),
	lib_god_util:db_god_update(?sql_god_star_update, [Star + 1, RoleId, GodId]),
	Power = get_god_power(LastPsTmp, GodId),
	lib_log_api:log_god_up_star(RoleId, GodId, Star, Star + 1, [{?TYPE_GOODS, GoodsId, 1} || {_Pos, _AutoId, GoodsId} <- EquipList]),
	PSDemons = lib_demons_api:god_up_star(LastPsTmp),
	{ok, LastPs} = lib_temple_awaken_api:trigger_god_star(PSDemons, GodId, Star + 1),
%%	?MYLOG("cym", "44005 ~p~n", [{ GodId, Star + 1, Power}]),
	case data_god:get_god(GodId) of
		#base_god{color = GodColor, name = GodName} ->
			lib_chat:send_TV({all}, ?MOD_GOD, 2, [Figure#figure.name, GodColor, GodName, Star + 1]);
		_ ->
			ok
	end,
	{ok, BinData} = pt_440:write(44005, [?SUCCESS, GodId, Star + 1, Power]),
	lib_server_send:send_to_sid(Sid, BinData),
	{true, LastPs}.

get_god_all_star(PS) ->
	#player_status{god = StatusGod} = PS,
	#status_god{god_list = GodList} = StatusGod,
	lists:sum([Star ||#god{star = Star} <- GodList]).

%% -----------------------------------------------------------------
%% @desc     功能描述  升星时删除装备
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
delete_equip(PS, EquipList) ->
	GoodsStatus = lib_goods_do:get_goods_status(),
	DeleteInfoList = [{lib_goods_api:get_goods_info(AutoId, GoodsStatus), 1} || {_Pos, AutoId, _GoodsId} <- EquipList],
	{ok, NewGoodsStatus1} = lib_goods:delete_goods_list(GoodsStatus, DeleteInfoList),
	{Dict, _GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus1#goods_status.dict),
	NewGoodsStatus2 = NewGoodsStatus1#goods_status{dict = Dict},
	lib_goods_do:set_goods_status(NewGoodsStatus2),
%%	?MYLOG("cym", "GoodsL ~p~n", [GoodsL]),
	lib_goods_api:notify_client_num(PS#player_status.id, [G#goods{num = 0} || {G, _} <- DeleteInfoList]).


%% -----------------------------------------------------------------
%% @desc     功能描述 剩余的经验是否满足继续升级
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
repair_lv(Lv, Exp, GodId) ->
	Need = data_god:get_lv_exp(GodId, Lv),
	if
		Exp >= Need andalso Need =/= 0 ->
			repair_lv(Lv + 1, Exp - Need, GodId);
		true ->
			{Lv, Exp}
	end.



calc_takeoff_equips(Pos, EquipList, GoodsDict) ->
	F = fun
		({Position, GoodsAutoId, _GoodsTypeId} = X, {TakeoffGoods, NewEquipList}) ->
			if
				Position =:= Pos -> %%orelse Pos =:= 0
					case lib_goods_util:get_goods(GoodsAutoId, GoodsDict) of
						GoodsInfo when is_record(GoodsInfo, goods) ->
							{[GoodsInfo | TakeoffGoods], NewEquipList};
						_ ->
							{TakeoffGoods, NewEquipList}
					end;
				true ->
					{TakeoffGoods, [X | NewEquipList]}
			end
	end,
	{TakeoffGoods, NewEquipList} = lists:foldl(F, {[], []}, EquipList),
	{TakeoffGoods, lists:reverse(NewEquipList)}.

takeoff_equips(EquipGoodsList) ->
	[GoodsInfo#goods{other = Other#goods_other{optional_data = []}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList].


calc_equip_list_attr(EquipList) ->
	F = fun({_Pos, _AutoId, GoodsTypeId}, AccAttrList) ->
		case data_god:get_equip(GoodsTypeId) of
			#base_god_equip{attr = Attr} ->
				Attr ++ AccAttrList;
			_ ->
				AccAttrList
		end
	end,
	util:combine_list(lists:foldl(F, [], EquipList)).

get_god_power(#player_status{god = StatusGod, original_attr = SumOAttr}, GodId) ->
	#status_god{god_list = GodList} = StatusGod,
	case lists:keyfind(GodId, #god.id, GodList) of
		#god{} = God ->
			{Attr, _} = calc_god_power(0, God),
			lib_player:calc_partial_power(SumOAttr, 0, Attr) + lib_god_util:get_skill_power2(God);
		_ ->
			0
	end.

%% 计算全部降神战力
get_all_god_power(StatusGod, SumOAttr) ->
	#status_god{god_list = GodList} = StatusGod,
	F = fun(God, FunPower) ->
		{Attr, _} = calc_god_power(0, God),
		lib_player:calc_partial_power(SumOAttr, 0, Attr) + lib_god_util:get_skill_power2(God) + FunPower
	end,
	lists:foldl(F, 0, GodList).

get_god_skill_attr(GodId, MyStage) ->
	case data_god:get_god(GodId) of
		#base_god{talent = TalentList} ->
			SkillLIdList = [{SkillId, Lv} || {SkillId, Stage, Lv} <- TalentList, MyStage >= Stage],
			F = fun({SkillId1, Lv1}, AttrList) ->
				case data_skill:get(SkillId1, Lv1) of
					#skill{lv_data = LvData, career = ?SKILL_CAREER_GOD, type = Type}
						when Type == ?SKILL_TYPE_PASSIVE orelse  Type == ?SKILL_TYPE_ASSIST->
						LvData#skill_lv.base_attr ++ AttrList;
					_ ->
						AttrList
				end
			end,
			lists:foldl(F, [], SkillLIdList);
		_ ->
			[]
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取变身后的所有被动技能，如果没有变身则为空
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_god_passive_skill(PS) ->
	#player_status{god = StatusGod} = PS,
	#status_god{summon = Summon} = StatusGod,
	case Summon of
		#god_summon{passive_skill = PassiveSkill} ->
			PassiveSkill;
		_ ->
			[]
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  是否变身后，这个技能
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
check_skill_has_learn(Status, SkillId) ->
	#player_status{god = StatusGod} = Status,
	#status_god{summon = Summon} = StatusGod,
	case Summon of
		#god_summon{initiative_skill = SkillList} ->
			case lists:keyfind(SkillId, 1, SkillList) of
				{SkillId, _} ->
					true;
				_ ->
					false
			end;
		_ ->
			false
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  合成后的装备， 战力处理
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
up_equip_list_af_compose(PS, Goods) ->
	#goods{other = Others, subtype = Pos, id = AutoId, goods_id = GoodsId} = Goods,
	#goods_other{optional_data = Data} = Others,
	#player_status{god = StatusGod} = PS,
	#status_god{god_list = GodList} = StatusGod,
	case Data of
		[GodId] ->
			case lists:keyfind(GodId, #god.id, GodList) of
				#god{equip_list = EquipList, id = GodId} = God ->
					case lists:keyfind(Pos, 1, EquipList) of
						{Pos, _, _} ->
							NewEquipList = lists:keystore(Pos, 1, EquipList, {Pos, AutoId, GoodsId}),
							EquipAttr = calc_equip_list_attr(NewEquipList),
							NewGod = God#god{equip_list = NewEquipList, equip_attr = EquipAttr},
							NewGodList = lists:keystore(GodId, #god.id, GodList, NewGod),
							NewStatusGod = StatusGod#status_god{god_list = NewGodList},
							PS1 = PS#player_status{god = NewStatusGod},
							LastPS = update_god_power(PS1),
							pp_god:handle(44001, LastPS, [GodId]),
							LastPS;
						_ ->
							PS
					end;
				_ ->
					PS
			end;
		_ ->
			PS
	end.


check_compose(PS, RuleId, GoodsAutoId) ->
	case lib_goods_api:get_goods_info(GoodsAutoId) of
		#goods{location = Location} = OldTargetGoodsInfo ->
			if
				Location == ?GOODS_LOC_GOD2_EQUIP ->
					case get_compose_cost(PS, RuleId, OldTargetGoodsInfo) of
						{true, CostList, TargetGoods} ->
							RightCostList = [{Type, GoodsTypeId, Num} || {Type, GoodsTypeId, Num} <- CostList, Num > 0],
							{true, RightCostList, OldTargetGoodsInfo, TargetGoods};
						{false, Err} ->
							{false, Err}
					end;
				true ->
					{false, ?ERRCODE(err440_compose_location_err)}
			end;
		_ ->
			{false, ?ERRCODE(err150_no_goods)}
	end.


get_compose_cost(PS, RuleId, OldTargetGoodsInfo) ->
	#goods{goods_id = OldTargetGoodsId} = OldTargetGoodsInfo,
	case data_goods_compose:get_cfg(RuleId) of
		#goods_compose_cfg{regular_mat = RegularMat, goods = TargetGoods} when RegularMat =/= [] ->
%%			NeedLength = length(RegularMat),
%%			?MYLOG("cym", "RegularMat ~p NeedLength ~p~n", [RegularMat, NeedLength]),
			{EquipGoodsTypeId, EquipGoodsNum, RegularMatCost} = get_regular_mat(RegularMat, 1),
			if
				EquipGoodsTypeId == 0 ->
					{false, ?MISSING_CONFIG};
				RegularMatCost == [] ->  %%合成不需要其他材料
					case lib_goods_api:get_goods_num(PS, [EquipGoodsTypeId]) of   %%这个方法只算背包的
						[{_, HaveNum} | _] ->   %%这里肯定有一件以上，就是身上穿的
							if
								TargetGoods == [] ->
									{false, ?ERRCODE(err440_compose_target_null)};
								OldTargetGoodsId =/= EquipGoodsTypeId ->
									{false, ?FAIL};
								HaveNum + 1 >= EquipGoodsNum ->  %%可以直接合成
									{true, [{?TYPE_GOODS, EquipGoodsTypeId, EquipGoodsNum - 1}], TargetGoods};
								true ->
									get_compose_cost2(PS, [{?TYPE_GOODS, EquipGoodsTypeId, HaveNum}], EquipGoodsNum - (HaveNum + 1), EquipGoodsTypeId, TargetGoods, RegularMatCost)
							end;
						_ ->
							{false, ?FAIL}
					end;
				true ->
					case lib_goods_api:check_object_list(PS, RegularMatCost) of   %%检查是否满足材料
						true ->
							case lib_goods_api:get_goods_num(PS, [EquipGoodsTypeId]) of   %%这个方法只算背包的
								[{_, HaveNum} | _] ->   %%这里肯定有一件以上，就是身上穿的
									if
										TargetGoods == [] ->
											{false, ?ERRCODE(err440_compose_target_null)};
										OldTargetGoodsId =/= EquipGoodsTypeId ->
											{false, ?FAIL};
										HaveNum + 1 >= EquipGoodsNum ->  %%可以直接合成
											{true, [{?TYPE_GOODS, EquipGoodsTypeId, EquipGoodsNum - 1}] ++ RegularMatCost, TargetGoods};
										true ->
											get_compose_cost2(PS, [{?TYPE_GOODS, EquipGoodsTypeId, HaveNum}], EquipGoodsNum - (HaveNum + 1), EquipGoodsTypeId, TargetGoods, RegularMatCost)
									end;
								_ ->
									{false, ?FAIL}
							end;
						{false, Err} ->
							{false, Err}
					end
			end;
		_ ->
			{false, ?MISSING_CONFIG}
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取消耗列表
%% @param    参数     CostList：：上一级的消耗列表  GoodsTypeId:: 上一级消耗的物品  Num：：上一级需要的道具数量 TargetGoods：：目标物品   OldRegularMatCost 材料消耗
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_compose_cost2(PS, CostList, Num, GoodsTypeId, TargetGoods, OldRegularMatCost) ->
	case data_god:get_equip(GoodsTypeId) of
		#base_god_equip{next_equip = RuleId} ->
			if
				RuleId == 0 ->
					{false, ?ERRCODE(goods_not_enough)};
				true ->
					case data_goods_compose:get_cfg(RuleId) of
						#goods_compose_cfg{regular_mat = RegularMat} ->
							{EquipGoodsTypeId, EquipGoodsNum, RegularMatCost} = get_regular_mat(RegularMat, Num),
							if
								EquipGoodsTypeId == 0 ->
									{false, ?MISSING_CONFIG};
								RegularMatCost == [] ->  %%合成不需要其他材料
									case lib_goods_api:get_goods_num(PS, [EquipGoodsTypeId]) of   %%这个方法只算背包的
										[{_, HaveNum} | _] ->   %%这里肯定有一件以上，就是身上穿的
											if
												HaveNum >= EquipGoodsNum ->  %%可以直接合成
													{true, [{?TYPE_GOODS, EquipGoodsTypeId, EquipGoodsNum}] ++ RegularMatCost ++ OldRegularMatCost ++ CostList, TargetGoods};
												true ->
%%													?MYLOG("cym", "get_compose_cost2 ++++++  ~p~n", [HaveNum]),
													get_compose_cost2(PS, [{?TYPE_GOODS, EquipGoodsTypeId, HaveNum}] ++ CostList,
														EquipGoodsNum - HaveNum, EquipGoodsTypeId, TargetGoods, OldRegularMatCost ++ RegularMatCost)
											end;
										_ ->
											{false, ?FAIL}
									end;
								true ->
%%									?MYLOG("cym", "RegularMatCost ~p ~p ~n", [RegularMatCost ++ OldRegularMatCost, EquipGoodsNum]),
									case lib_goods_api:check_object_list(PS, RegularMatCost ++ OldRegularMatCost) of   %%检查是否满足材料
										true ->
											case lib_goods_api:get_goods_num(PS, [EquipGoodsTypeId]) of   %%这个方法只算背包的
												[{_, HaveNum} | _] ->   %%这里肯定有一件以上，就是身上穿的
%%													?MYLOG("cym", "HaveNum ~p ~n", [HaveNum]),
													if
														HaveNum >= EquipGoodsNum ->  %%可以直接合成
															{true, [{?TYPE_GOODS, EquipGoodsTypeId, EquipGoodsNum}] ++ RegularMatCost ++ OldRegularMatCost ++ CostList, TargetGoods};
														true ->
															get_compose_cost2(PS, [{?TYPE_GOODS, EquipGoodsTypeId, HaveNum}] ++ CostList,
																EquipGoodsNum - HaveNum, EquipGoodsTypeId, TargetGoods, OldRegularMatCost ++ RegularMatCost)
													end;
												_ ->
													{false, ?FAIL}
											end;
										{false, Err} ->
											{false, Err}
									end
							end;
						_ ->
							{false, ?MISSING_CONFIG}
					end
			end;
		_ ->
			{false, ?MISSING_CONFIG}
	end.


do_compose(#player_status{id = RoleId} = PS, RightCostList, OldTargetGoodsInfo, TargetGoods, RuleId, GoodsAutoId) ->
	case lib_goods_api:cost_object_list_with_check(PS, RightCostList, god_equip_compose, "") of
		{true, NewPs} ->
			case do_compose2(NewPs, OldTargetGoodsInfo, TargetGoods) of
				{ok, _ErrorCode, NewGoodsStatus, _NewPlayerStatus, UpdateGoodsList, _ReturnGoodsL, _RemoveStoneL, NewTargetGoodsInfo} ->
					lib_goods_do:set_goods_status(NewGoodsStatus),
					%% 更新客户端缓存
					lib_goods_api:notify_client_num(RoleId, UpdateGoodsList),
					lib_goods_api:update_client_goods_info([NewTargetGoodsInfo]),
					lib_goods_api:notify_client(_NewPlayerStatus, [NewTargetGoodsInfo]),
					#goods{goods_id = OldTargetGoodsId} = OldTargetGoodsInfo,
					NewPlayerStatus = lib_god:up_equip_list_af_compose(_NewPlayerStatus, NewTargetGoodsInfo),
					%% 合成日志
					lib_log_api:log_goods_compose(RoleId, RuleId, [], [{?TYPE_GOODS, OldTargetGoodsId, 1}] ++ RightCostList, [], 1, TargetGoods),
					{ok, LastPlayerStatus} = lib_goods_util:count_role_equip_attribute(NewPlayerStatus),
					{ok, Bin} = pt_440:write(44014, [?SUCCESS, RuleId, GoodsAutoId]),
					lib_server_send:send_to_uid(PS#player_status.id, Bin),
					{ok, LastPlayerStatus};
				{false, ErrorCode, NewGoodsStatus, _NewPlayerStatus} ->
					lib_goods_do:set_goods_status(NewGoodsStatus),
					{ok, Bin} = pt_440:write(44014, [ErrorCode, RuleId, GoodsAutoId]),
					lib_server_send:send_to_uid(PS#player_status.id, Bin),
					{ok, PS};
				Error ->
					?ERR("goods_compose error:~p", [Error]),
					{ok, Bin} = pt_440:write(44014, [?FAIL, RuleId, GoodsAutoId]),
					lib_server_send:send_to_uid(PS#player_status.id, Bin),
					{ok, PS}
			end;
		{false, Err, _} ->
			{ok, Bin} = pt_440:write(44014, [Err, RuleId, GoodsAutoId]),
			lib_server_send:send_to_uid(PS#player_status.id, Bin),
			{ok, PS}
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  合成物品
%% @param    参数      OldTargetGoodsInfo::#goods{}   用来被合成的身上的装备，  TargetGoods [{Type, GoodsTypeId, Num}] 合成的物品
%% @return   返回值    {ok, Ps}
%% @history  修改历史
%% -----------------------------------------------------------------
do_compose2(PlayerStatus, OldTargetGoodsInfo, TargetGoods) ->
	NewGoodsStatus1 = lib_goods_do:get_goods_status(),
	F = fun() ->
		%% 扣除指定物品
		ok = lib_goods_dict:start_dict(),
		{_, TargetGoodsTypeId, _} = hd(TargetGoods),   %%目标物品id
		%% 处理穿在身上的作为合成材料降神装备
		#goods{id = GoodsId, other = OldGoodsOthers} = OldTargetGoodsInfo,
		#goods_other{extra_attr = _OldExtraAttr, optional_data = _OPData} = OldGoodsOthers,
		#ets_goods_type{
			level = NewLv,
			color = NewColor,
			suit_id = _NewSuitId,
			addition = NewAddition
		} = data_goods_type:get(TargetGoodsTypeId),
		{NewPriceType, NewPrice} = data_goods:get_goods_buy_price(TargetGoodsTypeId),
		Sql = io_lib:format(<<"update goods set price_type = ~p, price = ~p where id = ~p">>,
			[NewPriceType, NewPrice, GoodsId]),
		db:execute(Sql),
		Sql1 = io_lib:format(<<"update goods_low set gtype_id = ~p, level = ~p, color = ~p, bind = ~p, addition = '~s', extra_attr = '~s' where gid = ~p">>,
			[TargetGoodsTypeId, NewLv, NewColor, ?UNBIND, util:term_to_string(NewAddition), util:term_to_string(OldGoodsOthers#goods_other.extra_attr), GoodsId]),
		db:execute(Sql1),
		Sql2 = io_lib:format(<<"update goods_high set goods_id = ~p where gid = ~p">>,
			[TargetGoodsTypeId, GoodsId]),
		db:execute(Sql2),
		NewTargetGoodsInfo = OldTargetGoodsInfo#goods{
			goods_id = TargetGoodsTypeId,
			price_type = NewPriceType,
			price = NewPrice,
			bind = ?UNBIND,
			level = NewLv,
			color = NewColor,
			other = OldGoodsOthers
		},
%%		?MYLOG("cym", "NewGoodsStatus1 ~p~n", [NewGoodsStatus1]),
		NewGoodsStatus2 = lib_goods:change_goods(NewTargetGoodsInfo, ?GOODS_LOC_GOD2_EQUIP, NewGoodsStatus1),
		{Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus2#goods_status.dict),
		NewGoodsStatus3 = NewGoodsStatus2#goods_status{
			dict = Dict},
		ReturnGoodsL = [{stone_list, []}, {suit_return, []}],
		{ok, ?SUCCESS, NewGoodsStatus3, PlayerStatus, GoodsL, ReturnGoodsL, [], NewTargetGoodsInfo}
	end,
	lib_goods_util:transaction(F).


%%解析合成数据， RegularMat,  Num :: 合成数据的份数
%% returen {合成需要的装备id, 装备数量， 材料List}
get_regular_mat(RegularMat, RegularMatNum) ->
	NewList = lists:flatten(RegularMat),
	F = fun(Goods, {EquipGoodsTypeId, EquipGoodsNum, RegularMatCost}) ->
		case Goods of
			{_, GoodsId, Num} ->
				case data_goods_type:get(GoodsId) of
					#ets_goods_type{type = Type} ->
						if
							Type == ?GOODS_TYPE_GOD_EQUIP ->
								{GoodsId, Num * RegularMatNum + EquipGoodsNum, RegularMatCost};
							true ->
								{EquipGoodsTypeId, EquipGoodsNum, [{?TYPE_GOODS, GoodsId, Num * RegularMatNum} | RegularMatCost]}
						end;
					_ ->
						{EquipGoodsTypeId, EquipGoodsNum, RegularMatCost}
				end;
			_ ->
				{EquipGoodsTypeId, EquipGoodsNum, RegularMatCost}
		end
	end,
	lists:foldl(F, {0, 0, []}, NewList).






calc_expect_power(PS, God) ->
	#god{id = GodId} = God,
	{GodAttr, _Power} = calc_god_power(0, God),
	Power = lib_player:calc_expact_power(PS#player_status.original_attr, 0, GodAttr) +  lib_god_util:get_skill_power2(God),
%%	?MYLOG("cym", "Power ~p~n", [Power]),
	{ok, Bin} = pt_440:write(44015, [GodId, Power]),
	lib_server_send:send_to_sid(PS#player_status.sid, Bin).



god_stren(PS, GodType, GoodsList) ->
	#player_status{id = RoleId, god = StatusGod} = PS,
	#status_god{god_list = GodList, god_stren = GodStren} = StatusGod,
	#god_stren{stren_list = StrenList} = GodStren,
	GodIdList = data_god:get_god_by_color(GodType),
	#god_stren_item{level = OldLevel, exp = OldExp} = GodStrenItem =
		ulists:keyfind(GodType, #god_stren_item.god_type, StrenList, #god_stren_item{god_type = GodType}),
	CheckList = [
		{check_max_stren_level, OldLevel, GodType},
		{check_all_god_max_star, GodType, GodList, GodIdList}
	],
	case lib_god_util:checklist(CheckList) of 
		true ->
			#base_god_stren{lv_up_need_exp = LvUpExp} = data_god:get_god_stren_cfg(GodType, OldLevel),
			{NewLevel, NewExp, CostList} = god_stren_lv_up(GodType, OldLevel, LvUpExp, OldExp, GoodsList, []),
			case NewLevel =/= OldLevel orelse NewExp =/= OldExp of 
				true ->
					case lib_goods_api:cost_object_list_with_check(PS, CostList, god_stren, "") of 
						{true, NewPS} ->
							lib_log_api:log_god_stren(RoleId, GodType, OldLevel, OldExp, NewLevel, NewExp, CostList),
							NewGodStrenItem = GodStrenItem#god_stren_item{level = NewLevel, exp = NewExp},
							lib_god_util:db_god_stren_replace(RoleId, NewGodStrenItem),
							NewStrenList = lists:keystore(GodType, #god_stren_item.god_type, StrenList, NewGodStrenItem),
		            		NewGodStren = GodStren#god_stren{stren_list = NewStrenList},
		            		LastGodStren = count_god_stren_attr(NewGodStren),
		            		NewStatusGod = StatusGod#status_god{god_stren = LastGodStren},
		            		NewPS1 = NewPS#player_status{god = NewStatusGod},
		            		LastPS = lib_player:count_player_attribute(NewPS1),
		            		lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
		            		{ok, LastPS, NewGodStrenItem};
						{false, Res, _} ->
							{false, Res}
					end;
				_ ->
					{ok, PS, GodStrenItem}
			end;
		{false, Res} ->
			{false, Res}
	end.

god_stren_lv_up(_GodType, Level, LvUpExp, Exp, [], Return) when Exp < LvUpExp ->
	{Level, Exp, Return};
god_stren_lv_up(GodType, Level, LvUpExp, Exp, [{GoodsTypeId, Num}|DeleteGoodsList], Return) when Exp < LvUpExp ->
	case data_god:get_equip(GoodsTypeId) of 
		#base_god_equip{limit = Limit, color = EquipColor, decompose_exp = ExpAdd} ->
			case GodType == Limit andalso EquipColor =< ?ORANGE andalso Num > 0 of 
				true -> 
					NewExp = Exp + ExpAdd * Num, NewReturn = [{?TYPE_GOODS, GoodsTypeId, Num}|Return];
				_ ->
					NewExp = Exp, NewReturn = Return
			end;
		_ -> NewExp = Exp, NewReturn = Return
	end,
	god_stren_lv_up(GodType, Level, LvUpExp, NewExp, DeleteGoodsList, NewReturn);
god_stren_lv_up(GodType, Level, LvUpExp, Exp, DeleteGoodsList, Return) ->
	NewLevel = Level + 1,
	NewExp = Exp - LvUpExp,
	MaxLevel = data_god:get_stren_max_level(GodType),
	case NewLevel >= MaxLevel of 
		false ->
			%% 如果剩余的经验还能升级，继续升级
			case data_god:get_god_stren_cfg(GodType, NewLevel) of
				#base_god_stren{lv_up_need_exp = NewLvUpExp} ->
					god_stren_lv_up(GodType, NewLevel, NewLvUpExp, NewExp, DeleteGoodsList, Return);
				_ ->
					{NewLevel, NewExp, Return}
			end;
		_ ->
			{NewLevel, NewExp, Return}
	end.

count_god_stren_attr(GodStren) ->
	#god_stren{stren_list = StrenList} = GodStren,
	F = fun(#god_stren_item{god_type = GodType, level = Level}, List) ->
		#base_god_stren{attr_add = AttrAdd} = data_god:get_god_stren_cfg(GodType, Level),
		lib_player_attr:add_attr(list, [AttrAdd, List])
	end,
	AttrList = lists:foldl(F, [], StrenList),
	GodStren#god_stren{attr = AttrList}.



%% 智能合成
intelligent_compose(#player_status{id = RoleId} = Ps, [], UpdateGodList, CostList, ComposeGoodsList, LogCostMat, LogComposeEquip) -> 
	%% 结算
	GoodsStatus = lib_goods_do:get_goods_status(),
	GoodsTypeIds = [EquipType || #goods{goods_id = EquipType} <- CostList],
	GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{gid_in, GoodsTypeIds}]),
	case intelligent_compose_core_help(GoodsStatusBfTrans, CostList) of 
		{ok, NewGoodsStatus, UpdateGoodsL} ->
			LastGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(NewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
			lib_goods_do:set_goods_status(LastGoodsStatus),
			%% 发送合成物品
			Res = lib_goods_api:give_goods_by_list(Ps, ComposeGoodsList, goods_compose, 0),
			case Res of 
				{1, _, _} ->
					%% 记录合成日志
					lib_log_api:log_god_auto_compose(RoleId, LogCostMat, LogComposeEquip),
					% 更新客户端数据
					lib_goods_api:notify_client_num(RoleId, UpdateGoodsL),
					{ok, Bin} = pt_440:write(44016, [?SUCCESS, UpdateGodList]),
					lib_server_send:send_to_uid(RoleId, Bin);
				_Error ->
					?ERR("intelligent compose err:~p", [_Error]),
					{ok, Bin} = pt_440:write(44016, [?ERRCODE(err150_compose_fail), []]),
					lib_server_send:send_to_uid(RoleId, Bin)
			end;
		_Err ->
			?ERR("intelligent compose err:~p", [_Err]),
			{ok, Bin} = pt_440:write(44016, [?ERRCODE(err150_compose_fail), []]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end;
intelligent_compose(#player_status{id = RoleId} = Ps, [{RuleId, Count} | ComposeList], UpdateGodList, CostList, ComposeGoodsList, LogCostMat, LogComposeEquip) ->
	case lib_god_util:check_intelligent_compose(RoleId, RuleId, Count, ComposeGoodsList, UpdateGodList, LogCostMat, LogComposeEquip) of		
		{true, NewCostList, NewComposeGoodsList, NewUpdateGodList, NewLogCostMat, NewLogComposeEquip} ->
			intelligent_compose(Ps, ComposeList, NewUpdateGodList, NewCostList ++ CostList, NewComposeGoodsList, NewLogCostMat, NewLogComposeEquip);
		{false, ErrCode} ->
			{ok, Bin} = pt_440:write(44016, [ErrCode, []]),
			lib_server_send:send_to_uid(RoleId, Bin)
	end.

intelligent_compose_core_help(GoodsStatusBfTrans, CostList) ->
	F = fun() ->
		ok = lib_goods_dict:start_dict(),
		%% 删除物品
		NewCostGoodsList = [{GoodsInfo, 1}|| GoodsInfo <- CostList],
	    {ok, NewGoodsStatus} = lib_goods:delete_goods_list(GoodsStatusBfTrans, NewCostGoodsList),
		{Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
		NewGoodsStatus2 = NewGoodsStatus#goods_status{
			dict = Dict},
		{ok, NewGoodsStatus2, GoodsL}
	end,
	lib_goods_util:transaction(F).
