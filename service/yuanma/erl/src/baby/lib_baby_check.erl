%%%--------------------------------------
%%% @Module  : lib_baby_check
%%% @Author  : lxl
%%% @Created : 2019.5.9
%%% @Description:  宝宝
%%%--------------------------------------

-module (lib_baby_check).

-include("common.hrl").
-include("server.hrl").
-include("errcode.hrl").
-include("def_fun.hrl").
-include("rec_baby.hrl").
-include("predefine.hrl").
-include("def_goods.hrl").
-include("goods.hrl").

-compile(export_all). 

equip(PS, GS, PosId, GoodsId) ->
	#player_status{status_baby = StatusBaby} = PS,
	#status_baby{stage = Stage, equip_list = EquipList} = StatusBaby,
	BabyEquip = #baby_equip{id = OGoodsId} = ulists:keyfind(PosId, #baby_equip.pos_id, EquipList, #baby_equip{pos_id = PosId}),
	GoodsInfo = lib_goods_util:get_goods(GoodsId, GS#goods_status.dict),
	OldGoodsInfo = lib_goods_util:get_goods(OGoodsId, GS#goods_status.dict),
	CheckList = [
		{check_goods_base, PS, GoodsInfo},
		{check_equip_stage, Stage, GoodsInfo},
		{check_equip_pos, PosId, GoodsInfo}
	],
	case checklist(CheckList) of 
		true ->
			{ok, OldGoodsInfo, GoodsInfo, BabyEquip};
		Res -> Res
	end.

upgrade_equip_stage(PS, PosId) ->
	#player_status{id = RoleId, status_baby = StatusBaby} = PS,
	#status_baby{stage = _Stage, equip_list = EquipList} = StatusBaby,
	BabyEquip = #baby_equip{stage = EStage, stage_lv = EStageLv, stage_exp = EStageExp}
		= ulists:keyfind(PosId, #baby_equip.pos_id, EquipList, #baby_equip{pos_id = PosId}),
	MaxStageLv = data_baby_new:get_equip_max_level(PosId, EStage),
	IsUpStage = EStageLv >= MaxStageLv,
	case IsUpStage of 
		true -> %% 升阶
			NewEStage = EStage+1, NewEStageLv = 0,
			BabyEquipStageCon = data_baby_new:get_baby_equip_stage(NewEStage),
			BabyEquipStrenCon = data_baby_new:get_baby_equip_stren(PosId, NewEStage, NewEStageLv),
			CheckList = [
				{check_is_config, BabyEquipStageCon, base_baby_equip_stage},
				{check_is_config, BabyEquipStrenCon, base_baby_equip_stren},
				{check_goods_enough, PS, BabyEquipStageCon}
			],
			case checklist(CheckList) of 
				true ->
					{LEStage, LEStageLv, LEStageExp} = lib_baby:upgrade_equip_stage_helper(PosId, NewEStage, NewEStageLv, EStageExp, 0),
					NewBabyEquip = BabyEquip#baby_equip{stage = LEStage, stage_lv = LEStageLv, stage_exp = LEStageExp},
					CostList = BabyEquipStageCon#base_baby_equip_stage.cost,
					{ok, 1, IsUpStage, BabyEquip, NewBabyEquip, CostList};
				Res -> Res
			end;
		_ -> %% 升级
			#goods_status{dict = Dict} = lib_goods_do:get_goods_status(),
			GoodsIdNumList = [begin
		        case data_goods_type:get(GoodsTypeId) of
		            #ets_goods_type{bag_location = BagLocation} ->
		                GoodsList = lib_goods_util:get_type_goods_list(RoleId, GoodsTypeId, BagLocation, Dict),
		                TotalNum = lib_goods_util:get_goods_totalnum(GoodsList),
		                {GoodsTypeId, TotalNum};
		            _ ->
		                ?ERR("goods_num err: goods_type_id = ~p err_config", [GoodsTypeId]),
		                {GoodsTypeId, 0}
		        end
		    end||{GoodsTypeId, _AddExp} <- ?equip_exp_goods],
		    NewGoodsIdNumList = [{GoodsTypeId, Num}||{GoodsTypeId, Num} <- GoodsIdNumList, Num > 0],
		    {NewEStage, NewEStageLv, NewEStageExp, CostList} = lib_baby:upgrade_equip_stage_lv(PosId, EStage, EStageLv, EStageExp, NewGoodsIdNumList, []),
		    case CostList == [] of 
		    	true ->
		    		{false, ?GOODS_NOT_ENOUGH};
		    	_ ->
				    NewBabyEquip = BabyEquip#baby_equip{stage = NewEStage, stage_lv = NewEStageLv, stage_exp = NewEStageExp},
				    {ok, 2, IsUpStage, BabyEquip, NewBabyEquip, CostList}
			end
	end.

%% 装备铭刻
engrave_baby_equip(PS, GS, PosId, GoodsList) ->
	#player_status{status_baby = StatusBaby} = PS,
	#goods_status{dict = Dict} = GS,
	#status_baby{equip_list = EquipList} = StatusBaby,
	BabyEquip = #baby_equip{id = GoodsId, goods_id = EquipTypeId}
		= ulists:keyfind(PosId, #baby_equip.pos_id, EquipList, #baby_equip{pos_id = PosId}),
	CostList = lib_baby:get_engrave_goods_list(EquipTypeId, GoodsList),
	?PRINT("engrave_baby_equip## :~p~n", [{EquipTypeId, GoodsList, CostList}]),
	GoodsInfo = lib_goods_util:get_goods(GoodsId, Dict),
	CheckList = [
		{check_equip_goods_skill, GoodsInfo},
		{check_engrave_goods, PS, GoodsList, CostList}
	],
	case checklist(CheckList) of 
		true ->
			case CostList == [] of 
				true -> {false, ?GOODS_NOT_ENOUGH};
				_ ->
					EngraveRation = lib_baby:get_engrave_prob(EquipTypeId, GoodsList),
					?PRINT("engrave_baby_equip## EngraveRation :~p~n", [EngraveRation]),
					{ok, BabyEquip, GoodsInfo, EngraveRation, CostList}
			end;
		Res -> Res
	end.
	
active_figure(PS, BabyId) ->
	#player_status{status_baby = StatusBaby} = PS,
	#status_baby{stage = Stage, active_list = ActiveList} = StatusBaby,
	case lists:keyfind(BabyId, #baby_figure.baby_id, ActiveList) of 
		#baby_figure{baby_star = BabyStar} = BabyFigure ->
			BabyFigureStarConfig = data_baby_new:get_baby_figure_star(BabyId, BabyStar+1),
			CheckList = [
				{check_is_config, BabyFigureStarConfig, base_baby_figure_star},
				{check_goods_enough, PS, BabyFigureStarConfig}
			],
			case checklist(CheckList) of 
				true ->
					{ok, 1, BabyStar, BabyFigure#baby_figure{baby_star = BabyStar+1}, BabyFigureStarConfig#base_baby_figure_star.cost};
				Res -> Res
			end;
		_ ->
			BabyFigureConfig = data_baby_new:get_baby_figure(BabyId),
			CheckList = [
				{check_is_config, BabyFigureConfig, base_baby_figure},
				{check_active_stage, Stage, BabyFigureConfig},
				{check_goods_enough, PS, BabyFigureConfig}
			],
			case checklist(CheckList) of 
				true ->
					{ok, 2, 0, #baby_figure{baby_id = BabyId, baby_star = 1}, BabyFigureConfig#base_baby_figure.cost};
				Res -> Res
			end
	end.


check({check_is_config, Config, ConfigAtom}) ->
	case is_record(Config, ConfigAtom) of 
		true -> true;
		_ -> {false, ?MISSING_CONFIG}
	end;
check({check_goods_base, PS, GoodsInfo}) ->
	if
        is_record(GoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= PS#player_status.id ->
            {false, ?ERRCODE(err150_palyer_err)};
        GoodsInfo#goods.location =/= GoodsInfo#goods.bag_location ->
            {false, ?ERRCODE(err150_location_err)};
        GoodsInfo#goods.type =/= ?GOODS_TYPE_BABY_EQUIP ->
            {false, ?ERRCODE(err150_type_err)};
        true ->
            true
    end;
check({check_equip_stage, Stage, GoodsInfo}) when is_record(GoodsInfo, goods) ->
    check({check_equip_stage, Stage, GoodsInfo#goods.goods_id});
check({check_equip_stage, Stage, GoodsTypeId}) ->
	case data_baby_new:get_baby_equip(GoodsTypeId) of 
		#base_baby_equip{equip_stage = EquipStage} when Stage >= EquipStage -> true;
		#base_baby_equip{} -> {false, ?ERRCODE(err182_stage_not_enough)};
		_ -> {false, ?MISSING_CONFIG}
	end;
check({check_equip_pos, PosId, GoodsInfo}) ->
	case data_baby_new:get_baby_equip(GoodsInfo#goods.goods_id) of 
		#base_baby_equip{pos_id = PosId} -> true;
		_ -> {false, ?ERRCODE(err182_equip_pos_err)}
	end;
check({check_active_stage, Stage, BabyFigureConfig}) ->
	#base_baby_figure{active_stage = ActiveStage} = BabyFigureConfig,
	case ActiveStage =< Stage of 
		true -> true;
		_ -> {false, ?ERRCODE(err182_stage_not_enough)}
	end;
check({check_equip_goods_skill, GoodsInfo}) ->
	case is_record(GoodsInfo, goods) of 
		false -> {false, ?ERRCODE(err182_not_equip)};
		_ -> 
			case GoodsInfo#goods.other#goods_other.skill_id > 0 of 
				true -> {false, ?ERRCODE(err182_skill_had_active)};
				_ -> true
			end
	end;
check({check_engrave_goods, PS, GoodsTypeIdList, CostList}) ->
	case length(GoodsTypeIdList) =/= length(CostList) of 
		true -> {false, ?MISSING_CONFIG};
		_ ->
			check({check_goods_enough, PS, CostList})
	end;
check({check_goods_enough, PS, BabyEquipStageCon}) when is_record(BabyEquipStageCon, base_baby_equip_stage) ->
	#base_baby_equip_stage{cost = CostList} = BabyEquipStageCon,
	check({check_goods_enough, PS, CostList});
check({check_goods_enough, PS, BabyFigureStarConfig}) when is_record(BabyFigureStarConfig, base_baby_figure_star) ->
	#base_baby_figure_star{cost = CostList} = BabyFigureStarConfig,
	check({check_goods_enough, PS, CostList});
check({check_goods_enough, PS, BabyFigureConfig}) when is_record(BabyFigureConfig, base_baby_figure) ->
	#base_baby_figure{cost = CostList} = BabyFigureConfig,
	check({check_goods_enough, PS, CostList});

check({check_goods_enough, PS, CostList}) when is_list(CostList) ->
	case lib_goods_api:check_object_list(PS, CostList) of 
		true -> true;
		Res -> Res
	end;
check(X) ->
    ?INFO("baby_check error ~p~n", [X]),
    {false, ?FAIL}.


%% helper function

checklist([]) -> true;
checklist([H | T]) ->
    case check(H) of
        true -> checklist(T);
        {false, Res} -> {false, Res}
    end.
