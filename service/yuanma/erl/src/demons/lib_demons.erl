%%%--------------------------------------
%%% @Module  : lib_demons
%%% @Author  : lxl
%%% @Created : 2019.6.21
%%% @Description:  使魔
%%%--------------------------------------

-module (lib_demons).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("figure.hrl").
-include("demons.hrl").
-include("predefine.hrl").
-include("goods.hrl").
-include("skill.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_module_buff.hrl").
-include("def_goods.hrl").

-compile(export_all). 

gm_save_data() ->
	OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_demons, delay_stop, []) || E <- OnlineRoles],
    ok.

login(PS) ->
	#player_status{id = RoleId, figure = Figure} = PS,
	#figure{lv = Lv} = Figure,
	StatusDemons = lib_demons_util:new_status_demons(RoleId, Lv),
	%print_status_demons(login, StatusDemons),
	DemonsIdBattle = StatusDemons#status_demons.demons_id,
	PS#player_status{figure = Figure#figure{demons_id = DemonsIdBattle}, status_demons = StatusDemons}.

delay_stop(PS) ->
	#player_status{id = RoleId, status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	spawn(fun() ->
		Fun = fun(#demons{demons_id = DemonsId, slot_list = SlotList}) ->
			F1 = fun(#slot_skill{skill_id = SkillId, slot = Slot, level = Level}) ->
				Sql = io_lib:format(<<"delete from `demons_slot_skill` where `role_id` = ~p and `demons_id` = ~p and `slot` = ~p">>, [RoleId, DemonsId, Slot]),
				db:execute(Sql),
				lib_demons_util:db_replace_demons_slot(RoleId, DemonsId, SkillId, Slot, Level)
			end,
			lists:foreach(F1, SlotList)
		end,
	    lists:foreach(Fun, DemonsList)
	end),
	PS.

logout(PS) ->
	#player_status{id = RoleId, figure = Figure, status_demons = StatusDemons} = PS,
    #figure{lv = Lv} = Figure,
    case Lv >= ?demons_open_lv of 
        true ->
            #status_demons{demons_shop = DemonsShop} = StatusDemons,
            case DemonsShop of 
            	#demons_shop{is_dirty = 1} ->
            		lib_demons_util:db_replace_demons_shop(RoleId, DemonsShop),
            		PS;
            	_ ->
            		PS
            end;
        _ ->
            PS
    end.

get_battle_demons_id(RoleId) ->
	case lib_demons_util:db_select_demons_role_msg(RoleId) of 
		[DemonsIdBattle, _PaintingListStr] -> DemonsIdBattle;
		_ -> 0
	end.

handle_event(PS, #event_callback{type_id = ?EVENT_LV_UP}) ->
	#player_status{id = RoleId, figure = Figure, status_demons = StatusDemons} = PS,
	#figure{lv = Lv} = Figure,
	#status_demons{demons_list = DemonsList, demons_shop = DemonsShop} = StatusDemons,
	DemonsId = ?demons_id_free,
	case DemonsId > 0 andalso Lv == ?demons_open_lv andalso lists:keymember(DemonsId, #demons.demons_id, DemonsList) == false of 
		true ->
			Demons = active_demons_free(RoleId, DemonsId),
            NewDemonsShop = lib_demons_util:calc_shop_data(RoleId, Lv, DemonsShop),
			NewStatusDemons = StatusDemons#status_demons{demons_id = DemonsId, demons_list = [Demons|DemonsList], demons_shop = NewDemonsShop},
			lib_demons_util:db_replace_demons_role_msg(RoleId, NewStatusDemons),
			%% 统计使魔技能列表
			NewStatusDemonsAfSticSkill = lib_demons_util:static_demons_skill_infos(NewStatusDemons, DemonsId),
			%% 计算使魔基础属性
			NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemonsAfSticSkill),
			%% 计算使魔技能属性
			NewStatusDemonsAfSkillAttr = lib_demons_util:count_demons_attr(?ATTR_TYPE_SKILL, NewStatusDemonsAfDemons),
			%% 计算使魔技能战力
			NewStatusDemonsAfSkillPower = lib_demons_util:count_demons_skill_power(NewStatusDemonsAfSkillAttr),
			PSAfDemons = PS#player_status{status_demons = NewStatusDemonsAfSkillPower, figure = Figure#figure{demons_id = DemonsId}},
			CountPS = count_player_attribute(PSAfDemons),
			%% 更新场景技能
			PSAfTrainObj = update_scene_train_obj(CountPS, DemonsId),
			update_scene_info(PSAfTrainObj, all),
			%% 场景广播 切换使魔
			lib_scene:broadcast_player_attr(PSAfTrainObj, [{8, DemonsId}]),
			BuffPS = lib_module_buff:update_module_buff(PSAfTrainObj),
			{ok, LastPS} = lib_supreme_vip_api:active_demons(BuffPS, DemonsId),
			{ok, LastPS};
		_ ->
			{ok, PS}
	end;
handle_event(PS, _) ->
    {ok, PS}.

%% 凌晨刷新使魔商店
daily_reset() ->
    OnlineRoles = ets:tab2list(?ETS_ONLINE),
    [lib_player:apply_cast(E#ets_online.id, ?APPLY_CAST_SAVE, lib_demons, updata_demons_shop, []) || E <- OnlineRoles].

updata_demons_shop(PS) ->
    #player_status{id = RoleId, figure = Figure, status_demons = StatusDemons} = PS,
    #figure{lv = Lv} = Figure,
    case Lv >= ?demons_open_lv of 
        true ->
            NewDemonsShop = lib_demons_util:calc_shop(RoleId, 0, utime:unixtime()),
            IsOpen = mod_daily:get_count(PS#player_status.id, ?MOD_DEMONS, 1),
            lib_server_send:send_to_sid(PS#player_status.sid, pt_183, 18315, [IsOpen]),
            NewStatusDemons = StatusDemons#status_demons{demons_shop = NewDemonsShop},
            {ok, PS#player_status{status_demons = NewStatusDemons}};
        _ ->
            {ok, PS}
    end.

%% 获取使魔对玩家的生效的被动技能
get_demons_skill(PS) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList, slot_skill = SlotSkill} = StatusDemons,
	case lists:keyfind(DemonsIdBattle, #demons.demons_id, DemonsList) of 
		#demons{skill_for_role = SkillForRole} ->
			SkillForRole++SlotSkill;
		_ ->
			SlotSkill
	end.

get_demons_module_buff(PS) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	ModBuffSkillList = [{DemonsId, SkillId, SkillLv, IsActive} 
		||#demons{demons_id = DemonsId, skill_list = SkillList} <- DemonsList, #demons_skill{skill_id = SkillId, level = SkillLv, sk_type = SkType, is_active = IsActive} <- SkillList, SkType == ?DEMONS_SKILL_TYPE_LIFE],
	F = fun({_DemonsId, SkillId, SkillLv, IsActive}, List) ->
		case IsActive == 1 of 
			true ->
				case data_demons:get_demons_skill_upgrade_cfg(SkillId, SkillLv) of 
					#base_demons_skill_upgrade{usage = Usage} ->
						AddList = [{ModBufId, BufVal} ||{buff, ModBufId, BufVal} <- Usage],
						ModuleBuffList = lib_module_buff:trans_to_module_buff(AddList),
						ModuleBuffList ++ List;
					_ ->
						List
				end;
			_ ->
				List
		end
	end,
	ModBuffList = lists:foldl(F, [], ModBuffSkillList),
	ModBuffList.

%% 使魔技能使用检查
check_use_demons_skill(PS, SkillId) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList, skill_use_time = SkillUseTime} = StatusDemons,
	case lists:keyfind(DemonsIdBattle, #demons.demons_id, DemonsList) of 
		#demons{skill_for_demons = SkillForDemons} ->
			NowTime = utime:longunixtime(),
			%?PRINT("check_use_demons_skill ~p~n", [NowTime-SkillUseTime]),
			case NowTime >= SkillUseTime + (?demons_skill_cd * 1000) of 
				true ->
					case lists:keyfind(SkillId, 1, SkillForDemons) of 
						{SkillId, SkillLv} ->
							{true, SkillLv};
						_ ->
							{false, 6}
					end;
				_ ->
					{false, 5}
			end;
		_ ->
			{false, 6}
	end.

%% 使用技能成功
use_demons_skill_succ(PS, _SkillId) ->
	#player_status{status_demons = StatusDemons} = PS,
	%?PRINT("use_demons_skill_succ ### ~n", []),
	PS#player_status{status_demons = StatusDemons#status_demons{skill_use_time = utime:longunixtime()}}.

%% 获取上阵使魔的战斗信息
get_demons_battle_info(PS) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList} = StatusDemons,
	case lists:keyfind(DemonsIdBattle, #demons.demons_id, DemonsList) of 
		#demons{attr_list = AttrList, skill_for_demons = SkillForDemons} ->
			F = fun({SkillId, SkillLv}, List) ->
				case data_skill:get(SkillId, SkillLv) of 
					#skill{type = Type} when Type == ?SKILL_TYPE_PASSIVE ->
						[{SkillId, SkillLv}|List];
					_ ->
						List
				end
			end,
			DemonsPassiveSkills = lists:foldl(F, [], SkillForDemons),
			{ok, AttrList, DemonsPassiveSkills};
		_ ->
			false
	end.

%% 查看使魔基础信息
send_active_demons(PS) ->
	#player_status{sid = Sid, status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList} = StatusDemons,
	SendList = [{DemonsId, Level, Exp, Star, SlotNum,
                 [{SkillId, SkillLv, Process, IsActive} ||#demons_skill{skill_id = SkillId, level = SkillLv, process = Process, is_active = IsActive} <- SkillList],
                 [{SkId, SkLv, Slot, Quality, Sort} ||#slot_skill{skill_id = SkId, level = SkLv, slot = Slot, quality = Quality, sort = Sort} <- SlotList]} 
            ||#demons{demons_id = DemonsId, level = Level, exp = Exp, star = Star, skill_list = SkillList, slot_list = SlotList, slot_num = SlotNum} <- DemonsList],
	% ?PRINT("send_active_demons DemonsIdBattle ~p~n", [DemonsIdBattle]),
	IsOpen = mod_daily:get_count(PS#player_status.id, ?MOD_DEMONS, 1),
	% ?PRINT("send_active_demons IsOpen:~p, ~p~n", [IsOpen, SendList]),
	lib_server_send:send_to_sid(Sid, pt_183, 18301, [IsOpen, SendList]).
%% 查看使魔详细信息
send_demons_detail(PS, DemonsId) ->
	#player_status{sid = Sid, status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
		#demons{power = _Power} = Demons ->
			% case Power > 0 of 
			% 	true ->
			% 		?PRINT("send_demons_detail#1 ~p~n", [{DemonsId, Power}]),
			% 		lib_server_send:send_to_sid(Sid, pt_183, 18302, [DemonsId, Power]);
			% 	_ ->
			NewPower = lib_demons_util:count_demons_power(PS, Demons),
			%NewDemons = Demons#demons{power = NewPower},
			%NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
			?PRINT("send_demons_detail#2 ~p~n", [{DemonsId, NewPower}]),
			lib_server_send:send_to_sid(Sid, pt_183, 18302, [DemonsId, NewPower]),
			{ok, PS};
			% end;
		_ ->
			Demons1 = #demons{demons_id=DemonsId, star = 0},
			SkillList = lib_demons_util:refresh_demons_skill(Demons1, []),
			Demons2 = Demons1#demons{skill_list = SkillList},
			Demons = lib_demons_util:count_single_demons_attr(Demons2),
			NewPower = lib_demons_util:count_demons_expact_power(PS, Demons),
			lib_server_send:send_to_sid(Sid, pt_183, 18302, [DemonsId, NewPower]),
			ok
	end.
%% 羁绊
send_demons_fetters(PS) ->
	#player_status{sid = Sid, status_demons = StatusDemons} = PS,
	#status_demons{fetters_list = FettersList} = StatusDemons,
	?PRINT("send_demons_fetters ~p~n", [FettersList]),
	lib_server_send:send_to_sid(Sid, pt_183, 18303, [FettersList]).

%% 上卷
send_painting_info(PS) ->
	#player_status{sid = Sid, status_demons = StatusDemons} = PS,
	#status_demons{painting_list = PaintingList} = StatusDemons,
	?PRINT("send_painting_info ~p~n", [PaintingList]),
	lib_server_send:send_to_sid(Sid, pt_183, 18307, [PaintingList]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 使魔激活/升星
active_demons(PS, DemonsId) ->
	case lib_demons_util:check_active_demons(PS, DemonsId) of 
		{active, NewDemons, DemonsCfg, DemonsStarCfg} when is_record(DemonsCfg, base_demons) -> %% 激活
			#base_demons{fetters = FettersCheck} = DemonsCfg,
			#base_demons_star{cost = CostList} = DemonsStarCfg,
			case lib_goods_api:cost_object_list(PS, CostList, active_demons, integer_to_list(DemonsId)) of 
				{true, PSAfCost} ->
					#player_status{id = RoleId, figure = #figure{name = RoleName}, status_demons = StatusDemons} = PSAfCost,
					lib_log_api:log_active_demons(RoleId, DemonsId, CostList),
					lib_demons_util:db_replace_demons(RoleId, NewDemons),
					#status_demons{demons_list = DemonsList, fetters_list = OFettersList} = StatusDemons,	
					NewDemonsList = [NewDemons|DemonsList],
					%% 刷新羁绊
					NewFettersList = lib_demons_util:refresh_fetters(NewDemonsList, FettersCheck, OFettersList),
					NewStatusDemons = StatusDemons#status_demons{demons_list = NewDemonsList, fetters_list = NewFettersList},
					%% 统计使魔技能列表
					NewStatusDemonsAfSticSkill = lib_demons_util:static_demons_skill_infos(NewStatusDemons, DemonsId),
					%% 计算使魔基础属性
					NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemonsAfSticSkill),
					%NewStatusDemonsAfPainting = lib_demons_util:count_demons_attr(?ATTR_TYPE_PAINTING, NewStatusDemonsAfDemons),
					%% 计算使魔羁绊属性
					NewStatusDemonsAfFetters = lib_demons_util:count_demons_attr(?ATTR_TYPE_FETTERS, NewStatusDemonsAfDemons),
					%% 计算使魔技能属性
					NewStatusDemonsAfSkillAttr = lib_demons_util:count_demons_attr(?ATTR_TYPE_SKILL, NewStatusDemonsAfFetters),
					%% 计算使魔技能战力
					NewStatusDemonsAfSkillPower = lib_demons_util:count_demons_skill_power(NewStatusDemonsAfSkillAttr),
					PSAfDemons = PSAfCost#player_status{status_demons = NewStatusDemonsAfSkillPower},
					CountPS = count_player_attribute(PSAfDemons),
					%% 更新场景属性和技能
					update_scene_info(CountPS, all),
					PSAfDemonsPower = update_demons_power(CountPS, DemonsId),
					BuffPS = lib_module_buff:update_module_buff(PSAfDemonsPower),
					{ok, LastPS} = lib_supreme_vip_api:active_demons(BuffPS, DemonsId),
					%print_status_demons(active, NewStatusDemonsAfSkillPower),
					lib_chat:send_TV({all}, ?MOD_DEMONS, 2, [RoleName, util:make_sure_binary(DemonsCfg#base_demons.demons_name)]),
					lib_demons_api:auto_upgrade_demons_skill_process(RoleId, DemonsId),
					{ok, LastPS};
				{false, Res, _} ->
					{false, Res}
			end;
		{up_star, NewDemons, DemonsCfg, DemonsStarCfg} when is_record(DemonsStarCfg, base_demons_star) -> %% 升星
			#base_demons_star{cost = CostList} = DemonsStarCfg,
			case lib_goods_api:cost_object_list(PS, CostList, active_demons, integer_to_list(DemonsId)) of 
				{true, PSAfCost} ->
					#player_status{id = RoleId, figure = #figure{name = RoleName}, status_demons = StatusDemons} = PSAfCost,
					lib_log_api:log_up_star_demons(RoleId, DemonsId, NewDemons#demons.star-1, NewDemons#demons.star, CostList),
					lib_demons_util:update_demons_star(RoleId, NewDemons),
					#status_demons{demons_list = DemonsList} = StatusDemons,	
					NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
					%% 上卷数更新
					PaintingList = [Star ||#demons{star = Star} <- NewDemonsList, Star >= ?painting_star],
					PaintingNum = lists:sum([0|PaintingList]),
					NewStatusDemons = StatusDemons#status_demons{painting_num = PaintingNum, demons_list = NewDemonsList},
					%% 统计使魔技能列表
					NewStatusDemonsAfSticSkill = lib_demons_util:static_demons_skill_infos(NewStatusDemons, DemonsId),
					%% 计算使魔基础属性
					NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemonsAfSticSkill),
					%NewStatusDemonsAfPainting = lib_demons_util:count_demons_attr(?ATTR_TYPE_PAINTING, NewStatusDemonsAfDemons),
					%% 计算使魔技能属性
					NewStatusDemonsAfSkillAttr = lib_demons_util:count_demons_attr(?ATTR_TYPE_SKILL, NewStatusDemonsAfDemons),
					%% 计算使魔技能战力
					NewStatusDemonsAfSkillPower = lib_demons_util:count_demons_skill_power(NewStatusDemonsAfSkillAttr),
					PSAfDemons = PSAfCost#player_status{status_demons = NewStatusDemonsAfSkillPower},
					CountPS = count_player_attribute(PSAfDemons),
					%% 更新战斗对象属性
					PSAfTrainObj = update_scene_train_obj(CountPS, DemonsId),
					%% 更新场景属性和技能
					update_scene_info(PSAfTrainObj, all),
					PSAfDemonsPower = update_demons_power(PSAfTrainObj, DemonsId),
					LastPS = lib_module_buff:update_module_buff(PSAfDemonsPower),
					%?PRINT("active_demons#2 ~p~n", [NewStatusDemonsAfSkillPower]),
					%print_status_demons(up_star, NewStatusDemonsAfSkillPower),
					lib_chat:send_TV({all}, ?MOD_DEMONS, 1, [RoleName, util:make_sure_binary(DemonsCfg#base_demons.demons_name), NewDemons#demons.star]),
					{ok, LastPS};
				{false, Res, _} ->
					{false, Res}
			end;
		{false, Res} -> {false, Res};
		_Err ->
			?ERR("active_demons err:~p~n", [_Err]),
			{false, ?FAIL}
	end.

active_demons_free(RoleId, DemonsId) ->
	Demons1 = #demons{demons_id=DemonsId, star = 0, slot_num = ?DEMONS_SLOT_BEGIN},
	SkillList = lib_demons_util:refresh_demons_skill(Demons1, []),
	Demons2 = Demons1#demons{skill_list = SkillList},
	Demons = lib_demons_util:count_single_demons_attr(Demons2),
	lib_demons_util:db_replace_demons(RoleId, Demons),
	lib_log_api:log_active_demons(RoleId, DemonsId, []),
	lib_demons_api:auto_upgrade_demons_skill_process(RoleId, DemonsId),
	Demons.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 使魔升级
upgrade_demons(PS, DemonsId, GoodsIdNumList) ->
	case lib_demons_util:check_upgrade_demons(PS, DemonsId) of 
		{true, Demons} ->
			#demons{demons_id = DemonsId, level = Level, exp = Exp} = Demons,
			DemonsUpgradeGoods = lib_demons_util:get_demons_upgrade_goods(DemonsId),
			{NewLevel, NewExp, CostList} = upgrade_demons_do(DemonsId, Level, Exp, DemonsUpgradeGoods, GoodsIdNumList, []),
			?PRINT("upgrade_demons ~p~n", [{NewLevel, NewExp, CostList}]),
			case lib_goods_api:cost_object_list_with_check(PS, CostList, upgrade_demons, integer_to_list(DemonsId)) of 
				{true, PSAfCost} ->
					#player_status{id = RoleId, status_demons = StatusDemons} = PSAfCost,
					Demons1 = Demons#demons{level = NewLevel, exp = NewExp},
					NewDemons = lib_demons_util:count_single_demons_attr(Demons1),
					lib_log_api:log_up_level_demons(RoleId, DemonsId, Level, Exp, NewLevel, NewExp, CostList),
					lib_demons_util:update_demons_level(RoleId, NewDemons),
					#status_demons{demons_list = DemonsList} = StatusDemons,	
					NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
					NewStatusDemons = StatusDemons#status_demons{demons_list = NewDemonsList},
					NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemons),
					PSAfDemons = PSAfCost#player_status{status_demons = NewStatusDemonsAfDemons},
					CountPS = count_player_attribute(PSAfDemons),
					%% 更新场景属性
					PSAfTrainObj = update_scene_train_obj(CountPS, DemonsId),
					update_scene_info(PSAfTrainObj, attr),
					LastPS = update_demons_power(PSAfTrainObj, DemonsId),
					%?PRINT("upgrade_demons ~p~n", [NewStatusDemonsAfDemons]),
					%print_status_demons(up_level, NewStatusDemonsAfDemons),
					{ok, LastPS};
				{false, Res, _} ->
					{false, Res}
			end;
		Res ->
			Res
	end.

upgrade_demons_do(_DemonsId, Level, Exp, _DemonsUpgradeGoods, [], CostList) ->
	{Level, Exp, CostList};
upgrade_demons_do(DemonsId, Level, Exp, DemonsUpgradeGoods, [{GTypeId, Num}|GoodsIdNumList], CostList) ->
	{_, ExpAddOne} = lists:keyfind(GTypeId, 1, DemonsUpgradeGoods),
	{NewLevel, NewExp, CostNum} = upgrade_demons_helper(DemonsId, Level, Exp, Num, ExpAddOne, 0),
	case CostNum < Num of 
		true -> %% 升满级了
			NewCostList = ?IF(CostNum > 0, [{?TYPE_GOODS, GTypeId, CostNum}|CostList], CostList),
			{NewLevel, NewExp, NewCostList};
		_ ->
			upgrade_demons_do(DemonsId, NewLevel, NewExp, DemonsUpgradeGoods, GoodsIdNumList, [{?TYPE_GOODS, GTypeId, Num}|CostList])
	end.


upgrade_demons_helper(DemonsId, Level, Exp, 0, ExpAddOne, Acc) ->
	case lib_demons_util:get_demons_level_cfg(DemonsId, Level+1) of 
		#base_demons_level{exp = ExpCon} ->
        	case Exp >= ExpCon of
                true ->
                    NewLevel = Level+1,
                    NewExp = Exp - ExpCon,
                    upgrade_demons_helper(DemonsId, NewLevel, NewExp, 0, ExpAddOne, Acc);
                false ->
                    {Level, Exp, Acc}
            end;
		_ ->
			{Level, Exp, Acc}
	end;
upgrade_demons_helper(DemonsId, Level, Exp, Num, ExpAddOne, Acc) ->
	case lib_demons_util:get_demons_level_cfg(DemonsId, Level+1) of 
		#base_demons_level{exp = ExpCon} ->
			UpCostNum = max(umath:ceil((ExpCon - Exp) / ExpAddOne), 0),
        	CostNum = ?IF(Num =< UpCostNum, Num, UpCostNum),
        	ExpAdd = CostNum * ExpAddOne,
        	case Exp+ExpAdd >= ExpCon of
                true ->
                    NewLevel = Level+1,
                    NewExp = Exp + ExpAdd - ExpCon,
                    upgrade_demons_helper(DemonsId, NewLevel, NewExp, 0, ExpAddOne, Acc+CostNum);
                false ->
                    {Level, Exp+ExpAdd, Acc+CostNum}
            end;
		_ ->
			{Level, Exp, Acc}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 使魔跟随
demons_follow(PS, DemonsId) ->
	#player_status{id = RoleId, status_demons = StatusDemons, figure = Figure} = PS,
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList} = StatusDemons,
	case DemonsId == DemonsIdBattle of 
		false ->
			case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
				#demons{} ->
					NewDemonsIdBattle = DemonsId,
					NewStatusDemons = StatusDemons#status_demons{demons_id = NewDemonsIdBattle},
					lib_demons_util:db_replace_demons_role_msg(RoleId, NewStatusDemons),
					%% 统计使魔技能列表
					NewStatusDemonsAfSticSkilltmp = lib_demons_util:static_demons_skill_infos(NewStatusDemons, DemonsIdBattle),
					NewStatusDemonsAfSticSkill = lib_demons_util:static_demons_skill_infos(NewStatusDemonsAfSticSkilltmp, DemonsId),
					%% 计算使魔技能属性
					NewStatusDemonsAfSkillAttr = lib_demons_util:count_demons_attr(?ATTR_TYPE_SKILL, NewStatusDemonsAfSticSkill),
					NewPS = PS#player_status{figure = Figure#figure{demons_id = NewDemonsIdBattle}, status_demons = NewStatusDemonsAfSkillAttr},
					lib_role:update_role_show(RoleId, [{demons_id, DemonsId}]),
					CountPS = count_player_attribute(NewPS),
					%% 更新场景技能
					PSAfTrainObj = update_scene_train_obj(CountPS, DemonsId),
					update_scene_info(PSAfTrainObj, all),
					%% 场景广播 切换使魔
					lib_scene:broadcast_player_attr(PSAfTrainObj, [{8, DemonsId}]),
					%?PRINT("demons_follow ~p~n", [NewStatusDemonsAfSkillAttr]),
					%print_status_demons(follow, NewStatusDemonsAfSkillAttr),
					{ok, PSAfTrainObj};
				_ ->
					{false, ?ERRCODE(err183_demons_not_active)}
			end;
		_ ->
			{false, ?ERRCODE(err183_demons_is_follow)}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 领取上卷奖励
get_painting_reward(PS, PaintingId) ->
	#player_status{id = RoleId, status_demons = StatusDemons} = PS,
	#status_demons{painting_list = PaintingList, painting_num = PaintingNum} = StatusDemons,
	IsReceive = lists:member(PaintingId, PaintingList),
	case IsReceive of 
		false ->
			case data_demons:get_painting_cfg(PaintingId) of 
				#base_demons_painting{painting_num = PaintingNumNeed, reward = Reward} when PaintingNum>=PaintingNumNeed ->
					NewPaintingList = [PaintingId|PaintingList],
					NewStatusDemons = StatusDemons#status_demons{painting_list = NewPaintingList},
					lib_demons_util:db_replace_demons_role_msg(RoleId, NewStatusDemons),
					NewStatusDemonsAfPainting = lib_demons_util:count_demons_attr(?ATTR_TYPE_PAINTING, NewStatusDemons),
					PSAfPaint = PS#player_status{status_demons = NewStatusDemonsAfPainting},
					CountPS = count_player_attribute(PSAfPaint),
					lib_log_api:log_demons_painting_reward(RoleId, PaintingId, PaintingNum, Reward),
					{ok, NewPS} = lib_goods_api:send_reward_with_mail(CountPS, #produce{type = demons_painting, reward = Reward}),
					?PRINT("get_painting_reward ~p~n", [{PaintingId, Reward}]),
					{ok, NewPS};
				#base_demons_painting{} ->
					{false, ?ERRCODE(err183_cannot_receive)};
				_ ->
					{false, ?MISSING_CONFIG}
			end;
		_ ->
			{false, ?ERRCODE(err183_is_receive)}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 技能升级
upgrade_demons_skill_level(PS, DemonsId, SkillId) ->
	case lib_demons_util:upgrade_demons_skill_level(PS, DemonsId, SkillId) of 
		{ok, NewDemons, NewDemonsSkill, CostList} ->
			case lib_goods_api:cost_object_list(PS, CostList, upgrade_demons_skill, integer_to_list(SkillId)) of 
				{true, PSAfCost} ->
					#player_status{id = RoleId, status_demons = StatusDemons} = PSAfCost,
					lib_log_api:log_upgrade_demons_skill(RoleId, DemonsId, SkillId, NewDemonsSkill#demons_skill.level, CostList),
					lib_demons_util:db_replace_demons_skill(RoleId, DemonsId, NewDemonsSkill),
					#status_demons{demons_list = DemonsList} = StatusDemons,	
					NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
					NewStatusDemons = StatusDemons#status_demons{demons_list = NewDemonsList},
					%% 统计使魔技能列表
					NewStatusDemonsAfSticSkill = lib_demons_util:static_demons_skill_infos(NewStatusDemons, DemonsId),
					%% 计算使魔技能属性
					NewStatusDemonsAfSkillAttr = lib_demons_util:count_demons_attr(?ATTR_TYPE_SKILL, NewStatusDemonsAfSticSkill),
					%% 计算使魔技能战力
					NewStatusDemonsAfSkillPower = lib_demons_util:count_demons_skill_power(NewStatusDemonsAfSkillAttr),
					PSAfDemons = PSAfCost#player_status{status_demons = NewStatusDemonsAfSkillPower},
					CountPS = count_player_attribute(PSAfDemons),
					%% 更新场景技能
					update_scene_info(CountPS, all),
					LastPS = update_demons_power(CountPS, DemonsId),
					%?PRINT("upgrade_demons_skill_level ~p~n", [NewStatusDemonsAfSkillPower]),
					%print_status_demons(up_skill, NewStatusDemonsAfSkillPower),
					{ok, LastPS, NewDemonsSkill#demons_skill.level};
				{false, Res, _} ->
					{false, Res}
			end;
		Res ->
			Res
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 技能进度
upgrade_demons_skill_process(PS, DemonsId, SkillId, TriggerVal) ->
	#player_status{id = RoleId, sid = Sid, status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
		#demons{skill_list = SkillList}=Demons ->
			case lists:keyfind(SkillId, #demons_skill.skill_id, SkillList) of 
				#demons_skill{level = SkillLv, sk_type = ?DEMONS_SKILL_TYPE_LIFE, process = Process, is_active = IsActive}=DemonsSkill ->
					#base_demons_skill{usage = Conditions} = data_demons:get_demons_skill_cfg(DemonsId, SkillId),
					{_, Key, ProcessNeed} = ulists:keyfind(process, 1, Conditions, {process, undefined, 0}),
					if
						IsActive == 1 -> {PS, is_active};
						true ->
							case is_complete(Key, Process, ProcessNeed) of 
								true -> {PS, skip};
								_ ->
									Process1 = update_process(Key, Process, TriggerVal),
									MaxProcess = get_skill_max_process(Key, Process1, ProcessNeed),
									NewProcess = min(Process1, MaxProcess),
									NewDemonsSkill = DemonsSkill#demons_skill{process = NewProcess},
									NewSkillList = lists:keyreplace(SkillId, #demons_skill.skill_id, SkillList, NewDemonsSkill),
									Demons1 = Demons#demons{skill_list = NewSkillList},
									lib_demons_util:db_replace_demons_skill(RoleId, DemonsId, NewDemonsSkill),
									NewDemons = lib_demons_util:count_single_demons_attr(Demons1),	
									NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
									NewStatusDemons = StatusDemons#status_demons{demons_list = NewDemonsList},
									NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemons),
									PSAfDemons = PS#player_status{status_demons = NewStatusDemonsAfDemons},
									CountPS = count_player_attribute(PSAfDemons),
									LastPS = update_demons_power(CountPS, DemonsId),
									mod_scene_agent:update(LastPS, [{battle_attr, LastPS#player_status.battle_attr}]),
									lib_server_send:send_to_sid(Sid, pt_183, 18317, [DemonsId, SkillId, SkillLv, NewProcess, IsActive]),
									{LastPS, skip}
							end
					end;
				_ -> {PS, skip}
			end;
		_ -> {PS, skip}
	end.
%% 离线，直接改数据库
upgrade_demons_skill_process_off(RoleId, DemonsId, SkillId, TriggerKey, TriggerVal) ->
	case db:get_row(io_lib:format("select 1 from role_demons where role_id=~p and demons_id=~p", [RoleId, DemonsId])) of 
		[] -> %% 为激活
			skip;
		_ ->
			#base_demons_skill{usage = Conditions} = data_demons:get_demons_skill_cfg(DemonsId, SkillId),
			{_, Key, ProcessNeed} = ulists:keyfind(process, 1, Conditions, {process, undefined, 0}),
			case db:get_row(io_lib:format("SELECT process, is_active FROM `role_demons_skill` where role_id = ~p and demons_id=~p and skill_id=~p ", [RoleId, DemonsId, SkillId])) of 
				[Process, IsActive] -> ok;
				_ -> Process = 0, IsActive = 0
			end,
			if
				IsActive == 1 -> is_active;
				true ->
					case is_complete(Key, Process, ProcessNeed) of 
						true -> skip;
						_ ->
							lib_player:db_replace_offline_event_data(RoleId, ?MOD_DEMONS, 1, [TriggerKey, TriggerVal], utime:unixtime()),
							skip
					end
			end
	end.

is_complete(_Key, Process, ProcessNeed) when is_integer(ProcessNeed) ->
	Process >= ProcessNeed;
is_complete(_Key, Process, {_, ProcessNeed}) when is_integer(ProcessNeed) ->
	Process >= ProcessNeed;
is_complete(_Key, _Process, _) ->
	false.

get_skill_max_process(_Key, _NowProcess, ProcessNeed) when is_integer(ProcessNeed)  ->
	ProcessNeed;
get_skill_max_process(_Key, _NowProcess, {_, ProcessNeed}) when is_integer(ProcessNeed)  ->
	ProcessNeed;
get_skill_max_process(_Key, NowProcess, _ProcessNeed) ->
	NowProcess.

is_belong_life_skill(Key, TriggerVal, Key, ProcessNeed) ->
	if
		Key == kill_boss ->
			{BossType, _} = TriggerVal,
			{BossType1, _} = ProcessNeed,
			BossType == BossType1;
		Key == daily_charge_reward ->
			{GradeId, _} = TriggerVal,
			{GradeId1, _} = ProcessNeed,
			GradeId == GradeId1;
		Key == race_act ->
			{ScoreNeed, _} = ProcessNeed,
			{{OldScore, NewScore}, _} = TriggerVal,
			OldScore < ScoreNeed andalso NewScore >= ScoreNeed;
		Key == liveness ->
			{LivenessNeed, _} = ProcessNeed,
			{{OldLiveness, NewLiveness}, _} = TriggerVal,
			OldLiveness < LivenessNeed andalso NewLiveness >= LivenessNeed;
		true ->
			true
	end;
is_belong_life_skill(_TriggerKey, _TriggerVal, _Key, _ProcessNeed) ->
	false.

update_process(Key, Process, TriggerVal) when is_integer(TriggerVal) ->
	if
		%% 根据key来判断是递增还是直接赋值
		Key == equip_rating; Key == dragon_level; Key == god_star;
		Key == god_court; Key == constellation_forge_lv ->
			TriggerVal;
		true -> %% 默认递增
			Process + TriggerVal
	end;
update_process(_Key, Process, {_, ValueAdd}) when is_integer(ValueAdd) ->
	if
		%% 根据key来判断是递增还是直接赋值
		true -> %% 默认递增
			Process + ValueAdd
	end;
update_process(_Key, Process, _TriggerVal) ->
	Process.

active_life_skill(PS, DemonsId) ->
	#player_status{id = RoleId, status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
		#demons{skill_list = SkillList}=Demons ->
			case [DemonsSkill ||DemonsSkill <- SkillList, DemonsSkill#demons_skill.sk_type == ?DEMONS_SKILL_TYPE_LIFE] of 
				[#demons_skill{skill_id = SkillId, process = Process, is_active = IsActive}=DemonsSkill|_] when IsActive == 0 ->
					#base_demons_skill{usage = Conditions} = data_demons:get_demons_skill_cfg(DemonsId, SkillId),
					{_, Key, ProcessNeed} = ulists:keyfind(process, 1, Conditions, {process, undefined, 0}),
					case is_complete(Key, Process, ProcessNeed) of 
						true -> 
							NewDemonsSkill = DemonsSkill#demons_skill{is_active = 1},
							NewSkillList = lists:keyreplace(SkillId, #demons_skill.skill_id, SkillList, NewDemonsSkill),
							Demons1 = Demons#demons{skill_list = NewSkillList},
							lib_demons_util:db_replace_demons_skill(RoleId, DemonsId, NewDemonsSkill),
							NewDemons = lib_demons_util:count_single_demons_attr(Demons1),	
							NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
							NewStatusDemons = StatusDemons#status_demons{demons_list = NewDemonsList},
							NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemons),
							PSAfDemons = PS#player_status{status_demons = NewStatusDemonsAfDemons},
							CountPS = count_player_attribute(PSAfDemons),
							LastPS = update_demons_power(CountPS, DemonsId),
							%% 更新生活技能
							BuffPS = lib_module_buff:update_module_buff(LastPS),
							{true, BuffPS};
						_ ->
							{false, ?ERRCODE(err183_demons_skill_not_complete)}
					end;
				_ -> {false, ?ERRCODE(err183_demons_skill_active)}
			end;
		_ -> {false, ?ERRCODE(err183_demons_not_active)}
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 使魔天赋技能升级/镶嵌/替换
upgrade_demons_slot_skill(PS, DemonsId, GoodsTypeId, Slot) ->
    case lib_demons_util:demons_slot_skill(PS, DemonsId, GoodsTypeId, Slot) of 
        {ok, NewDemons, CostList, {OldSkillId, OldLevel}, SlotSkill} ->
            #slot_skill{level = Level, skill_id = SkillId, quality = Quality, sort = Sort} = SlotSkill,
            case lib_goods_api:cost_object_list_with_check(PS, CostList, demons_slot_skill, integer_to_list(SkillId)) of 
                {true, PSAfCost} ->
                    #player_status{id = RoleId, status_demons = StatusDemons, figure = #figure{name = RoleName}} = PSAfCost,
                    lib_log_api:log_demons_slot_skill(RoleId, RoleName, DemonsId, Slot, OldSkillId, OldLevel, SkillId, Level, CostList),
                    if
                        OldSkillId == SkillId orelse OldSkillId == 0 ->
                            skip;
                        true ->
                            lib_demons_util:db_delete_demons_slot(RoleId, DemonsId, OldSkillId)
                    end,
                    lib_demons_util:db_replace_demons_slot(RoleId, DemonsId, SkillId, Slot, Level),
                    #status_demons{demons_list = DemonsList} = StatusDemons, 
                    Demons = lib_demons_util:count_single_demons_attr(NewDemons),
                    % ?PRINT("Demons:~p~n,NewDemons:~p~n",[Demons,NewDemons]),
                    NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, Demons),
                    NewStatusDemons = StatusDemons#status_demons{demons_list = NewDemonsList},
                    ?PRINT("StatusDemons:~p~n",[StatusDemons#status_demons.total_attr]),
                    %% 统计使魔天赋技能列表
                    NewStatusDemonsAfSticSlotSkill = lib_demons_util:static_demons_slot_skill_infos(NewStatusDemons),
                    %% 计算使魔天赋技能属性
                    NewStatusDemonsAfSkillAttr = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemonsAfSticSlotSkill),
                    %% 计算使魔天赋技能战力
                    NewStatusDemonsAfSkillPower = lib_demons_util:count_slot_skill_power(NewStatusDemonsAfSkillAttr),
                    PSAfDemons = PSAfCost#player_status{status_demons = NewStatusDemonsAfSkillPower},
                    CountPS = count_player_attribute(PSAfDemons),
                    %% 更新场景技能
                    update_scene_info(CountPS, all),
                    PowerPS = update_demons_power(CountPS, DemonsId),
                    %?PRINT("upgrade_demons_skill_level ~p~n", [NewStatusDemonsAfSkillPower]),
                    % print_status_demons(up_skill, NewStatusDemonsAfSkillPower),
                    {ok, LastPS} = lib_supreme_vip_api:equip_demons_skill(PowerPS),
                    {ok, LastPS, SkillId, Quality, Sort, Level};
                {false, _Res, _} ->
                    {false, ?ERRCODE(goods_not_enough)}
            end;
        Res ->
            Res
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 商城信息
send_demons_shop_info(PS) ->
    #player_status{id = RoleId, sid = Sid, status_demons = StatusDemons, figure = #figure{lv = RoleLv}} = PS,
    #status_demons{demons_shop = DemonsShop} = StatusDemons,
    case RoleLv >= ?demons_open_lv of 
        true ->
            case DemonsShop of
                #demons_shop{refresh_times = RefreshTimes, goods = Goods} ->
                    NewPS = PS;
                _ ->
                    NewDemonsShop = lib_demons_util:calc_shop(RoleId, 0, utime:unixtime()),
                    #demons_shop{refresh_times = RefreshTimes, goods = Goods} = NewDemonsShop,
                    NewStatusDemons = StatusDemons#status_demons{demons_shop = NewDemonsShop},
                    NewPS = PS#player_status{status_demons = NewStatusDemons}
            end,
            Cost = get_refresh_cost(RefreshTimes+1),
            Fun = fun({Id, BuyTimes}, Acc) ->
                case data_demons:get_shop_item(Id) of
                    #base_demons_shop{goods_id = GoodsTypeId, num = Num, price = Price, cost_num = CostNum, discount = Discount} ->
                        [{Id, GoodsTypeId, Price, Num, CostNum, Discount, 1, BuyTimes}|Acc];
                    _ ->
                        Acc
                end
            end,
            SendList = lists:foldl(Fun, [], Goods),
            lib_server_send:send_to_sid(Sid, pt_183, 18311, [utime:unixdate()+86400, RefreshTimes, Cost, SendList]),
            {ok, NewPS};
        _ ->
            lib_server_send:send_to_sid(Sid, pt_183, 18311, [0, 0, [], []]),
            {ok, PS}
    end.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 商城购买
demons_shop_buy(ShopItemId, PS) ->
    #player_status{id = RoleId, sid = Sid, status_demons = StatusDemons, figure = #figure{lv = RoleLv}} = PS,
    #status_demons{demons_shop = DemonsShop} = StatusDemons,
    case RoleLv >= ?demons_open_lv of 
        true ->
            case DemonsShop of
                #demons_shop{refresh_times = _RefreshTimes, goods = Goods} ->
                    case lists:keyfind(ShopItemId, 1, Goods) of
                        {ShopItemId, BuyTimes} when BuyTimes < 1 ->
                            case data_demons:get_shop_item(ShopItemId) of
                                #base_demons_shop{goods_id = GoodsTypeId, num = Num, price = Price, cost_num = CostNum, discount = Discount} ->
                                    Cost = if
                                    	Price == ?GOODS_ID_DEMONS_COIN ->
                                    		[{?TYPE_CURRENCY, Price, (CostNum * Discount) div 100}];
                                    	true ->
                                    		[{Price, 0, (CostNum * Discount) div 100}]
                                    end,
                                    Reward = [{0, GoodsTypeId, Num}],
                                    case lib_goods_api:cost_object_list_with_check(PS, Cost,  demons_shop, integer_to_list(Discount)) of
                                        {false, _Code, _NewPS} ->
                                            lib_server_send:send_to_sid(Sid, pt_183, 18312, [ShopItemId, BuyTimes, _Code]);
                                        {true, NewPs} ->
                                            NewGoods = lists:keyreplace(ShopItemId, 1, Goods, {ShopItemId, BuyTimes+1}),
                                            NewDemonsShop = DemonsShop#demons_shop{stime = utime:unixtime(), goods = NewGoods, is_dirty = 0},
                                            lib_demons_util:db_replace_demons_shop(RoleId, NewDemonsShop),
                                            {ok, Player} = lib_goods_api:send_reward_with_mail(NewPs, #produce{type = demons_shop, reward = Reward}),
                                            lib_server_send:send_to_sid(Sid, pt_183, 18312, [ShopItemId, BuyTimes+1, ?SUCCESS]),
                                            {ok, Player#player_status{status_demons = StatusDemons#status_demons{demons_shop = NewDemonsShop}}}
                                    end;
                                _ ->
                                    lib_server_send:send_to_sid(Sid, pt_183, 18312, [0, 0, ?MISSING_CONFIG])
                            end;
                        _ ->
                            lib_server_send:send_to_sid(Sid, pt_183, 18312, [0, 0, ?ERRCODE(err183_demons_shop_no_goods)])
                    end;
                _ ->
                    NewDemonsShop = lib_demons_util:calc_shop(RoleId, 0, utime:unixtime()),
                    lib_server_send:send_to_sid(Sid, pt_183, 18312, [0, 0, ?ERRCODE(err183_demons_shop_no_goods)]),
                    NewStatusDemons = StatusDemons#status_demons{demons_shop = NewDemonsShop},
                    %lib_demons_util:db_replace_demons_shop(RoleId, NewDemonsShop),
                    {ok, PS#player_status{status_demons = NewStatusDemons}}
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_183, 18312, [0, 0, ?ERRCODE(lv_limit)]),
            {ok, PS}
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 商城刷新 demons_shop_refresh
demons_shop_refresh(PS) ->
    #player_status{id = RoleId, sid = Sid, status_demons = StatusDemons, figure = #figure{lv = RoleLv, name = RoleName}} = PS,
    #status_demons{demons_shop = DemonsShop} = StatusDemons,
    case RoleLv >= ?demons_open_lv of 
        true ->
            case DemonsShop of
                #demons_shop{refresh_times = RefreshTimes} ->
                    Cost = get_refresh_cost(RefreshTimes+1),
                    case lib_goods_api:cost_object_list_with_check(PS, Cost,  demons_shop_refresh, integer_to_list(RefreshTimes+1)) of
                        {false, _Code, _NewPS} ->
                            lib_server_send:send_to_sid(Sid, pt_183, 18313, [_Code, RefreshTimes+1, Cost]);
                        {true, NewPS} ->
                            NewDemonsShop = lib_demons_util:calc_shop(RoleId, RefreshTimes+1, utime:unixtime()),
                            %lib_demons_util:db_replace_demons_shop(RoleId, NewDemonsShop),
                            lib_log_api:log_demons_shop_refresh(RoleId, RoleName, RefreshTimes+1, Cost),
                            NewStatusDemons = StatusDemons#status_demons{demons_shop = NewDemonsShop},
                            NewCost = get_refresh_cost(RefreshTimes+2),
                            lib_server_send:send_to_sid(Sid, pt_183, 18313, [?SUCCESS, RefreshTimes+1, NewCost]),
                            {ok, NewPS#player_status{status_demons = NewStatusDemons}}
                    end;
                _ ->
                    NewDemonsShop = lib_demons_util:calc_shop(RoleId, 0, utime:unixtime()),
                    NewCost = get_refresh_cost(1),
                    lib_server_send:send_to_sid(Sid, pt_183, 18313, [?ERRCODE(err183_demons_shop_no_goods), 0, NewCost]),
                    NewStatusDemons = StatusDemons#status_demons{demons_shop = NewDemonsShop},
                    %lib_demons_util:db_replace_demons_shop(RoleId, NewDemonsShop),
                    {ok, PS#player_status{status_demons = NewStatusDemons}}
            end;
        _ ->
            lib_server_send:send_to_sid(Sid, pt_183, 18313, [?ERRCODE(lv_limit), 0, []]),
            {ok, PS}
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 查看技能真实战力
get_slot_skill_power(PS, DemonsId, Sign, Id, SkillLv) ->
    #player_status{sid = Sid, original_attr = OriginalAttr, status_demons = StatusDemons} = PS,
    if
        Sign == 1 -> %% 查看槽位上的技能战力
            #status_demons{demons_list = DemonsList} = StatusDemons,
            SkillId = Id,
            case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of
                #demons{slot_list = SlotList} ->
                    case lists:keyfind(Id, #slot_skill.skill_id, SlotList) of
                        #slot_skill{level = Level} when SkillLv == Level ->
                            SkillAttr = lib_skill_api:get_skill_attr2mod(0, [{Id, Level}]),
                            SkPower = lib_skill_api:get_skill_power(Id, Level),
                            Code = ?SUCCESS,
                            Power = lib_player:calc_partial_power(OriginalAttr, SkPower, SkillAttr);
                        #slot_skill{} ->
                            SkillAttr = lib_skill_api:get_skill_attr2mod(0, [{Id, SkillLv}]),
                            SkPower = lib_skill_api:get_skill_power(Id, SkillLv),
                            Code = ?SUCCESS,
                            Power = lib_player:calc_expact_power(OriginalAttr, SkPower, SkillAttr);
                        _ ->
                            Code = ?ERRCODE(err183_demons_error_slot_skill),
                            SkillAttr = lib_skill_api:get_skill_attr2mod(0, [{Id, SkillLv}]),
                            SkPower = lib_skill_api:get_skill_power(Id, SkillLv),
                            Power = lib_player:calc_expact_power(OriginalAttr, SkPower, SkillAttr)
                    end;
                _ ->
                    Code = ?ERRCODE(err183_demons_not_active),
                    Power = 0
            end;
        true ->  %% 查看背包技能战力（默认一级）
            case data_demons:get_skill_id_by_goods(Id) of
                SkillId when is_integer(SkillId) ->
                    Code = ?SUCCESS,
                    SkillAttr = lib_skill_api:get_skill_attr2mod(0, [{SkillId, SkillLv}]),
                    SkPower = lib_skill_api:get_skill_power(SkillId, SkillLv),
                    Power = lib_player:calc_expact_power(OriginalAttr, SkPower, SkillAttr);
                _ -> 
                    Code = ?MISSING_CONFIG,
                    SkillId = 0,
                    Power = 0
            end
    end,
    ?PRINT("===== {SkillId,SkillLv, Power}:~p~n",[{SkillId,SkillLv, Power}]),
    lib_server_send:send_to_sid(Sid, pt_183, 18314, [Power, DemonsId, Sign, SkillId, SkillLv, Code]),
    {ok, PS}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 辅助函数
get_refresh_cost(RefreshTimes) ->
    Costfig = ?shop_cost,
    Fun = fun({_Min, _Max, _Cost}) ->
        RefreshTimes >= _Min andalso RefreshTimes =< _Max
    end,
    case ulists:find(Fun, Costfig) of
        {ok, {_, _, Cost}} when is_list(Cost) ->
            Cost;
        _ ->
           [{1, 0, 1000}]
    end.

count_player_attribute(PS) ->
	CountPS = lib_player:count_player_attribute(PS),
	lib_player:send_attribute_change_notify(CountPS, ?NOTIFY_ATTR),
	CountPS.

%% 更新使魔战力
update_demons_power(PS, DemonsId) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,	
	case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
		#demons{power = _Power} = Demons ->
			NewPower = lib_demons_util:count_demons_power(PS, Demons),
            % ?PRINT("========= Power:~p,NewPower:~p, Demons:~p~n",[Power,NewPower,Demons]),
			NewDemons = Demons#demons{power = NewPower},
			NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
			PS#player_status{status_demons = StatusDemons#status_demons{demons_list = NewDemonsList}};
		_ ->
			PS
	end.

update_scene_info(PS, Type) ->
	#player_status{battle_attr = BA, status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList, slot_skill = SlotSkill} = StatusDemons,
    SkillPassive = case lists:keyfind(DemonsIdBattle, #demons.demons_id, DemonsList) of 
        #demons{skill_for_role = SkillForRole} ->
            SkillForRole++SlotSkill;
        _ ->
            SlotSkill
    end,
	if
		Type == all ->
			mod_scene_agent:update(PS, [{battle_attr, BA}, {passive_skill, SkillPassive}, {demons_id, DemonsIdBattle}]);
		Type == attr ->
			mod_scene_agent:update(PS, [{battle_attr, BA}]);
		Type == skill ->
			mod_scene_agent:update(PS, [{passive_skill, SkillPassive}]);
		Type == skill_figure ->
			mod_scene_agent:update(PS, [{passive_skill, SkillPassive}, {demons_id, DemonsIdBattle}]);
		true ->
			ok
	end.

update_scene_train_obj(PS, DemonsId) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_id = DemonsIdBattle, demons_list = _DemonsList} = StatusDemons,
	case DemonsId == DemonsIdBattle of 
		true ->
			case get_demons_battle_info(PS) of 
				{ok, AttrList, DemonsPassiveSkills} ->
					SceneObj = #scene_train_object{
		                att_sign = ?BATTLE_SIGN_DEMONS
		                , battle_attr = #battle_attr{attr = lib_player_attr:to_attr_record(AttrList)}
		                , passive_skill = DemonsPassiveSkills
		            },
		            KeyValueList = [{scene_train_object, SceneObj}],
					NewPS = lib_player:update_scene_train_obj(KeyValueList, PS),
					mod_scene_agent:update(NewPS, KeyValueList),
					NewPS;
				_ ->
					PS
			end;
		_ ->
			PS
	end.

%% 获取使魔副本的使魔战斗信息
%% return: [{使魔id, 技能列表, 属性}]
get_battle_demons_for_dun(PS) ->
	#player_status{status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	F = fun(Demons, Return) ->
		#demons{
			demons_id = DemonsId, skill_list = SkillList, attr_list = AttrList
		} = Demons,
		FI = fun(#demons_skill{skill_id = SkillId, sk_type = SkType, level = Level}, SkillReturn) ->
			case SkType of 
				?DEMONS_SKILL_TYPE_BATTLE -> 
					case data_demons:get_skill_map(SkillId) of 
						[{_SkillFollow, SkillUnfollow, _PassTarget}] -> 
							[{SkillUnfollow, Level}|SkillReturn];
						_ ->
							SkillReturn
					end;
				?DEMONS_SKILL_TYPE_PASSIVE ->
					case data_demons:get_skill_map(SkillId) of 
						[{SkillFollow, _SkillUnfollow, _PassTarget}] -> 
							[{SkillFollow, Level}|SkillReturn];
						_ ->
							SkillReturn
					end;
				_ -> SkillReturn
			end
		end,
		DemonsSkills = lists:foldl(FI, [], SkillList),
		[{DemonsId, DemonsSkills, lib_player_attr:to_attr_record(AttrList)}|Return]
	end,
	lists:foldl(F, [], DemonsList).

gm_active_all_demons(PS, Star, Level) ->
	#player_status{status_demons = StatusDemons} = PS,
	AllDemonsIds = data_demons:get_all_demons_id(),
	F = fun(DemonsId, List) ->
        SlotNum = lib_demons_util:get_slot_unlock_num(?DEMONS_SLOT_BEGIN, Star),
        Sql = io_lib:format(<<"delete from `demons_slot_skill` where `role_id` = ~p and `demons_id` = ~p">>, [PS#player_status.id, DemonsId]),
        db:execute(Sql),
		Demons = #demons{demons_id = DemonsId, star = Star, level = Level, slot_num = SlotNum},
		SkillList = lib_demons_util:refresh_demons_skill(Demons, []),
		NewDemonsAfSkill = Demons#demons{skill_list = SkillList},
		NewDemonsAfAttr = lib_demons_util:count_single_demons_attr(NewDemonsAfSkill),
		lib_demons_util:db_replace_demons(PS#player_status.id, NewDemonsAfAttr),
		[NewDemonsAfAttr|List]
	end,
	DemonsList = lists:foldl(F, [], AllDemonsIds),
	Fetters = lib_demons_util:refresh_fetters(DemonsList),
	%% 上卷数更新
	PaintingList = [Star ||#demons{star = Star1} <- DemonsList, Star1 >= ?painting_star],
	PaintingNum = lists:sum([0|PaintingList]),
	NewStatusDemons = StatusDemons#status_demons{painting_num = PaintingNum, demons_list = DemonsList, fetters_list = Fetters},
	%% 统计使魔技能列表
	NewStatusDemonsAfSticSkill = lib_demons_util:static_demons_skill_infos(NewStatusDemons),
	%% 计算使魔基础属性
	NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemonsAfSticSkill),
	%% 计算使魔羁绊属性
	NewStatusDemonsAfFetters = lib_demons_util:count_demons_attr(?ATTR_TYPE_FETTERS, NewStatusDemonsAfDemons),
	%NewStatusDemonsAfPainting = lib_demons_util:count_demons_attr(?ATTR_TYPE_PAINTING, NewStatusDemonsAfFetters),
	NewStatusDemonsAfSkillAttr = lib_demons_util:count_demons_attr(?ATTR_TYPE_SKILL, NewStatusDemonsAfFetters),
	%% 计算使魔技能战力
	NewStatusDemonsAfSkillPower = lib_demons_util:count_demons_skill_power(NewStatusDemonsAfSkillAttr),
	PSAfDemons = PS#player_status{status_demons = NewStatusDemonsAfSkillPower},
	CountPS = count_player_attribute(PSAfDemons),
	%% 更新场景属性和技能
	update_scene_info(CountPS, all),
	CountPS.

gm_add_skill_process(PS, DemonsId, AddProcess) ->
	#player_status{id = RoleId, sid = Sid, status_demons = StatusDemons} = PS,
	#status_demons{demons_list = DemonsList} = StatusDemons,
	case lists:keyfind(DemonsId, #demons.demons_id, DemonsList) of 
		#demons{skill_list = SkillList}=Demons ->
			case [Item ||#demons_skill{sk_type = ?DEMONS_SKILL_TYPE_LIFE}=Item <- SkillList] of 
				[#demons_skill{skill_id = SkillId, level = SkillLv, process = Process, is_active = IsActive}=DemonsSkill|_] ->
					#base_demons_skill{usage = Conditions} = data_demons:get_demons_skill_cfg(DemonsId, SkillId),
					{_, Key, ProcessNeed} = ulists:keyfind(process, 1, Conditions, {process, undefined, 0}),
					if
						IsActive == 1 -> PS;
						true ->
							case is_complete(Key, Process, ProcessNeed) of 
								true -> PS;
								_ ->
									Process1 = Process + AddProcess,
									MaxProcess = get_skill_max_process(Key, Process1, ProcessNeed),
									NewProcess = min(MaxProcess, Process1),
									NewDemonsSkill = DemonsSkill#demons_skill{process = NewProcess},
									NewSkillList = lists:keyreplace(SkillId, #demons_skill.skill_id, SkillList, NewDemonsSkill),
									Demons1 = Demons#demons{skill_list = NewSkillList},
									lib_demons_util:db_replace_demons_skill(RoleId, DemonsId, NewDemonsSkill),
									NewDemons = lib_demons_util:count_single_demons_attr(Demons1),	
									NewDemonsList = lists:keyreplace(DemonsId, #demons.demons_id, DemonsList, NewDemons),
									NewStatusDemons = StatusDemons#status_demons{demons_list = NewDemonsList},
									NewStatusDemonsAfDemons = lib_demons_util:count_demons_attr(?ATTR_TYPE_DEMONS, NewStatusDemons),
									PSAfDemons = PS#player_status{status_demons = NewStatusDemonsAfDemons},
									CountPS = count_player_attribute(PSAfDemons),
									LastPS = update_demons_power(CountPS, DemonsId),
									lib_server_send:send_to_sid(Sid, pt_183, 18317, [DemonsId, SkillId, SkillLv, NewProcess, IsActive]),
									LastPS
							end
					end;
				_ -> PS
			end;
		_ -> PS
	end.


% print_status_demons(OpType, StatusDemons) ->
% 	?PRINT("status_demons ############## Op : ~p~n", [OpType]),
% 	#status_demons{demons_id = DemonsIdBattle, demons_list = DemonsList, attr_list = AttrList, skill_power = SkPower, skill_passive = SkPassive} = StatusDemons,
% 	?PRINT("DemonsIdBattle : ~p~n", [DemonsIdBattle]),
% 	F = fun(Demons) ->
% 		#demons{demons_id = DemonsId, skill_list = SkillList, skill_for_demons = SkForDemons, skill_for_role = SkForRole} = Demons,
% 		?PRINT("### DemonsId : ~p~n", [DemonsId]),
% 		?PRINT("### SkillList : ~p~n", [SkillList]),
% 		?PRINT("### SkForDemons : ~p~n", [SkForDemons]),
% 		?PRINT("### SkForRole : ~p~n", [SkForRole])
% 	end,
% 	lists:foreach(F, DemonsList),
% 	?PRINT("AttrList : ~p~n", [AttrList]),
% 	?PRINT("SkPassive : ~w~n", [SkPassive]),
% 	?PRINT("SkPower : ~p~n", [SkPower]),
% 	ok.