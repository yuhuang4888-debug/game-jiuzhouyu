%%%--------------------------------------
%%% @Module  : pp_house
%%% @Author  : huyihao
%%% @Created : 2018.05.17
%%% @Description:  家园
%%%--------------------------------------
-module (pp_house).
-export ([handle/3]).
-include("server.hrl").
-include("figure.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("def_module.hrl").
-include("def_goods.hrl").
-include("guild.hrl").
-include("predefine.hrl").
-include("def_event.hrl").
-include("activitycalen.hrl").
-include("daily.hrl").
-include("house.hrl").
-include("marriage.hrl").
-include("language.hrl").

%% 把家具放入身上（计算属性战力）
handle(17701, Ps, [GoodsId, PutNum1]) ->
    #player_status{
        id = RoleId,
        house = HouseStatus
    } = Ps,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{
        dict = Dict
    } = GoodsStatus,
    #house_status{
        home_id = {BlockId, HouseId},
        choose_house = {ChooseBlockId, _ChooseHouseId}
    } = HouseStatus,
    if
        BlockId =:= 0 ->
            {ok, Bin} = pt_177:write(17701, [?ERRCODE(err177_house_none)]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPs = Ps;
        ChooseBlockId =/= 0 ->
            {ok, Bin} = pt_177:write(17701, [?ERRCODE(err177_house_choose)]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPs = Ps;
        true ->
            FurnitureBagInfo = lib_goods_util:get_goods(GoodsId, Dict),
            case FurnitureBagInfo of
                false ->
                    NewPs = Ps,
                    {ok, Bin} = pt_177:write(17701, [?ERRCODE(err177_house_not_furniture)]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    #goods{
                        goods_id = GoodsTypeId,
                        num = BagNum,
                        cell = OriginalCell,
                        location = Location
                    } = FurnitureBagInfo,
                    FurnitureIdList = data_house:get_furniture_id_list(),
                    IfFurniture = lists:member(GoodsTypeId, FurnitureIdList),
                    if
                        IfFurniture =:= false ->
                            NewPs = Ps,
                            {ok, Bin} = pt_177:write(17701, [?ERRCODE(err177_house_not_furniture)]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        Location =/= ?GOODS_LOC_FURNITURE_BAG ->
                            NewPs = Ps,
                            {ok, Bin} = pt_177:write(17701, [?ERRCODE(err177_house_furniture_location_wrong)]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        true ->
                            FurnitureWearList = lib_goods_util:get_type_goods_list(RoleId, GoodsTypeId, ?GOODS_LOC_FURNITURE, Dict),
                            case FurnitureWearList of
                                [] ->
                                    FurnitureWearInfo = false,
                                    WearNum = 0;
                                [FurnitureWearInfo|_] ->
                                    #goods{
                                        num = WearNum
                                    } = FurnitureWearInfo
                            end,
                            #house_furniture_con{
                                max_num = MaxWearNum
                            } = data_house:get_house_furniture_con(GoodsTypeId),
                            if
                                BagNum < PutNum1 ->
                                    NewPs = Ps,
                                    {ok, Bin} = pt_177:write(17701, [?ERRCODE(err177_furniture_not_enough)]),
                                    lib_server_send:send_to_uid(RoleId, Bin);
                                WearNum >= MaxWearNum ->
                                    NewPs = Ps,
                                    {ok, Bin} = pt_177:write(17701, [?ERRCODE(err177_house_furniture_max)]),
                                    lib_server_send:send_to_uid(RoleId, Bin);
                                true ->
                                    %% 若放进去的数量超过上限则把上限为止填满
                                    LessNum = MaxWearNum - WearNum,
                                    case PutNum1 > LessNum of
                                        true ->
                                            PutNum = LessNum;
                                        false ->
                                            PutNum = PutNum1
                                    end,
                                    F = case (BagNum - PutNum) =< 0 of
                                            false -> %% 背包里扣完大于0
                                                case FurnitureWearInfo of
                                                    false -> %% 身上没有穿
                                                        fun() ->
                                                            ok = lib_goods_dict:start_dict(),
                                                            NewNum = FurnitureBagInfo#goods.num - PutNum,
                                                            [_, NewGoodsStatus1] = lib_goods:change_goods_num(FurnitureBagInfo, NewNum, GoodsStatus),
                                                            %{Cell, NewNullCellsMap} = lib_goods_util:get_null_cell(NullCells, ?GOODS_LOC_FURNITURE),
                                                            NewInfo = FurnitureBagInfo#goods{id = 0, cell = 0, num = PutNum, location = ?GOODS_LOC_FURNITURE},
                                                            [_NewGoodsInfo, NewStatus1] = lib_goods:add_goods(NewInfo, NewGoodsStatus1),
                                                            {Dict1, UpGoods1} = lib_goods_dict:handle_dict_and_notify(NewStatus1#goods_status.dict),
                                                            StatusCells = lib_goods_util:occupy_num_cells(NewStatus1, ?GOODS_LOC_FURNITURE),
                                                            NewStatus2 = StatusCells#goods_status{dict = Dict1},
                                                            {ok, NewStatus2, UpGoods1}
                                                        end;
                                                    _ -> %% 身上穿了
                                                        fun() ->
                                                            ok = lib_goods_dict:start_dict(),
                                                            NewBagNum = FurnitureBagInfo#goods.num - PutNum,
                                                            NewWearNum = FurnitureWearInfo#goods.num + PutNum,
                                                            [_, NewStatus1] = lib_goods:change_goods_num(FurnitureBagInfo, NewBagNum, GoodsStatus),
                                                            [_, NewStatus2] = lib_goods:change_goods_num(FurnitureWearInfo, NewWearNum, NewStatus1),
                                                            {Dict1, UpGoods1} = lib_goods_dict:handle_dict_and_notify(NewStatus2#goods_status.dict),
                                                            NewStatus3 = NewStatus2#goods_status{dict = Dict1},
                                                            {ok, NewStatus3, UpGoods1}
                                                        end
                                                end;
                                            true -> %% 背包里扣完等于0
                                                case FurnitureWearInfo of
                                                    false -> %% 身上没有穿
                                                        fun() ->
                                                            ok = lib_goods_dict:start_dict(),
                                                            lib_goods_api:notify_client_num(RoleId, [FurnitureBagInfo#goods{num=0}]),
                                                            %NewNullCells = lib_goods_util:add_null_cell(NullCells, ?GOODS_LOC_FURNITURE_BAG, OriginalCell),
                                                            %{Cell, NewNullCellsMap} = lib_goods_util:get_null_cell(NewNullCells, ?GOODS_LOC_FURNITURE),
                                                            [_NewGoodsInfo, NewStatus1] = lib_goods:change_goods_cell(FurnitureBagInfo, ?GOODS_LOC_FURNITURE, 0, GoodsStatus),
                                                            {Dict1, UpGoods1} = lib_goods_dict:handle_dict_and_notify(NewStatus1#goods_status.dict),
                                                            NewStatus2 = NewStatus1#goods_status{dict = Dict1},
                                                            {ok, NewStatus2, UpGoods1}
                                                        end;
                                                    _ -> %% 身上穿了
                                                        fun() ->
                                                            ok = lib_goods_dict:start_dict(),
                                                            NewStatus1 = lib_goods:delete_goods(FurnitureBagInfo, GoodsStatus),
                                                            %% 此处通知客户端将从原背包中移除但不会从服务端删除物品
                                                            lib_goods_api:notify_client_num(RoleId, [FurnitureBagInfo#goods{num=0}]),
                                                            NewWearNum = FurnitureWearInfo#goods.num + PutNum,
                                                            [_, NewStatus2] = lib_goods:change_goods_num(FurnitureWearInfo, NewWearNum, NewStatus1),
                                                            {Dict1, UpGoods1} = lib_goods_dict:handle_dict_and_notify(NewStatus2#goods_status.dict),
                                                            NewStatus3 = NewStatus2#goods_status{dict = Dict1},
                                                            {ok, NewStatus3, UpGoods1}
                                                        end
                                                end
                                        end,
                                    case lib_goods_util:transaction(F) of
                                        {ok, NewGoodsStatus, UpGoods} ->
                                            NewFurnitureWearList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_FURNITURE, NewGoodsStatus#goods_status.dict),
                                            FurnitureAttr = lib_house:count_house_attribute(NewFurnitureWearList),
                                            NewHouseStatus = HouseStatus#house_status{
                                                furniture_attr = FurnitureAttr
                                            },
                                            NewPs1 = Ps#player_status{
                                                house = NewHouseStatus
                                            },
                                            lib_goods_do:set_goods_status(NewGoodsStatus),
                                            lib_goods_api:notify_client(RoleId, UpGoods),
                                            WearFurnitureList = [begin
                                                #goods{
                                                    id = GoodsId1,
                                                    goods_id = GoodsTypeId1,
                                                    num = GoodsNum1
                                                } = Furniture,
                                                {GoodsId1, GoodsTypeId1, GoodsNum1}
                                            end||Furniture <- NewFurnitureWearList],
                                            mod_house:add_furniture(RoleId, BlockId, HouseId, WearFurnitureList),
                                            {ok, NewPs} = lib_goods_util:count_role_equip_attribute(NewPs1),
                                            lib_player:send_attribute_change_notify(NewPs, ?NOTIFY_ATTR),
                                            lib_log_api:log_house_add_furniture(RoleId, GoodsId, GoodsTypeId, PutNum);
                                        Error ->
                                            NewPs = Ps,
                                            ?ERR("put furniture err: ~p~n", [Error]),
                                            {ok, Bin} = pt_177:write(17701, [?FAIL]),
                                            lib_server_send:send_to_uid(RoleId, Bin)
                                    end
                            end
                    end
            end
    end,
    {ok, NewPs};

%% 打开房子选择界面
handle(17702, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        house = HouseStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    #house_status{
        home_id = {BlockId, HouseId},
        choose_house = {ChooseBlockId, _ChooseHouseId}
    } = HouseStatus,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17702, [?LEVEL_LIMIT, 0, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case ChooseBlockId of
                0 ->
                    mod_house:open_block_list(RoleId);
                _ ->
                    {ok, Bin} = pt_177:write(17702, [?SUCCESS, BlockId, HouseId, []]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end;

%% 打开房子选择界面
handle(17703, Ps, [BlockId]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17703, [?LEVEL_LIMIT, BlockId, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_house:open_house_list(RoleId, BlockId)
    end;

%% 进入房子
handle(17704, Ps, [BlockId, HouseId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        house = HouseStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17704, [?LEVEL_LIMIT, BlockId, HouseId, 0, "", 0, ""]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case lib_house:check_into_house(Ps) of
                true ->
                    #house_status{
                        home_id = HomeId,
                        choose_house = {ChooseBlockId, _ChooseHouseId}
                    } = HouseStatus,
                    case HomeId of
                        {BlockId, HouseId} ->
                            case ChooseBlockId of
                                0 ->
                                    mod_house:into_house(RoleId, BlockId, HouseId);
                                _ ->
                                    {ok, Bin} = pt_177:write(17704, [?ERRCODE(err177_house_choose), BlockId, HouseId, 0, "", 0, ""]),
                                    lib_server_send:send_to_uid(RoleId, Bin)
                            end;
                        _ ->
                            mod_house:into_house(RoleId, BlockId, HouseId)
                    end;
                {false, Code} ->
                    {ok, Bin} = pt_177:write(17704, [Code, BlockId, HouseId, 0, "", 0, ""]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end;

%% 离开房子
handle(17705, Ps, []) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        old_scene_info = OldSceneInfo,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    SceneIdList = data_house:get_house_scene_list(),
    case lists:member(SceneId, SceneIdList) of
        true ->
            Code = ?SUCCESS,
            case OldSceneInfo of
                undefined ->
                    [OldScene, OldX, OldY] = lib_scene:get_outside_scene_by_lv(Lv),
                    OldScenePooldId = 0,
                    OldCopyId = 0;
                {OldScene1, OldScenePooldId1, OldCopyId1, OldX1, OldY1} ->
                    case lists:member(OldScene1, SceneIdList) of
                        true ->
                            [OldScene, OldX, OldY] = lib_scene:get_outside_scene_by_lv(Lv),
                            OldScenePooldId = 0,
                            OldCopyId = 0;
                        false ->
                            OldScene = OldScene1,
                            OldScenePooldId = OldScenePooldId1,
                            OldCopyId = OldCopyId1,
                            OldX = OldX1,
                            OldY = OldY1
                    end
            end,
            NewPs = lib_scene:change_scene(Ps, OldScene, OldScenePooldId, OldCopyId, OldX, OldY, false, []);
        false ->
            Code = ?ERRCODE(err177_house_not_in),
            NewPs = Ps
    end,
    {ok, Bin} = pt_177:write(17705, [Code]),
    lib_server_send:send_to_uid(RoleId, Bin),
    {ok, NewPs};

%% 打开提升界面
handle(17706, Ps, [BlockId, HouseId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        house = HouseStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17706, [?LEVEL_LIMIT, BlockId, HouseId, 0, 0]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            #house_status{
                home_id = {OwnBlockId, OwnHouseId}
            } = HouseStatus,
            case {OwnBlockId, OwnHouseId} of
                {BlockId, HouseId} ->
                    mod_house:open_upgrade(RoleId, BlockId, HouseId);
                _ ->
                    {ok, Bin} = pt_177:write(17706, [?ERRCODE(err177_house_not_own), BlockId, HouseId, 0, 0]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end
    end;

%% 提升房子
handle(17707, Ps, [BlockId, HouseId, Type]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus,
        house = HouseStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17707, [?LEVEL_LIMIT, BlockId, HouseId, Type]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPs = Ps;
        true ->
            #marriage_status{
                lover_role_id = LoverRoleId,
                type = MarriageType
            } = MarriageStatus,
            #house_status{
                home_id = {BlockId1, _HouseId1},
                house_lv = HouseLv
            } = HouseStatus,
            if
                BlockId1 =:= 0 ->
                    {ok, Bin} = pt_177:write(17707, [?ERRCODE(err177_house_none), BlockId, HouseId, Type]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    NewPs = Ps;
                MarriageType =/= 2 andalso Type =:= 2 ->
                    {ok, Bin} = pt_177:write(17707, [?ERRCODE(err172_couple_single), BlockId, HouseId, Type]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    NewPs = Ps;
                true ->
                    case mod_house:check_upgrade_house(RoleId, BlockId, HouseId) of
                        true ->
                            #house_lv_con{
                                cost_list = CostList
                            } = data_house:get_house_lv_con(HouseLv+1),
                            case MarriageType of
                                2 ->
                                    LoverRoleIdF = LoverRoleId;
                                _ ->
                                    LoverRoleIdF = 0
                            end,
                            case Type of
                                1 ->
                                    case lib_consume_data:advance_cost_objects(Ps, CostList, upgrade_house, "", false) of
                                        {true, NewPs, CostKey} ->
                                            Args = {RoleId, LoverRoleIdF, CostList, BlockId, HouseId, Type, CostKey},
                                            mod_house:upgrade_house(Args);
                                        {false, Code} ->
                                            {ok, Bin} = pt_177:write(17707, [Code, BlockId, HouseId, Type]),
                                            lib_server_send:send_to_uid(RoleId, Bin),
                                            NewPs = Ps
                                    end;
                                _ ->
                                    AACostList =[begin
                                        {GoodsType, GoodsTypeId, round(GoodsNum/2)}
                                    end||{GoodsType, GoodsTypeId, GoodsNum} <- CostList],
                                    case lib_consume_data:advance_cost_objects(Ps, AACostList, upgrade_house_aa, "", false) of
                                        {true, NewPs, CostKey} ->
                                            Args = {RoleId, LoverRoleIdF, AACostList, BlockId, HouseId, HouseLv, Type, CostKey},
                                            mod_house:upgrade_house_aa(Args);
                                        {false, Code} ->
                                            {ok, Bin} = pt_177:write(17707, [Code, BlockId, HouseId, Type]),
                                            lib_server_send:send_to_uid(RoleId, Bin),
                                            NewPs = Ps
                                    end
                            end;
                        {false, Code} ->
                            {ok, Bin} = pt_177:write(17707, [Code, BlockId, HouseId, Type]),
                            lib_server_send:send_to_uid(RoleId, Bin),
                            NewPs = Ps
                    end
            end
    end,
    {ok, NewPs};
            
%% 购买房子
handle(17708, Ps, [BlockId, HouseId, Type]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        marriage = MarriageStatus,
        house = HouseStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17708, [?LEVEL_LIMIT, BlockId, HouseId, Type]),
            lib_server_send:send_to_uid(RoleId, Bin),
            NewPs = Ps;
        true ->
            #marriage_status{
                lover_role_id = LoverRoleId,
                type = MarriageType
            } = MarriageStatus,
            #house_status{
                home_id = {BlockId1, _HouseId1}
            } = HouseStatus,
            if
                BlockId1 =/= 0 ->
                    {ok, Bin} = pt_177:write(17708, [?ERRCODE(err177_house_have), BlockId, HouseId, Type]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    NewPs = Ps;
                MarriageType =/= 2 andalso Type =:= 2 ->
                    {ok, Bin} = pt_177:write(17708, [?ERRCODE(err172_couple_single), BlockId, HouseId, Type]),
                    lib_server_send:send_to_uid(RoleId, Bin),
                    NewPs = Ps;
                true ->
                    BlockIdList = data_house:get_block_id_list(),
                    HouseIdList = data_house:get_block_house_id_list(BlockId),
                    IfBlockId = lists:member(BlockId, BlockIdList),
                    IfHouseId = lists:member(HouseId, HouseIdList),
                    if
                        IfBlockId =/= true ->
                            {ok, Bin} = pt_177:write(17708, [?MISSING_CONFIG, BlockId, HouseId, Type]),
                            lib_server_send:send_to_uid(RoleId, Bin),
                            NewPs = Ps;
                        IfHouseId =/= true ->
                            {ok, Bin} = pt_177:write(17708, [?MISSING_CONFIG, BlockId, HouseId, Type]),
                            lib_server_send:send_to_uid(RoleId, Bin),
                            NewPs = Ps;
                        true ->
                            case mod_house:check_buy_house(RoleId, BlockId, HouseId) of
                                true ->
                                    HouseLvList = data_house:get_house_lv_list(),
                                    HouseLvMin = lists:min(HouseLvList),
                                    #house_lv_con{
                                        cost_list = CostList
                                    } = data_house:get_house_lv_con(HouseLvMin),
                                    case MarriageType of
                                        2 ->
                                            LoverRoleIdF = LoverRoleId;
                                        _ ->
                                            LoverRoleIdF = 0
                                    end,
                                    case Type of
                                        1 ->
                                            case lib_consume_data:advance_cost_objects(Ps, CostList, buy_house, "", false) of
                                                {true, NewPs, CostKey} ->
                                                    Args = {RoleId, LoverRoleIdF, CostList, BlockId, HouseId, Type, CostKey},
                                                    mod_house:buy_house(Args);
                                                {false, Code} ->
                                                    {ok, Bin} = pt_177:write(17708, [Code, BlockId, HouseId, Type]),
                                                    lib_server_send:send_to_uid(RoleId, Bin),
                                                    NewPs = Ps
                                            end;
                                        _ ->
                                            AACostList = [begin
                                                 {GoodsType, GoodsTypeId, round(GoodsNum/2)}
                                             end||{GoodsType, GoodsTypeId, GoodsNum} <- CostList],
                                            case lib_consume_data:advance_cost_objects(Ps, AACostList, buy_house_aa, "", false) of
                                                {true, NewPs, CostKey} ->
                                                    Args = {RoleId, LoverRoleIdF, AACostList, BlockId, HouseId, Type, CostKey},
                                                    mod_house:buy_house_aa(Args);
                                                {false, Code} ->
                                                    {ok, Bin} = pt_177:write(17708, [Code, BlockId, HouseId, Type]),
                                                    lib_server_send:send_to_uid(RoleId, Bin),
                                                    NewPs = Ps
                                            end
                                    end;
                                {false, Code} ->
                                    {ok, Bin} = pt_177:write(17708, [Code, BlockId, HouseId, Type]),
                                    lib_server_send:send_to_uid(RoleId, Bin),
                                    NewPs = Ps
                            end
                    end
            end
    end,
    {ok, NewPs};

%% 回复AA购买房子/升级/选房
handle(17710, Ps, [AnswerType]) ->
    #player_status{
        id = AnswerRoleId,
        marriage = MarriageStatus
    } = Ps,
    #marriage_status{
        type = MarriageType
    } = MarriageStatus,
    case MarriageType =:= 2 of
        false ->
            {ok, Bin} = pt_177:write(17710, [?ERRCODE(err172_couple_single), 0]),
            lib_server_send:send_to_uid(AnswerRoleId, Bin),
            NewPs = Ps;
        true ->
            case mod_house:check_answer_house_aa(AnswerRoleId, AnswerType) of
                {false, Code, Type} ->
                    {ok, Bin} = pt_177:write(17710, [Code, Type]),
                    lib_server_send:send_to_uid(AnswerRoleId, Bin),
                    NewPs = Ps;
                {buy_house, AnswerCostList, Type} ->
                    case lib_consume_data:advance_cost_objects(Ps, AnswerCostList, answer_buy_house_aa, "", false) of
                        {true, NewPs, AnswerCostKey} ->
                            mod_house:answer_buy_house_aa(AnswerRoleId, AnswerCostKey, AnswerCostList);
                        {false, Code} ->
                            {ok, Bin} = pt_177:write(17710, [Code, Type]),
                            lib_server_send:send_to_uid(AnswerRoleId, Bin),
                            NewPs = Ps
                    end;
                {upgrade_house, AnswerCostList, Type} ->
                        case lib_consume_data:advance_cost_objects(Ps, AnswerCostList, upgrade_house_aa, "", false) of
                        {true, NewPs, AnswerCostKey} ->
                            mod_house:answer_upgrade_house_aa(AnswerRoleId, AnswerCostKey, AnswerCostList);
                        {false, Code} ->
                            {ok, Bin} = pt_177:write(17710, [Code, Type]),
                            lib_server_send:send_to_uid(AnswerRoleId, Bin),
                            NewPs = Ps
                    end;
                {choose_house, Code, Type} ->
                    {ok, Bin} = pt_177:write(17710, [Code, Type]),
                    lib_server_send:send_to_uid(AnswerRoleId, Bin),
                    NewPs = Ps
            end
    end,
    {ok, NewPs};

%% 确认查看回复
handle(17712, Ps, []) ->
    #player_status{
        id = RoleId
    } = Ps,
    mod_house:take_answer_info(RoleId);

%% 把家具放进家园场景里/移动家具
handle(17713, Ps, [LocId, GoodsTypeId, Type, X, Y, Face, MapId, InsId]) ->
    #player_status{
        id = RoleId,
        figure = Figure,
        scene = SceneId,
        copy_id = CopyId,
        house = HouseStatus
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17713, [?LEVEL_LIMIT, LocId, GoodsTypeId, Type, 0, X, Y, Face, MapId, InsId]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            #house_status{
                home_id = {BlockId, _HouseId}
            } = HouseStatus,
            case BlockId of
                0 ->
                    {ok, Bin} = pt_177:write(17713, [?ERRCODE(err177_house_none), LocId, GoodsTypeId, Type, 0, X, Y, Face, MapId, InsId]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    HouseSceneIdList = data_house:get_house_scene_list(),
                    case lists:member(SceneId, HouseSceneIdList) of
                        false ->
                            {ok, Bin} = pt_177:write(17713, [?ERRCODE(err177_house_not_in), LocId, GoodsTypeId, Type, 0, X, Y, Face, MapId, InsId]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        true ->
                            Args = [LocId, GoodsTypeId, Type, X, Y, Face, MapId, InsId, CopyId],
                            mod_house:put_furniture_inside(RoleId, Args)
                    end
            end
    end;

%% 场景里家具列表
handle(17714, Ps, [BlockId, HouseId]) ->
    #player_status{
        id = RoleId,
        scene = SceneId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17714, [?LEVEL_LIMIT, BlockId, HouseId, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            SceneIdList = data_house:get_house_scene_list(),
            case lists:member(SceneId, SceneIdList) of
                false ->
                    {ok, Bin} = pt_177:write(17714, [?ERRCODE(err177_house_not_in), BlockId, HouseId, []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    mod_house:get_inside_list(RoleId, BlockId, HouseId)
            end
    end;

%% 登录请求玩家收到的aa请求和aa结果
handle(17715, Ps, []) ->
    #player_status{
        id = RoleId
    } = Ps,
    mod_house:login_check(RoleId);

%% 打开结婚后选择房子界面
handle(17716, Ps, [BlockId1, HouseId1]) ->
    #player_status{
        id = RoleId,
        house = HouseStatus
    } = Ps,
    #house_status{
        home_id = {BlockId, HouseId},
        choose_house = {ChooseBlockId, _ChooseHouseId}
    } = HouseStatus,
    case {BlockId1, HouseId1} of
        {BlockId, HouseId} ->
            case ChooseBlockId of
                0 ->
                    {ok, Bin} = pt_177:write(17716, [?ERRCODE(err177_house_not_choose), []]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    mod_house:open_choose_house(RoleId, BlockId, HouseId)
            end;
        _ ->
            {ok, Bin} = pt_177:write(17716, [?ERRCODE(err177_house_not_own), []]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 结婚后选择房子
handle(17717, Ps, [BlockId1, HouseId1]) ->
    #player_status{
        id = RoleId,
        house = HouseStatus
    } = Ps,
    #house_status{
        home_id = {BlockId, HouseId},
        choose_house = {ChooseBlockId, ChooseHouseId}
    } = HouseStatus,
    case lists:member({BlockId1, HouseId1}, [{BlockId, HouseId}, {ChooseBlockId, ChooseHouseId}]) of
        true ->
            case ChooseBlockId of
                0 ->
                    {ok, Bin} = pt_177:write(17717, [?ERRCODE(err177_house_not_choose)]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                _ ->
                    mod_house:choose_house(RoleId, BlockId, HouseId, BlockId1, HouseId1)
            end;
        false ->
            {ok, Bin} = pt_177:write(17717, [?ERRCODE(err177_house_not_own)]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 修改留言
handle(17719, Ps, [BlockId1, HouseId1, Text]) ->
    #player_status{
        id = RoleId,
        house = HouseStatus
    } = Ps,
    #house_status{
        home_id = {BlockId, HouseId},
        choose_house = {ChooseBlockId, _ChooseHouseId}
    } = HouseStatus,
    case {BlockId1, HouseId1} of
        {BlockId, HouseId} ->
            case ChooseBlockId of
                0 ->
                    case util:check_length(Text, ?HouseTextLen) of
                        true ->
                            mod_house:change_text(RoleId, BlockId, HouseId, Text);
                        false ->
                            {ok, Bin} = pt_177:write(17719, [?ERRCODE(err177_house_text_too_long), BlockId1, HouseId1, Text]),
                            lib_server_send:send_to_uid(RoleId, Bin)
                    end;
                _ ->
                    {ok, Bin} = pt_177:write(17719, [?ERRCODE(err177_house_not_choose), BlockId1, HouseId1, Text]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end;
        _ ->
            {ok, Bin} = pt_177:write(17719, [?ERRCODE(err177_house_not_own), BlockId1, HouseId1, Text]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 查看家园里的家具列表
handle(17720, Ps, [BlockId1, HouseId1, ThemeId, FurnitureType]) ->
    #player_status{
        id = RoleId,
        house = HouseStatus
    } = Ps,
    #house_status{
        home_id = {BlockId, HouseId},
        choose_house = {ChooseBlockId, _ChooseHouseId}
    } = HouseStatus,
    case {BlockId1, HouseId1} of
        {BlockId, HouseId} ->
            case ChooseBlockId of
                0 ->
                    mod_house:get_house_furnitureList(RoleId, BlockId, HouseId, ThemeId, FurnitureType);
                _ ->
                    {ok, Bin} = pt_177:write(17720, [?ERRCODE(err177_house_not_choose), BlockId1, HouseId1, ThemeId, FurnitureType, []]),
                    lib_server_send:send_to_uid(RoleId, Bin)
            end;
        _ ->
            {ok, Bin} = pt_177:write(17720, [?ERRCODE(err177_house_not_own), BlockId1, HouseId1, ThemeId, FurnitureType, []]),
            lib_server_send:send_to_uid(RoleId, Bin)
    end;

%% 获得推荐房子列表
handle(17722, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17722, [?LEVEL_LIMIT, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_house:get_recommend_house_list(RoleId)
    end;

%% 打开家园送礼界面
handle(17723, Ps, []) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            Code = ?LEVEL_LIMIT,
            SendList = [];
        true ->
            Code = ?SUCCESS,
            GiftIdList = data_house:get_house_gift_id_list(),
            F = fun(GiftId, LimitGiftlist1) ->
                #house_gift_con{
                    daily_max = DailyMax,
                    counter_id = CounterId
                } = data_house:get_house_gift_con(GiftId),
                case DailyMax of
                    0 ->
                        LimitGiftlist1;
                    _ ->
                        [{?MOD_HOUSE, ?DEFAULT_SUB_MODULE, CounterId}|LimitGiftlist1]
                end
            end,
            LimitGiftlist = lists:foldl(F, [], GiftIdList),
            DailyNumList = mod_daily:get_count(RoleId, LimitGiftlist),
            F1 = fun(GiftId, SendList1) ->
                #house_gift_con{
                    counter_id = CounterId
                } = data_house:get_house_gift_con(GiftId),
                case lists:keyfind(CounterId, 3, DailyNumList) of
                    false ->
                        SendList1;
                    {_ModuleId, _SubModuleId, _CounterId, DailyNum} ->
                        [{GiftId, DailyNum}|SendList1]
                end
            end,
            SendList = lists:foldl(F1, [], GiftIdList)
    end,
    {ok, Bin} = pt_177:write(17723, [Code, SendList]),
    lib_server_send:send_to_uid(RoleId, Bin);

%% 进行家园送礼
handle(17724, Ps, [BlockId, HouseId, GiftId, WishWord]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            NewPs = Ps,
            {ok, Bin} = pt_177:write(17724, [?LEVEL_LIMIT, BlockId, HouseId, GiftId]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            case util:check_length(WishWord, ?GiftWishWordLen) of
                false ->
                    NewPs = Ps,
                    {ok, Bin} = pt_177:write(17724, [?ERRCODE(err177_house_wish_word_too_long), BlockId, HouseId, GiftId]),
                    lib_server_send:send_to_uid(RoleId, Bin);
                true ->
                    case data_house:get_house_gift_con(GiftId) of
                        [] ->
                            NewPs = Ps,
                            {ok, Bin} = pt_177:write(17724, [?MISSING_CONFIG, BlockId, HouseId, GiftId]),
                            lib_server_send:send_to_uid(RoleId, Bin);
                        #house_gift_con{goods_list = CostList, daily_max = DailyMax, counter_id = CounterId} ->
                            case DailyMax of
                                0 ->
                                    IfPass = 1;
                                _ ->
                                    DailyNum = mod_daily:get_count(RoleId, ?MOD_HOUSE, CounterId),
                                    LimitNum = mod_daily:get_limit_by_type(?MOD_HOUSE, CounterId),
                                    case DailyNum >= LimitNum of
                                        true ->
                                            IfPass = 0;
                                        false ->
                                            IfPass = 1
                                    end
                            end,
                            case IfPass of
                                0 ->
                                    NewPs = Ps,
                                    {ok, Bin} = pt_177:write(17724, [?ERRCODE(err177_house_gift_over_limit), BlockId, HouseId, GiftId]),
                                    lib_server_send:send_to_uid(RoleId, Bin);
                                _ ->
                                    case mod_house:check_send_gift(BlockId, HouseId) of
                                        {false, Code} ->
                                            NewPs = Ps,
                                            {ok, Bin} = pt_177:write(17724, [Code, BlockId, HouseId, GiftId]),
                                            lib_server_send:send_to_uid(RoleId, Bin);
                                        true ->
                                            case lib_consume_data:advance_cost_objects(Ps, CostList, house_send_gift, "", true) of
                                                {true, NewPs, CostKey} ->
                                                    Args = [RoleId, CostKey],
                                                    mod_house:send_gift(BlockId, HouseId, GiftId, WishWord, Args);
                                                {false, Code} ->
                                                    NewPs = Ps,
                                                    {ok, Bin} = pt_177:write(17724, [Code, BlockId, HouseId, GiftId]),
                                                    lib_server_send:send_to_uid(RoleId, Bin)
                                            end
                                    end
                            end
                    end
            end
    end,
    {ok, NewPs};

%% 家园收礼记录
handle(17726, Ps, [BlockId, HouseId]) ->
    #player_status{
        id = RoleId,
        figure = Figure
    } = Ps,
    #figure{
        lv = Lv
    } = Figure,
    OpenLv = lib_module:get_open_lv(?MOD_HOUSE, 1),
    case Lv >= OpenLv of
        false ->
            {ok, Bin} = pt_177:write(17726, [?LEVEL_LIMIT, 0, []]),
            lib_server_send:send_to_uid(RoleId, Bin);
        true ->
            mod_house:get_gift_log(RoleId, BlockId, HouseId)
    end;

handle(_Code, Ps, []) ->
    ?PRINT("ERR : ~p~n", [[?MODULE, _Code]]),
    {ok, Ps}.