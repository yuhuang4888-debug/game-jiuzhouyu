%-----------------------------------------------------------------------------
% @Module  :       pp_constellation_equip.erl
% @Author  :       
% @Email   :       
% @Created :       2019-11-5
% @Description:    星宿
%-----------------------------------------------------------------------------

-module(pp_constellation_equip).
-include ("common.hrl").
-include ("errcode.hrl").
-include ("server.hrl").
-include ("goods.hrl").
-include ("def_goods.hrl").
-include ("constellation_equip.hrl").
-include ("predefine.hrl").
-include ("def_module.hrl").
-include ("def_event.hrl").
-include ("figure.hrl").
-include ("def_fun.hrl").

-export ([handle/3, send_item/3, get_tips_msg/3]).

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = case data_constellation_equip:get_value(open_lv)  of
        Lv when is_integer(Lv) -> Lv;
        _ -> 0
    end,
    OpenDayLimit = case data_constellation_equip:get_value(open_day_limit) of
        Day when is_integer(Day) -> Day;
        _ -> 0
    end,
    OpenDay = util:get_open_day(),
    case OpenDay >= OpenDayLimit andalso Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> 
            if
                Cmd == 23250 orelse Cmd == 23255 ->
                    do_handle(Cmd, PlayerStatus, Data);
                true ->
                    skip
            end
    end.


