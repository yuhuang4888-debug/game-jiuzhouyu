%%% ----------------------------------------------------
%%% @Module:        lib_equip_refinement
%%% @Author:        lxl
%%% @Description:   装备神炼
%%% @Created:       
%%% ----------------------------------------------------
-module(lib_equip_refinement).

-include("equip_refinement.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_module.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("def_goods.hrl").
-include("predefine.hrl").

-export([
    get_equip_refinement_list/1
    , promote/2
    , get_refinement_lv/2
    , count_equip_refinement_attr/1
    , count_equip_refinement_attr/2
    ]).


get_equip_refinement_list(RoleId) ->
    case db_select_equip_refinement(RoleId) of 
        [] -> [];
        DbList ->
            [{EquipPos, RefineLv} ||[EquipPos, RefineLv] <- DbList]
    end.

get_refinement_lv(GS, GoodsInfo) when GoodsInfo#goods.location == ?GOODS_LOC_EQUIP ->
    #goods_status{equip_refinement = NewEquipRefinementList} = GS,
    #goods{equip_type = EquipPos} = GoodsInfo,
    case lists:keyfind(EquipPos, 1, NewEquipRefinementList) of 
        {_, RefineLv} -> RefineLv; _ -> 0
    end;
get_refinement_lv(_GoodsStatus, _GoodsInfo)  ->
    0.

promote(PS, GoodsId) ->
    GS = lib_goods_do:get_goods_status(),
    case check_promote(PS, GS, GoodsId) of 
        {false, ErrCode} -> {false, ErrCode};
        {ok, GoodsInfo, NewRefineLv, CostList} ->
            case lib_goods_api:cost_object_list(PS, CostList, equip_refinement, integer_to_list(NewRefineLv)) of 
                {false, ErrCode, _} -> {false, ErrCode};
                {true, PSAfCost} ->
                    GSAfCost = lib_goods_do:get_goods_status(),
                    #goods_status{equip_refinement = EquipRefinementList} = GSAfCost,
                    #goods{equip_type = EquipPos} = GoodsInfo,
                    %% 日志
                    lib_log_api:log_equip_refinement_promote(PS#player_status.id, EquipPos, NewRefineLv, CostList),
                    %% sql
                    db_replace_equip_refinement(PS#player_status.id, EquipPos, NewRefineLv),
                    %% 传闻
                    send_refine_tv(PS, GoodsInfo, NewRefineLv),
                    NewEquipRefinementList = lists:keystore(EquipPos, 1, EquipRefinementList, {EquipPos, NewRefineLv}),
                    NewGS = GSAfCost#goods_status{equip_refinement = NewEquipRefinementList},
                    lib_goods_do:set_goods_status(NewGS),
                    NewPS = count_equip_refinement_attr(PSAfCost, NewGS),
                    LastPS = lib_player:count_player_attribute(NewPS),
                    lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
                    {ok, LastPS, GoodsId, NewRefineLv}
            end
    end.

count_equip_refinement_attr(PS, GS) ->
    #player_status{goods = StatusGoods} = PS,
    EquipRefinementAttr = count_equip_refinement_attr(GS),
    NewStatusGoods = StatusGoods#status_goods{equip_refinement_attr = EquipRefinementAttr},
    PS#player_status{goods = NewStatusGoods}.

count_equip_refinement_attr(GS) ->
    #goods_status{dict = Dict, equip_refinement = EquipRefinementList} = GS,
    EquipList = lib_goods_util:get_equip_list(GS#goods_status.player_id, Dict),
    F = fun(EquipInfo, Acc) ->
        EquipStage = lib_equip:get_equip_stage(EquipInfo),
        case EquipStage >= 9 of 
            true ->
                #goods{equip_type = EquipPos, other = #goods_other{extra_attr = ExtraAttr}} = EquipInfo,
                RefinePos = data_equip_suit:pos2type(EquipPos),
                {_, RefineLv} = ulists:keyfind(EquipPos, 1, EquipRefinementList, {EquipPos, 0}),
                case data_equip_refinement:get(RefineLv, RefinePos) of 
                    #base_equip_refinement{promote = Promote} ->
                        UniExtraAttr = data_attr:unified_format_extra_attr(ExtraAttr, []),
                        AttrList = [{AttrId, round(AttrVal*Promote/10000)} ||{Color, _, AttrId, AttrVal, _, _} <- UniExtraAttr, Color >= ?ORANGE],
                        ulists:kv_list_plus_extra([AttrList, Acc]);
                    _ ->
                        Acc
                end;
            _ ->
                Acc
        end
    end,
    EquipRefinementAttr = lists:foldl(F, [], EquipList),
    EquipRefinementAttr.


check_promote(PS, GS, GoodsId) ->
    GoodsInfo = lib_goods_api:get_goods_info(GoodsId, GS),
    EquipStage = lib_equip:get_equip_stage(GoodsInfo),
    if
        is_record(GoodsInfo, goods) =:= false ->
            {fail, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GS#goods_status.player_id ->
            {fail, ?ERRCODE(err150_palyer_err)};
        GoodsInfo#goods.location =/= ?GOODS_LOC_EQUIP -> {false, ?ERRCODE(err152_not_equip)};
        GoodsInfo#goods.other#goods_other.extra_attr == [] -> {false, ?ERRCODE(err152_no_super_attr)};
        EquipStage < 9 -> {false, ?ERRCODE(err152_equip_stage_err)};
        true ->
            UniExtraAttr = data_attr:unified_format_extra_attr(GoodsInfo#goods.other#goods_other.extra_attr, []),
            case [1 ||{Color, _, _, _, _, _} <- UniExtraAttr, Color >= ?ORANGE] == [] of 
                true -> {false, ?ERRCODE(err152_no_super_attr)};
                _ ->
                    #goods_status{equip_refinement = EquipRefinementList} = GS,
                    #goods{equip_type = EquipPos} = GoodsInfo,
                    RefinePos = data_equip_suit:pos2type(EquipPos),
                    {_, OldRefineLv} = ulists:keyfind(EquipPos, 1, EquipRefinementList, {EquipPos, 0}),
                    NewRefineLv = OldRefineLv + 1,
                    case data_equip_refinement:get(NewRefineLv, RefinePos) of 
                        #base_equip_refinement{cost_list = CostList} ->
                            case lib_goods_api:check_object_list(PS, CostList) of 
                                true ->
                                    {ok, GoodsInfo, NewRefineLv, CostList};
                                {false, ErrCode} ->
                                    {false, ErrCode}
                            end;
                        _ ->
                            {false, ?MISSING_CONFIG}
                    end
            end
    end.

send_refine_tv(PS, GoodsInfo, NewRefineLv) ->
    #player_status{id = RoleId, figure = #figure{name = RoleName}} = PS,
    #goods{id = GoodsId, goods_id = GoodsTypeId, equip_type = EquipPos, other = #goods_other{extra_attr = ExtraAttr}} = GoodsInfo,
    RefinePos = data_equip_suit:pos2type(EquipPos),
    #base_equip_refinement{promote = Promote} = data_equip_refinement:get(NewRefineLv, RefinePos),
    SuperAttrStr = extract_super_attr_string(ExtraAttr, Promote),
    lib_chat:send_TV({all}, ?MOD_EQUIP, 11, [RoleName, GoodsTypeId, GoodsId, RoleId, NewRefineLv, SuperAttrStr]).

extract_super_attr_string(ExtraAttr, Promote) ->
    UniExtraAttr = data_attr:unified_format_extra_attr(ExtraAttr, []),
    F = fun({Color, _, AttrId, AttrVal, _, _}, Acc) when Color >= ?ORANGE ->
            %% <color@{Color}><a@attr{AttrId}></a></color>+{增加值}%
            AddVal = util:float_sub(round(AttrVal*Promote/10000)/ 100, 2),
            ItemStr = lists:concat(["<color@", Color, "><attr@", AttrId, "></attr></color>+", util:term_to_string(AddVal), "%"]),
            case Acc == [] of 
                true -> ItemStr;
                _ -> Acc ++ "、" ++ ItemStr
            end;
        (_, Acc) -> Acc
    end,
    lists:foldl(F, "", UniExtraAttr).

db_select_equip_refinement(RoleId) ->
    db:get_all(io_lib:format(?sql_select_equip_refinement, [RoleId])).

db_replace_equip_refinement(RoleId, EquipPos, RefineLv) ->
    db:execute(io_lib:format(?sql_replace_equip_refinement, [RoleId, EquipPos, RefineLv])).
