%%-----------------------------------------------------------------------------
%% @Module  :       pp_draconic.erl
%% @Author  :       
%% @Email   :       
%% @Created :       2019-03-02
%% @Description:    圣印
%%-----------------------------------------------------------------------------

-module(pp_draconic).

-include("common.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("def_goods.hrl").
-include("draconic.hrl").
-include("def_module.hrl").
-include("predefine.hrl").
-include("figure.hrl").
-export ([handle/3]).

send_error(Sid, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_622:write(62200, [CodeInt, CodeArgs]),
    % ?PRINT("17300 >>> ~p~n", [Code]),
    lib_server_send:send_to_sid(Sid, BinData).

handle(Cmd, PlayerStatus, Data) ->
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = case data_draconic:get_draconic_value(3) of
        Lv when is_integer(Lv) -> Lv;
        _ -> 0
    end,
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.

do_handle(62201, PS, []) ->
    #player_status{sid = Sid, draconic_status = DraconicStatus} = PS,
    #draconic_status{equip_list = EquipList} = DraconicStatus,
    % ?PRINT("======== EquipList:~p~n",[EquipList]),
    {ok, BinData} = pt_622:write(62201, [EquipList]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 强化
do_handle(62202, PS, [Pos, StrenType]) ->
    #player_status{sid = Sid,id = RoleId, figure = #figure{name = RoleName}, draconic_status = DraconicStatus} = PS,
    #draconic_status{equip_list = EquipList} = DraconicStatus,
    OldDraconicbl = lib_goods_api:get_currency(PS, ?GOODS_ID_DRACONIC),
    #goods_status{dict = GoodsDict, draconic_stren_list = DraconicStrenList} = GoodsStatus = lib_goods_do:get_goods_status(),
    case lists:keyfind(Pos, 1, EquipList) of
        {Pos, GoodsAutoId, _Stren} -> 
            GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsDict),
            case lib_draconic:calc_stren(PS, GoodsInfo, StrenType) of
                {NewPs, NewGoodsInfo, NewStren} ->
                    F = fun
                        () ->
                            ok = lib_goods_dict:start_dict(),
                            % lib_draconic:change_goods_other(NewGoodsInfo),
                            {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(GoodsStatus#goods_status.dict),
                            Dict2 = lib_goods_dict:add_dict_goods(NewGoodsInfo, Dict),
                            NewDraconicStrenList = lists:keystore(Pos, 1, DraconicStrenList, {Pos, NewStren}),
                            db:execute(io_lib:format(?draconic_replace_other, [RoleId, Pos, NewStren])),
                            NewGoodsStatus = GoodsStatus#goods_status{dict = Dict2, draconic_stren_list = NewDraconicStrenList},
                            {ok, NewGoodsStatus, GoodsL}
                    end,
                    case lib_goods_util:transaction(F) of
                        {ok, NewGoodsStatus, GoodsL} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            lib_goods_api:notify_client_num(RoleId, GoodsL),
                            % ?PRINT("62202   NewStren:~p~n",[NewStren]),
                            {ok, BinData} = pt_622:write(62202, [Pos, NewStren]),
                            % lib_achievement_api:async_event(RoleId, lib_achievement_api, draconic_stren_event, NewGoodsStatus#goods_status.draconic_stren_list),
                            lib_server_send:send_to_sid(Sid, BinData),
                            NewDraconicbl = lib_goods_api:get_currency(NewPs, ?GOODS_ID_DRACONIC),
                            log_strength(RoleId, RoleName, GoodsInfo, NewGoodsInfo, OldDraconicbl - NewDraconicbl),
                            NewPS2 = lib_player:count_player_attribute(NewPs),
                            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                            {ok, battle_attr, NewPS2};
                        _E ->
                            % ?PRINT("62202   _E:~p~n",[_E]),
                            send_error(Sid, ?FAIL)
                    end;
                {_NewPs, Code} ->
                    send_error(Sid, Code)
            end;
        _ ->
            send_error(Sid, ?FAIL)
    end;

%% 穿装备
do_handle(62203, PS, [_Pos, GoodsAutoId]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{draconic_status = DraconicStatus, id = RoleId, sid = Sid} = PS,
    #draconic_status{equip_list = EquipList} = DraconicStatus,
    case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
        #goods{location = Location, type = ?GOODS_TYPE_DRACONIC, subtype = Pos, cell = _BagCell} = GoodsInfo 
        when Location == ?GOODS_LOC_DRACONIC ->  
            % OldGoodsInfo =
            case lists:keyfind(Pos, 1, EquipList) of
                {_, _V, OlStren} -> skip;
                    % lib_goods_util:get_goods(V, GoodsStatus#goods_status.dict);
                _ ->
                    DraconicLeveList = lib_goods_util:get_draconic_level_list(RoleId, []),
                    case lists:keyfind(Pos, 1, DraconicLeveList) of
                        {_, OlStren} -> skip;
                            % lib_goods_util:get_goods(V, GoodsStatus#goods_status.dict);
                        _ ->
                            OlStren = 0
                    end
                    % []
            end,
            TakeoffGoods = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
            F = fun
                () ->
                    ok = lib_goods_dict:start_dict(),
                    %% 脱下原来的装备
                    if
                        TakeoffGoods =/= [] ->
                            F2 = fun
                                (GoodsInfo1, GoodsStatusAcc) ->
                                    [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo1, ?GOODS_LOC_DRACONIC, 0, GoodsStatusAcc),
                                    NewGoodsStatusAcc
                            end,
                            TakeoffEndGoods = lib_draconic:takeoff_equips(TakeoffGoods),
                            GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods);
                        true ->
                            GoodsStatusTmp = GoodsStatus
                    end,
                    DressGoodsInfo = lib_draconic:dress_on_equips(OlStren, GoodsInfo),
                    [_GoodsInfo2, GoodsStatus2] = lib_goods:change_goods_cell(DressGoodsInfo, ?GOODS_LOC_DRACONIC_EQUIP, Pos, GoodsStatusTmp),
                    #goods_status{dict = OldGoodsDict} = GoodsStatus2,
                    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                    NewGoodsStatus = GoodsStatus2#goods_status{dict = GoodsDict},
                    {ok, GoodsL, NewGoodsStatus}
            end,
            case lib_goods_util:transaction(F) of
                {ok, GoodsL, NewGoodsStatus} ->
                    Fun = fun(#goods{id = GoodsId} = Goods, Acc) ->
                        case lists:keyfind(GoodsId, #goods.id, Acc) of
                            #goods{} ->
                                Acc;
                            _E ->
                                [Goods|Acc]
                        end
                    end,
                    NewGoodsL = lists:foldl(Fun, [], GoodsL),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                    if
                        TakeoffGoods =/= [] ->
                            [lib_goods_api:notify_client_num(RoleId, [GoodsInfo1#goods{num=0}]) || GoodsInfo1 <- TakeoffGoods];
                        true ->
                            skip
                    end,
                    lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]),
                    lib_goods_api:notify_client(RoleId, NewGoodsL),
                    NewPS = lib_draconic:updata_draconic_status(PS, [{chang_equip, {NewGoodsStatus}}]),
                    {ok, BinData} = pt_622:write(62203, []), %%客户端的需求！！
                    lib_server_send:send_to_sid(Sid, BinData),
                    NewPS2 = lib_player:count_player_attribute(NewPS),
                    % Num = erlang:length(NewPS2#player_status.draconic_status#draconic_status.equip_list),
                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                    handle(62201, NewPS2, []),
                    {ok, battle_attr, NewPS2};
                _Err ->
                    % ?PRINT("UP  _Err:~p~n",[_Err]),
                    send_error(Sid, ?FAIL)
            end;
        #goods{location = ?GOODS_LOC_DRACONIC_EQUIP, type = ?GOODS_TYPE_DRACONIC} ->
            send_error(Sid, ?ERRCODE(err654_has_equiped));
        _ ->
            send_error(Sid, ?FAIL)
    end;

% ########### 脱装备 #############
do_handle(62204, PS, [Pos]) ->
    #player_status{draconic_status = DraconicStatus, id = RoleId, sid = Sid} = PS,
    #draconic_status{equip_list = EquipList} = DraconicStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lists:keyfind(Pos, 1, EquipList) of
        false ->
            send_error(Sid, ?FAIL);
        {_, _, _Stren} ->
            TakeoffGoods = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
            if
                TakeoffGoods =:= [] ->
                    send_error(Sid, ?FAIL);
                true ->
                    CellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_DRACONIC),
                    if
                        CellNum < length(TakeoffGoods) ->
                            send_error(Sid, ?ERRCODE(err622_bag_not_enough));
                        true ->
                            F = fun
                                () ->
                                    ok = lib_goods_dict:start_dict(),
                                    F2 = fun
                                        (GoodsInfo, GoodsStatusAcc) ->
                                            [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_DRACONIC, 0, GoodsStatusAcc),
                                            NewGoodsStatusAcc
                                    end,
                                    TakeoffEndGoods = lib_draconic:takeoff_equips(TakeoffGoods),
                                    GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods),
                                    #goods_status{dict = OldGoodsDict} = GoodsStatusTmp,
                                    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                    NewGoodsStatus = GoodsStatusTmp#goods_status{dict = GoodsDict},
                                    % [lib_draconic:change_goods_other(G) || G <- TakeoffEndGoods],
                                    {ok, GoodsL, NewGoodsStatus}
                            end,
                            case lib_goods_util:transaction(F) of
                                {ok, GoodsL, NewGoodsStatus} ->
                                    lib_goods_do:set_goods_status(NewGoodsStatus),
                                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                    [lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]) || GoodsInfo <- TakeoffGoods],
                                    lib_goods_api:notify_client(RoleId, GoodsL),
                                    NewPS = lib_draconic:updata_draconic_status(PS, [{chang_equip, {NewGoodsStatus}}]),
                                    {ok, BinData} = pt_622:write(62204, []),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    NewPS2 = lib_player:count_player_attribute(NewPS),
                                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                    handle(62201, NewPS2, []),
                                    {ok, battle_attr, NewPS2};
                                _Err ->
                                    % ?MYLOG("draconic","OFF  _Err:~p~n",[_Err]),
                                    send_error(Sid, ?FAIL)
                            end %% lib_goods_util:transaction(F)
                    end %% if CellNum < length(TakeoffGoods)
            end %% case lists:keyfind(EudemonsId, ...)
    end;

% %% 圣魂丹界面
% do_handle(62205, PS, []) ->
%     #player_status{draconic_status = DraconicStatus, sid = Sid, figure = #figure{lv = RoleLv}} = PS,
%     #draconic_status{pill_map = PillMap} = DraconicStatus,
%     PillList = maps:to_list(PillMap),
%     F = fun({GoodsTypeid, DraconicPill}, Acc) ->
%         case DraconicPill of
%             #draconic_pill{goods_id = GoodsTypeid, total_num = TotalNum}->
%                 case data_draconic:get_draconic_pill_limit(GoodsTypeid, RoleLv) of
%                     Limit when is_integer(Limit) -> Limit;
%                     _ -> Limit = 0
%                 end,
%                 [{GoodsTypeid, TotalNum, Limit}|Acc];
%             _ ->
%                 Acc
%         end
%     end,
%     SendList = lists:foldl(F, [], PillList),
%     % ?PRINT("62205  SendList:~p~n",[SendList]),
%     {ok, BinData} = pt_622:write(62205, [SendList]),
%     lib_server_send:send_to_sid(Sid, BinData);

% %%圣魂丹使用
% do_handle(62206, PS, [GoodsTypeid, Num]) ->
%     #player_status{draconic_status = DraconicStatus, sid = Sid, id = RoleId, figure = #figure{name = RoleName, lv = RoleLv}} = PS,
%     #draconic_status{pill_map = PillMap} = DraconicStatus,
%     case data_draconic:get_draconic_pill_limit(GoodsTypeid, RoleLv) of
%         Limit when is_integer(Limit) -> Limit;
%         _ -> Limit = 0
%     end,
%     case data_draconic:get_per_add_attr(GoodsTypeid) of
%         ListCfg when is_list(ListCfg) ->skip;
%         _ -> ListCfg = []
%     end,
%     case data_goods_type:get(GoodsTypeid) of
%          #ets_goods_type{type = Type} ->
%              skip;
%          _ ->
%              Type = 38
%     end,
%     case maps:get(GoodsTypeid, PillMap, []) of
%         #draconic_pill{total_num = TotalNum, attr = Attr} = Pill ->
%             if
%                 TotalNum + Num =< Limit ->
%                     F = fun({AttrKey, Value}, Acc) ->
%                         [{AttrKey, Value * Num}|Acc]
%                     end,
%                     AddAttr = lists:foldl(F, [], ListCfg),
%                     Code = 0,
%                     %% 日志
%                     lib_log_api:log_draconic_pill(RoleId, RoleName, GoodsTypeid, TotalNum, TotalNum + Num, [{Type, GoodsTypeid, Num}]),
%                     Cost = [{Type, GoodsTypeid, Num}],
%                     NewPill = Pill#draconic_pill{total_num = TotalNum+Num, attr = AddAttr ++ Attr};
%                 TotalNum + Num > Limit andalso Limit - TotalNum > 0  ->
%                     F = fun({AttrKey, Value}, Acc) ->
%                         [{AttrKey, Value * (Limit - TotalNum)}|Acc]
%                     end,
%                     AddAttr = lists:foldl(F, [], ListCfg),
%                     Code = 0,
%                     Cost = [{Type, GoodsTypeid, Limit - TotalNum}],
%                     %% 日志
%                     lib_log_api:log_draconic_pill(RoleId, RoleName, GoodsTypeid, TotalNum, Limit, [{Type, GoodsTypeid, Limit - TotalNum}]),
%                     NewPill = Pill#draconic_pill{total_num = Limit, attr = AddAttr ++ Attr};
%                 true ->
%                     Code = ?ERRCODE(err654_pill_lv_limit),
%                     Cost = [],
%                     NewPill = Pill
%             end;
%         _ ->
%             if
%                 Num =< Limit ->
%                     F = fun({AttrKey, Value}, Acc) ->
%                         [{AttrKey, Value * Num}|Acc]
%                     end,
%                     AddAttr = lists:foldl(F, [], ListCfg),
%                     Code = 0,
%                     Cost = [{Type, GoodsTypeid, Num}],
%                     %% 日志
%                     lib_log_api:log_draconic_pill(RoleId, RoleName, GoodsTypeid, 0, Num, [{Type, GoodsTypeid, Num}]),
%                     NewPill = #draconic_pill{goods_id = GoodsTypeid, total_num = Num, attr = AddAttr};
%                 Num > Limit ->
%                     F = fun({AttrKey, Value}, Acc) ->
%                         [{AttrKey, Value * Limit}|Acc]
%                     end,
%                     %% 日志
%                     lib_log_api:log_draconic_pill(RoleId, RoleName, GoodsTypeid, 0, Limit, [{Type, GoodsTypeid, Limit}]),
%                     AddAttr = lists:foldl(F, [], ListCfg),
%                     Code = 0,
%                     Cost = [{Type, GoodsTypeid, Limit}],
%                     NewPill = #draconic_pill{goods_id = GoodsTypeid, total_num = Limit, attr = AddAttr}
%             end
%     end,
%     if
%         Code == 0 andalso Cost =/= [] ->
%             [{_, GoodsTypeid, CostNum}] = Cost,
%             case lib_goods_api:cost_object_list_with_check(PS, [{0, GoodsTypeid, Num}], draconic_pill, "") of
%                 {true, NewPs} ->
%                     RealCode = Code;
%                 {false, Code1, NewPs} ->
%                     RealCode = Code1
%             end,
%             db:execute(io_lib:format(?draconic_replace, [RoleId, GoodsTypeid, NewPill#draconic_pill.total_num]));
%         true ->
%             CostNum = 0,
%             NewPs = PS,
%             RealCode = Code
%     end,
%     % ?PRINT("Cost:~p, RealCode:~p~n",[Cost, RealCode]),
%     NewPillMap = maps:put(GoodsTypeid, NewPill, PillMap),
%     TotalPillAttr = lib_draconic:get_pill_total_attr(NewPillMap),
%     NewDraconicS = DraconicStatus#draconic_status{pill_map = NewPillMap, pill_attr = TotalPillAttr},
%     NewPS = NewPs#player_status{draconic_status = NewDraconicS},
%     NewPS2 = lib_player:count_player_attribute(NewPS),
%     lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
%     {ok, BinData} = pt_622:write(62206, [GoodsTypeid, CostNum, RealCode]),
%     % handle(62205, NewPS2, []),
%     lib_server_send:send_to_sid(Sid, BinData),
%     {ok, battle_attr, NewPS2};

do_handle(62207, PS, []) ->
    #player_status{sid = Sid, draconic_status = _DraconicStatus, original_attr = SumOAttr} = PS,
    % #draconic_status{rating = Rating} = DraconicStatus,
    DraconicAttr = lib_draconic:get_total_attr(PS),
    % ?PRINT("rating:~p~n",[Rating]),
    Power = lib_player:calc_partial_power(SumOAttr, 0, DraconicAttr),
    {ok, BinData} = pt_622:write(62207, [Power]),
    lib_server_send:send_to_sid(Sid, BinData);

do_handle(62208, PS, [GoodsTypeid]) ->
    #player_status{sid = Sid} = PS,
    GoodsTypeInfo = data_goods_type:get(GoodsTypeid),
    case GoodsTypeInfo of
        #ets_goods_type{type = ?GOODS_TYPE_DRACONIC, subtype = Subtype} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            {SendList, Code} =lib_draconic:calc_suit_info_preview(PS, GoodsStatus, GoodsTypeid, Subtype),
            {ok, BinData} = pt_622:write(62208, [SendList, Code]),
            lib_server_send:send_to_sid(Sid, BinData);
        _ ->
            % ?PRINT("======== GoodsTypeid:~p~n",[GoodsTypeid]),
            {ok, BinData} = pt_622:write(62208, [[], ?ERRCODE(err654_wrong_data)]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {ok, PS};

do_handle(62209, PS, []) ->
    #player_status{sid = Sid, draconic_status = DraconicStatus} = PS,
    #draconic_status{suit_info = NSuitInfo} = DraconicStatus,
    Fun = fun({SuitId,_,_,RealNum,_,_,_}, Acc) ->
        lists:keystore(SuitId, 1, Acc, {SuitId, RealNum})
    end,
    SendList = lists:foldl(Fun, [], NSuitInfo),
    % ?PRINT("@@@@@ SendList:~p,NSuitInfo:~p~n",[NSuitInfo,SendList]),
    {ok, BinData} = pt_622:write(62209, [SendList]),
    lib_server_send:send_to_sid(Sid, BinData);

do_handle(CMD, _PS, Args) ->
    ?ERR("protocol ~p, ~p nomatch ~n", [CMD, Args]).

calc_takeoff_equips(Pos, EquipList, GoodsDict) ->
    F = fun
        ({Position, GoodsAutoId, _Stren}, TakeoffGoods) ->
            if
                Position =:= Pos orelse Pos =:= 0 ->
                    case lib_goods_util:get_goods(GoodsAutoId, GoodsDict) of
                        GoodsInfo when is_record(GoodsInfo, goods) ->
                            [GoodsInfo|TakeoffGoods];
                        _ ->
                            TakeoffGoods
                    end;
                true ->
                    TakeoffGoods
            end
    end,
    TakeoffGoods = lists:foldl(F, [], EquipList),
    TakeoffGoods.

log_strength(RoleId, RoleName, GoodsInfo, NewGoodsInfo, Draconicbl) ->
    #goods{id = _AutoId, goods_id = EquipTypeId, other = #goods_other{stren = Stren0}, cell = Pos} = GoodsInfo,
    #goods{other = #goods_other{stren = Stren1}} = NewGoodsInfo,
    Cost = [{?TYPE_CURRENCY, ?GOODS_ID_DRACONIC, Draconicbl}],
    lib_log_api:log_draconic_stren(RoleId, RoleName, Pos, EquipTypeId, Stren0, Stren1, Cost).