% ########### 星宿概览 #############
do_handle(23201, PS, []) ->
    #player_status{constellation = ConstellationStatus, sid = Sid} = PS,
    #constellation_status{constellation_list = Items, attr_star = StarStaus} = ConstellationStatus,
    ItemsForSend = [lib_constellation_equip:item_data_for_send(Item) || Item <- Items],
    case StarStaus of
        #attr_star{star = Totalstar} -> skip;
        _ -> Totalstar = 0
    end,
    % ?MYLOG("xlh", "23201 ItemsForSend:~p~n", [ItemsForSend]),
    {ok, BinData} = pt_232:write(23201, [Totalstar, ItemsForSend]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 穿戴装备
do_handle(23202, PS, [GoodsAutoId, ConstellationId, IsReplace]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{constellation = ConstellationStatus, id = RoleId, sid = Sid, figure = #figure{name = Name}} = PS,
    #constellation_status{constellation_list = Items, attr_star = AttrStar} = ConstellationStatus,
    OldStar = AttrStar#attr_star.star,
    case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
        false ->
            send_error(Sid, ?FAIL);
        #constellation_item{pos_equip = EquipList, is_active = Active} = Item ->
            case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
                #goods{color = Color, location = Location, type = ?GOODS_TYPE_CONSTELLATION, subtype = Pos, cell = BagCell, other = Other} = GoodsInfoOld ->
                    ?PRINT("IsReplace:~p,Location:~p,EquipList:~p~n",[IsReplace,Location,EquipList]),
                    case lib_constellation_equip:check_equip(ConstellationId, GoodsInfoOld, Active, IsReplace, EquipList, GoodsStatus) of
                        true ->
                            {TakeoffGoods, NewEquipList1} = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
                            % NewEquipList = lists:keystore(Pos, 1, NewEquipList1, {Pos, GoodsAutoId, NewStren, NewExp}),
                            F = fun
                                () ->
                                    ok = lib_goods_dict:start_dict(),
                                    OldGoodsInfo1
                                    = case lists:keyfind(Pos, 1, EquipList) of
                                        {_, V} ->
                                            OGoodsInfo = lib_goods_util:get_goods(V, GoodsStatus#goods_status.dict),
                                            case OGoodsInfo of
                                                #goods{other = #goods_other{refine = OStar, addition = OAddtionAttr, stren = OStren}} ->skip;
                                                _ -> 
                                                    % {OAddtionAttr, OStar} = lib_constellation_equip:calc_default_addtion_and_refine(GoodsTypeId),
                                                    OAddtionAttr = [], OStar = 0,
                                                    OStren = 0
                                            end,
                                            OGoodsInfo;
                                        _ ->
                                            OStren = 0, OStar = 0, OAddtionAttr = [], []
                                    end,
                                    if
                                        TakeoffGoods =/= [] andalso TakeoffGoods =/= [OldGoodsInfo1] ->
                                            F2 = fun
                                                (GoodsInfo1, GoodsStatusAcc) ->
                                                    [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo1, ?GOODS_LOC_CONSTELLATION, 0, GoodsStatusAcc),
                                                    NewGoodsStatusAcc
                                            end,
                                            TakeoffEndGoods = lib_constellation_equip:takeoff_equips(TakeoffGoods),
                                            GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods);
                                        true ->
                                            GoodsStatusTmp = GoodsStatus
                                    end,
                                    if
                                        is_record(OldGoodsInfo1, goods) ->
                                            #goods{color = ColorO, other = OtherO} =  OldGoodsInfo1,
                                            HasStarAttrO = lib_constellation_equip:judge_has_star_attr(OtherO#goods_other.addition),
                                            HasStarAttr = lib_constellation_equip:judge_has_star_attr(Other#goods_other.addition),
                                            if
                                                IsReplace == 1 andalso ColorO < Color andalso HasStarAttrO == true andalso HasStarAttr == false ->
                                                    OldGoodsInfo = OldGoodsInfo1#goods{other = OtherO#goods_other{refine = 0, addition = [], stren = 0, optional_data = []}},
                                                    %% 扣除指定物品
                                                    {ok, GoodsStatus1} = lib_goods:delete_goods_list(GoodsStatusTmp, [{OldGoodsInfo, OldGoodsInfo1#goods.num}]),
                                                    GoodsInfo = GoodsInfoOld#goods{other = Other#goods_other{refine = OStar, addition = OAddtionAttr, stren = OStren}};
                                                true ->
                                                    OldGoodsInfo = OldGoodsInfo1#goods{other = OtherO#goods_other{optional_data = []}},
                                                    lib_constellation_equip:change_goods_other(OldGoodsInfo),
                                                    GoodsInfo = GoodsInfoOld,
                                                    [_OldGoodsInfo1, GoodsStatus1] = lib_goods:change_goods_cell(OldGoodsInfo, Location, BagCell, GoodsStatus)
                                            end;
                                        true ->
                                            GoodsInfo = GoodsInfoOld,
                                            GoodsStatus1 = GoodsStatusTmp
                                    end,
                                    DressGoodsInfo = lib_constellation_equip:dress_on_equips(GoodsInfo, ConstellationId),
                                    lib_constellation_equip:change_goods_other(DressGoodsInfo),
                                    [_GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(DressGoodsInfo, ?GOODS_LOC_CONSTELLATION_EQUIP, Pos, GoodsStatus1),
                                    #goods_status{dict = OldGoodsDict} = GoodsStatus2,
                                    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                    NewGoodsStatus = GoodsStatus2#goods_status{dict = GoodsDict},
                                    % ?PRINT("DressGoodsInfo:~p~n",[DressGoodsInfo]),
                                    {ok, GoodsL, NewGoodsStatus, GoodsInfo, TakeoffGoods}
                            end,
                            case lib_goods_util:transaction(F) of
                                {ok, GoodsL, NewGoodsStatus, GoodsInfo, TakeoffGoods} ->
                                    NewEquipList = lists:keystore(Pos, 1, NewEquipList1, {Pos, GoodsAutoId}),
                                    lib_goods_do:set_goods_status(NewGoodsStatus),
                                    % 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                    if
                                        TakeoffGoods =/= [] ->
                                            [lib_goods_api:notify_client_num(RoleId, [GoodsInfo1#goods{num=0}]) || GoodsInfo1 <- TakeoffGoods];
                                        true ->
                                            skip
                                    end,
                                    lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]),
                                    lib_goods_api:notify_client(RoleId, GoodsL),

                                    NewItem = Item#constellation_item{pos_equip = NewEquipList},
                                    {NewConstellationStatus, _RefreshItem} =
                                        lib_constellation_equip:update_status(PS, ConstellationStatus, NewItem, NewGoodsStatus#goods_status.dict, GoodsInfo),
                                    NewPS = PS#player_status{constellation = NewConstellationStatus},
                                    {ok, BinData} = pt_232:write(23202, [GoodsAutoId, GoodsInfo#goods.goods_id]), %%客户端的需求！！
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    NewPS2 = lib_player:count_player_attribute(NewPS),
                                    NewConstellation = lib_constellation_equip:calc_partial_power(NewConstellationStatus, NewPS2#player_status.original_attr),
                                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                    NewStar = NewConstellation#constellation_status.attr_star#attr_star.star,
                                    if
                                        NewStar =/= OldStar ->
                                            #attr_star{star_level = StarLevel, max_level = MaxLevel} = NewConstellation#constellation_status.attr_star,
                                            lib_log_api:log_constellation_star(RoleId, Name, 3, NewStar, StarLevel, StarLevel, MaxLevel),
                                            lib_constellation_equip:notify_client_star(NewConstellation#constellation_status.attr_star, RoleId);
                                        true ->
                                            skip
                                    end,
                                    send_item(Sid, NewConstellation, ConstellationId),
                                    %% 属性转移日志
                                    if
                                        IsReplace == 1 andalso TakeoffGoods =/= [] ->
                                            lib_constellation_forge:evolution_info(NewPS2, ConstellationId),
                                            [#goods{id = OldGoodsId, goods_id = OldGoodsTypeId}|_] = TakeoffGoods,
                                            lib_log_api:log_throw(constellation_attr, RoleId, OldGoodsId, OldGoodsTypeId, 1, 0, 0),
                                            {OldGTypeId, OldAddtion, GTypeId, Addition, NewAddtion} = calc_attr_log_args(TakeoffGoods, GoodsInfo, GoodsInfoOld),
                                            lib_log_api:log_constellation_attr_change(RoleId, Name, OldGTypeId, OldAddtion, GTypeId, Addition, NewAddtion);
                                        true ->
                                            skip
                                    end,
                                    
                                    {ok, battle_attr, NewPS2#player_status{constellation = NewConstellation}};
                                _Err ->
                                    % ?PRINT("_Err:~p~n",[_Err]),
                                    send_error(Sid, ?FAIL)
                            end;
                        {false, ErrCode} ->
                            send_error(Sid, ErrCode)
                    end;
                _Error ->
                    ?PRINT("GoodsAutoId:~p~n",[GoodsAutoId]),
                    send_error(Sid, ?FAIL)
            end
    end;

% ########### 脱装备 #############
do_handle(23203, PS, [ConstellationId, Pos]) ->
    #player_status{constellation = ConstellationStatus, id = RoleId, sid = Sid, figure = #figure{name = Name}} = PS,
    #constellation_status{constellation_list = Items, 
        attr_star = #attr_star{star_level = StarLevel, star = OldStar}
        } = ConstellationStatus,
    % ?MYLOG("XLH","ConstellationStatus:~p~n",[ConstellationStatus]),
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
        false ->
            % ?PRINT("ConstellationId:~p~n",[ConstellationId]),
            send_error(Sid, ?FAIL);
        #constellation_item{pos_equip = EquipList} = Item ->
            {TakeoffGoods, NewEquipList} = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
            % ?PRINT("TakeoffGoods:~p,EquipList:~p~n",[TakeoffGoods, EquipList]),
            if
                TakeoffGoods =:= [] ->
                    send_error(Sid, ?FAIL);
                true ->
                    [TakeOffGoodsInfo|_] = TakeoffGoods,
                    CellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_CONSTELLATION),
                    if
                        CellNum < length(TakeoffGoods) ->
                            send_error(Sid, ?ERRCODE(err150_constellation_no_cell));
                        true ->
                            F = fun
                                () ->
                                    ok = lib_goods_dict:start_dict(),
                                    F2 = fun
                                        (GoodsInfo, GoodsStatusAcc) ->
                                            [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_CONSTELLATION, 0, GoodsStatusAcc),
                                            NewGoodsStatusAcc
                                    end,
                                    TakeoffEndGoods = lib_constellation_equip:takeoff_equips(TakeoffGoods),
                                    GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods),
                                    #goods_status{dict = OldGoodsDict} = GoodsStatusTmp,
                                    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                    NewGoodsStatus = GoodsStatusTmp#goods_status{dict = GoodsDict},
                                    [lib_constellation_equip:change_goods_other(G) || G <- TakeoffEndGoods],
                                    {ok, GoodsL, NewGoodsStatus}
                            end,
                            case lib_goods_util:transaction(F) of
                                {ok, GoodsL, NewGoodsStatus} ->
                                    lib_goods_do:set_goods_status(NewGoodsStatus),
                                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                    [lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]) || GoodsInfo <- TakeoffGoods],
                                    lib_goods_api:notify_client(RoleId, GoodsL),
                                    NewItem = Item#constellation_item{pos_equip = NewEquipList},
                                    {NewConstellationStatus, _RefreshItem} = 
                                        lib_constellation_equip:update_status(PS, ConstellationStatus, NewItem, NewGoodsStatus#goods_status.dict, TakeoffGoods),
                                    NewPS = PS#player_status{constellation = NewConstellationStatus},
                                    {ok, BinData} = pt_232:write(23203, [TakeOffGoodsInfo#goods.id, TakeOffGoodsInfo#goods.goods_id]),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    NewPS2 = lib_player:count_player_attribute(NewPS),
                                    NewConstellation = lib_constellation_equip:calc_partial_power(NewConstellationStatus, NewPS2#player_status.original_attr),
                                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                    #constellation_status{attr_star = #attr_star{star_level = NewStarLevel, max_level = MaxLevel, star = StarNum} = AttrStar} = NewConstellation,
                                    OldStar =/= StarNum andalso lib_constellation_equip:notify_client_star(AttrStar, RoleId),
                                    OldStar =/= StarNum andalso lib_log_api:log_constellation_star(RoleId, Name, 4, StarNum, StarLevel, NewStarLevel, MaxLevel),
                                    send_item(Sid, NewConstellation, ConstellationId),
                                    {ok, battle_attr, NewPS2#player_status{constellation = NewConstellation}};
                                _Err ->
                                    % ?PRINT("_Err:~p~n",[_Err]),
                                    send_error(Sid, ?FAIL)
                            end %% lib_goods_util:transaction(F)
                    end %% if CellNum < length(TakeoffGoods)
            end %% case lists:keyfind(ConstellationId, ...)
    end;

%% 某个星宿总属性
do_handle(23204, PS, [ConstellationId]) ->
    #player_status{constellation = ConstellationStatus, sid = Sid} = PS,
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
        false ->
            send_error(Sid, ?FAIL);
        #constellation_item{all_attr = AllAttr} ->
            {ok, BinData} = pt_232:write(23204, [ConstellationId, AllAttr]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {ok, PS};

%% 星级大师界面
do_handle(23205, PS, []) ->
    #player_status{constellation = ConstellationStatus, sid = Sid} = PS,
    #constellation_status{attr_star = StarStaus} = ConstellationStatus,
    case StarStaus of
        #attr_star{power = Power, star_level = Level, star = Star, max_level = MaxLevel} ->
            ?PRINT("============= Level, MaxLevel, Star, Power:~p~n",[{Level, MaxLevel, Star, Power}]),
            {ok, BinData} = pt_232:write(23205, [Level, MaxLevel, Star, Power]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            send_error(Sid, ?FAIL)
    end,
    {ok, PS};

%% 星级大师升级
do_handle(23206, PS, [StarLevel]) ->
    #player_status{id = RoleId, constellation = ConstellationStatus, sid = Sid, figure = #figure{name = Name}} = PS,
    #constellation_status{attr_star = StarStaus, 
        decompose = #decompose_status{lv = Level, exp = Exp, star = Star, color = Color}
    } = ConstellationStatus,
    case StarStaus of
        #attr_star{max_level = MaxLevel, star_level = OldLevel} ->
            case check_star_up(StarStaus, StarLevel) of
                {false, Code} ->
                    {ok, BinData} = pt_232:write(23206, [Code, 0, 0]),
                    lib_server_send:send_to_sid(Sid, BinData);
                {true, _NewAttr} ->
                    NewMaxLevel = ?IF(MaxLevel >= StarLevel, MaxLevel, StarLevel),
                    NewStarStaus = StarStaus#attr_star{star_level = StarLevel, max_level = NewMaxLevel},
                    NewConstellationStatus = lib_constellation_equip:calc_constellation_status(RoleId, ConstellationStatus#constellation_status{attr_star = NewStarStaus}),
                    NewPS2 = lib_player:count_player_attribute(PS#player_status{constellation = NewConstellationStatus}),
                    NewConstellation = lib_constellation_equip:calc_partial_power(NewConstellationStatus, NewPS2#player_status.original_attr),
                    
                    lib_log_api:log_constellation_star(RoleId, Name, 1, NewStarStaus#attr_star.star, OldLevel, StarLevel, NewMaxLevel),

                    lib_constellation_equip:save_other_info(RoleId, Color, Star, Level, Exp, NewMaxLevel, StarLevel),
                    #constellation_status{attr_star = #attr_star{power = NewPower}} = NewConstellation,
                    {ok, BinData} = pt_232:write(23206, [?SUCCESS, StarLevel, NewPower]),
                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, NewPS2#player_status{constellation = NewConstellation}}
            end;
        _ ->
            send_error(Sid, ?FAIL)
    end;

%% 吞噬界面
do_handle(23207, PS, []) ->
    #player_status{constellation = ConstellationStatus, sid = Sid} = PS,
    #constellation_status{
        decompose = #decompose_status{power = Power, lv = Level, exp = Exp, star = Star, color = Color}
    } = ConstellationStatus,
    {ok, BinData} = pt_232:write(23207, [Level, Exp, Power, Color, Star]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, PS};

%% 吞噬界面更改勾选状态
do_handle(23208, PS, [NewColor, NewStar]) ->
    #player_status{id = RoleId, constellation = ConstellationStatus, sid = Sid} = PS,
    #constellation_status{attr_star = #attr_star{star_level = StarLevel, max_level = MaxLevel}, 
        decompose = #decompose_status{lv = Level, exp = Exp, star = _Star, color = _Color} = Decompose
    } = ConstellationStatus,
    ColorList = data_constellation_equip:get_value(decompose_color_status),
    StarList = data_constellation_equip:get_value(decompose_star_status),
    case lists:member(NewColor, ColorList) andalso lists:member(NewStar, StarList) of
        true ->
            NewConstellationStatus = ConstellationStatus#constellation_status{
                decompose = Decompose#decompose_status{star = NewStar, color = NewColor}},
            lib_constellation_equip:save_other_info(RoleId, NewColor, NewStar, Level, Exp, MaxLevel, StarLevel),
            {ok, BinData} = pt_232:write(23208, [NewColor, NewStar, ?SUCCESS]),
            lib_server_send:send_to_sid(Sid, BinData),
            {ok, PS#player_status{constellation = NewConstellationStatus}};
        _ ->
            send_error(Sid, ?FAIL)
    end;

% ########### 吞噬 #############
do_handle(23209, PS, [MaterialIdList]) ->
    #player_status{constellation = ConstellationStatus, id = RoleId, sid = Sid, figure = #figure{name = Name}} = PS,
    #constellation_status{attr_star = #attr_star{star_level = StarLevel, max_level = MaxLevel},
        decompose = #decompose_status{lv = Level, exp = Exp, star = Star, color = Color} = Decompose
    } = ConstellationStatus,
    #goods_status{dict = GoodsDict} = GoodsStatus = lib_goods_do:get_goods_status(),
    {MaterialList, LogMaterial} = lists:foldl(fun
        (Id, {Acc, LogAcc}) ->
            case lib_goods_util:get_goods(Id, GoodsDict) of
                #goods{goods_id = GoodsTypeId, location = ?GOODS_LOC_CONSTELLATION, type = ?GOODS_TYPE_CONSTELLATION} = Info ->
                    {[Info|Acc], [GoodsTypeId|LogAcc]};
                _ ->
                    {Acc, LogAcc}
            end
    end, {[], []}, ulists:removal_duplicate(MaterialIdList)),
    CheckCode = lib_constellation_equip:check_decompose(Level),
    if
        MaterialList =:= [] ->
            send_error(Sid, ?FAIL);
        CheckCode =/= true ->
            send_error(Sid, CheckCode);
        true ->
            {NewExp, NewLevel, CostMaterialList} = lib_constellation_equip:calc_decompose(Exp, Level, MaterialList, []),
            F = fun
                () ->
                    ok = lib_goods_dict:start_dict(),
                    DeleteList = [{Material, Material#goods.num} || Material <- CostMaterialList],
                    {ok, TmpGoodsStatus} = lib_goods:delete_goods_list(GoodsStatus, DeleteList),
                    {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(TmpGoodsStatus#goods_status.dict),
                    NewGoodsStatus = TmpGoodsStatus#goods_status{dict = Dict},
                    {ok, NewGoodsStatus, GoodsL}
            end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus, GoodsL} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    lib_goods_api:notify_client_num(RoleId, GoodsL),
                    
                    % 扣除指定物品日志
                    F1 = fun(TmpGoodsInfo) ->
                        #goods{id = GoodsId, goods_id = GoodsTypeId, num = TemNum} = TmpGoodsInfo,
                        lib_log_api:log_throw(constellation_decompose, RoleId, GoodsId, GoodsTypeId, TemNum, 0, 0)
                    end,
                    lists:foreach(F1, CostMaterialList),
                    %%日志
                    lib_log_api:log_constellation_decompose(RoleId, Name, LogMaterial, Level, Exp, NewLevel, NewExp),

                    NewDecompose = Decompose#decompose_status{exp = NewExp, lv = NewLevel},
                    NewConstellationStatus = lib_constellation_equip:calc_constellation_status(RoleId, ConstellationStatus#constellation_status{decompose = NewDecompose}),
                    NewPS2 = lib_player:count_player_attribute(PS#player_status{constellation = NewConstellationStatus}),
                    NewConstellation = lib_constellation_equip:calc_partial_power(NewConstellationStatus, NewPS2#player_status.original_attr),
                    % ?PRINT("{NewLevel, NewExp, power}:~p~n",[{NewLevel, NewExp, NewConstellation#constellation_status.decompose#decompose_status.power}]),
                    {ok, BinData} = pt_232:write(23209, [NewLevel, NewExp, NewConstellation#constellation_status.decompose#decompose_status.power]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                    lib_constellation_equip:save_other_info(RoleId, Color, Star, NewLevel, NewExp, MaxLevel, StarLevel),
                    
                    % log_strength(RoleId, CostMaterialList, GoodsInfo, NewGoodsInfo, Exp),
                    {ok, NewPS2};
                _ ->
                    send_error(Sid, ?FAIL)
            end
    end;

%% tips
do_handle(23250, PS, [RoleId, GoodsAutoId]) ->
    #player_status{sid = SId, id = Id} = PS,
    if
        Id == RoleId ->
            get_tips_msg(PS, SId, GoodsAutoId);
        true ->
            lib_player:apply_cast(RoleId, ?APPLY_CAST_STATUS, ?HAND_OFFLINE, pp_constellation_equip, get_tips_msg, [SId, GoodsAutoId])
    end;
    

%% 合成
do_handle(23252, PS, [ComposeId, IrrMaterial, ReMaterial, RatioMaterial]) ->
    #player_status{constellation = ConstellationStatus, id = RoleId, figure = Figure, sid = Sid} = PS,
    RoleName = Figure#figure.name,
    #constellation_status{compose = ComposeStatusList} = ConstellationStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case check_compose(PS, ComposeId, IrrMaterial, ReMaterial, RatioMaterial, GoodsStatus, ComposeStatusList) of
        {true, RealReward, CostGoodsInfoList, Cost, #base_constellation_compose{tv_type = TvId}, CostList, LogArgs, EquipGoodsInfo, NewComposeStatusList} ->
            % ?PRINT("CostGoodsInfoList:~p~n",[CostGoodsInfoList]),
            %% 先扣除钱和通用的固定材料
            CostRes = case lib_goods_api:cost_object_list(PS, Cost, constellation_compose, "") of
                {true, TemNewPS} -> 
                    TemGoodsStatus = lib_goods_do:get_goods_status(),
                    %% 扣除指定物品
                    F = fun() ->
                        ok = lib_goods_dict:start_dict(),
                        {ok, TemGoodsStatus1} = lib_goods:delete_goods_list(TemGoodsStatus, CostGoodsInfoList),
                        {Dict, GoodsL1} = lib_goods_dict:handle_dict_and_notify(TemGoodsStatus1#goods_status.dict),
                        TemGoodsStatus2 = TemGoodsStatus1#goods_status{dict = Dict},
                        {ok, TemGoodsStatus2, GoodsL1}
                    end,
                    case lib_goods_util:transaction(F) of
                        {ok, TemGoodsStatus2, GoodsL1} ->
                            {ok, TemGoodsStatus2, GoodsL1, TemNewPS#player_status{constellation = 
                                ConstellationStatus#constellation_status{compose = NewComposeStatusList}}};
                        _ ->
                            {false, TemGoodsStatus, TemNewPS}
                    end;
                {false, Code, TemNewPS} ->
                    {false, Code, GoodsStatus, TemNewPS}
            end,
            
            case CostRes of
                {ok, NewGoodsStatus1, GoodsL, NewPS} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus1),
                    lib_constellation_equip:save_compose(RoleId, NewComposeStatusList),
                    Res = if
                            RealReward =/= [] -> 
                                lib_goods_api:give_goods_by_list(NewPS, RealReward, goods_compose, 0);
                            true ->
                                0
                          end,
                    case Res of
                        {1, [#goods{subtype = Pos, other = Other} = NewTargetGoodsInfo|_] = GiveGoodsInfoList, _} ->
                            LastCode = ?ERRCODE(err150_compose_success),
                            Fun = fun(#goods{id = Id, goods_id = TemGoodsTypeId}, Acc) ->
                                [{Id, TemGoodsTypeId}|Acc]
                            end,
                            SendList = lists:foldl(Fun, [], GiveGoodsInfoList),
                            {ok, BinData} = pt_232:write(23252, [LastCode, ComposeId, SendList]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            if
                                TvId > 0 ->
                                    [#goods{id = Id, goods_id = TemGoodsTypeId}|_] = GiveGoodsInfoList,
                                    lib_chat:send_TV({all}, ?MOD_CONSTELLATION, TvId, [RoleName, RoleId, TemGoodsTypeId, Id, RoleId]);
                                true ->
                                    skip
                            end,

                            case EquipGoodsInfo of
                                #goods{other = #goods_other{refine = Star, stren = Stren, optional_data = OptonData}} -> %% 处理穿在身上的合成
                                    NewTargetGoodsInfo1 = NewTargetGoodsInfo#goods{other = Other#goods_other{refine = Star, stren = Stren, optional_data = OptonData}},
                                    GoodsStatusNew = lib_goods_do:get_goods_status(),
                                    [_GoodsInfo2, GoodsStatus2] = lib_goods:change_goods_cell(NewTargetGoodsInfo1, ?GOODS_LOC_CONSTELLATION_EQUIP, Pos, GoodsStatusNew),
                                    NewPS2 = lib_constellation_equip:update_status_after_compose(NewPS, _GoodsInfo2, GoodsStatus2),
                                    #goods_status{dict = OldGoodsDict} = GoodsStatus2,
                                    {GoodsDict, NewGoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                    NewGoodsStatus2 = GoodsStatus2#goods_status{dict = GoodsDict},
                                    lib_goods_do:set_goods_status(NewGoodsStatus2),
                                    lib_goods_api:notify_client_num(RoleId, GoodsL++NewGoodsL), %% 更新数量

                                    lib_goods_api:notify_client_num(RoleId, [NewTargetGoodsInfo#goods{num=0}]), %% 删除获得物品
         
                                    lib_goods_api:notify_client(NewPS2, [_GoodsInfo2]),     %% 更新穿在身上物品
                                    lib_goods_api:update_client_goods_info([_GoodsInfo2]);
                                _ -> 
                                    NewPS2 = NewPS,
                                    lib_goods_api:notify_client_num(RoleId, GoodsL)
                            end,
                            % 扣除指定物品日志
                            F1 = fun({TmpGoodsInfo, TemNum}) ->
                                #goods{id = GoodsId, goods_id = GoodsTypeId} = TmpGoodsInfo,
                                lib_log_api:log_throw(goods_compose, RoleId, GoodsId, GoodsTypeId, TemNum, 0, 0)
                            end,
                            lists:foreach(F1, CostGoodsInfoList),
                            {RegularLogList, IrregularLogList, RatioLoglist, SucessRatio} = LogArgs,
                            lib_log_api:log_constellation_compose(RoleId, RoleName, ComposeId, RegularLogList, IrregularLogList, RatioLoglist, Cost, SucessRatio, RealReward),
                            {ok, NewPS2};
                            
                            
                        _Error ->  
                            if
                                RealReward =/= [] ->
                                    Title = utext:get(2320001),Content = utext:get(2320002),
                                    lib_mail_api:send_sys_mail([RoleId], Title, Content, CostList);
                                true ->
                                    skip
                            end,
                            LastCode = ?ERRCODE(err150_compose_fail),
                            {ok, BinData} = pt_232:write(23252, [LastCode, ComposeId, []]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            lib_goods_do:set_goods_status(NewGoodsStatus1),
                            lib_goods_api:notify_client_num(RoleId, GoodsL),
                            {ok, NewPS}
                            % ComposeGoodsId = 0
                    end;
                {false, NewGoodsStatus, NewPS} ->
                    Title = utext:get(1500013),Content = utext:get(1500014),
                    lib_mail_api:send_sys_mail([RoleId], Title, Content, Cost),
                    LastCode = ?ERRCODE(err150_compose_fail),
                    {ok, BinData} = pt_232:write(23252, [LastCode, ComposeId, []]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    {ok, NewPS};
                {false, LastCode, NewGoodsStatus, NewPS} ->
                    {ok, BinData} = pt_232:write(23252, [LastCode, ComposeId, []]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    {ok, NewPS};
                _E ->
                    ?ERR("compose_goods err:~p", [_E]),
                    {ok, BinData} = pt_232:write(23252, [?FAIL, ComposeId, []]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end;
        {false, Code} ->
            {ok, BinData} = pt_232:write(23252, [Code, ComposeId, []]),
            lib_server_send:send_to_sid(Sid, BinData)
    end;
    
%% 解锁星宿
do_handle(23253, PS, [ConstellationId]) ->
    #player_status{id = RoleId, constellation = ConstellationStatus, sid = Sid} = PS,
    GoodsStatus = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GoodsStatus,
    case lib_constellation_equip:check_active(ConstellationStatus, ConstellationId, GoodsDict) of
        true ->
            #constellation_status{constellation_list = Items} = ConstellationStatus,
            case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
                #constellation_item{is_active = ?UNACTIVE} = Item ->
                    NewItem = Item#constellation_item{is_active = ?ACTIVE},
                    lib_constellation_equip:save_info(RoleId, ConstellationId, ?ACTIVE),
                    NewItems = lists:keystore(ConstellationId, #constellation_item.id, Items, NewItem),
                    NewConstellationStatus = ConstellationStatus#constellation_status{constellation_list = NewItems},
                    {ok, BinData} = pt_232:write(23253, [ConstellationId, ?SUCCESS]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, PS#player_status{constellation = NewConstellationStatus}};
                #constellation_item{is_active = ?ACTIVE} ->
                    send_error(Sid, ?ERRCODE(err232_has_active));
                _ ->
                    send_error(Sid, ?ERRCODE(err232_equip_condition_error))
            end;
        {false, Code} ->
            send_error(Sid, Code)
    end;

do_handle(23254, PS, [GoodsAutoId, TargetGoodsAutoId]) ->
    #player_status{constellation = ConstellationStatus, sid = Sid, figure = #figure{lv = RoleLv}} = PS,
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict),
    TargetGoodsInfo = lib_goods_util:get_goods(TargetGoodsAutoId, GoodsStatus#goods_status.dict),
    case lib_constellation_equip:check_before_show_tips(GoodsInfo, TargetGoodsInfo, GoodsStatus) of
        {false, Code} ->
            send_error(Sid, Code);
        {true, BaseEquipCfg, GoodsTypeInfo} ->
            #goods{subtype = Pos, other = #goods_other{rating = Rating, addition = Addition}} = GoodsInfo,
            #base_constellation_equip{page = ConstellationId, extra_list = ExtraList, is_suit = IsSuit, extra_base_attr = ExtraAttr} = BaseEquipCfg,
            case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
                false ->
                    send_error(Sid, ?FAIL);
                #constellation_item{pos_equip = _EquipList, dsgt_suit = DsgtSuit, suit = Suit} = _Item -> 
                    DynamicAttr = lib_constellation_equip:count_addtion_attr(RoleLv, Addition),

                    Fun1 = fun
                        ({AttrId, AttrVal, Color, AttrType}, Acc) ->
                            [{AttrId, AttrVal, 0, 0, Color, AttrType}|Acc];
                        ({AttrId, AttrVal, Level, PerAdd, Color, AttrType}, Acc) ->
                            [{AttrId, AttrVal, Level, PerAdd, Color, AttrType}|Acc];
                        (_, Acc) -> Acc
                    end,
                    SendAddtion = lists:foldl(Fun1, [], Addition),

                    #ets_goods_type{base_attrlist = BaseAttr} = GoodsTypeInfo,


                    case data_constellation_equip:get_equip_type(Pos) of
                        SuitType when SuitType > 0 andalso IsSuit > 0 -> 
                            SuitNum = lib_constellation_equip:find_value(SuitType, 1, 0, Suit),
                            {SuitAttr, _} = lib_constellation_equip:calc_suit_effect(ConstellationId, [{SuitType, SuitNum}]);
                        _ ->
                            SuitNum = 0, SuitAttr = []
                    end,
                    Fun = fun({AttrList, DsgtId}, {Acc, Acc1}) ->
                        TemNum = lib_constellation_equip:find_value(DsgtId, 1, 0, DsgtSuit),
                        {DsgtSuitAttr, _} = lib_constellation_equip:calc_dsgt_suit_effect([{DsgtId, TemNum}]),
                        {[{DsgtId, TemNum, DsgtSuitAttr, AttrList}|Acc], [AttrList|Acc1]}
                    end,
                    {SendDsgt, DsgtAttr} = lists:foldl(Fun, {[], []}, ExtraList),
                    {StrenAttr, EvoluAttr, MasterAttr, SpiritAttr} = lib_constellation_forge_api:get_forge_attr_detail(_Item, Pos),

                    ScoreAttr = lib_player_attr:add_attr(list, [ExtraAttr, DynamicAttr, DsgtAttr, StrenAttr, EvoluAttr, MasterAttr, SpiritAttr]),
                    Score = lib_eudemons:cal_equip_rating(GoodsTypeInfo, ScoreAttr),
                    {ok, BinData} = pt_232:write(23254, [GoodsAutoId, TargetGoodsAutoId, Score, SendDsgt, SendAddtion, DynamicAttr, SuitNum, SuitAttr, 
                            BaseAttr, ExtraAttr, StrenAttr, EvoluAttr, MasterAttr, SpiritAttr, Rating]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end;

%% tips
do_handle(23255, PS, [GoodsTypeId]) ->
    #player_status{sid = Sid, figure = #figure{lv = RoleLv}} = PS,
     case data_goods_type:get(GoodsTypeId) of
        #ets_goods_type{base_attrlist = BaseAttr} = GoodsTypeInfo -> 
            case data_constellation_equip:get_equip_info(GoodsTypeId) of
                #base_constellation_equip{extra_list = ExtraList, extra_base_attr = ExtraBaseAttr, extra_attr = Addition} ->
                    DynamicAttr = lib_constellation_equip:count_addtion_attr(RoleLv, Addition),
                    Fun1 = fun
                        ({AttrId, AttrVal, Color, AttrType}, Acc) ->
                            [{AttrId, AttrVal, 0, 0, Color, AttrType}|Acc];
                        ({AttrId, AttrVal, Level, PerAdd, Color, AttrType}, Acc) ->
                            [{AttrId, AttrVal, Level, PerAdd, Color, AttrType}|Acc];
                        (_, Acc) -> Acc
                    end,
                    SendAddtion = lists:foldl(Fun1, [], Addition),
                    SuitNum = 0, 
                    Fun = fun({AttrList, DsgtId}, {Acc, Acc1}) ->
                        {DsgtSuitAttr, _} = lib_constellation_equip:calc_dsgt_suit_effect([{DsgtId, 1}]),
                        {[{DsgtId, 1, DsgtSuitAttr, AttrList}|Acc], [AttrList|Acc1]}
                    end,
                    {SendDsgt, DsgtAttr} = lists:foldl(Fun, {[], []}, ExtraList),

                    ScoreAttr = lib_player_attr:add_attr(list, [ExtraBaseAttr, DynamicAttr, DsgtAttr]),
                    Score = lib_eudemons:cal_equip_rating(GoodsTypeInfo, ScoreAttr),
                    BaseRating = lib_eudemons:cal_equip_rating(GoodsTypeInfo, ExtraBaseAttr),
                    {ok, BinData} = pt_232:write(23255, [GoodsTypeId, Score, SendDsgt, SendAddtion, DynamicAttr, SuitNum, 
                            BaseAttr, ExtraBaseAttr, BaseRating]),
                    lib_server_send:send_to_sid(Sid, BinData);
                _ ->
                    send_error(Sid, ?ERRCODE(missing_config))
            end;
        _ -> 
            send_error(Sid, ?ERRCODE(missing_config))
    end;
    
do_handle(23256, PS, [ComposeId]) ->
    #player_status{constellation = ConstellationStatus, sid = Sid} = PS,
    #constellation_status{compose = ComposeStatusList} = ConstellationStatus,
    case data_constellation_equip:get_compose_info(ComposeId) of
        #base_constellation_compose{goods = ComposeGoods} ->
            case lists:keyfind(special, 1, ComposeGoods) of
                {_, Index, _} when is_integer(Index) -> 
                    Times = lib_constellation_equip:find_value(ComposeId, 1, 0, ComposeStatusList),
                    Num = Times rem Index;
                _ ->
                    Index = 0, Num = 0, Times = 0
            end;
        _ ->
            Index = 0, Num = 0, Times = 0
    end,
    ?PRINT("ComposeId, Times, Index, Num:~p~n",[{ComposeId, Times, Index, Index-Num}]),
    {ok, BinData} = pt_232:write(23256, [ComposeId, Times, Index, Num]),
    lib_server_send:send_to_sid(Sid, BinData),
    {ok, PS};

do_handle(23257, PS, [CostGoodsAutoId, TargetGoodsAutoId]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{constellation = ConstellationStatus, id = RoleId, sid = Sid, figure = #figure{name = Name}} = PS,
    #constellation_status{constellation_list = Items, attr_star = AttrStar} = ConstellationStatus,
    OldStar = AttrStar#attr_star.star,
    case lib_constellation_equip:check_translate(CostGoodsAutoId, TargetGoodsAutoId, GoodsStatus) of
        {true, CostGoodsInfo, #goods{other = Other} = TargetGoodsInfo, ConstellationId} ->
            F = fun
                () ->
                    ok = lib_goods_dict:start_dict(),
                    #goods{other = #goods_other{refine = OStar, addition = OAddtionAttr, stren = OStren}} = CostGoodsInfo,
                    %% 扣除指定物品
                    {ok, GoodsStatus1} = lib_goods:delete_goods_list(GoodsStatus, [{CostGoodsInfo, CostGoodsInfo#goods.num}]),
                    GoodsInfo = TargetGoodsInfo#goods{other = Other#goods_other{refine = OStar, addition = OAddtionAttr, stren = OStren}},
                    lib_constellation_equip:change_goods_other(GoodsInfo),
                    OldGoodsDict = lib_goods_dict:add_dict_goods(GoodsInfo, GoodsStatus1#goods_status.dict),
                    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                    NewGoodsStatus = GoodsStatus1#goods_status{dict = GoodsDict},
                    % ?PRINT("DressGoodsInfo:~p~n",[DressGoodsInfo]),
                    {ok, GoodsL, NewGoodsStatus, GoodsInfo}
            end,
            case lib_goods_util:transaction(F) of
                {ok, GoodsL, NewGoodsStatus, GoodsInfo} ->
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    % 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                    lib_goods_api:notify_client_num(RoleId, [CostGoodsInfo#goods{num=0}]),
                    lib_goods_api:notify_client(RoleId, GoodsL),
                    lib_goods_api:notify_client(RoleId, [GoodsInfo]),
                    %% 属性转移日志
                    #goods{id = OldGoodsId, goods_id = OldGoodsTypeId} = CostGoodsInfo,
                    lib_log_api:log_throw(constellation_attr, RoleId, OldGoodsId, OldGoodsTypeId, 1, 0, 0),
                    {OldGTypeId, OldAddtion, GTypeId, Addition, NewAddtion} = calc_attr_log_args([CostGoodsInfo], GoodsInfo, TargetGoodsInfo),
                    lib_log_api:log_constellation_attr_change(RoleId, Name, OldGTypeId, OldAddtion, GTypeId, Addition, NewAddtion),
                    
                    {ok, BinData} = pt_232:write(23257, [?SUCCESS]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
                        #constellation_item{} = Item ->
                            {NewConstellationStatus, _RefreshItem} =
                                lib_constellation_equip:update_status(PS, ConstellationStatus, Item, NewGoodsStatus#goods_status.dict, GoodsInfo),
                            NewPS = PS#player_status{constellation = NewConstellationStatus},
                            NewPS2 = lib_player:count_player_attribute(NewPS),
                            NewConstellation = lib_constellation_equip:calc_partial_power(NewConstellationStatus, NewPS2#player_status.original_attr),
                            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                            NewStar = NewConstellation#constellation_status.attr_star#attr_star.star,
                            if
                                NewStar =/= OldStar ->
                                    #attr_star{star_level = StarLevel, max_level = MaxLevel} = NewConstellation#constellation_status.attr_star,
                                    lib_log_api:log_constellation_star(RoleId, Name, 3, NewStar, StarLevel, StarLevel, MaxLevel),
                                    lib_constellation_equip:notify_client_star(NewConstellation#constellation_status.attr_star, RoleId);
                                true ->
                                    skip
                            end,
                            lib_constellation_forge:evolution_info(NewPS2, ConstellationId),
                            send_item(Sid, NewConstellation, ConstellationId),
                            {ok, battle_attr, NewPS2#player_status{constellation = NewConstellation}};
                        _ ->
                            {ok, PS}
                    end;
                _Err ->
                    send_error(Sid, ?FAIL)
            end;
        {false, Code} ->
            send_error(Sid, Code)
    end;

do_handle(CMD, PS, Args) ->
    %% 跑去锻造协议
    pp_constellation_forge:handle(CMD, PS, Args).

send_error(Sid, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_232:write(23200, [CodeInt, CodeArgs]),
    % ?PRINT("23200 >>> ~p~n", [Code]),
    lib_server_send:send_to_sid(Sid, BinData).

send_item(Sid, ConstellationStatus, ConstellationId) ->
    #constellation_status{constellation_list = Items, attr_star = StarStaus} = ConstellationStatus,
    case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
        false ->
            ItemsForSend = [];
        #constellation_item{} = Item ->
            ItemsForSend = [lib_constellation_equip:item_data_for_send(Item)]
    end,
    case StarStaus of
        #attr_star{star = Totalstar} -> skip;
        _ -> Totalstar = 0
    end,
    % ?PRINT("ItemsForSend:~p~n",[ItemsForSend]),
    {ok, BinData} = pt_232:write(23201, [Totalstar, ItemsForSend]),
    lib_server_send:send_to_sid(Sid, BinData).

calc_takeoff_equips(Pos, EquipList, GoodsDict) ->
    F = fun
        ({Position, GoodsAutoId} = X, {TakeoffGoods, NewEquipList}) ->
        ?PRINT("Pos:~p,X:~p~n",[Pos, X]),
            if
                Position =:= Pos orelse Pos =:= 0 ->
                    case lib_goods_util:get_goods(GoodsAutoId, GoodsDict) of
                        GoodsInfo when is_record(GoodsInfo, goods) ->
                            {[GoodsInfo|TakeoffGoods], NewEquipList};
                        _ ->
                            {TakeoffGoods, NewEquipList}
                    end;
                true ->
                    {TakeoffGoods, [X|NewEquipList]}
            end
    end,
    {TakeoffGoods, NewEquipList} = lists:foldl(F, {[], []}, EquipList),
    {TakeoffGoods, lists:reverse(NewEquipList)}.

check_star_up(StarStaus, Uplevel) ->
    case StarStaus of
        #attr_star{star_level = Level, star = Star} ->
            if
                Level + 1 < Uplevel ->
                    {false, ?ERRCODE(err232_active_before_level)};
                Level >= Uplevel ->
                    {false, ?ERRCODE(err232_has_stren_up)};
                true ->
                    case data_constellation_equip:get_star_info(Uplevel)of
                        #base_equip_star{star = NeedStar, attr = Attr} when Star >= NeedStar -> 
                            {true, Attr};
                        #base_equip_star{} ->
                            {false, ?ERRCODE(err232_star_not_enougth)};
                        _ ->
                            {false, ?ERRCODE(missing_config)}
                    end
            end;
        _ ->
            {false, ?ERRCODE(err232_wrong_data)}
    end.


check_compose(Player, ComposeId, IrrMaterial, ReMaterial, RatioMaterial, GoodsStatus, ComposeStatusList) ->
    case data_constellation_equip:get_compose_info(ComposeId) of
        #base_constellation_compose{regular_mat = Regular, irregular_mat = Irregular, 
                ratio_type = RatioType, ratio = Ratio, fail_goods = FailReward, cost = Cost} = ComposeCfg ->
            case lib_goods_api:check_object_list(Player, Cost) of
                true ->
                    RegularRes = check_compose_regular_helper(ReMaterial, Regular, GoodsStatus, [], 0, [], []),
                    % ?PRINT("ComposeId:~p,Regular:~p,ReMaterial:~p,Irregular:~p,IrrMaterial:~p~n",[ComposeId,Regular,ReMaterial, Irregular,IrrMaterial]),
                    case RegularRes of
                        {true, CostRegularMaterial, Bind, RegularLogList, EquipGoodsInfo} ->
                            case check_compose_irregular_helper(IrrMaterial, ComposeId, Irregular, GoodsStatus, [], Bind, []) of
                                {true, CostIrregularMaterial, NewBind, IrregularLogList} ->
                                    case check_compose_ratio_helper(RatioMaterial, GoodsStatus, [], 0, []) of
                                        {true, CostRatioMaterial, AddPoint, RatioLoglist} ->
                                            if
                                                RatioType == ?COMPOSE_RATOP_TYPE_REGULAR ->
                                                    SucessRatio = Ratio*100;
                                                true ->
                                                    case Ratio of
                                                        [BaseRatio, NeedPoint] ->
                                                            SucessRatio = (BaseRatio + AddPoint/NeedPoint * max((100 - BaseRatio), 0))*100;
                                                        [{_, _}|_] ->
                                                            Fun = fun({_, Num}, AccNum) ->
                                                                AccNum + Num
                                                            end,
                                                            Sum = lists:foldl(Fun, 0, CostIrregularMaterial++CostRatioMaterial),
                                                            F1 = fun({Num1, _}) ->
                                                                Sum >= Num1
                                                            end,
                                                            case ulist:find(F1, lists:reverse(lists:keysort(1, Ratio))) of
                                                                {_, {_, SucessRatioCfg}} -> SucessRatio = SucessRatioCfg* 100;
                                                                _ -> SucessRatio = 0
                                                            end;
                                                        _ ->
                                                            SucessRatio = 0
                                                    end
                                                    
                                            end,
                                            RandRatio = urand:rand(1, 10000),
                                            ?PRINT("RandRatio:~p, SucessRatio:~p~n",[RandRatio, round(SucessRatio)]),
                                            CostMaterial = CostIrregularMaterial++CostRegularMaterial++CostRatioMaterial,
                                            ReturnCost = [{?IF(TemBind == ?BIND, ?TYPE_BIND_GOODS, ?TYPE_GOODS), GoodsTypeId, Num}
                                                ||{#goods{goods_id = GoodsTypeId, bind = TemBind}, Num} <- CostMaterial],
                                            LogArgs = {RegularLogList, IrregularLogList, RatioLoglist, round(SucessRatio) div 100},
                                            case RandRatio < SucessRatio of
                                                true ->
                                                    {Reward, NewComposeStatusList} = get_compose_reward(ComposeCfg, ComposeStatusList, NewBind),
                                                    {true, Reward, CostMaterial, Cost, ComposeCfg, ReturnCost++Cost, LogArgs, EquipGoodsInfo, NewComposeStatusList};
                                                _ ->
                                                    {true, FailReward, CostMaterial, Cost, ComposeCfg, ReturnCost++Cost, LogArgs, [], ComposeStatusList}
                                            end;
                                        Res ->
                                            Res
                                    end;
                                IrregularRes ->
                                    IrregularRes
                            end;
                        _ ->
                            RegularRes
                    end;
                _Err ->
                    _Err
            end;
        _ ->
            {false, ?ERRCODE(missing_config)}
    end.

%% 检查固定材料
check_compose_regular_helper(_, [], _GoodsStatus, GoodsInfoList, Bind, LogList, EquipGoodsInfo) -> {true, GoodsInfoList, Bind, LogList, EquipGoodsInfo};
check_compose_regular_helper([], _MaterialListCfg, _GoodsStatus, _GoodsInfoList, _Bind, _LogList, _EquipGoodsInfo) -> 
    {false, ?ERRCODE(err232_wrong_num)};
check_compose_regular_helper([H|T], MaterialListCfg, GoodsStatus, GoodsInfoList, Bind, LogList, EquipGoodsInfo) ->
    GoodsInfo = lib_goods_util:get_goods(H, GoodsStatus#goods_status.dict),
    if
        is_record(GoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {false, ?ERRCODE(err150_palyer_err)};
        true ->
            GtypeId = GoodsInfo#goods.goods_id,
            GtypeIdNum = GoodsInfo#goods.num,
            OptonData = GoodsInfo#goods.other#goods_other.optional_data,
            NewBind = max(GoodsInfo#goods.bind, Bind),
            NewIsSpecial = GoodsInfo#goods.type == ?GOODS_TYPE_CONSTELLATION andalso
            GoodsInfo#goods.location == ?GOODS_LOC_CONSTELLATION_EQUIP,
            if
                NewIsSpecial == true ->
                    case judge_constellation(OptonData) of
                        true ->
                            NewEquipGoodsInfo = GoodsInfo;
                        _Err ->
                            ?ERR("GoodsInfo:~p~n",[GoodsInfo]),
                            NewEquipGoodsInfo = EquipGoodsInfo
                    end;
                true ->
                    NewEquipGoodsInfo = EquipGoodsInfo
            end,
            case lists:keyfind(GtypeId, 2, MaterialListCfg) of
                {Type, _, NeedNum} -> 
                    OldNum = lib_constellation_equip:find_value(GtypeId, 1, 0, LogList),
                    if
                        NeedNum > GtypeIdNum ->
                            NewMaterialCfg = lists:keystore(GtypeId, 2, MaterialListCfg, {Type, GtypeId, NeedNum - GtypeIdNum}),
                            NewLogList = lists:keystore(GtypeId, 1, LogList, {GtypeId, OldNum+GtypeIdNum}),
                            check_compose_regular_helper(T, NewMaterialCfg, GoodsStatus, [{GoodsInfo, GtypeIdNum}|GoodsInfoList], NewBind, NewLogList, NewEquipGoodsInfo);
                        true ->
                            NewMaterialCfg = lists:keydelete(GtypeId, 2, MaterialListCfg),
                            NewLogList = lists:keystore(GtypeId, 1, LogList, {GtypeId, OldNum+NeedNum}),
                            check_compose_regular_helper(T, NewMaterialCfg, GoodsStatus, [{GoodsInfo, NeedNum}|GoodsInfoList], NewBind, NewLogList, NewEquipGoodsInfo)
                    end;
                    
                _ ->
                    {false, ?ERRCODE(err232_wrong_material)}
            end
    end.

judge_constellation(OptonData) ->
    case OptonData of
        [ConstellationId|_] ->
            case data_constellation_equip:get_page_info(ConstellationId) of
                #base_constellation_page{} -> true;
                _ ->
                    {false, ?ERRCODE(err232_wrong_material)}
            end;
        _ ->
            ?ERRCODE(err232_wrong_material)
    end.

get_compose_reward(ComposeCfg, ComposeStatusList, Bind) -> 
    #base_constellation_compose{id = Id, goods = ComposeGoods, bind_type = BindType} = ComposeCfg,
    Times = lib_constellation_equip:find_value(Id, 1, 0, ComposeStatusList),
    CalcReward = case lists:keyfind(special, 1, ComposeGoods) of
        {_, Index, List} -> 
            % NewComposeStatusList = lists:keystore(Id, 1, ComposeStatusList, {Id, Times+1}),
            Res = (Times+1) rem Index,
            NewComposeStatusList = if
                Res == 0 ->
                    lists:keystore(Id, 1, ComposeStatusList, {Id, 0});
                true ->
                    lists:keystore(Id, 1, ComposeStatusList, {Id, Times+1})
            end,
            % NewComposeStatusList = ?IF(Times rem Index == 0, ComposeStatusList, lists:keystore(Id, 1, ComposeStatusList, {Id, 0})),
            ?PRINT("Res:~p, Times:~p ~n",[Res, Times+1]),
            ?IF(Times =/= 0 andalso Res == 0, List, lib_constellation_equip:find_value(normal, 1, [], ComposeGoods));
        _ ->
            NewComposeStatusList =  ComposeStatusList,
            List = [],
            lib_constellation_equip:find_value(normal, 1, [], ComposeGoods)
    end,
    if
        BindType == ?COMPOSE_BIND ->
            NewBind = ?BIND;
        BindType == ?COMPOSE_UNBIND ->
            NewBind = ?UNBIND;
        true ->
            NewBind = Bind
    end,
    Fun = fun({Weight, _, GId, TemNum}, Acc) ->
        [{Weight, {GId, TemNum}}|Acc]
    end,
    RandWeight = lists:foldl(Fun, [], CalcReward),
    case urand:rand_with_weight(RandWeight) of
        {GtypeId, Num} -> 
            case lists:keyfind(GtypeId, 3, List) of
                {_, _, _, _} -> 
                    NComposeStatusList = lists:keystore(Id, 1, NewComposeStatusList, {Id, 0});
                _ -> NComposeStatusList = NewComposeStatusList
            end,
            {[{?IF(NewBind == ?BIND, ?TYPE_BIND_GOODS, ?TYPE_GOODS), GtypeId, Num}], NComposeStatusList};
        _ -> {[], NewComposeStatusList}
    end.

check_compose_irregular_helper([], _, [], _, [], Bind, LogList) -> {true, [], Bind, LogList};
check_compose_irregular_helper([], _, _, _, [], _Bind, _LogList) -> {false, ?ERRCODE(err232_material_not_enougth)};
check_compose_irregular_helper([], _, _, _, GoodsInfoList, Bind, LogList) -> {true, GoodsInfoList, Bind, LogList};
check_compose_irregular_helper([H|T], Id, Irregular, GoodsStatus, GoodsInfoList, Bind, LogList) ->
    GoodsInfo = lib_goods_util:get_goods(H, GoodsStatus#goods_status.dict),
    if
        is_record(GoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {false, ?ERRCODE(err150_palyer_err)};
        true ->
            GtypeId = GoodsInfo#goods.goods_id,
            NewBind = max(GoodsInfo#goods.bind, Bind),
            case lists:member(GtypeId, Irregular) of
                true -> 
                    OldNum = lib_constellation_equip:find_value(GtypeId, 1, 0, LogList),
                    NewLogList = lists:keystore(GtypeId, 1, LogList, {GtypeId, OldNum+GoodsInfo#goods.num}),
                    check_compose_irregular_helper(T, Id, Irregular, GoodsStatus, 
                            [{GoodsInfo, GoodsInfo#goods.num}|GoodsInfoList], NewBind, NewLogList);
                _ ->
                    {false, ?ERRCODE(err232_wrong_material)}
            end
    end.

check_compose_ratio_helper([], _, GoodsInfoList, AddPoint, LogList) -> {true, GoodsInfoList, AddPoint, LogList};
check_compose_ratio_helper([H|T], GoodsStatus, GoodsInfoList, AddPoint, LogList) ->
    GoodsInfo = lib_goods_util:get_goods(H, GoodsStatus#goods_status.dict),
    if
        is_record(GoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {false, ?ERRCODE(err150_palyer_err)};
        true ->
            GtypeId = GoodsInfo#goods.goods_id,
            case data_constellation_equip:get_equip_info(GtypeId) of
                #base_constellation_equip{compose_info = OneAddPoint} ->
                    % OneAddRatio = lib_constellation_equip:find_value(Id, 1, 0, ComposeAddRatioList),
                    OldNum = lib_constellation_equip:find_value(GtypeId, 1, 0, LogList),
                    NewLogList = lists:keystore(GtypeId, 1, LogList, {GtypeId, OldNum+GoodsInfo#goods.num}),
                    check_compose_ratio_helper(T, GoodsStatus, 
                            [{GoodsInfo, GoodsInfo#goods.num}|GoodsInfoList], AddPoint+OneAddPoint*GoodsInfo#goods.num, NewLogList);
                _ ->
                    {false, ?ERRCODE(err232_wrong_material)}
            end
    end.


calc_attr_log_args([TakeoffGoods|_], GoodsInfo, GoodsInfoOld) 
when is_record(TakeoffGoods, goods) andalso is_record(GoodsInfo, goods) andalso is_record(GoodsInfoOld, goods) ->
    #goods{goods_id = OldGTypeId, other = #goods_other{addition = OldAddtion}} = TakeoffGoods,
    #goods{goods_id = GTypeId, other = #goods_other{addition = NewAddtion}} = GoodsInfo,
    #goods{other = #goods_other{addition = Addtion}} = GoodsInfoOld,
    {OldGTypeId, OldAddtion, GTypeId, Addtion, NewAddtion};
calc_attr_log_args(_, _, _) -> {0,[],0,[],[]}.

get_tips_msg(PS, SId, GoodsAutoId) ->
    #player_status{constellation = ConstellationStatus, figure = #figure{lv = RoleLv}} = PS,
    #constellation_status{constellation_list = Items} = ConstellationStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict),
    case lib_constellation_equip:check_before_show_tips(GoodsInfo, GoodsStatus) of
        {false, Code} ->
            send_error(SId, Code);
        {true, BaseEquipCfg, GoodsTypeInfo} ->
            #goods{subtype = Pos, other = #goods_other{rating = Rating, addition = Addition}} = GoodsInfo,
            #base_constellation_equip{page = ConstellationId, extra_list = ExtraList, is_suit = IsSuit, extra_base_attr = ExtraAttr} = BaseEquipCfg,
            case lists:keyfind(ConstellationId, #constellation_item.id, Items) of
                false ->
                    send_error(SId, ?FAIL);
                #constellation_item{pos_equip = EquipList, dsgt_suit = DsgtSuit, suit = Suit} = _Item -> 
                    DynamicAttr = lib_constellation_equip:count_addtion_attr(RoleLv, Addition),

                    Fun1 = fun
                        ({AttrId, AttrVal, Color, AttrType}, Acc) ->
                            [{AttrId, AttrVal, 0, 0, Color, AttrType}|Acc];
                        ({AttrId, AttrVal, Level, PerAdd, Color, AttrType}, Acc) ->
                            [{AttrId, AttrVal, Level, PerAdd, Color, AttrType}|Acc];
                        (_, Acc) -> Acc
                    end,
                    SendAddtion = lists:foldl(Fun1, [], Addition),
                    #ets_goods_type{base_attrlist = BaseAttr} = GoodsTypeInfo,

                    case lists:keyfind(GoodsAutoId, 2, EquipList) of
                        {_, _} ->
                            case data_constellation_equip:get_equip_type(Pos) of
                                SuitType when SuitType > 0 andalso IsSuit > 0 -> 
                                    SuitNum = lib_constellation_equip:find_value(SuitType, 1, 0, Suit),
                                    {SuitAttr, _} = lib_constellation_equip:calc_suit_effect(ConstellationId, [{SuitType, SuitNum}]);
                                _ ->
                                    SuitNum = 0, SuitAttr = []
                            end,
                            Fun = fun({AttrList, DsgtId}, {Acc, Acc1}) ->
                                TemNum = lib_constellation_equip:find_value(DsgtId, 1, 0, DsgtSuit),
                                {DsgtSuitAttr, _} = lib_constellation_equip:calc_dsgt_suit_effect([{DsgtId, TemNum}]),
                                {[{DsgtId, TemNum, DsgtSuitAttr, AttrList}|Acc], [AttrList|Acc1]}
                            end,
                            {SendDsgt, DsgtAttr} = lists:foldl(Fun, {[], []}, ExtraList),
                            {StrenAttr, EvoluAttr, MasterAttr, SpiritAttr} = lib_constellation_forge_api:get_forge_attr_detail(_Item, Pos);
                        _ ->
                            Fun = fun({AttrList, DsgtId}, {Acc, Acc1}) ->
                                {[{DsgtId, 0, [], AttrList}|Acc], [AttrList|Acc1]}
                            end,
                            {SendDsgt, DsgtAttr} = lists:foldl(Fun, {[], []}, ExtraList),
                            SuitNum = 0, SuitAttr = [], StrenAttr = [], EvoluAttr = [], MasterAttr = [], SpiritAttr = []
                    end,
                    ScoreAttr = lib_player_attr:add_attr(list, [ExtraAttr, DynamicAttr, DsgtAttr, StrenAttr, EvoluAttr, MasterAttr, SpiritAttr]),
                    Score = lib_eudemons:cal_equip_rating(GoodsTypeInfo, ScoreAttr),
                    {ok, BinData} = pt_232:write(23250, [GoodsAutoId, Score, SendDsgt, SendAddtion, DynamicAttr, SuitNum, SuitAttr, 
                            BaseAttr, ExtraAttr, StrenAttr, EvoluAttr, MasterAttr, SpiritAttr, Rating]),
                    lib_server_send:send_to_sid(SId, BinData)
            end
    end.