%%%--------------------------------------
%%% @Module  : lib_god_util
%%% @Author  : zengzy 
%%% @Created : 2018-02-27
%%% @Description:  变身系统
%%%--------------------------------------
-module(lib_god_util).
-compile(export_all).
-export([

]).

-include("server.hrl").
-include("errcode.hrl").
-include("skill.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("god.hrl").
-include("scene.hrl").
-include("def_fun.hrl").
-include("goods.hrl").
-include("attr.hrl").
%% ---------------------------------- 检测函数 -----------------------------------
checklist([]) ->
	true;
checklist([H | T]) ->
	case check(H) of
		true ->
			checklist(T);
		{false, Res} ->
			{false, Res}
	end.

%%检测等级
check({check_lv, Lv}) ->
	OpenLv = data_god:get_kv(open_lv),
	case Lv >= OpenLv of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err440_lv_not_enough)}
	end;
%%检测配置
check({check_cfg, Cfg, CfgType}) ->
	case is_record(Cfg, CfgType) of
		true ->
			true;
		false ->
			{false, ?ERRCODE(err440_cfg_error)}
	end;
%%检测是否已激活
check({check_active, GodId, GodList}) ->
	case lists:keyfind(GodId, #god.id, GodList) of
		false ->
			true;
		_ ->
			{false, ?ERRCODE(err440_has_active)}
	end;
%%检测激活条件
check({check_active_cost, GodCfg, PS}) ->
	#base_god{condition = Cost} = GodCfg,
	check({check_cost, Cost, PS});
%%检测消耗
check({check_cost, CostList, PS}) ->
	Result = lib_goods_util:check_object_list(PS, CostList),
	case Result of
		true ->
			true;
		{false, Res} ->
			{false, Res};
		_Othre ->
			true
	end;
%%检测完成任务
check({check_task, TaskId, PS}) ->
	case mod_task:is_finish(PS#player_status.tid, TaskId) of
		false ->
			{false, ?ERRCODE(err381_not_finish_task)};
		_ ->
			true
	end;

%%检测等级
check({check_active_lv, GodCfg, PS}) ->
	#base_god{condition_lv = ConditonLv} = GodCfg,
	#player_status{god = God} = PS,
	#status_god{god_list = GodList} = God,
	check_active_god(ConditonLv, GodList);

%%检测总等级
check({check_active_all_lv, GodCfg, PS}) ->
	#base_god{condition_all_lv = ConditionAllLv} = GodCfg,
	#player_status{god = God} = PS,
	#status_god{god_list = GodList} = God,
	check_active_god_all(ConditionAllLv, GodList);

%%品质是否符合需求
check({check_color_limit, LimitColor, LimitStar, EquipList}) ->
	is_color(EquipList, LimitColor, LimitStar);
check({check_equip_length, EquipList}) ->
	Length = length(EquipList),
	if
		Length >= ?equip_num ->
			true;
		true ->
			{false, ?ERRCODE(err440_equip_not_enough)}
	end;
check({check_max_star, Star, GodId}) ->
	StarList = data_god:get_star_list(GodId),
	MaxStar = ?IF(StarList == [], 0, lists:max(StarList)),
	if
		Star >= MaxStar ->
			{false, ?ERRCODE(err440_max_star)};
		true ->
			true
	end;
check({check_all_god_max_star, GodType, GodList, GodIdList}) ->
	check_all_god_max_star(GodType, GodIdList, GodList);
check({check_max_stren_level, OldLevel, GodType}) ->
	case data_god:get_stren_max_level(GodType) =< OldLevel of 
		true -> {false, ?ERRCODE(err440_stren_level_max)};
		_ -> true
	end;

check(_) ->
	{false, ?FAIL}.

%% -----------------------------------------------------------------
%% @desc     功能描述 检查能不能通过等级来激活
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------

check_active_god([], _GodList) ->
	true;

check_active_god(Condition, GodList) ->
	check_active_god_help(Condition, GodList).

check_active_god_help([], _GodList) ->
	true;
check_active_god_help([{GodId, Lv} | Condition], GodList) ->
	case lists:keyfind(GodId, #god.id, GodList) of
		#god{lv = GodLv} ->
			if
				GodLv >= Lv ->
					check_active_god_help(Condition, GodList);
				true ->
					{false, ?ERRCODE(err440_active_lv)}
			end;
		_ ->
			{false, ?ERRCODE(err440_active_lv)}
	end.


get_total_attr(PlayerStatus) ->
	#player_status{god = God} = PlayerStatus,
	case God of
		#status_god{god_list = GodList, god_stren = #god_stren{attr = StrenAttr}}->
			{Attr, _SkPower, _NewGodList} = lib_god:calc_power(GodList, 0, [], 0, []),
			Attr++StrenAttr;
		_ ->
			[]
	end.
%%	#status_god{god_list = GodList} = God,
%%%%	AllEquipAttr = [EquipAttr || #god{equip_attr = EquipAttr} <- GodList],
%%	{Attr, _SkPower, _NewGodList} = lib_god:calc_power(GodList, 0, [], 0, []),
%%	Attr.


check_update_lv(GLv, GodId) ->
%%	#status_mount{type_id = TypeId, stage = Stage, star = Star} = StatusMount,
	NeedExp = data_god:get_lv_exp(GodId, GLv),
	if
		NeedExp == 0 ->
			{fail, ?ERRCODE(err440_max_lv)};
		true ->
			{true, NeedExp}
	end.

check_all_god_max_star(_GodType, [], _GodList) -> true;
check_all_god_max_star(GodType, [GodId|GodIdList], GodList) ->
	case lists:keyfind(GodId, #god.id, GodList) of 
		false -> {false, {?ERRCODE(err440_god_type_not_active), [GodType]}};
		#god{star = Star} ->
			case check({check_max_star, Star, GodId}) of 
				true -> %% 没满星
					{false, {?ERRCODE(err440_god_type_not_max_star), [GodType]}};
				_ ->
					check_all_god_max_star(GodType, GodIdList, GodList)
			end
	end.

%% -----------------------------------------------------------------
%% @desc     功能描述  配置是否全部符合需求
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
is_color([], _LimitColor, _LimitStar) ->
	true;
is_color([{_Pos, _AutoId, GoodsId} | EquipList], LimitColor, LimitStar) ->
	
	case data_god:get_equip(GoodsId) of
		#base_god_equip{color = EquipColor} ->
			if
				LimitColor == EquipColor ->
					case data_equip:get_equip_attr_cfg(GoodsId) of
						#equip_attr_cfg{star = EquipStar} ->
							if
								LimitStar == EquipStar ->
									is_color(EquipList, LimitColor, LimitStar);
								true ->
									{false, ?ERRCODE(err440_color_limit)}
							end;
						_ ->
							{false, ?MISSING_CONFIG}
					end;
				true ->
					{false, ?ERRCODE(err440_color_limit)}
			end;
		_ ->
			false
	end.

%% ---------------------------------- db函数 -----------------------------------
db_god_select(RoleId) ->
	Sql = io_lib:format(?sql_god_select, [RoleId]),
	db:get_all(Sql).

db_skill_select(RoleId, GodId) ->
	Sql = io_lib:format(?sql_skill_select, [RoleId, GodId]),
	db:get_all(Sql).

db_role_select(RoleId) ->
	Sql = io_lib:format(?sql_god_role_select, [RoleId]),
	db:get_row(Sql).

db_god_replace(RoleId, God) ->
	#god{id = GodId, lv = Lv, exp = Exp,
		grade = Grade, pos = Pos, star = Star
	} = God,
	Sql = io_lib:format(?sql_god_replace, [RoleId, GodId, Lv, Exp, Grade, Star, Pos]),
	db:execute(Sql).

db_god_update(Format, Val) ->
	Sql = io_lib:format(Format, Val),
	db:execute(Sql).

db_skill_replace(RoleId, GodId, SkillId, Type, SkillLv, Exp) ->
	Sql = io_lib:format(?sql_skill_replace, [RoleId, GodId, SkillId, Type, SkillLv, Exp]),
	db:execute(Sql).

db_role_replace(RoleId, StatusGod) ->
	#status_god{battle = Battle, trans = Trans} = StatusGod,
	TermBattle = util:term_to_bitstring(Battle),
	Sql = io_lib:format(?sql_god_role_replace, [RoleId, TermBattle, Trans]),
%%	?MYLOG("cym", "Sql ~s~n", [Sql]),
	db:execute(Sql).

db_refresh_skill([], _RoleId, _GodId, _N) ->
	ok;
db_refresh_skill([{Type, SkillId, SkillLv, Exp} | T], RoleId, GodId, N) ->
	db_skill_replace(RoleId, GodId, SkillId, Type, SkillLv, Exp),
	case N >= 5 of
		true ->
			timer:sleep(100),
			db_refresh_skill(T, RoleId, GodId, 0);
		false ->
			db_refresh_skill(T, RoleId, GodId, N + 1)
	end.

db_god_stren_select(RoleId) ->
	Sql = io_lib:format(?sql_god_stren_select, [RoleId]),
	db:get_all(Sql).

db_god_stren_replace(RoleId, GodStrenItem) ->
	#god_stren_item{god_type = GodType, level = Level, exp = Exp} = GodStrenItem,
	Sql = io_lib:format(?sql_god_stren_replace, [RoleId, GodType, Level, Exp]),
	db:execute(Sql).

%% ---------------------------------- 日志 -----------------------------------
%%激活日志
log_active(RoleId, GodId) ->
	lib_log_api:log_god_active(RoleId, GodId).

%%升级日志
log_lv_up(RoleId, GodId, Olv, Nlv, NExp, AddExp, Cost) ->
	lib_log_api:log_god_lv_up(RoleId, GodId, Olv, Nlv, NExp, AddExp, Cost).

%%升阶日志
log_grade_up(RoleId, GodId, Grade, NGrade, Cost) ->
	lib_log_api:log_god_grade_up(RoleId, GodId, Grade, NGrade, Cost).




check_equip(GodId, TakeOnGoodsInfo) ->
	#goods{goods_id = GoodsId} = TakeOnGoodsInfo,
	case data_god:get_equip(GoodsId) of
		#base_god_equip{limit = Limit} ->
			case data_god:get_god(GodId) of
				#base_god{color = GodColor} ->
					if
						GodColor == Limit ->
							true;
						true ->
							{false, ?ERRCODE(err440_color_limit)}
					end;
				_ ->
					{false, ?ERRCODE(err440_not_active)}
			end;
		_ ->
			{false, ?ERRCODE(err440_not_god_equip)}
	end.


%% 幻兽物品other_data的保存格式
format_other_data(#goods{type = ?GOODS_TYPE_GOD_EQUIP, other = Other}) ->
	#goods_other{optional_data = T} = Other,
	[?GOODS_OTHER_KEY_GOD | T];


format_other_data(_) ->
	[].


%% 降神物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, Data) ->
	Other#goods_other{optional_data = Data}.

%% -----------------------------------------------------------------
%% @desc     功能描述  更新降神装备的额外数据到数据库中
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
change_goods_other(#goods{id = Id} = GoodsInfo) ->
	lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).


%% -----------------------------------------------------------------
%% @desc     功能描述  装备评分
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
cal_equip_rating(GoodsTypeR) ->
	#ets_goods_type{goods_id = GoodId} = GoodsTypeR,
	case data_god:get_equip(GoodId) of
		#base_god_equip{attr = Attr} ->
			lib_equip_api:cal_equip_rating(GoodsTypeR, Attr);
		_ ->
			0
	end.
	
%% -----------------------------------------------------------------
%% @desc     功能描述  是否禁止场景
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
is_forbid_scene(Scene) ->
	ForbidSceneType = data_god:get_kv(forbid_scene_type),
	case lists:member(Scene, ForbidSceneType) of
		true ->
			true;
		_ ->
			false
	end.


%% -----------------------------------------------------------------
%% @desc     功能描述  获取降神的技能的固定战力
%% @param    参数
%% @return   返回值
%% @history  修改历史
%% -----------------------------------------------------------------
get_skill_power(PlayerStatus) ->
	#player_status{god = GodStatus} = PlayerStatus,
%%	#status_god{god_list = GodList} = GodStatus,
	case GodStatus  of
		#status_god{god_list = GodList} ->
			F = fun(God, AccPower) ->
				get_skill_power2(God) + AccPower
			end,
			Power = lists:foldl(F, 0, GodList),
			Power;
		_ ->
			0
	end.
	

get_skill_power2(God) ->
	#god{grade = MyStage, id = Id} = God,
	case data_god:get_god(Id) of
		#base_god{skill = SkillCfg, talent = _TalentList} ->
			TalentList = get_right_talent_list(_TalentList),
			case lists:keyfind(MyStage, 1, SkillCfg) of
				{_, Skill} ->
					ok;
				_ ->
					Skill = []
			end,
			SkillLIdList = [{SkillId, Lv} || {SkillId, Stage, Lv} <- TalentList, MyStage >= Stage] ++ [{SkillId2, 1} || SkillId2 <- Skill],
			F1 = fun({SkillId1, Lv1}, GodPower) ->
				case data_skill:get(SkillId1, Lv1) of
					#skill{lv_data = LvData, career = ?SKILL_CAREER_GOD} ->
						LvData#skill_lv.power + GodPower;
					_ ->
						GodPower
				end
			end,
			LastPower = lists:foldl(F1, 0, SkillLIdList),
%%			?MYLOG("cym", "Id ~p  get_skill_power2 ~p~n", [Id, LastPower]),
			LastPower;
		_ ->
			0
	end.


check_active_god_all([], _GodList) ->
	true;
check_active_god_all({NeedGodList, NeedAllLv}, GodList) ->
	AllLv = get_all_god_lv(NeedGodList, GodList),
	if
		AllLv >= NeedAllLv ->
			true;
		true ->
			{false, ?ERRCODE(err440_god_all_lv)}
	end.


get_all_god_lv(NeedGodList, GodList) ->
	get_all_god_lv(NeedGodList, GodList, 0).


get_all_god_lv([], _GodList, AllLv) ->
	AllLv;
get_all_god_lv([GodId | NeedGodList], GodList, AllLv) ->
	case lists:keyfind(GodId, #god.id, GodList) of
		#god{lv = Lv} ->
			get_all_god_lv(NeedGodList, GodList, AllLv + Lv);
		_ ->
			get_all_god_lv(NeedGodList, GodList, AllLv)
	end.


%%去重， id重复的话，取后面的元组
get_right_talent_list(TalentList) ->
	get_right_talent_list(lists:reverse(TalentList), []).

get_right_talent_list([], Acc) ->
	Acc;
get_right_talent_list([{Id, Stage, Lv} | List], Acc) ->
	case lists:keyfind(Id, 1, Acc) of
		{Id, _OldStage, _OldLv} ->
			get_right_talent_list(List, Acc);
		_ ->
			get_right_talent_list(List, [{Id, Stage, Lv} | Acc])
	end.
	
	
%% 检测降神智能合成	
check_intelligent_compose(RoleId, RuleId, Count, ComposeGoodsList, UpdateGodList, LogCostMat, LogComposeEquip) ->
	case data_goods_compose:get_cfg(RuleId) of
		#goods_compose_cfg{regular_mat = RegularMat, goods = [{_, TargetGodGoodTypeId, _}] = RewardGoodsList} when RegularMat =/= [] ->	
			%% 获取降神背包物品
			#goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
			GodGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_GOD2_EQUIP_BAG, Dict),
			RegularMatLength = length(RegularMat),
			[{_, GodGoodTypeId, _}] = RegularMatLength > 0 andalso hd(RegularMat),
			%% 获取指定物品类型id的降神装备
			SpecifyGodGoodsList = [GodGoods || #goods{goods_id = EquipType} = GodGoods <- GodGoodsList, EquipType == GodGoodTypeId],
			SpecifyGodGoodsListLength = length(SpecifyGodGoodsList),
			CostLength = RegularMatLength * Count, %% 要消耗的长度
			%% 保证背包里有足够的合成装备数量	
			case Count > 0 andalso SpecifyGodGoodsListLength >= CostLength of
				true ->
					CostList = lists:sublist(SpecifyGodGoodsList, CostLength),				
					ComposeGoodsList2 = [{goods_attr, TmpGTypeId, Count, []}
                        || {?TYPE_GOODS, TmpGTypeId, _} <- RewardGoodsList],
                    {true, CostList, ComposeGoodsList2 ++ ComposeGoodsList, [{?GOODS_TYPE_GOD_EQUIP, TargetGodGoodTypeId, Count}|UpdateGodList], [{GodGoodTypeId, CostLength}|LogCostMat], [{TargetGodGoodTypeId, Count}|LogComposeEquip]};
				false ->
					{false, ?FAIL}
			end;
		_ ->
			?ERR("miss config: ~p", [?MISSING_CONFIG]),
			{false, ?MISSING_CONFIG}
	end.


get_exp_ratio(Ps) ->
	#player_status{scene = Scene, god = StatusGod} = Ps,
	ExpSceneList = data_god:get_kv(exp_scene_list),
	ExpSkillList = data_god:get_kv(exp_skill_list),
	case lists:member(Scene, ExpSceneList) of
		true ->
			case StatusGod of
				#status_god{summon = #god_summon{god_id = GodId}, god_list = GodList} when GodId > 0 ->
					case lists:keyfind(GodId, #god.id, GodList) of
						#god{} ->
							{_, _, AssistSkill} = lib_god_summon:get_trans_form_skill(GodId, GodList),
							F = fun({SkillId, Lv}, AddRatio) ->
									case lists:member(SkillId, ExpSkillList) of
										true ->
											case data_skill:get(SkillId, Lv) of
												#skill{lv_data = #skill_lv{effect = [{?EXP_ADD,_,_,_,_,Ratio,_,_,_,_}]}} ->
													erlang:round(Ratio * ?RATIO_COEFFICIENT) + AddRatio;
												_ ->
													AddRatio
											end;
										_ ->
											AddRatio
									end
								end,
							Res = lists:foldl(F, 0, AssistSkill),
%%							?PRINT("Res ~p~n", [Res]),
							Res;
						_ ->
							0
					end;
				_ ->
					0
			end;
		_ ->
			0
	end.