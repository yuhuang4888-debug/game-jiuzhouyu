%% ---------------------------------------------------------------------------
%% @doc 灵器模块
%% @author lxl
%% @since  2018-09-07
%% @deprecated
%% ---------------------------------------------------------------------------
-module(lib_anima_equip).
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-include("anima_equip.hrl").

-export([
    login/2
    , equip_anima/4
    , unequip_anima/3
]).

login(PS, GS) ->
    #player_status{id = RoleId} = PS,
    AnimaEquipList = lib_goods_util:get_goods_list_by_type(RoleId, ?GOODS_LOC_ANIMA_EQUIP, ?GOODS_TYPE_EQUIP, GS#goods_status.dict),
    F = fun(GoodsInfo, Map) ->
        #goods{id = GoodsId, goods_id = GTypeId, sub_location = AnimaId, color = Color} = GoodsInfo,
        case AnimaId > 0 of 
            true ->
                EquipPos = data_goods:get_equip_cell(GoodsInfo#goods.equip_type),
                Stage = lib_equip_api:get_equip_stage(GoodsInfo),
                Star = lib_equip_api:get_equip_star(GoodsInfo),
                AnimaEquip = #anima_equip{anima_id = AnimaId, goods_id = GoodsId, equip_pos = EquipPos, type_id = GTypeId, stage = Stage, color = Color, star = Star},
                AnimaList = maps:get(AnimaId, Map, []),
                maps:put(AnimaId, [AnimaEquip|AnimaList], Map);
            _ -> Map
        end
    end,
    AnimaMap = lists:foldl(F, #{}, AnimaEquipList),
    NewPS = PS#player_status{anima_status = #anima_status{anima_map = AnimaMap}},
    LastPS = count_player_attr_all(NewPS),
    %?PRINT("login status : ~p~n", [LastPS#player_status.anima_status]),
    LastPS.


equip_anima(PS, AnimaId, GoodsId, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_anima_equip_check:equip_anima(PS, GoodsStatus, AnimaId, GoodsId, EquipPos) of
        {ok, OldGoodsInfo, GoodsInfo} ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                equip_anima_do(GoodsStatus, OldGoodsInfo, GoodsInfo, AnimaId, EquipPos)
            end,
            case lib_goods_util:transaction(F) of 
                {ok, NewStatus, AnimaEquip, UpdateGoodsList} ->
                    #player_status{id = RoleId, anima_status = AnimaStatus} = PS,
                    #anima_status{anima_map = AnimaMap} = AnimaStatus,
                    lib_goods_do:set_goods_status(NewStatus),
                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                    lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num = 0}]),
                    lib_goods_api:notify_client(RoleId, UpdateGoodsList),
                    %% 更新anima_status
                    AnimaList = maps:get(AnimaId, AnimaMap, []),
                    NewAnimaList = lists:keystore(EquipPos, #anima_equip.equip_pos, AnimaList, AnimaEquip),
                    NewAnimaMap = maps:put(AnimaId, NewAnimaList, AnimaMap),
                    NewPS = PS#player_status{anima_status = AnimaStatus#anima_status{anima_map = NewAnimaMap}},
                    LastPS = count_player_attr_and_report(NewPS, AnimaId),
                    {ok, LastPS, AnimaEquip};
                _Err ->
                    ?ERR("euqip anima err :~p~n", [_Err]),
                    {false, ?FAIL}
            end;
        {false, Res} -> {false, Res}
    end.

equip_anima_do(GoodsStatus, OldGoodsInfo, GoodsInfo, AnimaId, EquipPos) ->
    Location = ?GOODS_LOC_ANIMA_EQUIP,
    Stage = lib_equip_api:get_equip_stage(GoodsInfo),
    Star = lib_equip_api:get_equip_star(GoodsInfo),
    case is_record(OldGoodsInfo, goods) of
        true -> %% 存在已装备的物品，则替换装备
            OriginalCell = 0, %%
            OriginalLocation = OldGoodsInfo#goods.bag_location,
            %% 更新oldgoods信息
            [_NewOldGoodsInfo, GoodsStatus1] =
                lib_goods:change_goods_sub_location(OldGoodsInfo, OriginalLocation, 0, OriginalCell, GoodsStatus),

            %% 更新newgoods
            [NewGoodsInfo, NewGoodsStatus] =
                lib_goods:change_goods_sub_location(GoodsInfo, Location, AnimaId, EquipPos, GoodsStatus1),

            AnimaEquip = #anima_equip{
                anima_id = AnimaId, goods_id = NewGoodsInfo#goods.id, equip_pos = EquipPos, type_id = NewGoodsInfo#goods.goods_id, 
                stage = Stage, color = GoodsInfo#goods.color, star = Star
            };
        %% 不存在，直接穿戴
        false ->
            %% 更新newgoods
            [NewGoodsInfo, NewGoodsStatus] =
                lib_goods:change_goods_sub_location(GoodsInfo, Location, AnimaId, EquipPos, GoodsStatus),

            AnimaEquip = #anima_equip{
                anima_id = AnimaId, goods_id = NewGoodsInfo#goods.id, equip_pos = EquipPos, type_id = NewGoodsInfo#goods.goods_id,
                stage = Stage, color = GoodsInfo#goods.color, star = Star
            }
    end,
    #goods_status{dict = OldGoodsDict} = NewGoodsStatus,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    NewStatus = NewGoodsStatus#goods_status{
        dict = GoodsDict
    },
    {ok, NewStatus, AnimaEquip, GoodsL}.

unequip_anima(PS, AnimaId, EquipPos) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_anima_equip_check:unequip_anima(PS, GoodsStatus, AnimaId, EquipPos) of
        {true, GoodsInfo} ->
            F = fun() ->
                ok = lib_goods_dict:start_dict(),
                unequip_anima_do(GoodsStatus, GoodsInfo)
            end,
            case lib_goods_util:transaction(F) of 
                {ok, NewStatus, UpdateGoodsList} ->
                    #player_status{id = RoleId, anima_status = AnimaStatus} = PS,
                    #anima_status{anima_map = AnimaMap} = AnimaStatus,
                    lib_goods_do:set_goods_status(NewStatus),
                    lib_goods_api:notify_client(RoleId, UpdateGoodsList),
                    %% 更新anima_status
                    AnimaList = maps:get(AnimaId, AnimaMap, []),
                    NewAnimaList = lists:keydelete(EquipPos, #anima_equip.equip_pos, AnimaList),
                    NewAnimaMap = maps:put(AnimaId, NewAnimaList, AnimaMap),
                    NewPS = PS#player_status{anima_status = AnimaStatus#anima_status{anima_map = NewAnimaMap}},
                    LastPS = count_player_attr_and_report(NewPS, AnimaId),
                    {ok, LastPS};
                _Err ->
                    ?ERR("uneuqip anima err :~p~n", [_Err]),
                    {false, ?FAIL}
            end;
        {false, Res} -> {false, Res}
    end.

unequip_anima_do(GoodsStatus, GoodsInfo) ->
    OriginalCell = 0, %%
    OriginalLocation = GoodsInfo#goods.bag_location,
    %% 更新oldgoods信息
    [_NewOldGoodsInfo, GoodsStatus1] =
        lib_goods:change_goods_sub_location(GoodsInfo, OriginalLocation, 0, OriginalCell, GoodsStatus),
    #goods_status{dict = OldGoodsDict} = GoodsStatus1,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    NewStatus = GoodsStatus1#goods_status{
        dict = GoodsDict
    },
    {ok, NewStatus, GoodsL}.


count_player_attr_all(PS) ->
    #player_status{anima_status = AnimaStatus} = PS,
    AnimaIdList = data_anima_equip:get_all_anima(),
    F = fun(AnimaId, Status) ->
        count_player_attr_core(Status, AnimaId)
    end,
    NewAnimaStatus = lists:foldl(F, AnimaStatus, AnimaIdList),
    PS#player_status{anima_status = NewAnimaStatus}.

count_player_attr_and_report(PS, AnimaId) ->
    #player_status{anima_status = AnimaStatus} = PS,
    NewAnimaStatus = count_player_attr_core(AnimaStatus, AnimaId),
    NewPS = PS#player_status{anima_status = NewAnimaStatus},
    LastPS = lib_player:count_player_attribute(NewPS),
    lib_player:send_attribute_change_notify(LastPS, ?NOTIFY_ATTR),
    LastPS.
    
count_player_attr_core(AnimaStatus, AnimaId) ->
    #anima_status{anima_map = AnimaMap, attr_list = AttrList} = AnimaStatus,
    AnimaStageList = data_anima_equip:get_anima_attr(AnimaId),
    AnimaList = maps:get(AnimaId, AnimaMap, []),
    F = fun(#anima_equip{type_id = GoodsTypeId}=AnimaEquip, {BaseAttrList, StaticAnimaInfo}) ->
        case data_goods_type:get(GoodsTypeId) of 
            #ets_goods_type{base_attrlist = BaseAttr} ->
                BaseAttrList1 = lib_player_attr:add_attr(list, [BaseAttr, BaseAttrList]),
                NewStaticAnimaInfo = static_anima_info(StaticAnimaInfo, AnimaStageList, AnimaEquip),
                {BaseAttrList1, NewStaticAnimaInfo};
            _ -> {BaseAttrList, StaticAnimaInfo}
        end
    end,
    {BaseAttrListTmp, StaticAnimaInfo} = lists:foldl(F, {[], #{}}, AnimaList),
    BaseAttrList = [ {K, round(V * 0.8)} || {K, V} <- BaseAttrListTmp],
    StageAttrList = get_anima_stage_attr(StaticAnimaInfo, AnimaStageList),
    AnimaAttrList = lib_player_attr:add_attr(list, [StageAttrList, BaseAttrList]),
    NewAttrList = lists:keystore(AnimaId, 1, AttrList, {AnimaId, AnimaAttrList}),
    AttrAll = static_all_attr(NewAttrList),
    AnimaStatus#anima_status{attr_list = NewAttrList, attr = AttrAll}.

get_anima_stage_attr(StaticAnimaInfo, AnimaStageList) ->
    F = fun({AttrStage, Condition, AttrList}, List) ->
        [NeedNum, _ColorValue, _StageValue, _StarValue] = Condition,
        HadNum = maps:get(AttrStage, StaticAnimaInfo, 0),
        case HadNum >= NeedNum of 
            true -> lib_player_attr:add_attr(list, [AttrList, List]);
            _ -> List
        end
    end,
    lists:foldl(F, [], AnimaStageList).

static_all_attr(AttrList) ->
    lib_player_attr:add_attr(list, [Attr || {_, Attr} <- AttrList]).

static_anima_info(StaticAnimaInfo, AnimaStageList, AnimaEquip) ->
    #anima_equip{stage = Stage, color = Color, star = Star} = AnimaEquip,
    F = fun({AttrStage, Condition, _}, Map) ->
        [_, ColorValue, StageValue, StarValue] = Condition,
        case Stage >= StageValue andalso Color >= ColorValue andalso Star >= StarValue of 
            true ->
                OldNum = maps:get(AttrStage, Map, 0),
                maps:put(AttrStage, OldNum+1, Map);
            _ -> Map
        end
    end,
    lists:foldl(F, StaticAnimaInfo, AnimaStageList).
