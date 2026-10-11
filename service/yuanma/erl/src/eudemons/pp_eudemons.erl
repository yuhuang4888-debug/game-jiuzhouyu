%%-----------------------------------------------------------------------------
%% @Module  :       pp_eudemons.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2017-11-27
%% @Description:    幻兽
%%-----------------------------------------------------------------------------

-module (pp_eudemons).
-include ("common.hrl").
-include ("errcode.hrl").
-include ("server.hrl").
-include ("goods.hrl").
-include ("def_goods.hrl").
-include ("eudemons.hrl").
-include ("predefine.hrl").
-include ("def_module.hrl").
-include ("def_event.hrl").
-include ("figure.hrl").
-include ("attr.hrl").

-export ([handle/3, send_error/2]).

handle(Cmd, PlayerStatus, Data) ->
    % ?PRINT("Cmd:~p, Data:~p~n",[Cmd, Data]),
    #player_status{figure = Figure} = PlayerStatus,
    OpenLv = case data_eudemons:get_cfg(open_lv,lv)  of
        Lv when is_integer(Lv) -> Lv;
        _ -> 0
    end,
    case Figure#figure.lv >= OpenLv of
        true ->
            do_handle(Cmd, PlayerStatus, Data);
        false -> skip
    end.


% ########### 幻兽概览 #############
do_handle(17301, PS, []) ->
    #player_status{eudemons = EudemonsStatus, sid = Sid} = PS,
    #eudemons_status{fight_location_count = LocationCount, eudemons_list = Items} = EudemonsStatus,
    ItemsForSend = [lib_eudemons:item_data_for_send(Item) || Item <- Items],
    % ?MYLOG("xlh", "17301 LocationCount:~p,ItemsForSend:~p~n", [LocationCount,ItemsForSend]),
    {ok, BinData} = pt_173:write(17301, [LocationCount, ItemsForSend]),
    lib_server_send:send_to_sid(Sid, BinData);

