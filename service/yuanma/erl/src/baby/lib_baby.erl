%%%--------------------------------------
%%% @Module  : lib_baby
%%% @Author  : lxl
%%% @Created : 2019.5.9
%%% @Description:  宝宝
%%%--------------------------------------

-module (lib_baby).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("attr.hrl").
-include("marriage.hrl").
-include("figure.hrl").
-include("rec_baby.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("goods.hrl").
-include("def_module.hrl").

-export ([

]).   

-compile(export_all). 

%%------------------------------ 登陆
login(PS) ->
	#player_status{id = RoleId, marriage = #marriage_status{lover_role_id = LoverId}} = PS,
	StatusBaby = new_status_baby(RoleId),
	StatusBabyAfRaise = count_baby_attr(?ATTR_TYPE_RAISE, StatusBaby),
	StatusBabyAfStage = count_baby_attr(?ATTR_TYPE_STAGE, StatusBabyAfRaise),
	StatusBabyAfKnowledge = count_baby_attr(?ATTR_TYPE_EQUIP, StatusBabyAfStage),
	StatusBabyAfFigure = count_baby_attr(?ATTR_TYPE_FIGURE, StatusBabyAfKnowledge),
	case LoverId > 0 of 
		true ->
			MateInfo = ets_keyfind(LoverId),
			NewStatusBaby1 = count_baby_attr(?ATTR_TYPE_MATE, [StatusBabyAfFigure, MateInfo]);
		_ ->
			NewStatusBaby1 = StatusBabyAfFigure
	end,
	NewStatusBaby = count_baby_skill_power(NewStatusBaby1),
	%?PRINT("baby login ## ~p~n", [NewStatusBaby]),
	PS#player_status{status_baby = NewStatusBaby}.

%% 宝宝技能
get_baby_skills(PS) ->
	#player_status{status_baby = StatusBaby} = PS,
	#status_baby{equip_list = EquipList} = StatusBaby,
	[{SkillId, 1} ||#baby_equip{skill_id = SkillId} <- EquipList, SkillId > 0].

%% 宝宝属性
get_baby_attr(PS) ->
	#player_status{status_baby = StatusBaby} = PS,
	case StatusBaby of 
		#status_baby{total_attr = BabyAttr} -> BabyAttr;
		_ -> []
	end.

%% 宝宝技能战力
get_baby_skill_power(PS) ->		
	#player_status{status_baby = StatusBaby} = PS,
	case StatusBaby of 
		#status_baby{skill_power = SkillPower} -> SkillPower;
		_ -> 0
	end.

%% ------------------------------ 伴侣的宝宝升阶后，更新自己战力
update_power_with_mate_baby(PS, MateInfo) ->
	#player_status{status_baby = StatusBaby, marriage = #marriage_status{lover_role_id = LoverId}} = PS,
	case StatusBaby#status_baby.active_time > 0 andalso LoverId > 0 of 
		true -> 
			NewStatusBaby = count_baby_attr(?ATTR_TYPE_MATE, [StatusBaby, MateInfo]),
			PSAfAttr = PS#player_status{status_baby = NewStatusBaby},
			CountPS = lib_player:count_player_attribute(PSAfAttr),
			lib_player:send_attribute_change_notify(CountPS, ?NOTIFY_ATTR),
			{ok, CountPS};
		_ ->
			{ok, PS}
	end.

%% -------------------------------- 结婚/离婚后更新宝宝战力(伴侣宝宝提供属性)
update_baby_attr_after_marriage(PS) ->
	#player_status{status_baby = StatusBaby, marriage = #marriage_status{lover_role_id = LoverId}} = PS,
	case LoverId > 0 of 
		true -> 
			MateInfo = ets_keyfind(LoverId),
			NewStatusBaby = count_baby_attr(?ATTR_TYPE_MATE, [StatusBaby, MateInfo]),
			PSAfAttr = PS#player_status{status_baby = NewStatusBaby},
			PSAfAttr;
		_ ->
			PS
	end.

update_baby_attr_after_divorse(PS) ->
	#player_status{status_baby = StatusBaby} = PS,
	#status_baby{attr_list = AttrList} = StatusBaby,
	NewAttrList = lists:keydelete(?ATTR_TYPE_MATE, 1, AttrList),
	TotalAttr = statistic_total_attr(NewAttrList),
	NewStatusBaby = StatusBaby#status_baby{attr_list = NewAttrList, total_attr = TotalAttr},
	PSAfAttr = PS#player_status{status_baby = NewStatusBaby},
	PSAfAttr.

%%------------------------------ 宝宝激活
active_baby(PS) ->
	#player_status{id = RoleId, sid = Sid, figure = #figure{lv = RoleLv}, status_baby = StatusBaby} = PS,
	#status_baby{active_time = ActiveTime} = StatusBaby,
	case RoleLv >= ?active_level of 
		false -> ErrCode = ?LEVEL_LIMIT, NewPS = PS;
		_ ->
			case ActiveTime > 0 of 
				true -> ErrCode = ?ERRCODE(err182_baby_is_active), NewPS = PS;
				_ ->
					case lib_goods_api:cost_object_list_with_check(PS, ?active_cost, baby_unlock, "") of 
						{false, Res, NewPS} -> ErrCode = Res;
						{true, PS1} ->
							ErrCode = ?SUCCESS,
							NowTime = utime:unixtime(),
							NStatusBaby = StatusBaby#status_baby{active_time = NowTime, raise_lv = 1},
							StatusBabyAfAttr = count_baby_attr(?ATTR_TYPE_RAISE, NStatusBaby),
							?PRINT("active_baby ## ~p~n", [StatusBabyAfAttr]),
							PSAfAttr = PS1#player_status{status_baby = StatusBabyAfAttr},
							db_replace_baby_basic(RoleId, StatusBabyAfAttr),
							lib_baby_api:active_baby(RoleId, RoleLv, NowTime),
							lib_baby_api:baby_raise_up(PSAfAttr, 0),
							NewPS = count_player_power(PSAfAttr)
					end
			end
	end,
	lib_server_send:send_to_sid(Sid, pt_182, 18210, [ErrCode]),
	{ok, NewPS}.

%%------------------------------ 增加养育值
add_raise_exp(RoleId, AddRaiseExp, Args) when is_integer(RoleId) ->
	case lib_player:get_alive_pid(RoleId) of 
		false ->
			StatusBaby = new_status_baby(RoleId),
			add_raise_exp_do(StatusBaby, RoleId, AddRaiseExp, Args);
		Pid ->
			lib_player:apply_cast(Pid, ?APPLY_CAST_STATUS, ?MODULE, add_raise_exp, [AddRaiseExp, Args])
	end;
add_raise_exp(PS, AddRaiseExp, Args) ->
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	{IsUp, StatusBabyAfRaise} = add_raise_exp_do(StatusBaby, RoleId, AddRaiseExp, Args),
	PSAfRaise = PS#player_status{status_baby = StatusBabyAfRaise},
	case IsUp of 
		true ->
			StatusBabyAfAttr = count_baby_attr(?ATTR_TYPE_RAISE, StatusBabyAfRaise),
			PSAfAttr = PSAfRaise#player_status{status_baby = StatusBabyAfAttr},
			CountPS = count_player_power(PSAfAttr),
			lib_baby_api:baby_raise_up(CountPS, StatusBaby#status_baby.raise_lv),
			{ok, SupVipPS} = lib_supreme_vip_api:baby_raise_up(CountPS, StatusBabyAfAttr#status_baby.raise_lv),
			%?PRINT("add_raise_exp ## StatusBaby: ~p~n", [StatusBabyAfAttr]),
			{ok, SupVipPS};
		_ ->
			{ok, PSAfRaise}
	end.
	
add_raise_exp_do(StatusBaby, RoleId, AddRaiseExp, Args) ->
	#status_baby{raise_lv = RaiseLv, raise_exp = RaiseExp} = StatusBaby,
	[TaskId] = Args,
	{NewRaiseLv, NewRaiseExp} = add_raise_exp_core(RaiseLv, RaiseExp, AddRaiseExp),
	lib_log_api:log_baby_raise_up(RoleId, TaskId, AddRaiseExp, RaiseLv, RaiseExp, NewRaiseLv, NewRaiseExp),
	case NewRaiseLv =/= RaiseLv orelse NewRaiseExp =/= RaiseExp of 
		true ->
			db_update_baby_basic_raise(RoleId, NewRaiseLv, NewRaiseExp),
			lib_temple_awaken_api:async_trigger(RoleId, [{baby_lv, NewRaiseLv}]),
			{NewRaiseLv =/= RaiseLv, StatusBaby#status_baby{raise_lv = NewRaiseLv, raise_exp = NewRaiseExp}};
		_ ->
			{false, StatusBaby}
	end.

add_raise_exp_core(RaiseLv, RaiseExp, AddRaiseExp) ->
	case data_baby_new:get_baby_stage(1, 1, RaiseLv+1) of 
		#base_baby_stage{exp_con = ExpCon} ->
			case RaiseExp + AddRaiseExp >= ExpCon of 
				true ->
					add_raise_exp_core(RaiseLv+1, 0, RaiseExp + AddRaiseExp - ExpCon);
				_ ->
					{RaiseLv, RaiseExp + AddRaiseExp}
			end;
		_ ->
			{RaiseLv, RaiseExp}
	end.

%%------------------------------ 宝宝升阶
%% 一键提升
upgrade_baby_stage(PS, GoodsIdNumList) ->
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	#status_baby{stage = Stage, stage_lv = StageLv, stage_exp = StageExp} = StatusBaby,
	{NewStage, NewStageLv, NewStageExp, RealCostList} = upgrade_baby_stage_do(Stage, StageLv, StageExp, GoodsIdNumList, []),
	case RealCostList == [] of 
		true ->
			{false, ?ERRCODE(err182_max_stage)};
		_ ->
			case lib_goods_api:cost_object_list_with_check(PS, RealCostList, baby_stage_up, "") of 
				{true, PSAfCost} ->
					lib_log_api:log_baby_upgrade_stage(RoleId, Stage, StageLv, StageExp, NewStage, NewStageLv, NewStageExp, RealCostList),
					db_update_baby_basic_stage(RoleId, NewStage, NewStageLv, NewStageExp),
					StatusBabyAfStage = StatusBaby#status_baby{stage = NewStage, stage_lv = NewStageLv, stage_exp = NewStageExp},
					PSAfStage = PSAfCost#player_status{status_baby = StatusBabyAfStage},
					case NewStage =/= Stage orelse NewStageLv =/= StageLv of 
						true -> %% 升级
							StatusBabyAfAttr = count_baby_attr(?ATTR_TYPE_STAGE, StatusBabyAfStage),
							PSAfAttr = PSAfStage#player_status{status_baby = StatusBabyAfAttr},
							CountPS = count_player_power(PSAfAttr),
							lib_baby_api:baby_stage_up(CountPS, Stage, StageLv),
							?PRINT("upgrade_baby_stage ## succ: ~p~n", [{NewStage, NewStageLv, NewStageExp}]),
							{ok, CountPS};
						_ ->
							{ok, PSAfStage}
					end;
				{false, Res, _PS} ->
					{false, Res}
			end
	end.

upgrade_baby_stage_do(Stage, StageLv, StageExp, [], CostList) ->
	{Stage, StageLv, StageExp, CostList};
upgrade_baby_stage_do(Stage, StageLv, StageExp, [{GoodsTypeId, Num}|GoodsIdNumList], CostList) ->
	{_, ExpAddOne} = lists:keyfind(GoodsTypeId, 1, ?stage_exp_goods),
	{NewStage, NewStageLv, NewStageExp, CostNum} = upgrade_baby_stage_core(Stage, StageLv, StageExp, Num, ExpAddOne, 0),
	case CostNum < Num of 
		true -> %% 升满级了
			NewCostList = ?IF(CostNum > 0, [{?TYPE_GOODS, GoodsTypeId, CostNum}|CostList], CostList),
			{NewStage, NewStageLv, NewStageExp, NewCostList};
		_ ->
			upgrade_baby_stage_do(NewStage, NewStageLv, NewStageExp, GoodsIdNumList, [{?TYPE_GOODS, GoodsTypeId, Num}|CostList])
	end.

upgrade_baby_stage_core(Stage, StageLv, StageExp, 0, _ExpAddOne, AccNum) ->
	case data_baby_new:get_baby_stage(2, Stage, StageLv+1) of
        [] ->
        	BabyStageCon = data_baby_new:get_baby_stage(2, Stage+1, 1);
        BabyStageCon -> ok
    end,
    case BabyStageCon of 
        #base_baby_stage{
            stage = StageCon, level = LevelCon, exp_con = ExpCon
        } ->
            case StageExp >= ExpCon of
                true ->
                    NewStage = StageCon,
                    NewStageLv = LevelCon,
                    NewStageExp = StageExp - ExpCon,
                    upgrade_baby_stage_core(NewStage, NewStageLv, NewStageExp, 0, _ExpAddOne, AccNum);
                false ->
                    {Stage, StageLv, StageExp, AccNum}
            end;
        _ ->
            {Stage, StageLv, StageExp, AccNum}
    end;
upgrade_baby_stage_core(Stage, StageLv, StageExp, Num, ExpAddOne, AccNum) ->
    case data_baby_new:get_baby_stage(2, Stage, StageLv+1) of
        [] ->
        	BabyStageCon = data_baby_new:get_baby_stage(2, Stage+1, 1);
        BabyStageCon -> ok
    end,
    case BabyStageCon of 
        #base_baby_stage{
            stage = StageCon, level = LevelCon, exp_con = ExpCon
        } ->
        	UpCostNum = max(umath:ceil((ExpCon - StageExp) / ExpAddOne), 0),
        	CostNum = ?IF(Num =< UpCostNum, Num, UpCostNum),
        	ExpAdd = CostNum * ExpAddOne,
            case StageExp+ExpAdd >= ExpCon of
                true ->
                    NewStage = StageCon,
                    NewStageLv = LevelCon,
                    NewStageExp = StageExp + ExpAdd - ExpCon,
                    upgrade_baby_stage_core(NewStage, NewStageLv, NewStageExp, max(0, Num-CostNum), ExpAddOne, AccNum+CostNum);
                false ->
                    NewStage = Stage,
                    NewStageLv = StageLv,
                    NewStageExp = StageExp + ExpAdd,
                    {NewStage, NewStageLv, NewStageExp, AccNum+CostNum}
            end;
        _ ->
            {Stage, StageLv, StageExp, AccNum}
    end.  

%%------------------------------------- 特长
%% 佩戴
equip(PS, PosId, GoodsId) ->
	GS = lib_goods_do:get_goods_status(),
	case lib_baby_check:equip(PS, GS, PosId, GoodsId) of 
		{ok, OldGoodsInfo, NewGoodsInfo, BabyEquip} ->
			#player_status{id = RoleId, status_baby = StatusBaby} = PS,
			#status_baby{equip_list = EquipList} = StatusBaby,
			F = fun() ->
		        ok = lib_goods_dict:start_dict(),
		        equip_core(GS, BabyEquip, OldGoodsInfo, NewGoodsInfo)
		    end,
		    case lib_goods_util:transaction(F) of
		        {ok, NewGS, NewBabyEquip, UpGoodsList} ->
		        	#baby_equip{id = OldGoodsId, goods_id = OldGoodsTypeId, skill_id = OldSkillId} = BabyEquip,
		        	#baby_equip{id = NewGoodsId, goods_id = NewGoodsTypeId, skill_id = NewSkillId} = NewBabyEquip,
		        	lib_log_api:log_baby_equip_goods(RoleId, PosId, OldGoodsId, OldGoodsTypeId, OldSkillId, NewGoodsId, NewGoodsTypeId, NewSkillId),
		            lib_goods_do:set_goods_status(NewGS),
		            lib_goods_api:notify_client_num(RoleId, [NewGoodsInfo#goods{num = 0}]),
		            lib_goods_api:notify_client(PS, UpGoodsList),
		            NewEquipList = lists:keystore(PosId, #baby_equip.pos_id, EquipList, NewBabyEquip),
		            NewStatusBaby = StatusBaby#status_baby{equip_list = NewEquipList},
		            StatusBabyAfAttr = count_baby_attr(?ATTR_TYPE_EQUIP, NewStatusBaby),
		            StatusBabyAfSKill = count_baby_skill_power(StatusBabyAfAttr),
					PSAfAttr = PS#player_status{status_baby = StatusBabyAfSKill},
					CountPS = count_player_power(PSAfAttr),
					lib_baby_api:baby_equip_update(CountPS),
					?PRINT("equip ## succ: ~p~n", [StatusBabyAfAttr]),
					{ok, CountPS};
		        Error ->
		            ?ERR("equip error:~p", [Error]),
		            {false, ?FAIL}
		    end;
		{false, Res} ->
			{false, Res}
	end.
	
equip_core(GS, BabyEquip, OldGoodsInfo, GoodsInfo) ->
	EquipLocation = ?GOODS_LOC_BABY_EQUIP,
	UnEquipLocation = GoodsInfo#goods.location,
	#baby_equip{pos_id = PosId} = BabyEquip,
	case is_record(OldGoodsInfo, goods) of 
		true -> %% 替代旧装备
			[_NewUnEquipInfo, GS1] = lib_goods:change_goods_cell(OldGoodsInfo, UnEquipLocation, 0, GS),
			[NewEquipInfo, NewGS] = lib_goods:change_goods_cell(GoodsInfo, EquipLocation, PosId, GS1);
		_ -> %% 新装备
			[NewEquipInfo, NewGS] = lib_goods:change_goods_cell(GoodsInfo, EquipLocation, PosId, GS)
	end,
	#goods{id = GoodsId, goods_id = GoodsTypeId, other = #goods_other{skill_id = SkillId}} = NewEquipInfo,
	NewBabyEquip = BabyEquip#baby_equip{id = GoodsId, goods_id = GoodsTypeId, skill_id = SkillId},
	db_replace_baby_equip(GS#goods_status.player_id, NewBabyEquip),
	%% 更新物品dict
	#goods_status{dict = OldGoodsDict} = NewGS,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    LastGS = NewGS#goods_status{
        dict = GoodsDict
    },
    {ok, LastGS, NewBabyEquip, GoodsL}.

%% 升阶
upgrade_equip_stage(PS, PosId) ->
	case lib_baby_check:upgrade_equip_stage(PS, PosId) of 
		{ok, OprType, _IsUpStage, OldBabyEquip, NewBabyEquip, CostList} ->
			case lib_goods_api:cost_object_list(PS, CostList, upgrade_equip, "") of 
				{true, PSAfCost} ->
					#player_status{id = RoleId, status_baby = StatusBaby} = PSAfCost,
					#status_baby{equip_list = EquipList} = StatusBaby,
					#baby_equip{stage = NewStage, stage_lv = NewStageLv, stage_exp = NewStageExp} = NewBabyEquip,
					#baby_equip{stage = OldStage, stage_lv = OldStageLv, stage_exp = OldStageExp} = OldBabyEquip,
					lib_log_api:log_baby_equip_stage_up(RoleId, PosId, OprType, OldStage, OldStageLv, OldStageExp, NewStage, NewStageLv, NewStageExp, CostList),
					db_update_baby_equip_stage(RoleId, PosId, NewStage, NewStageLv, NewStageExp),
					NewEquipList = lists:keystore(PosId, #baby_equip.pos_id, EquipList, NewBabyEquip),
		            NewStatusBaby = StatusBaby#status_baby{equip_list = NewEquipList},
		            StatusBabyAfAttr = count_baby_attr(?ATTR_TYPE_EQUIP, NewStatusBaby),
					PSAfAttr = PSAfCost#player_status{status_baby = StatusBabyAfAttr},
					CountPS = count_player_power(PSAfAttr),
					lib_baby_api:baby_equip_update(CountPS),
					?PRINT("upgrade_equip_stage ## succ: ~p~n", [StatusBabyAfAttr]),
					{ok, CountPS};
				{false, ErrorCode, _} ->
					{false, ErrorCode}
			end;
		Res -> Res
	end.

upgrade_equip_stage_lv(_PosId, Stage, StageLv, StageExp, [], CostList) ->
	{Stage, StageLv, StageExp, CostList};
upgrade_equip_stage_lv(PosId, Stage, StageLv, StageExp, [{GoodsTypeId, Num}|GoodsIdNumList], CostList) ->
	{_, ExpAddOne} = lists:keyfind(GoodsTypeId, 1, ?equip_exp_goods),
	{NewStage, NewStageLv, NewStageExp, CostNum} = upgrade_equip_stage_lv_core(PosId, Stage, StageLv, StageExp, Num, ExpAddOne, 0),
	%?PRINT("upgrade_equip_stage_lv ## succ: ~p~n", [{NewStage, NewStageLv, NewStageExp, CostNum}]),
	case CostNum < Num of 
		true -> %% 升满级了
			NewCostList = ?IF(CostNum > 0, [{?TYPE_GOODS, GoodsTypeId, CostNum}|CostList], CostList),
			{NewStage, NewStageLv, NewStageExp, NewCostList};
		_ ->
			upgrade_equip_stage_lv(PosId, NewStage, NewStageLv, NewStageExp, GoodsIdNumList, [{?TYPE_GOODS, GoodsTypeId, Num}|CostList])
	end.

upgrade_equip_stage_lv_core(_PosId, Stage, StageLv, StageExp, 0, _ExpAddOne, AccNum) ->
	{Stage, StageLv, StageExp, AccNum};
upgrade_equip_stage_lv_core(PosId, Stage, StageLv, StageExp, Num, ExpAddOne, AccNum) ->
    MaxStageLv = data_baby_new:get_equip_max_level(PosId, Stage),
    case StageLv >= MaxStageLv of 
    	true -> %% 当前阶数达到最大阶数等级
    		{Stage, StageLv, StageExp, AccNum};
    	_ ->
		    case data_baby_new:get_baby_equip_stren(PosId, Stage, StageLv+1) of 
		        #base_baby_equip_stren{
		            stage = _StageCon, stage_lv = _LevelCon, point_con = ExpCon
		        } ->
		        	UpCostNum = max(umath:ceil((ExpCon - StageExp) / ExpAddOne), 0),
		        	CostNum = ?IF(Num =< UpCostNum, Num, UpCostNum),
		        	ExpAdd = CostNum * ExpAddOne,
		        	{NewStage, NewStageLv, NewStageExp} = upgrade_equip_stage_helper(PosId, Stage, StageLv, StageExp, ExpAdd),
		            upgrade_equip_stage_lv_core(PosId, NewStage, NewStageLv, NewStageExp, max(0, Num-CostNum), ExpAddOne, AccNum+CostNum);
		        _ ->
		            {Stage, StageLv, StageExp, AccNum}
		    end
    end.

upgrade_equip_stage_helper(PosId, Stage, StageLv, StageExp, ExpAdd) ->
	MaxStageLv = data_baby_new:get_equip_max_level(PosId, Stage),
	case StageLv >= MaxStageLv of 
		true -> 
			{Stage, StageLv, StageExp + ExpAdd};
		_ ->
			case data_baby_new:get_baby_equip_stren(PosId, Stage, StageLv+1) of 
		        #base_baby_equip_stren{
		            stage = StageCon, stage_lv = LevelCon, point_con = ExpCon
		        } ->
		            case StageExp+ExpAdd >= ExpCon of
		                true ->
		                    NewStage = StageCon,
		                    NewStageLv = LevelCon,
		                    NewStageExp = StageExp + ExpAdd - ExpCon,
		                    upgrade_equip_stage_helper(PosId, NewStage, NewStageLv, NewStageExp, 0);
		                false ->
		                    NewStage = Stage,
		                    NewStageLv = StageLv,
		                    NewStageExp = StageExp + ExpAdd,
		                    {NewStage, NewStageLv, NewStageExp}
		            end;
		        _ ->
		            {Stage, StageLv, StageExp+ExpAdd}
		    end
	end.

%% 装备铭刻
engrave_baby_equip(PS, PosId, GoodsList) ->
	GS = lib_goods_do:get_goods_status(),
	case lib_baby_check:engrave_baby_equip(PS, GS, PosId, GoodsList) of 
		{ok, BabyEquip, GoodsInfo, EngraveRation, CostList} ->
			case lib_goods_api:cost_object_list(PS, CostList, engrave_equip, "") of 
				{true, PSAfCost} ->
					GSAfCost = lib_goods_do:get_goods_status(),
					#player_status{id = RoleId, status_baby = StatusBaby} = PSAfCost,
					#status_baby{equip_list = EquipList} = StatusBaby,
					#goods{id = GoodsId, goods_id = GoodsTypeId} = GoodsInfo,
					case EngraveRation >= urand:rand(1, 10000) of 
						true ->
							F = fun() ->
						        ok = lib_goods_dict:start_dict(),
						        engrave_baby_equip_core(RoleId, GSAfCost, BabyEquip, GoodsInfo)
						    end,
						    case lib_goods_util:transaction(F) of
						        {ok, NewGS, NewBabyEquip, UpGoodsList} ->
						        	lib_log_api:log_baby_equip_engrave(RoleId, GoodsId, GoodsTypeId, 1, EngraveRation, NewBabyEquip#baby_equip.skill_id, CostList),
						            lib_goods_do:set_goods_status(NewGS),
						            lib_goods_api:notify_client(PS, UpGoodsList),
						            NewEquipList = lists:keystore(PosId, #baby_equip.pos_id, EquipList, NewBabyEquip),
								    NewStatusBaby = StatusBaby#status_baby{equip_list = NewEquipList},
								    StatusBabyAfAttr = count_baby_attr(?ATTR_TYPE_EQUIP, NewStatusBaby),
								    StatusBabyAfSKill = count_baby_skill_power(StatusBabyAfAttr),
									PSAfAttr = PSAfCost#player_status{status_baby = StatusBabyAfSKill},
									CountPS = count_player_power(PSAfAttr),
									lib_baby_api:baby_equip_update(CountPS),
									%% 传闻
									#baby_equip{skill_id = SkillId} = NewBabyEquip,
									Color = data_goods:get_goods_color(GoodsTypeId),
									SkillName = lib_skill_api:get_skill_name(SkillId, 1),
									lib_chat:send_TV({all}, ?MOD_BABY, 3, [PS#player_status.figure#figure.name, GoodsTypeId, Color, util:make_sure_binary(SkillName)]),
									?PRINT("engrave_baby_equip ## succ: ~p~n", [NewBabyEquip]),
									{ok, CountPS};
						        Error ->
						            ?ERR("engrave_baby_equip error:~p", [Error]),
						            {false, ?FAIL}
						    end;
						_ ->
							lib_log_api:log_baby_equip_engrave(RoleId, GoodsId, GoodsTypeId, 2, EngraveRation, 0, CostList),
							?PRINT("engrave_baby_equip ## succ: ~p~n", [222]),
							{ok, PSAfCost}
					end;
				{false, ErrorCode, _} ->
					{false, ErrorCode}
			end;
		Res -> Res
	end.

engrave_baby_equip_core(RoleId, GS, BabyEquip, GoodsInfo) ->
	#goods{goods_id = GoodsTypeId} = GoodsInfo,
	#base_baby_equip{skills = SkillId} = data_baby_new:get_baby_equip(GoodsTypeId),
	NewBabyEquip = BabyEquip#baby_equip{skill_id = SkillId},
	db_update_baby_equip_skill(RoleId, BabyEquip#baby_equip.pos_id, SkillId),
	[_NewGoodsInfo, NewGS] = lib_goods:change_goods_skill_id(GoodsInfo, SkillId, GS),
	%% 更新物品dict
	#goods_status{dict = OldGoodsDict} = NewGS,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    LastGS = NewGS#goods_status{
        dict = GoodsDict
    },
    {ok, LastGS, NewBabyEquip, GoodsL}.

%% 计算铭刻概率
get_engrave_prob(EquipTypeId, GoodList) ->
	case data_baby_new:get_baby_equip(EquipTypeId) of 
		#base_baby_equip{color = Color} ->
			F = fun(GTypeId, Acc) ->
			    case data_baby_new:get_baby_equip_engrave(Color, GTypeId) of
			        #base_baby_equip_engrave{ratio = Ratio} ->
			            Acc + Ratio;
			        _ ->
			            Acc
			    end
		    end,
		    min(lists:foldl(F, 0, GoodList), 10000);
		_ ->
			0
	end.

get_engrave_goods_list(EquipTypeId, GoodsTypeIdList) ->
	case data_baby_new:get_baby_equip(EquipTypeId) of 
		#base_baby_equip{color = Color} ->
			F = fun(GoodsTypeId, L) ->
				case data_baby_new:get_baby_equip_engrave(Color, GoodsTypeId) of 
					#base_baby_equip_engrave{num = Num} -> [{?TYPE_GOODS, GoodsTypeId, Num}|L];
					_ -> L
				end
			end,
			CostList = lists:foldl(F, [], GoodsTypeIdList),
			CostList;
		_ ->
			[]
	end.
	
%%  宝宝装备生成时，计算物品的极品属性
gen_equip_dynamic_attr(GoodsTypeInfo, #goods_other{skill_id = OSkill} = GoodsOther) ->
    #ets_goods_type{goods_id = GoodsId} = GoodsTypeInfo,
    case data_baby_new:get_baby_equip(GoodsId) of
        #base_baby_equip{skills = SkillId, gen_ratio = GenRatio} ->
            ExtraAttr = [],
            BaseRating = lib_equip_api:cal_equip_rating(GoodsTypeInfo, ExtraAttr),
            NewSkillId = case OSkill =:= 0 of
                             true ->
                                 ?IF(urand:rand(1, 10000) =< GenRatio, SkillId, 0);
                             _ ->
                                 OSkill
                         end,
            %?PRINT("gen_equip_dynamic_attr ## NewSkillId: ~p~n", [NewSkillId]),
            GoodsOther#goods_other{rating = BaseRating, extra_attr = ExtraAttr, skill_id = NewSkillId};
        _ ->
            GoodsOther
    end.

%% 合成获得技能概率
compose_skill(GoodsTypeId, UpdateGoodsList) ->
    case data_baby_new:get_baby_equip(GoodsTypeId) of
        #base_baby_equip{skills = SkillId, compose_ratio = WeightL, gen_ratio = GenRatio} ->
            ComSkillNum = length([TmpSkill || #goods{other = #goods_other{skill_id = TmpSkill}} <- UpdateGoodsList, TmpSkill =/= 0]),
            case lists:keyfind(ComSkillNum, 1, WeightL) of
                {_, TmpRatio} ->
                    %% 换算概率（万分比）
                    %ComRatio = round(max(TmpRatio - GenRatio, 0) / (10000 - GenRatio)),
                    ComRatio = GenRatio + TmpRatio,
                    ?PRINT("compose_skill ## ComRatio: ~p~n", [ComRatio]),
                    ?IF(urand:rand(1, 10000) =< ComRatio, SkillId, 0);
                _ ->
                    0
            end;
        _ ->
            0
    end.

%%------------------------------------- 宝宝幻化
%% 激活形象/形象升星
active_figure(PS, BabyId) ->
	case lib_baby_check:active_figure(PS, BabyId) of 
		{ok, ActiveType, OldStar, NewBabyFigure, CostList} ->
			case lib_goods_api:cost_object_list(PS, CostList, active_figure, "") of 
				{true, PSAfCost} ->
					#player_status{id = RoleId, status_baby = StatusBaby} = PSAfCost,
					#status_baby{active_list = ActiveList} = StatusBaby,
					#baby_figure{baby_star = NewStar} = NewBabyFigure,
					lib_log_api:log_baby_active_figure(RoleId, BabyId, ActiveType, OldStar, NewStar, CostList),
					db_replace_baby_figure(RoleId, NewBabyFigure),
					NewActiveList = lists:keystore(BabyId, #baby_figure.baby_id, ActiveList, NewBabyFigure),
		            NewStatusBaby = StatusBaby#status_baby{active_list = NewActiveList},
		            StatusBabyAfAttr = count_baby_attr(?ATTR_TYPE_FIGURE, NewStatusBaby),
					PSAfAttr = PSAfCost#player_status{status_baby = StatusBabyAfAttr},
					CountPS = count_player_power(PSAfAttr),
					lib_baby_api:active_baby_figure(CountPS, BabyId),
					%?PRINT("active_figure ## succ : ~p~n", [StatusBabyAfAttr]),
					{ok, CountPS};
				{false, ErrorCode, _} ->
					{false, ErrorCode}
			end;
		Res -> ?PRINT("active_figure ## Res : ~p~n", [Res]), Res 
	end.

%% 使用形象
use_figure(PS, NewBabyId) ->
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	#status_baby{baby_id = BabyId, baby_name = BabyName, active_list = ActiveList} = StatusBaby,
	if
		BabyId == NewBabyId -> {false, ?ERRCODE(err182_figure_in_use)};
		true ->
			case lists:keyfind(NewBabyId, #baby_figure.baby_id, ActiveList) of 
				false -> 
					{false, ?ERRCODE(err182_not_active)};
				_ ->
					db_update_baby_basic_baby_id(RoleId, NewBabyId, BabyName),
					NewStatusBaby = StatusBaby#status_baby{baby_id = NewBabyId},
					lib_baby:ets_update(RoleId, [{#baby_basic.baby_id, NewBabyId}]),
					%?PRINT("use_figure ## succ : ~p~n", [NewStatusBaby]),
					{ok, PS#player_status{status_baby = NewStatusBaby}}
			end
	end.
%% 取消使用形象
unuse_figure(PS, NewBabyId) ->
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	#status_baby{baby_id = BabyId, baby_name = BabyName} = StatusBaby,
	if
		BabyId =/= NewBabyId -> {false, ?ERRCODE(err182_figure_not_use)};
		true ->
			db_update_baby_basic_baby_id(RoleId, 0, BabyName),
			NewStatusBaby = StatusBaby#status_baby{baby_id = 0},
			lib_baby:ets_update(RoleId, [{#baby_basic.baby_id, 0}]),
			%?PRINT("unuse_figure ## succ : ~p~n", [NewStatusBaby]),
			{ok, PS#player_status{status_baby = NewStatusBaby}}
	end.
%% 改名
change_baby_name(PS, BabyName) ->
	#player_status{id = RoleId} = PS,
	case mod_counter:get_count(RoleId, ?MOD_MARRIAGE, 2) of 
		0 ->
			mod_counter:increment(RoleId, ?MOD_MARRIAGE, 2),
			change_baby_name_do(PS, BabyName);
		_ ->
			case lib_goods_api:cost_object_list_with_check(PS, ?rename_cost, baby_name, "") of 
				{true, NewPS} ->
					change_baby_name_do(NewPS, BabyName);
				{false, Res, _} ->
					{false, Res}
			end
	end.

change_baby_name_do(PS, BabyName) ->
	NewBabyName = util:make_sure_binary(BabyName),
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	#status_baby{baby_id = BabyId} = StatusBaby,
	db_update_baby_basic_baby_id(RoleId, BabyId, NewBabyName),
	NewStatusBaby = StatusBaby#status_baby{baby_name = NewBabyName},
	lib_baby:ets_update(RoleId, [{#baby_basic.baby_name, NewBabyName}]),
	%?PRINT("change_baby_name ## succ : ~p~n", [NewStatusBaby]),
	{ok, PS#player_status{status_baby = NewStatusBaby}}.

%%---------------------------------- 宝宝点赞
%% 展示宝宝
display_baby(PS) ->
	#player_status{id = RoleId, figure = #figure{name = RoleName} = Figure, status_baby = StatusBaby} = PS,
	case mod_baby_mgr:call({is_in_display, RoleId}) of 
		true -> 
			%% 发个展示传闻
			lib_chat:send_TV({all_lv, ?active_level, 99999}, RoleId, Figure, ?MOD_BABY, 1, [RoleId]),
			{ok, PS};
		_ ->
			BabyBasic = trans_to_baby_basic(RoleId, StatusBaby),
			mod_baby_mgr:cast({display_baby, [RoleId, RoleName, BabyBasic]}),
			%% 发个展示传闻
			lib_chat:send_TV({all_lv, ?active_level, 99999}, RoleId, Figure, ?MOD_BABY, 1, [RoleId]),
			?PRINT("display_baby ## succ : ~p~n", [ok]),
			{ok, PS}
	end.
%% 点赞宝宝
praise_player_baby(PS, RoleId, Opr) ->
	#player_status{id = PraiserId, figure = #figure{lv = RoleLv, name = PraiserName}} = PS,
	case RoleLv >= 150 of 
		true ->
			case mod_baby_mgr:call({praise_player_baby, [RoleId, PraiserId, PraiserName]}) of 
				{ok, IsFirstTimes} ->
					if
						Opr == 2 andalso IsFirstTimes == false -> {false, ?ERRCODE(err182_had_praise_back)};
						true ->
							PraiseCount = mod_daily:get_count(PraiserId, ?MOD_MARRIAGE, 1),
							case IsFirstTimes == true andalso PraiseCount < ?praise_reward_times of 
								true ->
									lib_log_api:log_baby_praise(PraiserId, RoleId, PraiseCount+1, ?praise_reward),
									mod_daily:increment(PraiserId, ?MOD_MARRIAGE, 1),
									{ok, NewPS} = lib_goods_api:send_reward_with_mail(PS, #produce{type = praise_baby, reward = ?praise_reward, show_tips = 3}),
									?PRINT("praise_player_baby ## succ : ~p~n", [ok]),
									{ok, NewPS, ?praise_reward};
								_ ->
									lib_log_api:log_baby_praise(PraiserId, RoleId, PraiseCount+1, []),
									mod_daily:increment(PraiserId, ?MOD_MARRIAGE, 1),
									{ok, PS, []}
							end
					end;
				{false, Res} ->
					{false, Res};
				_Err ->
					?ERR("praise_player_baby ~p~n", [_Err]),
					{false, ?ERRCODE(system_busy)}
			end;
		_ ->
			{false, ?LEVEL_LIMIT}
	end.

%%---------------------------------- 计算宝宝属性
%% 养育属性
count_baby_attr(?ATTR_TYPE_RAISE, StatusBaby) ->
	#status_baby{raise_lv = RaiseLv, attr_list = AttrList} = StatusBaby,
	RaiseBaseAttr = get_baby_type_attr([{?ATTR_TYPE_RAISE, RaiseLv}]),
	NewAttrList = lists:keystore(?ATTR_TYPE_RAISE, 1, AttrList, {?ATTR_TYPE_RAISE, RaiseBaseAttr}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusBaby#status_baby{attr_list = NewAttrList, total_attr = TotalAttr};
%% 培养阶数属性
count_baby_attr(?ATTR_TYPE_STAGE, StatusBaby) ->
	#status_baby{stage = Stage, stage_lv = StageLv, attr_list = AttrList} = StatusBaby,
	StageBaseAttr = get_baby_type_attr([{?ATTR_TYPE_STAGE, Stage, StageLv}]),
	NewAttrList = lists:keystore(?ATTR_TYPE_STAGE, 1, AttrList, {?ATTR_TYPE_STAGE, StageBaseAttr}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusBaby#status_baby{attr_list = NewAttrList, total_attr = TotalAttr};
%% 特长属性
count_baby_attr(?ATTR_TYPE_EQUIP, StatusBaby) ->
	#status_baby{equip_list = EquipList, attr_list = AttrList} = StatusBaby,
	KnowledgeAttr = get_baby_type_attr([{?ATTR_TYPE_EQUIP, EquipList}]),
	NewAttrList = lists:keystore(?ATTR_TYPE_EQUIP, 1, AttrList, {?ATTR_TYPE_EQUIP, KnowledgeAttr}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusBaby#status_baby{attr_list = NewAttrList, total_attr = TotalAttr};
%% 幻化属性
count_baby_attr(?ATTR_TYPE_FIGURE, StatusBaby) ->
	#status_baby{active_list = ActiveList, attr_list = AttrList} = StatusBaby,
	BabyFigureAttr = get_baby_type_attr([{?ATTR_TYPE_FIGURE, ActiveList}]),
	NewAttrList = lists:keystore(?ATTR_TYPE_FIGURE, 1, AttrList, {?ATTR_TYPE_FIGURE, BabyFigureAttr}),
	TotalAttr = statistic_total_attr(NewAttrList),
	StatusBaby#status_baby{attr_list = NewAttrList, total_attr = TotalAttr};
%% 伴侣宝宝提供的属性
count_baby_attr(?ATTR_TYPE_MATE, [StatusBaby, MateInfo]) ->
	case MateInfo#baby_basic.active_time > 0 of
		true ->
			#status_baby{attr_list = AttrList} = StatusBaby,
			MateAttr = get_baby_type_attr([{?ATTR_TYPE_MATE, MateInfo}]),
			NewAttrList = lists:keystore(?ATTR_TYPE_MATE, 1, AttrList, {?ATTR_TYPE_MATE, MateAttr}),
			TotalAttr = statistic_total_attr(NewAttrList),
			StatusBaby#status_baby{attr_list = NewAttrList, total_attr = TotalAttr};
		_ ->
			StatusBaby
	end;

count_baby_attr(_, StatusBaby) ->
	StatusBaby.

statistic_total_attr(AttrList) ->
	NewAttrList = [Attrs ||{_, Attrs} <- AttrList],
	lib_player_attr:add_attr(list, NewAttrList).


%% 根据具体类型来计算属性
get_baby_type_attr(List) ->
	get_baby_type_attr(List, []).

get_baby_type_attr([], Return) -> Return;
get_baby_type_attr([Item|List], Return) ->
	case Item of 
		{?ATTR_TYPE_RAISE, RaiseLv} ->
			case data_baby_new:get_baby_stage(1, 1, RaiseLv) of 
				#base_baby_stage{base_attr = RaiseBaseAttr} ->
					NewReturn = lib_player_attr:add_attr(list, [RaiseBaseAttr, Return]),
					get_baby_type_attr(List, NewReturn);
				_ ->
					get_baby_type_attr(List, Return)
			end;
		{?ATTR_TYPE_STAGE, Stage, StageLv} ->
			case data_baby_new:get_baby_stage(2, Stage, StageLv) of 
				#base_baby_stage{base_attr = StageBaseAttr} ->
					NewReturn = lib_player_attr:add_attr(list, [StageBaseAttr, Return]),
					get_baby_type_attr(List, NewReturn);
				_ ->
					get_baby_type_attr(List, Return)
			end;
		{?ATTR_TYPE_EQUIP, EquipList} ->
			F = fun(BabyEquip, InnerList) ->
				#baby_equip{
					pos_id = PosId, goods_id = GoodsId, stage = Stage,
					stage_lv = StageLv, skill_id = _SkillId
				} = BabyEquip,
				case GoodsId > 0 of 
					true ->
						case data_goods_type:get(GoodsId) of 
							#ets_goods_type{base_attrlist = GoodsBaseAttr} -> ok;
							_ -> GoodsBaseAttr = []
						end,	
						case data_baby_new:get_baby_equip_stren(PosId, Stage, StageLv) of 
							#base_baby_equip_stren{base_attr = EquipStrenAttr} -> ok;
							_ -> EquipStrenAttr = []
						end,
						case data_baby_new:get_baby_equip_stage(Stage) of 
							#base_baby_equip_stage{base_attr = EquipStageAttr} -> 
								{_, PosEquipStageAttr} = ulists:keyfind(PosId, 1, EquipStageAttr, {PosId, []});
							_ -> PosEquipStageAttr = []
						end,
						NewGoodsBaseAttr = lib_player_attr:partial_attr_convert(GoodsBaseAttr++PosEquipStageAttr),
						lib_player_attr:add_attr(list, [NewGoodsBaseAttr, EquipStrenAttr, InnerList]);
					_ ->
						InnerList
				end
			end,
			EquipAttr = lists:foldl(F, [], EquipList),
			NewReturn = lib_player_attr:add_attr(list, [EquipAttr, Return]),
			get_baby_type_attr(List, NewReturn);
		{?ATTR_TYPE_FIGURE, ActiveList} ->
			F = fun(#baby_figure{baby_id = BabyId, baby_star = BabyStar}, InnerList) ->
				case data_baby_new:get_baby_figure_star(BabyId, BabyStar) of 
					#base_baby_figure_star{base_attr = BabyStarAttr} -> 
						lib_player_attr:add_attr(list, [BabyStarAttr, InnerList]);
					_ -> InnerList
				end
			end,
			BabyFigureAttr = lists:foldl(F, [], ActiveList),
			NewReturn = lib_player_attr:add_attr(list, [BabyFigureAttr, Return]),
			get_baby_type_attr(List, NewReturn);
		{?ATTR_TYPE_MATE, MateInfo} ->
			#baby_basic{raise_lv = RaiseLv, stage = Stage, stage_lv = StageLv} = MateInfo,
			case data_baby_new:get_baby_stage(1, 1, RaiseLv) of 
				#base_baby_stage{extra_attr = RaiseExtraAttr} -> ok;
				_ -> RaiseExtraAttr = []
			end,
			case data_baby_new:get_baby_stage(2, Stage, StageLv) of 
				#base_baby_stage{extra_attr = StageExtraAttr} -> ok;
				_ -> StageExtraAttr = []
			end,
			MateAttr = lib_player_attr:add_attr(list, [RaiseExtraAttr, StageExtraAttr]),
			NewReturn = lib_player_attr:add_attr(list, [MateAttr, Return]),
			get_baby_type_attr(List, NewReturn);
		_ ->
			get_baby_type_attr(List, Return)
	end.

get_baby_figure_power(BabyId, BabyStar, PS) ->
	#player_status{status_baby = StatusBaby, original_attr = SumOAttr} = PS,
	#status_baby{attr_list = _AttrList} = StatusBaby,
	case data_baby_new:get_baby_figure_star(BabyId, BabyStar) of 
		#base_baby_figure_star{base_attr = BabyStarAttr} -> ok;
		_ -> BabyStarAttr = []
	end,
	BabyFigurePower = lib_player:calc_partial_power(SumOAttr, 0, BabyStarAttr),
	?PRINT("get_baby_figure_power ~p~n", [BabyFigurePower]),
	BabyFigurePower.

%% 判断升阶会不会触发伴侣的属性产生变化
is_trigger_mate_attr(?ATTR_TYPE_RAISE, [OldRaiseLv, RaiseLv]) ->
	case data_baby_new:get_baby_stage(1, 1, OldRaiseLv) of 
		#base_baby_stage{extra_attr = OldRaiseExtraAttr} -> ok;
		_ -> OldRaiseExtraAttr = []
	end,
	case data_baby_new:get_baby_stage(1, 1, RaiseLv) of 
		#base_baby_stage{extra_attr = RaiseExtraAttr} -> ok;
		_ -> RaiseExtraAttr = []
	end,
	OldRaiseExtraAttr =/= RaiseExtraAttr;

is_trigger_mate_attr(?ATTR_TYPE_STAGE, [OldStage, OldStageLv, Stage, StageLv]) ->
	case data_baby_new:get_baby_stage(2, OldStage, OldStageLv) of 
		#base_baby_stage{extra_attr = OldStageExtraAttr} -> ok;
		_ -> OldStageExtraAttr = []
	end,
	case data_baby_new:get_baby_stage(2, Stage, StageLv) of 
		#base_baby_stage{extra_attr = StageExtraAttr} -> ok;
		_ -> StageExtraAttr = []
	end,
	OldStageExtraAttr =/= StageExtraAttr;
is_trigger_mate_attr(_, _) ->
	false.

count_baby_power(TypeList, TypeAttrList) ->
	AttrList = [Attr ||{Type, Attr} <- TypeAttrList, lists:member(Type, TypeList)],
	AttrListCom = lib_player_attr:add_attr(list, AttrList),
	lib_player:calc_all_power(AttrListCom).

count_baby_skill_power(StatusBaby) ->
	#status_baby{equip_list = EquipList} = StatusBaby,
	F = fun(#baby_equip{skill_id = SkillId}, Acc) ->
		case SkillId > 0 of 
			true ->
				SkillP = lib_skill_api:get_skill_power(SkillId, 1),
				SkillP + Acc;
			_ ->
				Acc 
		end
	end,
	SkillPower = lists:foldl(F, 0, EquipList),
	StatusBaby#status_baby{skill_power = SkillPower}.

count_player_power(PS) ->
	CountPS = lib_player:count_player_attribute(PS),
	#player_status{id = RoleId, status_baby = StatusBaby, original_attr = SumOAttr} = CountPS,
	#status_baby{attr_list = AttrList, skill_power = SkillPower} = StatusBaby,
	%% 去除宝宝自身属性，计算战力
	NewAttrList = lists:keydelete(?ATTR_TYPE_MATE, 1, AttrList),
	TotalAttr = statistic_total_attr(NewAttrList),
	BabyTotalPower = lib_player:calc_partial_power(SumOAttr, SkillPower, TotalAttr),
	?PRINT("count_player_power ~p~n", [{BabyTotalPower, SkillPower}]),
	db_update_baby_basic_power(RoleId, BabyTotalPower),
	lib_baby:ets_update(RoleId, [{#baby_basic.total_power, BabyTotalPower}]),
	lib_player:send_attribute_change_notify(CountPS, ?NOTIFY_ATTR),
	CountPS#player_status{status_baby = StatusBaby#status_baby{total_power = BabyTotalPower}}.

count_equip_power(PS, StatusBaby) ->
	#player_status{status_baby = StatusBaby, original_attr = SumOAttr} = PS,
	#status_baby{attr_list = AttrList, skill_power = SkillPower} = StatusBaby,
	{_, EquipAttr} = ulists:keyfind(?ATTR_TYPE_EQUIP, 1, AttrList, {?ATTR_TYPE_EQUIP, AttrList}),
	BabyEquipPower = lib_player:calc_partial_power(SumOAttr, SkillPower, EquipAttr),
	BabyEquipPower.

%%---------------------------------- 初始化 #status_baby{}
new_status_baby(RoleId) ->
	case db_select_baby_basic(RoleId) of 
		[ActiveTime, BabyIdUse, BabyName, RaiseLv, RaiseExp, Stage, StageLv, StageExp, BabyTotalPower] -> 
			EquipsDbList = db_select_baby_equips(RoleId),
			EquipList = 
				[#baby_equip{pos_id=PosId, id = Id, goods_id=GoodsId, stage = EStage, stage_lv = EStageLv, stage_exp = EStageExp, skill_id = SkillId} 
					|| [PosId, Id, GoodsId, EStage, EStageLv, EStageExp, SkillId] <- EquipsDbList],
			ActiveDbList = db_select_baby_figure(RoleId),
			ActiveList = [#baby_figure{baby_id=BabyId, baby_star=BabyStar} || [BabyId, BabyStar] <- ActiveDbList],
			#status_baby{
				active_time = ActiveTime
				, baby_id = BabyIdUse      
			    , baby_name = BabyName
			    , raise_lv = RaiseLv
			    , raise_exp = RaiseExp
			    , stage = Stage
			    , stage_lv = StageLv
			    , stage_exp = StageExp
			    , equip_list = EquipList
			    , active_list = ActiveList
			    , total_power = BabyTotalPower
			};
		_ -> 
			#status_baby{}
	end.

new_ets_baby(RoleId) ->
	StatusBaby = new_status_baby(RoleId),
	trans_to_baby_basic(RoleId, StatusBaby).

trans_to_baby_basic(RoleId, StatusBaby) ->	
	#baby_basic{
		role_id = RoleId
		, active_time = StatusBaby#status_baby.active_time
	    , baby_id = StatusBaby#status_baby.baby_id
	    , baby_name = StatusBaby#status_baby.baby_name
	    , raise_lv = StatusBaby#status_baby.raise_lv
	    , stage = StatusBaby#status_baby.stage
	    , stage_lv = StatusBaby#status_baby.stage_lv
	    , equip_list = StatusBaby#status_baby.equip_list
	    , active_list = StatusBaby#status_baby.active_list
	    , total_power = StatusBaby#status_baby.total_power
	}.

%% -------------------------------- 协议查询函数
%% 玩家宝宝基础信息
send_role_baby_basic(PS, RoleId) ->
	#player_status{id = SenderId, sid = SendSid, status_baby = StatusBaby} = PS,
	case SenderId == RoleId of 
		true ->
			BabyBasic = trans_to_baby_basic(SenderId, StatusBaby);
		_ ->
			BabyBasic = ets_keyfind(RoleId)
	end,
	PackBasicInfo = pack_baby_basic(BabyBasic),
	{ok, Bin} = pt_182:write(18202, [PackBasicInfo]),
	%?PRINT("send_role_baby_basic ##  : ~p~n", [Bin]),
	lib_server_send:send_to_sid(SendSid, Bin).

%% 宝宝养育界面信息
send_baby_raise_info(PS) ->
	#player_status{id = RoleId, sid = Sid, status_baby = StatusBaby, figure = #figure{lv = RoleLv}} = PS,
	#status_baby{raise_lv = RaiseLv, raise_exp = RaiseExp, attr_list = AttrList} = StatusBaby,
	RaisePower = count_baby_power([?ATTR_TYPE_RAISE], AttrList),
	mod_baby_mgr:cast({send_baby_raise_info, [RoleId, Sid, RoleLv, RaiseLv, RaiseExp, RaisePower]}).
%% 宝宝培养界面信息
send_baby_stage_info(PS) ->
	#player_status{id = _RoleId, sid = Sid, status_baby = StatusBaby} = PS,
	#status_baby{stage = Stage, stage_lv = StageLv, stage_exp = StageExp, attr_list = AttrList} = StatusBaby,
	StagePower = count_baby_power([?ATTR_TYPE_STAGE], AttrList),
	%?PRINT("send_baby_stage_info ##  : ~p~n", [{Stage, StageLv, StageExp, StagePower}]),
	lib_server_send:send_to_sid(Sid, pt_182, 18204, [Stage, StageLv, StageExp, StagePower]).
%% 宝宝装备界面信息
send_baby_equip_info(PS) ->
	#player_status{id = _RoleId, sid = Sid, status_baby = StatusBaby} = PS,
	#status_baby{equip_list = EquipList} = StatusBaby,
	SendEquipList = 
		[{PosId, Id, GoodsTypeId, Stage, StageLv, StageExp, SkillId}
			||#baby_equip{pos_id=PosId, id=Id, goods_id=GoodsTypeId, stage=Stage, stage_lv=StageLv, stage_exp=StageExp, skill_id=SkillId} <- EquipList],
	BabyEquipPower = count_equip_power(PS, StatusBaby),
	%?PRINT("send_baby_equip_info ##  : ~p~n", [{EquipAttr, BabyEquipPower}]),
	lib_server_send:send_to_sid(Sid, pt_182, 18205, [SendEquipList, BabyEquipPower]).

%% 宝宝幻化界面信息
send_baby_active_list_info(PS) ->
	#player_status{id = _RoleId, sid = Sid, status_baby = StatusBaby} = PS,
	#status_baby{active_list = ActiveList, attr_list = _AttrList} = StatusBaby,
	SendActiveList = [{BabyId, BabyStar}||#baby_figure{baby_id=BabyId, baby_star=BabyStar} <- ActiveList],
	%FigurePower = count_baby_power([?ATTR_TYPE_FIGURE], AttrList),
	%?PRINT("send_baby_active_list_info ##  : ~p~n", [SendActiveList]),
	lib_server_send:send_to_sid(Sid, pt_182, 18206, [SendActiveList]).
%% 宝宝家庭界面信息
send_baby_family_info(PS) ->
	#player_status{id = RoleId, sid = Sid, status_baby = StatusBaby, marriage = #marriage_status{lover_role_id = LoverId}} = PS,
	case LoverId > 0 of 
		true ->
			BabyBasicSelf = trans_to_baby_basic(RoleId, StatusBaby),
			BabyBasicMate = ets_keyfind(LoverId),
			SendList = pack_family_info([{BabyBasicSelf, BabyBasicMate}, {BabyBasicMate, BabyBasicSelf}]);
		_ ->
			BabyBasicSelf = trans_to_baby_basic(RoleId, StatusBaby),
			SendList = pack_family_info([{BabyBasicSelf, #baby_basic{}}])
	end,
	%?PRINT("send_baby_family_info ##  : ~p~n", [SendList]),
	lib_server_send:send_to_sid(Sid, pt_182, 18207, [SendList]).
%% 宝宝点赞榜单
send_baby_praise_rank(PS) ->
	#player_status{id = RoleId, sid = Sid} = PS,
	mod_baby_mgr:cast({send_praise_rank, [RoleId, Sid]}).
%% 自己宝宝点赞记录
send_baby_praise_record(PS) ->
	#player_status{id = RoleId, sid = Sid} = PS,
	mod_baby_mgr:cast({send_praise_rank_record, [RoleId, Sid]}).

pack_baby_basic(BabyBasic) ->
	#baby_basic{
		role_id = RoleId
		, active_time = ActiveTime
	    , baby_id = BabyId
	    , baby_name = BabyName
	    , raise_lv = RaiseLv
	    , stage = Stage
	    , stage_lv = StageLv
	    , equip_list = EquipList
	    , active_list = ActiveList
	    , total_power = BabyPower
	} = BabyBasic,
	% CalcAttrList = [
 %        {?ATTR_TYPE_RAISE, RaiseLv}, {?ATTR_TYPE_STAGE, Stage, StageLv}, 
 %        {?ATTR_TYPE_EQUIP, EquipList}, {?ATTR_TYPE_FIGURE, ActiveList}
 %    ],
     #figure{name = RoleName} = lib_role:get_role_figure(RoleId),
 %    BabyAttr = lib_baby:get_baby_type_attr(CalcAttrList),
 %    BabyPower = lib_player:calc_all_power(BabyAttr),
	SendEquipList = 
		[{PosId, GoodsTypeId, EStage, EStageLv, ESkillId} 
			||#baby_equip{pos_id=PosId, goods_id=GoodsTypeId, stage=EStage, stage_lv=EStageLv, skill_id=ESkillId} <- EquipList],
	SendActiveList = [{BabyId1, BabyStar} ||#baby_figure{baby_id=BabyId1, baby_star=BabyStar} <- ActiveList],
	[{RoleId, RoleName, ActiveTime, BabyId, BabyName, RaiseLv, Stage, StageLv, BabyPower, SendEquipList, SendActiveList}].

pack_family_info(List) ->
	pack_family_info(List, []).
pack_family_info([], Return) -> Return;
pack_family_info([{BabyBasicSelf, _BabyBasicMate}|L], Return) ->
	#baby_basic{
		role_id = RoleId
		, active_time = ActiveTime
	    , baby_id = BabyId
	    , baby_name = BabyName
	    , raise_lv = RaiseLv
	    , stage = Stage
	    , stage_lv = StageLv
	    , equip_list = EquipList
	    , active_list = ActiveList
	    , total_power = SelfPower
	} = BabyBasicSelf,
	CalcSelfAttrList = [
        {?ATTR_TYPE_RAISE, RaiseLv}, {?ATTR_TYPE_STAGE, Stage, StageLv}, 
        {?ATTR_TYPE_EQUIP, EquipList}, {?ATTR_TYPE_FIGURE, ActiveList}
    ],
    SelfAttr = lib_baby:get_baby_type_attr(CalcSelfAttrList),
    MateAttr = lib_baby:get_baby_type_attr([{?ATTR_TYPE_MATE, BabyBasicSelf}]), %% 改为给伴侣提供的属性，不是伴侣提供给我我的属性
    %SelfPower = lib_player:calc_all_power(SelfAttr),
    NewReturn = [{RoleId, ActiveTime, BabyId, BabyName, RaiseLv, Stage, StageLv, SelfPower, [{1, SelfAttr}, {2, MateAttr}]}] ++ Return,
    pack_family_info(L, NewReturn).

%%--------------------------------- ets表 函数
ets_keyfind(RoleId) ->
	case ets:lookup(?ets_baby_basic, RoleId) of 
		[#baby_basic{role_id = RoleId}=BabyBasic] -> 
			BabyBasic;
		_ ->
			BabyBasic = new_ets_baby(RoleId),
			ets_insert(BabyBasic),
			BabyBasic
	end.

ets_insert(Value) when is_record(Value, baby_basic) ->
	ets:insert(?ets_baby_basic, Value);
ets_insert(_Value) ->
	ok.

ets_update(Key, UpList) ->
	ets:update_element(?ets_baby_basic, Key, UpList).

%%---------------------------------- 辅助函数
is_baby_active(RoleId) when is_integer(RoleId) ->
	case db:get_row(io_lib:format(<<"select active_time from role_baby_basic where role_id=~p">>, [RoleId])) of 
		[ActiveTime] when ActiveTime > 0 -> true;
		_ -> false
	end;
is_baby_active(PS) ->
	#player_status{status_baby = StatusBaby} = PS,
	StatusBaby#status_baby.active_time > 0.

%%--------------------------------- DB函数
%% 宝宝基础信息
db_select_baby_basic_all() ->
	Sql = io_lib:format(?sql_select_baby_basic_all, []),
	db:get_all(Sql).

db_select_baby_basic(RoleId) ->
	Sql = io_lib:format(?sql_select_baby_basic, [RoleId]),
	db:get_row(Sql).

db_replace_baby_basic(RoleId, StatusBaby) ->
	#status_baby{
		active_time = ActiveTime
	    , baby_id = BabyId
	    , baby_name = BabyName
	    , raise_lv = RaiseLv
	    , raise_exp = RaiseExp  
	    , stage = Stage
	    , stage_lv = StageLv
	    , stage_exp = StageExp    
	    , total_power = TotalPower
	} = StatusBaby,
	Sql = io_lib:format(?sql_replace_baby_basic, [RoleId, ActiveTime, BabyId, util:fix_sql_str(BabyName), RaiseLv, RaiseExp, Stage, StageLv, StageExp, TotalPower]),
	db:execute(Sql).

db_update_baby_basic_raise(RoleId, RaiseLv, RaiseExp) ->
	db:execute(io_lib:format(?sql_update_baby_basic_raise, [RaiseLv, RaiseExp, RoleId])).

db_update_baby_basic_stage(RoleId, Stage, StageLv, StageExp) ->
	db:execute(io_lib:format(?sql_update_baby_basic_stage, [Stage, StageLv, StageExp, RoleId])).

db_update_baby_basic_baby_id(RoleId, BabyId, BabyName) ->
	db:execute(io_lib:format(?sql_update_baby_basic_baby_id, [BabyId, util:fix_sql_str(BabyName), RoleId])).

db_update_baby_basic_power(RoleId, BabyPower) ->
	db:execute(io_lib:format(?sql_update_baby_basic_power, [BabyPower, RoleId])).

%% 宝宝特长
db_select_baby_equips(RoleId) ->
	Sql = io_lib:format(?sql_select_baby_equips, [RoleId]),
	db:get_all(Sql).

db_replace_baby_equip(RoleId, BabyEquip) ->
	#baby_equip{
		pos_id = PosId
		, id = Id
	    , goods_id = GoodsId
	    , stage = Stage
	    , stage_lv = StageLv 
	    , stage_exp = StageExp
	    , skill_id = SkillId
	} = BabyEquip,
	Sql = io_lib:format(?sql_replace_baby_equip, [RoleId, PosId, Id, GoodsId, Stage, StageLv, StageExp, SkillId]),
	db:execute(Sql).	

db_update_baby_equip_stage(RoleId, PosId, Stage, StageLv, StageExp) ->
	db:execute(io_lib:format(?sql_update_baby_equip_stage, [Stage, StageLv, StageExp, RoleId, PosId])).

db_update_baby_equip_skill(RoleId, PosId, SkillId) ->
	db:execute(io_lib:format(?sql_update_baby_equip_skill, [SkillId, RoleId, PosId])).

%% 宝宝幻化
db_select_baby_figure(RoleId) ->
	Sql = io_lib:format(?sql_select_baby_figure, [RoleId]),
	db:get_all(Sql).

db_replace_baby_figure(RoleId, BabyFigure) ->
	#baby_figure{
		baby_id = BabyId
	    , baby_star = BabyStar
	} = BabyFigure,
	Sql = io_lib:format(?sql_replace_baby_figure, [RoleId, BabyId, BabyStar]),
	db:execute(Sql).

%% 宝宝养育任务
db_select_baby_task_all() ->
	Sql = io_lib:format(?sql_select_baby_task_all, []),
	db:get_all(Sql).

db_select_baby_task(RoleId) ->
	Sql = io_lib:format(?sql_select_baby_task, [RoleId]),
	db:get_all(Sql).

db_replace_baby_task(RoleId, BabyTask) ->
	#baby_task{
		task_id = TaskId
	    , finish_num = FinishNum
	    , finish_state = FinishState
	} = BabyTask,
	Sql = io_lib:format(?sql_replace_baby_task, [RoleId, TaskId, FinishNum, FinishState]),
	db:execute(Sql).

db_replace_baby_task_all(RoleId, BabyTaskList) ->
	ValuesList = [
		[RoleId, TaskId, FinishNum, FinishState] 
		|| #baby_task{task_id = TaskId, finish_num = FinishNum, finish_state = FinishState} <- BabyTaskList],
	Sql = usql:replace(role_baby_task, [role_id, task_id, finish_num, finish_state], ValuesList),
	db:execute(Sql).

db_delete_baby_task() ->
	db:execute(io_lib:format(?sql_delete_baby_task, [])).

%% 宝宝点赞
db_select_baby_praise_all() ->
	Sql = io_lib:format(?sql_select_baby_praise, []),
	db:get_all(Sql).

db_replace_baby_praise(RoleId, PraiserId, PraiserName) ->
	db:execute(io_lib:format(?sql_replace_baby_praise, [RoleId, PraiserId, util:fix_sql_str(PraiserName)])).

db_delete_baby_praise() ->
	db:execute(io_lib:format(?sql_delete_baby_praise, [])).
