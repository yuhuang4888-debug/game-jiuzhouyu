%% ---------------------------------------------------------------------------
%% @doc 灵器模块
%% @author lxl
%% @since  2018-09-07
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_anima_equip_check).
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("anima_equip.hrl").

-compile(export_all).


equip_anima(PS, GoodsStatus, AnimaId, GoodsId, EquipPos) ->
	GoodsInfo = lib_goods_util:get_goods(GoodsId, GoodsStatus#goods_status.dict),
	#player_status{anima_status = #anima_status{anima_map = AnimaMap}} = PS,
	AnimaList = maps:get(AnimaId, AnimaMap, []),
	AnimaEquip = lists:keyfind(EquipPos, #anima_equip.equip_pos, AnimaList),
	case AnimaEquip of 
		#anima_equip{goods_id = OldGoodsId} -> OldGoodsInfo = lib_goods_util:get_goods(OldGoodsId, GoodsStatus#goods_status.dict);
		_ -> OldGoodsInfo = []
	end,
	CheckList = [
		{check_goods_base, GoodsInfo, PS},
		{check_lv, GoodsInfo, PS#player_status.figure#figure.lv},
		{check_sex, GoodsInfo, PS#player_status.figure#figure.sex},
        {check_career, GoodsInfo, PS#player_status.figure#figure.career},
        {check_turn, GoodsInfo, PS#player_status.figure#figure.turn},
		{check_anima_id_valid, AnimaId, PS},
		{check_equip_pos_valid, GoodsInfo, EquipPos},
		{check_equip_condition_valid, AnimaId, GoodsInfo},
		{check_replace_bag_cell, PS, OldGoodsInfo}
	],
	case checklist(CheckList) of 
		true ->
			{ok, OldGoodsInfo, GoodsInfo};
		{false, Res} -> {false, Res}
	end.

unequip_anima(PS, GoodsStatus, AnimaId, EquipPos) ->
	#player_status{anima_status = #anima_status{anima_map = AnimaMap}} = PS,
	AnimaList = maps:get(AnimaId, AnimaMap, []),
	AnimaEquip = lists:keyfind(EquipPos, #anima_equip.equip_pos, AnimaList),
	if
		is_record(AnimaEquip, anima_equip) == false -> {false, ?ERRCODE(err180_not_equip)};
		AnimaEquip#anima_equip.goods_id == 0 -> {false, ?ERRCODE(err180_not_equip)};
		true ->
			GoodsInfo = lib_goods_util:get_goods(AnimaEquip#anima_equip.goods_id, GoodsStatus#goods_status.dict),
			case is_record(GoodsInfo, goods) of 
				true ->
					case checklist([{check_replace_bag_cell, PS, GoodsInfo}]) of 
						true ->
							{true, GoodsInfo};
						{false, Res} -> {false, Res}
					end;
				_ ->
					{false, ?ERRCODE(err150_no_goods)}
			end
	end.


check_goods_base(GoodsInfo, PS) ->
	#player_status{id = PlayerId} = PS,
    if
        %% 物品不存在
        is_record(GoodsInfo, goods) =:= false orelse GoodsInfo#goods.id < 0 ->
            {false, ?ERRCODE(err150_no_goods)};
        %% 物品不属于你所有
        GoodsInfo#goods.player_id =/= PlayerId ->
            {false, ?ERRCODE(err150_palyer_err)};
        %% 不是装备
        GoodsInfo#goods.type =/= ?GOODS_TYPE_EQUIP ->
            {false, ?ERRCODE(err150_palyer_err)};
        %% 物品不在背包
        GoodsInfo#goods.location =/= GoodsInfo#goods.bag_location orelse GoodsInfo#goods.sub_location /= 0 ->
            {false, ?ERRCODE(err150_location_err)};
        %% 物品数量不正确
        GoodsInfo#goods.num =/= 1 ->
            {false, ?ERRCODE(err150_num_err)};
        true ->
            true
    end.

check_equip_condition(Condition, GoodsInfo) ->
	F = fun(Item, IsOk) ->
		case Item of 
			{stage, NeedStage} ->
				Stage = lib_equip_api:get_equip_stage(GoodsInfo),
				case Stage >= NeedStage of
					true -> IsOk;
					_ -> false
				end;
			{qa, NeedColor, NeedStar} ->
				Star = lib_equip_api:get_equip_star(GoodsInfo),
				Color = GoodsInfo#goods.color,
				if
					Color >= NeedColor andalso Star >= NeedStar -> IsOk;
					true -> false
				end;
			_ -> IsOk
		end
	end,
	case lists:foldl(F, true, Condition) of 
		true -> true;
		_ -> {false, ?ERRCODE(err180_equip_condition_err)}
	end.


checklist([]) -> true;
checklist([H|L]) ->
	case check_list(H) of 
		true -> checklist(L);
		{false, Res} -> {false, Res}
	end.	

check_list({check_goods_base, GoodsInfo, PS}) ->
	check_goods_base(GoodsInfo, PS);

check_list({check_lv, GoodsInfo, PlayerLv}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    case G#ets_goods_type.level =< PlayerLv of
        true -> true;
        false -> {false, ?ERRCODE(err152_lv_err)}
    end;

check_list({check_sex, GoodsInfo, Sex}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.sex == 0 -> true;
        G#ets_goods_type.sex == Sex -> true;
        true -> {false, ?ERRCODE(err152_sex_error)}
    end;

check_list({check_career, GoodsInfo, Career}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.career == 0 -> true;
        G#ets_goods_type.career == Career -> true;
        true -> {false, ?ERRCODE(err152_career_error)}
    end;

check_list({check_turn, GoodsInfo, RoleTurn}) ->
    G = data_goods_type:get(GoodsInfo#goods.goods_id),
    if
        G#ets_goods_type.turn == 0 -> true;
        G#ets_goods_type.turn =< RoleTurn -> true;
        true -> {false, ?ERRCODE(err152_turn_error)}
    end;
           
check_list({check_anima_id_valid, AnimaId, PS}) ->
	case data_anima_equip:get_anima_cfg(AnimaId) of 
		#base_anima_cfg{open_lv = OpenLv} ->
			case PS#player_status.figure#figure.lv >= OpenLv of 
				true -> true;
				_ -> {false, ?ERRCODE(err180_anima_id_err)}
			end;
		_ -> {false, ?MISSING_CONFIG}
	end;

check_list({check_equip_pos_valid, GoodsInfo, EquipPos}) ->
	Cell = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
	case Cell == EquipPos of 
		true -> true;
		_ -> {false, ?ERRCODE(err180_equip_pos_err)}
	end;

check_list({check_equip_condition_valid, AnimaId, GoodsInfo}) ->
	case data_anima_equip:get_anima_cfg(AnimaId) of 
		#base_anima_cfg{condition = Condition} ->
			check_equip_condition(Condition, GoodsInfo);
		_ -> {false, ?MISSING_CONFIG}
	end;

check_list({check_replace_bag_cell, PS, OldGoodsInfo}) ->
	case OldGoodsInfo of 
		#goods{goods_id = GoodsTypeId} ->
			lib_goods_api:can_give_goods(PS, [{GoodsTypeId, 1}]);
		_ -> true
	end;

check_list(_) -> {false, ?FAIL}.