%% 穿戴装备
%% pt_17303_[4294970722,1,1] 4294970727
do_handle(17303, PS, [GoodsAutoId, EudemonsId, Replace]) ->
    GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{eudemons = EudemonsStatus, id = RoleId, sid = Sid} = PS,
    #eudemons_status{eudemons_list = Items} = EudemonsStatus,
    case lists:keyfind(EudemonsId, #eudemons_item.id, Items) of
        false ->
            send_error(Sid, ?FAIL);
        #eudemons_item{equip_list = EquipList} = Item ->
            case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
                #goods{type = ?GOODS_TYPE_EUDEMONS, subtype = Pos, location = ?GOODS_LOC_EUDEMONS_BAG, other = #goods_other{stren = Stren, overflow_exp = Exp} = Other} = GoodsInfoOld ->
                    case lib_eudemons:check_equip(EudemonsId, GoodsInfoOld) of
                        true ->
                            case lists:keyfind(Pos, 1, EquipList) of
                                {_, V, _, _} ->
                                    OGoodsInfo = lib_goods_util:get_goods(V, GoodsStatus#goods_status.dict),
                                    case OGoodsInfo of
                                        #goods{other = #goods_other{stren = OStren, overflow_exp = OExp}} ->skip;
                                        _ -> OStren = 0, OExp = 0
                                    end,
                                    OGoodsInfo;
                                _ ->
                                    OStren = 0, OExp = 0, []
                            end,
                            {TakeoffGoods, NewEquipList1} = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
                            % NewEquipList = lists:keystore(Pos, 1, NewEquipList1, {Pos, GoodsAutoId, NewStren, NewExp}),
                            F = fun
                                () ->
                                    ok = lib_goods_dict:start_dict(),
                                    %% 如果继承 计算旧装备上的强化经验，计算新的强化等级
                                    if
                                        Replace == 1 ->
                                            {NewStren, NewExp} = lib_eudemons:calc_equip_stren(Pos, Stren, OStren, Exp, OExp),
                                            % ?PRINT("============ Stren:~p,Exp:~p, OExp:~p,OStren:~p,NewStren:~p,NewExp:~p~n",[Stren, Exp, OExp, OStren,NewStren,NewExp]),
                                            GoodsInfo = GoodsInfoOld#goods{other = Other#goods_other{stren = NewStren, overflow_exp = NewExp}};
                                        true ->
                                            GoodsInfo = GoodsInfoOld
                                    end,
                                    % 脱下原来的装备
                                    if
                                        TakeoffGoods =/= [] ->
                                            F2 = fun
                                                (GoodsInfo1, GoodsStatusAcc) ->
                                                    [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo1, ?GOODS_LOC_EUDEMONS_BAG, 0, GoodsStatusAcc),
                                                    NewGoodsStatusAcc
                                            end,
                                            TakeoffEndGoods = lib_eudemons:takeoff_equips(Replace, TakeoffGoods),
                                            [lib_eudemons:change_goods_other(TofGoods)|| TofGoods <- TakeoffEndGoods],
                                            GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods);
                                        true ->
                                            GoodsStatusTmp = GoodsStatus
                                    end,
                                    DressGoodsInfo = lib_eudemons:dress_on_equips(GoodsInfo, EudemonsId),
                                    lib_eudemons:change_goods_other(DressGoodsInfo),
                                    [GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(DressGoodsInfo, ?GOODS_LOC_EUDEMONS, Pos, GoodsStatusTmp),
                                    #goods_status{dict = OldGoodsDict} = GoodsStatus2,
                                    % lib_eudemons:save_eudemons_equips(RoleId, EudemonsId, NewEquipList, EquipList),
                                    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                    NewGoodsStatus = GoodsStatus2#goods_status{dict = GoodsDict},

                                    {ok, GoodsL, NewGoodsStatus, GoodsInfo1}
                            end,
                            case lib_goods_util:transaction(F) of
                                {ok, GoodsL, NewGoodsStatus, GoodsInfo1} ->
                                    #goods{other = #goods_other{stren = NStren, overflow_exp = NExp}} = GoodsInfo1,
                                    NewEquipList = lists:keystore(Pos, 1, NewEquipList1, {Pos, GoodsAutoId, NStren, NExp}),
                                    lib_goods_do:set_goods_status(NewGoodsStatus),
                                    % 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                    if
                                        TakeoffGoods =/= [] ->
                                            [lib_goods_api:notify_client_num(RoleId, [TemGoodsInfo1#goods{num=0}]) || TemGoodsInfo1 <- TakeoffGoods];
                                        true ->
                                            skip
                                    end,
                                    lib_goods_api:notify_client_num(RoleId, [GoodsInfo1#goods{num=0, location = ?GOODS_LOC_EUDEMONS_BAG}]),
                                    lib_goods_api:notify_client(RoleId, GoodsL),
                                    NewItem = Item#eudemons_item{equip_list = NewEquipList},
                                    {FightChange, NewEudemonsStatus, RefreshItem} = lib_eudemons:update_status(RoleId, EudemonsStatus, NewItem, NewGoodsStatus#goods_status.dict),
                                    NewPS = PS#player_status{eudemons = NewEudemonsStatus},
                                    {ok, BinData} = pt_173:write(17303, []), %%客户端的需求！！
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    send_item(Sid, RefreshItem),
                                    if
                                        FightChange ->
                                            NewPS2 = lib_player:count_player_attribute(NewPS),
                                            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                            {ok, battle_attr, NewPS2};
                                        true ->
                                            {ok, NewPS}
                                    end;
                                _Err ->
                                    ?PRINT("_Err:~p~n",[_Err]),
                                    send_error(Sid, ?FAIL)
                            end;
                        {false, ErrCode} ->
                            send_error(Sid, ErrCode)
                    end;
                _ ->
                    send_error(Sid, ?FAIL)
            end
    end;

% ########### 脱装备 #############
do_handle(17304, PS, [EudemonsId, Pos]) ->
    #player_status{eudemons = EudemonsStatus, id = RoleId, sid = Sid} = PS,
    #eudemons_status{eudemons_list = Items} = EudemonsStatus,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lists:keyfind(EudemonsId, #eudemons_item.id, Items) of
        false ->
            send_error(Sid, ?FAIL);
        #eudemons_item{equip_list = EquipList} = Item ->
            {TakeoffGoods, NewEquipList} = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
            if
                TakeoffGoods =:= [] ->
                    send_error(Sid, ?FAIL);
                true ->
                    CellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_EUDEMONS_BAG),
                    if
                        CellNum < length(TakeoffGoods) ->
                            send_error(Sid, ?ERRCODE(err150_eudemonds_bag_nocell));
                        true ->
                            F = fun
                                () ->
                                    ok = lib_goods_dict:start_dict(),
                                    F2 = fun
                                        (GoodsInfo, GoodsStatusAcc) ->
                                            [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_EUDEMONS_BAG, 0, GoodsStatusAcc),
                                            NewGoodsStatusAcc
                                    end,
                                    TakeoffEndGoods = lib_eudemons:takeoff_equips(TakeoffGoods),
                                    GoodsStatusTmp = lists:foldl(F2, GoodsStatus, TakeoffEndGoods),
                                    #goods_status{dict = OldGoodsDict} = GoodsStatusTmp,
                                    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                                    NewGoodsStatus = GoodsStatusTmp#goods_status{dict = GoodsDict},
                                    if
                                        Item#eudemons_item.state =:= ?EUDEMONS_STATE_FIGHT ->
                                            lib_eudemons:save_eudemons_state(RoleId, EudemonsId, ?EUDEMONS_STATE_SLEEP);
                                        true ->
                                            ok
                                    end,
                                    [lib_eudemons:change_goods_other(G) || G <- TakeoffEndGoods],
                                    {ok, GoodsL, NewGoodsStatus}
                            end,
                            case lib_goods_util:transaction(F) of
                                {ok, GoodsL, NewGoodsStatus} ->
                                    lib_goods_do:set_goods_status(NewGoodsStatus),
                                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                    [lib_goods_api:notify_client_num(RoleId, [GoodsInfo#goods{num=0}]) || GoodsInfo <- TakeoffGoods],
                                    lib_goods_api:notify_client(RoleId, GoodsL),
                                    NewItem = Item#eudemons_item{equip_list = NewEquipList},
                                    {FightChange, NewEudemonsStatus, RefreshItem} = lib_eudemons:update_status(RoleId, EudemonsStatus, NewItem, NewGoodsStatus#goods_status.dict),
                                    NewPS = PS#player_status{eudemons = NewEudemonsStatus},
                                    if
                                        Item#eudemons_item.state =:= ?EUDEMONS_STATE_FIGHT ->
                                            lib_log_api:log_eudemons_operation(RoleId, EudemonsId, ?EUDEMONS_STATE_SLEEP);
                                        true ->
                                            ok
                                    end,
                                    {ok, BinData} = pt_173:write(17304, []),
                                    lib_server_send:send_to_sid(Sid, BinData),
                                    send_item(Sid, RefreshItem),
                                    if
                                        FightChange ->
                                            NewPS2 = lib_player:count_player_attribute(NewPS),
                                            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                            {ok, battle_attr, NewPS2};
                                        true ->
                                            {ok, NewPS}
                                    end;
                                _Err ->
                                    ?PRINT("_Err:~p~n",[_Err]),
                                    send_error(Sid, ?FAIL)
                            end %% lib_goods_util:transaction(F)
                    end %% if CellNum < length(TakeoffGoods)
            end %% case lists:keyfind(EudemonsId, ...)
    end;

% ########### 出战脱战 #############
do_handle(17305, PS, [EudemonsId, State]) when State =:= ?EUDEMONS_STATE_FIGHT orelse State =:= ?EUDEMONS_STATE_ACTIVE ->
    #player_status{eudemons = EudemonsStatus, sid = Sid, id = RoleId} = PS,
    #eudemons_status{eudemons_list = Items, fight_location_count = FightLocationCount} = EudemonsStatus,
    Length = length([1 || #eudemons_item{state = ?EUDEMONS_STATE_FIGHT} <- Items]),
    case lists:keyfind(EudemonsId, #eudemons_item.id, Items) of
        #eudemons_item{state = State0} = Item when State0 =/= State andalso State0 =/= ?EUDEMONS_STATE_SLEEP ->
            case State =:= ?EUDEMONS_STATE_ACTIVE
                orelse Length < FightLocationCount of
                true ->
                    NewItem = Item#eudemons_item{state = State},
                    lib_eudemons:save_eudemons_state(RoleId, EudemonsId, State),
                    NewItems = lists:keystore(EudemonsId, #eudemons_item.id, Items, NewItem),
                    TmpEudemonsStatus = EudemonsStatus#eudemons_status{eudemons_list = NewItems},
                    AttrEudemonsStatus = lib_eudemons:calc_eudemons_status_attr(TmpEudemonsStatus),
                    % SkillEudemonsStatus = lib_eudemons:update_skill_change(AttrEudemonsStatus, NewItem),
                    NewPS = PS#player_status{eudemons = AttrEudemonsStatus},
                    NewPS1 = lib_eudemons:update_skill_change(NewPS, NewItem),
                    NewPS2 = lib_player:count_player_attribute(NewPS1),
                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                    lib_log_api:log_eudemons_operation(RoleId, EudemonsId, State),
                    NewLength = length([1 || #eudemons_item{state = ?EUDEMONS_STATE_FIGHT} <- NewItems]),
                    lib_achievement_api:async_event(RoleId,lib_achievement_api,eudemons_extend_event,NewLength),
                    {ok, TemplePs} = lib_temple_awaken_api:trigger_active_eudemon(NewPS2, EudemonsId),
                    % ?PRINT("17305 EudemonsId:~p, State:~p~n",[EudemonsId, State]),
                    {ok, BinData} = pt_173:write(17305, [EudemonsId, State]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    {ok, battle_attr, TemplePs};
                _ ->
                    if
                        State =:= ?EUDEMONS_STATE_FIGHT ->
                            send_error(Sid, ?ERRCODE(err173_fight_limit));
                        true ->
                            send_error(Sid, ?ERRCODE(err173_system_business))
                    end   
            end;
        _ ->
            send_error(Sid, ?FAIL)
    end;

% ########### 拓展出战槽位 #############
do_handle(17306, PS, []) ->
    #player_status{eudemons = EudemonsStatus,id = RoleId, sid = Sid, figure = #figure{lv = RoleLv}} = PS,
    #eudemons_status{fight_location_count = FightLocationCount} = EudemonsStatus,
    % Limit = lib_counter:get_count_limit(?MOD_EUDEMONS, ?COUNTER_TYPE_EXTRA_LOCATION),
    DefaultCount = data_eudemons:get_cfg(default,fight_location),
    NextLocationCount = FightLocationCount - DefaultCount + 1,
    CfgList = case data_eudemons:get_cfg(fight_location_cost, NextLocationCount) of
                  CFG when is_list(CFG) -> CFG;
                  _ -> []
              end,

    case lists:keyfind(lv_limit, 1, CfgList) of
        {lv_limit, LvLimit} when is_integer(LvLimit) -> LvLimit;
        _ -> LvLimit = 0
    end,
    case lists:keyfind(cost, 1, CfgList) of
        {cost, Cost} when is_list(Cost) andalso RoleLv >= LvLimit ->
            case lib_goods_api:cost_object_list_with_check(PS, Cost, eudemons_buy_fight_location, integer_to_list(NextLocationCount)) of
                {true, CostPS} ->
                    mod_counter:increment_offline(RoleId, ?MOD_EUDEMONS, ?COUNTER_TYPE_EXTRA_LOCATION),
                    NewLocatinCount = FightLocationCount + 1,
                    {ok, BinData} = pt_173:write(17306, [NewLocatinCount]),
                    lib_server_send:send_to_sid(Sid, BinData),
                    % {ok, AchvPlayer} = lib_achievement_api:eudemons_extend_event(CostPS, NewLocatinCount),
                    {ok, CostPS#player_status{eudemons = EudemonsStatus#eudemons_status{fight_location_count = NewLocatinCount}}};
                {false, Code, _} ->
                    send_error(Sid, Code)
            end;
        {cost, Cost} when is_list(Cost) andalso RoleLv < LvLimit ->
            send_error(Sid, ?ERRCODE(err173_lv_limit));
        _ ->
            send_error(Sid, ?ERRCODE(err173_fight_location_limit))
    end;

% ########### 强化 #############
%% pt_17307_[4294970722, 0, [4294970723]]
do_handle(17307, PS, [GoodsAutoId, IsDouble, MaterialIdList]) ->
    % ?PRINT("17307 ~p~n",[[GoodsAutoId, IsDouble, MaterialIdList]]),
    #player_status{id = RoleId, sid = Sid} = PS,
    #goods_status{dict = GoodsDict} = GoodsStatus = lib_goods_do:get_goods_status(),
    MaterialList = lists:foldl(fun
        (Id, Acc) ->
            case lib_goods_util:get_goods(Id, GoodsDict) of
                #goods{location = ?GOODS_LOC_EUDEMONS_BAG, type = ?GOODS_TYPE_EUDEMONS} = Info ->
                    [Info|Acc];
                _ ->
                    Acc
            end
    end, [], ulists:removal_duplicate(MaterialIdList)),
    GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsDict),
    CheckCode = lib_eudemons:check_strength(GoodsInfo),
    if
        % is_record(GoodsInfo, goods) =:= false ->
        %     send_error(Sid, ?FAIL);
        % GoodsInfo#goods.location =/= ?GOODS_LOC_EUDEMONS ->
        %     send_error(Sid, ?FAIL);
        CheckCode =/= true ->
            send_error(Sid, CheckCode);
        MaterialList =:= [] ->
            send_error(Sid, ?FAIL);
        true ->
            if
                IsDouble =:= 1 ->
                    case lists:all(fun
                        (#goods{other = #goods_other{stren = MStren, overflow_exp = MExp}}) ->
                            MStren =:= 0 andalso MExp =:= 0
                    end, MaterialList) of
                        true ->
                            {NewGoodsInfo, CostMaterialList, Exp} = lib_eudemons:calc_strength(GoodsInfo, MaterialList, IsDouble),
                            if
                                Exp > 0 ->
                                    case data_eudemons:get_cfg(strength_cost_gold,cost) of
                                        [{Type, 0, Num}] ->
                                            Gold = util:ceil(Exp / 200),
                                            MoneyCost = [{Type, 0, Gold * Num}],
                                            About = lists:concat([NewGoodsInfo#goods.goods_id]),
                                            case lib_goods_api:cost_object_list_with_check(PS, MoneyCost, eudemons_double_strength_cost, About) of
                                                {true, CostPS} ->
                                                    Code = ?SUCCESS;
                                                {false,ErrCode,CostPS} ->
                                                    % Code = ?ERRCODE(money_not_enough)
                                                    Code = ErrCode
                                            end;
                                        _ ->
                                            CostPS = PS,
                                            Code = ?ERRCODE(err173_strength_cfg_error)
                                    end;
                                true -> %% 强化等级扩展后，原本有溢出经验的装备强化
                                    CostPS = PS, Code = ?SUCCESS
                            end;
                        _ ->
                            Exp = 0,
                            NewGoodsInfo = CostMaterialList = undefined,
                            CostPS = PS,
                            Code = ?ERRCODE(err173_strength_double_error)
                    end;
                true ->
                    {NewGoodsInfo, CostMaterialList, Exp} = lib_eudemons:calc_strength(GoodsInfo, MaterialList, IsDouble),
                    CostPS = PS,
                    Code = ?SUCCESS
            end,
            case Code =:= ?SUCCESS of
                true ->
                    F = fun
                        () ->
                            ok = lib_goods_dict:start_dict(),
                            DeleteList = [{Material, Material#goods.num} || Material <- CostMaterialList],
                            {ok, TmpGoodsStatus} = lib_goods:delete_goods_list(GoodsStatus, DeleteList),
                            lib_eudemons:change_goods_other(NewGoodsInfo),
                            {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(TmpGoodsStatus#goods_status.dict),
                            % #goods{other = #goods_other{stren = Stren, overflow_exp = OExp}} = NewGoodsInfo,
                            Dict2 = lib_goods_dict:add_dict_goods(NewGoodsInfo, Dict),
                            NewGoodsStatus = TmpGoodsStatus#goods_status{dict = Dict2},
                            {ok, NewGoodsStatus, GoodsL}
                            % lib_goods_api:notify_client_num(NewStatus#goods_status.player_id, UpdateGoodsList),
                    end,
                    case lib_goods_util:transaction(F) of
                        {ok, NewGoodsStatus, GoodsL} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            lib_goods_api:notify_client_num(RoleId, GoodsL),
                            #goods{other = #goods_other{stren = NewStren, overflow_exp = NewExp}} = NewGoodsInfo,
                            % #goods{other = #goods_other{stren = OldStren}} = GoodsInfo,
                            % ?PRINT("17307  GoodsAutoId:~p, NewStren:~p, NewExp:~p~n",[GoodsAutoId, NewStren, NewExp]),
                            {ok, BinData} = pt_173:write(17307, [GoodsAutoId, NewStren, NewExp]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            log_strength(RoleId, CostMaterialList, GoodsInfo, NewGoodsInfo, Exp),
                            case lib_eudemons:refresh_with_strength(CostPS, NewGoodsInfo, GoodsInfo, NewGoodsStatus#goods_status.dict) of
                                {FightChange, NewPS, Item} ->
                                    send_item(Sid, Item),
                                    if
                                        FightChange ->
                                            NewPS2 = lib_player:count_player_attribute(NewPS),
                                            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                            {ok, battle_attr, NewPS2};
                                        true ->
                                            {ok, NewPS}
                                    end;
                                {ok, NewPS} ->
                                    {ok, NewPS}
                            end;
                        _ ->
                            send_error(Sid, ?FAIL)
                    end;
                _ ->
                    send_error(Sid, Code)
            end
    end;

%% 强化预览
do_handle(17308, PS, [GoodsAutoId, IsDouble, MaterialIdList]) ->
    #player_status{sid = Sid} = PS,
    #goods_status{dict = GoodsDict} = lib_goods_do:get_goods_status(),
    MaterialList = lists:foldl(fun
        (Id, Acc) ->
            case lib_goods_util:get_goods(Id, GoodsDict) of
                #goods{location = ?GOODS_LOC_EUDEMONS_BAG, type = ?GOODS_TYPE_EUDEMONS} = Info ->
                    [Info|Acc];
                _ ->
                    Acc
            end
    end, [], ulists:removal_duplicate(MaterialIdList)),
    GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsDict),
    CheckCode = lib_eudemons:check_strength(GoodsInfo),
    if
        CheckCode =/= true ->
            send_error(Sid, CheckCode);
        MaterialList =:= [] ->
            send_error(Sid, ?FAIL);
        true ->
            if
                IsDouble =:= 1 ->
                    case lists:all(fun
                        (#goods{other = #goods_other{stren = MStren, overflow_exp = MExp}}) ->
                            MStren =:= 0 andalso MExp =:= 0
                    end, MaterialList) of
                        true ->
                            {NewGoodsInfo, _CostMaterialList, Exp} = lib_eudemons:calc_strength(GoodsInfo, MaterialList, IsDouble),
                            #goods{other = #goods_other{stren = NewStren}} = NewGoodsInfo,
                            {ok, BinData} = pt_173:write(17308, [GoodsAutoId, NewStren, Exp * 2]),
                            lib_server_send:send_to_sid(Sid, BinData);
                        _ ->
                            send_error(Sid, ?ERRCODE(err173_strength_double_error))
                    end;
                true ->
                    {NewGoodsInfo, _CostMaterialList, Exp} = lib_eudemons:calc_strength(GoodsInfo, MaterialList, IsDouble),
                    #goods{other = #goods_other{stren = NewStren}} = NewGoodsInfo,
                    {ok, BinData} = pt_173:write(17308, [GoodsAutoId, NewStren, Exp]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end;

do_handle(17309, PS, [Module, SubModule, AttrList]) ->
    #player_status{eudemons = EudemonsStatus, sid = Sid, original_attr = SumOAttr} = PS,
    #eudemons_status{all_base_attr = AllBaseAttr} = EudemonsStatus,
    Fun = fun({AttrId, AttrValue}, Acc) ->
        case lists:member(AttrId, ?PARTIAL_TYPE) orelse AttrId == ?PARTIAL_WHOLE_ADD_RATIO of
            true ->
                if
                    AllBaseAttr == [] orelse AttrList == [] ->
                        Acc;
                    true ->
                        AttrList1 = AllBaseAttr ++ [{AttrId, AttrValue}],
                        TotalAttr = lib_player_attr:partial_attr_convert(AttrList1),
                        % ?PRINT("AllBaseAttr:~p,TotalAttr:~p~n",[AllBaseAttr,TotalAttr]),
                        lib_player_attr:minus_attr(list, [TotalAttr, AllBaseAttr])++Acc
                end;
            _ ->
                [{AttrId, AttrValue}|Acc]
        end
    end,
    ExtraList = lists:foldl(Fun, [], AttrList),
    AddPower = lib_player:calc_partial_power(SumOAttr, 0, ExtraList),
    ?PRINT("AttrList:~p,AddPower:~p,ExtraList:~p~n",[AttrList,AddPower, ExtraList]),
    {ok, BinData} = pt_173:write(17309, [Module, SubModule, AddPower]),
    lib_server_send:send_to_sid(Sid, BinData);

do_handle(17310, PS, [ComposeId, Material]) ->
    #player_status{id = RoleId, figure = Figure, sid = Sid} = PS,
    RoleName = Figure#figure.name,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case check_compose(ComposeId, Material, GoodsStatus) of
        {true, RealReward, CostGoodsInfoList} ->
            F = fun() ->
                %% 先扣除钱和通用的固定材料
                ok = lib_goods_dict:start_dict(),
                %% 扣除指定物品
                {ok, NewGoodsStatus} = lib_goods:delete_goods_list(GoodsStatus, CostGoodsInfoList),
                {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(NewGoodsStatus#goods_status.dict),
                NewGoodsStatus1 = NewGoodsStatus#goods_status{dict = Dict},
                {ok, NewGoodsStatus1, GoodsL}
            end,
            case lib_goods_util:transaction(F) of
                {ok, NewGoodsStatus1, GoodsL} ->
                    %% 扣除指定物品日志
                    F1 = fun({TmpGoodsInfo, TemNum}, {Acc1, Acc2}) ->
                        #goods{id = GoodsId, goods_id = GoodsTypeId, other = #goods_other{stren = Stren, overflow_exp = Exp}} = TmpGoodsInfo,
                        lib_log_api:log_throw(goods_compose, RoleId, GoodsId, GoodsTypeId, TemNum, 0, 0),
                        {[{GoodsTypeId, TemNum}|Acc1], [{Stren, Exp}|Acc2]}
                    end,
                    {LogSpecifyArgs, OldExpList} = lists:foldl(F1, {[],[]}, CostGoodsInfoList),
                    % LogSpecifyArgs = [F1(OneDel) || OneDel <- CostGoodsInfoList],
                    lib_goods_do:set_goods_status(NewGoodsStatus1),
                    
                    lib_goods_api:notify_client_num(RoleId, GoodsL),
                    [{Type, GtypeId, Pos, Num}|_] = RealReward,
                    {Stren, Exp} = lib_eudemons:calc_equip_stren(Pos, 0, 0, OldExpList),
                    Res = lib_goods_api:give_goods_by_list(PS, [{goods_other, GtypeId, Num, Stren, Exp}], goods_compose, 0),
                    case Res of
                        {1, GiveGoodsInfoList, _} ->
                            LastCode = ?ERRCODE(err150_compose_success),
                            Fun = fun(#goods{id = Id, goods_id = TemGoodsTypeId, color = Color}, {Acc, TemAcc}) ->
                                NewAcc = case data_eudemons:get_equip_attr(TemGoodsTypeId) of
                                    #base_eudemons_equip_attr{star = Star} ->
                                        case lists:keyfind({Star, Color}, 1, TemAcc) of
                                            {_, SNum} -> 
                                                lists:keystore({Star, Color}, 1, TemAcc, {{Star, Color}, SNum + 1});
                                            _ ->
                                                lists:keystore({Star, Color}, 1, TemAcc, {{Star, Color}, 1})
                                        end;
                                    _ ->
                                        TemAcc
                                end,
                                {[{Id, TemGoodsTypeId}|Acc], NewAcc}
                            end,
                            {SendList, AchivList} = lists:foldl(Fun, {[], []}, GiveGoodsInfoList),
                            {ok, BinData} = pt_173:write(17310, [LastCode, ComposeId, SendList]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            lib_achievement_api:async_event(RoleId, lib_achievement_api, eudemons_compose_event, AchivList),
                            %% 合成日志
                            lib_log_api:log_eudemons_compose(RoleId, RoleName, LogSpecifyArgs, [{Type, GtypeId, Num}]);
                            
                            
                        _Error ->
                            ?ERR("compose_goods err:~p", [_Error]),
                            LastCode = ?ERRCODE(err150_compose_fail),
                            send_error(Sid, LastCode) 
                            % ComposeGoodsId = 0
                    end;
                _ ->
                   send_error(Sid, ?FAIL) 
            end;
        {false, Code} ->
            send_error(Sid, Code)
    end;
    
do_handle(17311, PS, [GoodsAutoId, Type, CostGooodsAutoId]) ->
    #player_status{id = RoleId, sid = Sid} = PS,
    #goods_status{dict = GoodsDict} = GoodsStatus = lib_goods_do:get_goods_status(),
    case data_eudemons:get_cfg(stren_cfg,cost) of
        [_GoodsTypeId, ExpAddcfg] ->
            CostGoodsInfo = lib_goods_util:get_goods(CostGooodsAutoId, GoodsDict),
            GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsDict),
            case lib_eudemons:check_strength(PS, GoodsInfo, CostGoodsInfo, Type, _GoodsTypeId, ExpAddcfg) of
                CheckCode when is_integer(CheckCode) -> 
                    send_error(Sid, CheckCode);
                {true, CostNum} ->
                    {NewGoodsInfo, NewExp, NewStren, CostExp} = lib_eudemons:calc_strength_new(GoodsInfo, Type, ExpAddcfg, CostNum),
                    F = fun
                        () ->
                            ok = lib_goods_dict:start_dict(),
                            DeleteList = [{CostGoodsInfo, CostNum}],
                            {ok, TmpGoodsStatus} = lib_goods:delete_goods_list(GoodsStatus, DeleteList),
                            lib_eudemons:change_goods_other(NewGoodsInfo),
                            {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(TmpGoodsStatus#goods_status.dict),
                            % #goods{other = #goods_other{stren = Stren, overflow_exp = OExp}} = NewGoodsInfo,
                            Dict2 = lib_goods_dict:add_dict_goods(NewGoodsInfo, Dict),
                            NewGoodsStatus = TmpGoodsStatus#goods_status{dict = Dict2},
                            {ok, NewGoodsStatus, GoodsL}
                            % lib_goods_api:notify_client_num(NewStatus#goods_status.player_id, UpdateGoodsList),
                    end,
                    case lib_goods_util:transaction(F) of
                        {ok, NewGoodsStatus, GoodsL} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            lib_goods_api:notify_client_num(RoleId, GoodsL),
                            % #goods{other = #goods_other{stren = OldStren}} = GoodsInfo,
                            % ?PRINT("17307  GoodsAutoId:~p, NewStren:~p, NewExp:~p~n",[GoodsAutoId, NewStren, NewExp]),
                            {ok, BinData} = pt_173:write(17311, [GoodsAutoId, NewStren, NewExp]),
                            lib_server_send:send_to_sid(Sid, BinData),
                            lib_goods_api:notify_client(RoleId, [NewGoodsInfo]),
                            log_strength(RoleId, CostGoodsInfo, CostNum, GoodsInfo, NewGoodsInfo, CostExp),
                            case lib_eudemons:refresh_with_strength(PS, NewGoodsInfo, GoodsInfo, NewGoodsStatus#goods_status.dict) of
                                {FightChange, NewPS, Item} ->
                                    send_item(Sid, Item),
                                    if
                                        FightChange ->
                                            NewPS2 = lib_player:count_player_attribute(NewPS),
                                            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                            {ok, battle_attr, NewPS2};
                                        true ->
                                            {ok, NewPS}
                                    end;
                                {ok, NewPS} ->
                                    {ok, NewPS}
                            end;
                        _ ->
                            send_error(Sid, ?FAIL)
                    end
            end;
        _ ->
            send_error(Sid, ?ERRCODE(missing_config))
    end;

%% 穿戴装备
%% pt_17303_[4294970722,1,1] 4294970727
do_handle(17312, PS, [GoodsAutoIdList, Replace, EudemonsId]) ->
    #goods_status{dict = GoodsDict} = GoodsStatus = lib_goods_do:get_goods_status(),
    #player_status{eudemons = EudemonsStatus, id = RoleId, sid = Sid} = PS,
    #eudemons_status{eudemons_list = Items} = EudemonsStatus,
    case lists:keyfind(EudemonsId, #eudemons_item.id, Items) of
        false ->
            send_error(Sid, ?FAIL);
        #eudemons_item{equip_list = EquipList} = Item ->
            case get_all_equip_goodsinfo(GoodsAutoIdList, EudemonsId, GoodsStatus) of
                GoodsInfoList when is_list(GoodsInfoList) andalso GoodsInfoList =/= [] ->   
                    {TakeoffGoods, NewEquipList1} = calc_takeoff_equips(GoodsInfoList, EquipList, GoodsDict, []),
                    F = fun
                        () ->
                            ok = lib_goods_dict:start_dict(),
                            {GoodsStatus2, NewEquipList} = calc_goods_status(Replace, TakeoffGoods, GoodsInfoList, GoodsStatus, EudemonsId, NewEquipList1),
                            #goods_status{dict = OldGoodsDict} = GoodsStatus2,
                            {Dict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
                            NewGoodsStatus = GoodsStatus2#goods_status{dict = Dict},
                            {ok, GoodsL, NewGoodsStatus, GoodsInfoList, NewEquipList}
                    end,
                    case lib_goods_util:transaction(F) of
                        {ok, GoodsL, NewGoodsStatus, GoodsInfoList, NewEquipList} ->
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            
                            % 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                            if
                                TakeoffGoods =/= [] ->
                                    [lib_goods_api:notify_client_num(RoleId, [GoodsInfo1#goods{num=0}]) || GoodsInfo1 <- TakeoffGoods];
                                true ->
                                    skip
                            end,
                            if
                                GoodsInfoList =/= [] ->
                                    [lib_goods_api:notify_client_num(RoleId, [GoodsInfo1#goods{num=0}]) || GoodsInfo1 <- GoodsInfoList];
                                true ->
                                    skip
                            end,
                            % ?PRINT("@@@@@@@@@@@ GoodsL:~p~n",[GoodsL]),
                            lib_goods_api:notify_client(RoleId, GoodsL),
                            NewItem = Item#eudemons_item{equip_list = NewEquipList},
                            {FightChange, NewEudemonsStatus, RefreshItem} = lib_eudemons:update_status(RoleId, EudemonsStatus, NewItem, NewGoodsStatus#goods_status.dict),
                            NewPS = PS#player_status{eudemons = NewEudemonsStatus},
                            {ok, BinData} = pt_173:write(17312, []), %%客户端的需求！！
                            lib_server_send:send_to_sid(Sid, BinData),
                            send_item(Sid, RefreshItem),
                            if
                                FightChange ->
                                    NewPS2 = lib_player:count_player_attribute(NewPS),
                                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                                    {ok, battle_attr, NewPS2};
                                true ->
                                    {ok, NewPS}
                            end;
                        _Err ->

                            send_error(Sid, ?FAIL)
                    end;
                _Err ->
                    send_error(Sid, ?FAIL)
            end
    end;

do_handle(CMD, _PS, Args) ->
    ?ERR("protocol ~p, ~p nomatch ~n", [CMD, Args]).

send_error(Sid, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_173:write(17300, [CodeInt, CodeArgs]),
    % ?PRINT("17300 >>> ~p~n", [Code]),
    lib_server_send:send_to_sid(Sid, BinData).

send_item(Sid, #eudemons_item{id = Id, state = State, score = Score, equip_list = EquipList, equip_attr = EquipAttr}) ->
    {ok, BinData} = pt_173:write(17302, [Id, State, Score, EquipList, EquipAttr]),
    lib_server_send:send_to_sid(Sid, BinData).

calc_takeoff_equips(GoodsInfoList, EquipList, GoodsDict, TakeoffGoods) ->
    F = fun
        (#goods{subtype = Pos}, {TemTakeoffGoods, TemEquipList}) ->
            case lists:keyfind(Pos, 1, TemEquipList) of
                {Pos, GoodsAutoId, _Stren, _} ->
                    case lib_goods_util:get_goods(GoodsAutoId, GoodsDict) of
                        TGoodsInfo when is_record(TGoodsInfo, goods) ->
                            {[TGoodsInfo|TemTakeoffGoods], lists:keydelete(Pos, 1, TemEquipList)};
                        _ ->
                            {TakeoffGoods, TemEquipList}
                    end;
                _ ->
                    {TemTakeoffGoods, TemEquipList}
            end
    end,
    {NewTakeoffGoods, NewEquipList} = lists:foldl(F, {TakeoffGoods, EquipList}, GoodsInfoList),
    {NewTakeoffGoods, lists:reverse(NewEquipList)}.

calc_takeoff_equips(Pos, EquipList, GoodsDict) ->
    F = fun
        ({Position, GoodsAutoId, _Stren, _} = X, {TakeoffGoods, NewEquipList}) ->
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

log_strength(RoleId, MaterialList, GoodsInfo, NewGoodsInfo, CostExp) ->
    #goods{id = AutoId, goods_id = EquipTypeId, other = #goods_other{stren = Stren0, overflow_exp = Exp0}} = GoodsInfo,
    #goods{other = #goods_other{stren = Stren1, overflow_exp = Exp1}} = NewGoodsInfo,
    lib_log_api:log_eudemons_strength(RoleId, AutoId, EquipTypeId, CostExp, Stren0, Exp0, Stren1, Exp1),
    [lib_log_api:log_throw(eudemons_strength_material, RoleId, GoodsId, GoodsTypeId, GoodsNum, Stren, Exp) || #goods{id = GoodsId, num = GoodsNum, goods_id = GoodsTypeId, other = #goods_other{stren = Stren, overflow_exp = Exp}} <- MaterialList].

log_strength(RoleId, CostGoodsInfo, CostNum, GoodsInfo, NewGoodsInfo, CostExp) ->
    #goods{id = AutoId, goods_id = EquipTypeId, other = #goods_other{stren = Stren0, overflow_exp = Exp0}} = GoodsInfo,
    #goods{other = #goods_other{stren = Stren1, overflow_exp = Exp1}} = NewGoodsInfo,
    lib_log_api:log_eudemons_strength(RoleId, AutoId, EquipTypeId, CostExp, Stren0, Exp0, Stren1, Exp1),
    #goods{id = GoodsId, goods_id = GoodsTypeId, other = #goods_other{stren = Stren, overflow_exp = Exp}} = CostGoodsInfo,
    lib_log_api:log_throw(eudemons_strength_material, RoleId, GoodsId, GoodsTypeId, CostNum, Stren, Exp).

check_compose(ComposeId, Material, GoodsStatus) ->
    case data_eudemons:get_compose_cfg(ComposeId) of
        #base_eudemons_compose{material = MaterialListCfg, cnum = Cnum, reward = RewardListCfg, num = Num} ->
            Length = erlang:length(Material),
            Reward = urand:get_rand_list_repeat(Num, RewardListCfg),
            % {_, GoodsTypeId} = urand:rand_with_weight(RewardListCfg),
            RealReward = get_reward(Reward,[]),
            Res = check_compose_helper(Material, MaterialListCfg, GoodsStatus, []),
            CheckRes = case Res of
                {true, _} ->
                    true;
                _ ->
                    1
            end,
            if
                Length =/= Cnum ->
                    {false, ?ERRCODE(err173_wrong_num)};
                RealReward == [] ->
                    {false, ?ERRCODE(missing_config)};
                CheckRes =/= true ->
                    Res;
                true ->
                    {true, CostGoodsInfoList} = Res,
                    {true, RealReward, CostGoodsInfoList}
            end;
        _ ->
            {false, ?ERRCODE(missing_config)}
    end.

check_compose_helper([], _MaterialListCfg, _GoodsStatus, GoodsInfoList) -> {true, GoodsInfoList};
check_compose_helper([H|T], MaterialListCfg, GoodsStatus, GoodsInfoList) ->
    GoodsInfo = lib_goods_util:get_goods(H, GoodsStatus#goods_status.dict),
    if
        is_record(GoodsInfo, goods) =:= false ->
            {false, ?ERRCODE(err150_no_goods)};
        GoodsInfo#goods.player_id =/= GoodsStatus#goods_status.player_id ->
            {false, ?ERRCODE(err150_palyer_err)};
        %% 戒指手镯允许使用身上的作为材料进行合成
        GoodsInfo#goods.type =/= ?GOODS_TYPE_EUDEMONS
        orelse GoodsInfo#goods.location =/= GoodsInfo#goods.bag_location ->
            {false, ?ERRCODE(err150_location_err)};
        true ->
            GtypeId = GoodsInfo#goods.goods_id,
            case lists:member(GtypeId, MaterialListCfg) of
                true -> %% 默认是不叠加物品！
                    check_compose_helper(T, MaterialListCfg, GoodsStatus, [{GoodsInfo, GoodsInfo#goods.num}|GoodsInfoList]);
                false ->
                    {false, ?ERRCODE(err173_wrong_material)}
            end
    end.

get_reward([], NewList) -> NewList;
get_reward([H|T], RealReward) ->
    NewList = case H of
        {_, GoodsTypeId} ->
            case data_goods_type:get(GoodsTypeId) of
                #ets_goods_type{subtype = Pos} -> [{?TYPE_GOODS, GoodsTypeId, Pos, 1}|RealReward];
                _ -> RealReward
            end;
        _ ->
            RealReward
    end,
    get_reward(T, NewList).
    
get_all_equip_goodsinfo(GoodsAutoIdList, EudemonsId, GoodsStatus) ->
    Fun = fun(GoodsAutoId, Acc) ->
        case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
            #goods{location = ?GOODS_LOC_EUDEMONS_BAG, subtype = Pos, type = ?GOODS_TYPE_EUDEMONS} = GoodsInfo ->
                case lists:keyfind(Pos, #goods.subtype, Acc) of
                    #goods{} -> Acc;
                    _ ->
                        case lib_eudemons:check_equip(EudemonsId, GoodsInfo) of
                            true -> [GoodsInfo|Acc];
                            _ -> Acc
                        end
                end; 
            _ ->
                Acc
        end
    end,
    lists:foldl(Fun, [], GoodsAutoIdList).

calc_goods_status(Replace, TakeoffGoods, EquipGoodsinfoList, GoodsStatus, EudemonsId, EquipList) ->
    Fun = fun(Egoods, {GoodsStatusTmp, Acc}) when is_record(Egoods, goods) ->
        #goods{
            id = GoodsAutoId, 
            subtype = Pos,
            other = #goods_other{stren = OStren, overflow_exp = OExp}
        } = Egoods,
        case lists:keyfind(Pos, #goods.subtype, TakeoffGoods) of
            #goods{other = #goods_other{stren = Stren, overflow_exp = Exp} = Other} = Tgoods ->
                if
                    Replace == 1 ->
                        {NewStren, NewExp} = lib_eudemons:calc_equip_stren(Pos, Stren, OStren, Exp, OExp),
                        GoodsInfo = Egoods#goods{other = Other#goods_other{stren = NewStren, overflow_exp = NewExp}},
                        NewAcc = lists:keystore(Pos, 1, Acc, {Pos, GoodsAutoId, NewStren, NewExp}),
                                    
                        OldGoodsInfo = Tgoods#goods{other = Other#goods_other{stren = 0, overflow_exp = 0, optional_data = []}},
                        lib_eudemons:change_goods_other(OldGoodsInfo),
                        [_OldGoodsInfo1, GoodsStatus1] = lib_goods:change_goods_cell(OldGoodsInfo, ?GOODS_LOC_EUDEMONS_BAG, 0, GoodsStatusTmp),

                        DressGoodsInfo = lib_eudemons:dress_on_equips(GoodsInfo, EudemonsId),
                        lib_eudemons:change_goods_other(DressGoodsInfo),
                        [_GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(DressGoodsInfo, ?GOODS_LOC_EUDEMONS, Pos, GoodsStatus1),

                        {GoodsStatus2, NewAcc};
                    true ->
                        NewAcc = lists:keystore(Pos, 1, Acc, {Pos, GoodsAutoId, OStren, OExp}),

                        OldGoodsInfo = Tgoods#goods{other = Other#goods_other{optional_data = []}},
                        lib_eudemons:change_goods_other(OldGoodsInfo),
                        [_OldGoodsInfo1, GoodsStatus1] = lib_goods:change_goods_cell(OldGoodsInfo, ?GOODS_LOC_EUDEMONS_BAG, 0, GoodsStatusTmp),

                        DressGoodsInfo = lib_eudemons:dress_on_equips(Egoods, EudemonsId),
                        lib_eudemons:change_goods_other(DressGoodsInfo),
                        [_GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(DressGoodsInfo, ?GOODS_LOC_EUDEMONS, Pos, GoodsStatus1),

                        {GoodsStatus2, NewAcc}
                end;
            _ ->
                DressGoodsInfo = lib_eudemons:dress_on_equips(Egoods, EudemonsId),
                lib_eudemons:change_goods_other(DressGoodsInfo),
                [_GoodsInfo1, GoodsStatus2] = lib_goods:change_goods_cell(DressGoodsInfo, ?GOODS_LOC_EUDEMONS, Pos, GoodsStatusTmp),

                NewAcc = lists:keystore(Pos, 1, Acc, {Pos, GoodsAutoId, OStren, OExp}),
                {GoodsStatus2, NewAcc}
        end;
        (_,{GoodsStatusTmp, Acc}) -> {GoodsStatusTmp, Acc}
    end,
    {NewGoodsStatus, NewEquipList} = lists:foldl(Fun, {GoodsStatus, EquipList}, EquipGoodsinfoList),
    {NewGoodsStatus, NewEquipList}.
