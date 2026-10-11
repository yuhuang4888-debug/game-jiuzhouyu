%%-----------------------------------------------------------------------------
%% @Module  :       lib_seal.erl
%% @Author  :
%% @Email   :
%% @Created :       2019-03-02
%% @Description:    圣印
%%-----------------------------------------------------------------------------

-module(lib_seal).

-include("server.hrl").
-include("seal.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("errcode.hrl").
-include("def_goods.hrl").
-include("def_fun.hrl").
-include("figure.hrl").
-include("predefine.hrl").

-export([
    login/3,
    send_seal_info/1,
    stren_seal_pos/3,
    dress_on_equip/2,
    dress_off_seal_equip/2,
    send_seal_bead_info/1,
    apply_seal_bead/3,
    send_rating/1,
    look_over_suit_info/2,
    get_seal_equip_num/1,
    up_equip_list_af_compose/2
]).

-export([
    calc_equip_dynamic_attr/2,
    cal_equip_rating/2,
    calc_over_all_rating/1,
    get_total_attr/1
]).

-export([
    change_goods_other/1,
    format_other_data/1,
    make_goods_other/2
]).

-export([
    gm_add_equip/3
]).

%% -----------------------------------------------------------------
%% @desc    功能描述 面板信息
%% -----------------------------------------------------------------
send_seal_info(PS) ->
    #player_status{sid = Sid, seal_status = SealStatus} = PS,
    #seal_status{equip_list = EquipList} = SealStatus,
    {ok, BinData} = pt_654:write(65401, [EquipList]),
    lib_server_send:send_to_sid(Sid, BinData).

%% -----------------------------------------------------------------
%% @desc    功能描述 圣印装备位置强化
%% -----------------------------------------------------------------
stren_seal_pos(Player, Pos, StrenType) ->
    #player_status{
        id = PlayerId, figure = #figure{name = Name}, seal_status = #seal_status{ equip_list = EquipList }
    } = Player,
    #goods_status{ dict = GoodsDict, seal_stren_list = SealStrenList} = GoodsStatus = lib_goods_do:get_goods_status(),
    case lists:keyfind(Pos, 1, EquipList) of
        {Pos, GoodsAutoId, _Stren} ->
            GoodsInfo = lib_goods_util:get_goods(GoodsAutoId, GoodsDict),
            OldSealbl = lib_goods_api:get_currency(Player, ?GOODS_ID_SEAL),
            case do_stren_seal_pos(Player, GoodsInfo, StrenType) of
                {NewPlayer, NewGoodsInfo, NewStren} ->
                    TransGoodsStatus = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{location, [?GOODS_LOC_SEAL_EQUIP]}]),
                    Fun = fun() ->
                        ok = lib_goods_dict:start_dict(),
                        {NewGoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(TransGoodsStatus#goods_status.dict),
                        LastGoodsDict = lib_goods_dict:add_dict_goods(NewGoodsInfo, NewGoodsDict),
                        NewStrenList = lists:keystore(Pos, 1, SealStrenList, {Pos, NewStren}),
                        db:execute(io_lib:format(?seal_replace_other, [PlayerId, Pos, NewStren])),
                        NewGoodsStatus = TransGoodsStatus#goods_status{ dict = LastGoodsDict, seal_stren_list = NewStrenList },
                        {ok, NewGoodsStatus, GoodsL}
                    end,
                    case lib_goods_util:transaction(Fun) of
                        {ok, TransNewGoodsStatus, GoodsL} ->
                            NewGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(TransNewGoodsStatus, TransGoodsStatus, GoodsStatus),
                            lib_goods_do:set_goods_status(NewGoodsStatus),
                            lib_goods_api:notify_client_num(PlayerId, GoodsL),
                            lib_achievement_api:async_event(PlayerId, lib_achievement_api, seal_stren_event, NewGoodsStatus#goods_status.seal_stren_list),
                            pack(PlayerId, 65402, [Pos, NewStren]),
                            NewSealbl = lib_goods_api:get_currency(NewPlayer, ?GOODS_ID_SEAL),
                            log_strength(PlayerId, Name, GoodsInfo, NewGoodsInfo, OldSealbl - NewSealbl),
                            NewPS2 = lib_player:count_player_attribute(NewPlayer),
                            lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                            {ok, battle_attr, NewPS2}
                    end;
                {_NewPlayer, ErrorCode} ->
                    send_error(PlayerId, ErrorCode)
            end;
        _ ->
            send_error(PlayerId, ?FAIL)
    end.

do_stren_seal_pos(PlayerStatus, GoodsInfo, StrenType) ->
    #player_status{seal_status = SealStatus} = PlayerStatus,
    #goods{cell = Pos, other = #goods_other{stren = Ostren}=Other} = GoodsInfo,
    #seal_status{equip_list = EquipList} = SealStatus,
    case lists:keyfind(Pos, 1, EquipList) of
        {Pos, _, Streng} -> skip;
        _ -> Streng = 0
    end,
    Strength = max(Ostren, Streng), %% 修复数据用
    case check_strength(GoodsInfo) of
        {true, StrenLimit} ->
            case calc_stren_core(PlayerStatus, Pos, Strength, StrenLimit, StrenType) of
                {false, _Code, NewPs, NewStren} ->
                    if
                        Strength < NewStren ->
                            Res = NewStren;
                        true ->
                            Res = {false, _Code}
                    end;
                {true, NewPs, NewStren} ->
                    Res = NewStren
            end,
            case Res of
                {false, TemCode} ->
                    {NewPs, TemCode};
                TNewStren ->
                    PS = updata_seal_status(NewPs, [{stren, {Pos, NewStren}}]), %% 更新数据
                    {PS, GoodsInfo#goods{other = Other#goods_other{stren = TNewStren}}, NewStren}
            end;
        Code ->
            {PlayerStatus, Code}
    end.

%% 强化检测当前装备强化等级上限
check_strength(GoodsInfo) ->
    if
        is_record(GoodsInfo, goods) =:= false ->
            ?ERRCODE(err150_no_goods);
        GoodsInfo#goods.location =/= ?GOODS_LOC_SEAL_EQUIP ->
            ?FAIL;
        true ->
            #goods{goods_id = GoodTypeId, other = #goods_other{stren = Strength}} = GoodsInfo,
            case data_seal:get_seal_equip_info(GoodTypeId) of
                #base_seal_equip{strong = StrenLimit} when Strength < StrenLimit ->
                    {true, StrenLimit};
                _ ->
                    ?ERRCODE(err654_strength_level_limit)
            end
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 穿戴圣印装备
%% -----------------------------------------------------------------
dress_on_equip(Player, GoodsAutoId) ->
    #player_status{ id = PlayerId, seal_status = #seal_status{equip_list = EquipList} } = Player,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lib_goods_util:get_goods(GoodsAutoId, GoodsStatus#goods_status.dict) of
        #goods{location = Location, type = ?GOODS_TYPE_SEAL, subtype = Pos, other = Other} = GoodsInfo when Location == ?GOODS_LOC_SEAL ->
            case lists:keyfind(Pos, 1, EquipList) of
                {Pos, _OldGoodsAutoId, StrenLevel} -> ok;
                _ -> StrenLevel = 0
            end,
            TakeoffGoods = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
            GoodsStatusBfTrans = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{location, [?GOODS_LOC_SEAL_EQUIP, ?GOODS_LOC_SEAL]}]),
            Fun = fun() ->
                ok = lib_goods_dict:start_dict(),
                do_seal_equip_dress_on(TakeoffGoods, GoodsStatusBfTrans, GoodsInfo, StrenLevel, Pos)
            end,
            case lib_goods_util:transaction(Fun) of
                {ok, GoodsL, TransNewGoodsStatus} ->
                    NewGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(TransNewGoodsStatus, GoodsStatusBfTrans, GoodsStatus),
                    Fun2 = fun(#goods{id = GoodsId} = Goods, Acc) ->
                        case lists:keyfind(GoodsId, #goods.id, Acc) of
                            #goods{} ->
                                Acc;
                            _E ->
                                [Goods|Acc]
                        end
                    end,
                    NewGoodsL = lists:foldl(Fun2, [], GoodsL),
                    lib_goods_do:set_goods_status(NewGoodsStatus),
                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                    if
                        TakeoffGoods =/= [] ->
                            [lib_goods_api:notify_client_num(PlayerId, [GoodsInfo1#goods{num=0}]) || GoodsInfo1 <- TakeoffGoods];
                        true ->
                            skip
                    end,
                    lib_goods_api:notify_client_num(PlayerId, [GoodsInfo#goods{num=0}]),
                    lib_goods_api:notify_client(PlayerId, NewGoodsL),
                    NewPlayer= updata_seal_status(Player, [{chang_equip, {NewGoodsStatus}}]),
                    pack(PlayerId, 65403, []),   %%客户端的需求！！
                    AttrPlayer = lib_player:count_player_attribute(NewPlayer),
                    SealEquipList = AttrPlayer#player_status.seal_status#seal_status.equip_list,
                    Num = erlang:length(SealEquipList),
                    lib_task_api:seal_set_num(AttrPlayer, Num),
                    EquipGoodsInfos = [lib_goods_api:get_goods_info(EqSealId, NewGoodsStatus)||{_, EqSealId, _}<-SealEquipList],
                    {ok, NewPlayer2} = lib_eternal_valley_api:trigger(AttrPlayer, {seal_status, EquipGoodsInfos}),
                    {ok, NewPlayer3} = lib_temple_awaken_api:trigger_seal_status(NewPlayer2, EquipGoodsInfos),
                    {ok, NewPlayer4} = lib_grow_welfare_api:trigger_seal_status(NewPlayer3, EquipGoodsInfos),
                    {ok, LastPlayer} = lib_custom_the_carnival:trigger_seal_rating(NewPlayer4, NewPlayer4#player_status.seal_status#seal_status.rating),
                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                    send_seal_info(LastPlayer),
                    {ok, battle_attr, LastPlayer};
                _Err ->
                    send_error(PlayerId, ?FAIL)
            end;
        #goods{location = ?GOODS_LOC_SEAL_EQUIP, type = ?GOODS_TYPE_SEAL} ->
            send_error(PlayerId, ?ERRCODE(err654_has_equiped));
        _ ->
            send_error(PlayerId, ?FAIL)
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 脱下圣印装备
%% -----------------------------------------------------------------
dress_off_seal_equip(Player, Pos) ->
    #player_status{ id = PlayerId, seal_status = #seal_status{equip_list = EquipList} } = Player,
    GoodsStatus = lib_goods_do:get_goods_status(),
    case lists:keyfind(Pos, 1, EquipList) of
        false ->
            send_error(PlayerId, ?FAIL);
        {Pos, _GoodsAutoId, _StrenLv} ->
            TakeOffGoodsInfos = calc_takeoff_equips(Pos, EquipList, GoodsStatus#goods_status.dict),
            if
                TakeOffGoodsInfos == [] ->
                    send_error(PlayerId, ?FAIL);
                true ->
                    CellNum = lib_goods_util:get_null_cell_num(GoodsStatus, ?GOODS_LOC_SEAL),
                    if
                        CellNum < length(TakeOffGoodsInfos) ->
                            send_error(PlayerId, ?ERRCODE(err150_seal_no_cell));
                        true ->
                            TransGoodsStatus = lib_goods_util:make_goods_status_in_transaction(GoodsStatus, [{location, [?GOODS_LOC_SEAL]}]),
                            Fun = fun() ->
                                ok = lib_goods_dict:start_dict(),
                                do_dress_off(TakeOffGoodsInfos, TransGoodsStatus)
                            end,
                            case lib_goods_util:transaction(Fun) of
                                {ok, GoodsL, NewTransGoodsStatus} ->
                                    NewGoodsStatus = lib_goods_util:restore_goods_status_out_transaction(NewTransGoodsStatus, TransGoodsStatus, GoodsStatus),
                                    lib_goods_do:set_goods_status(NewGoodsStatus),
                                    %% 此处通知客户端将材料装备从背包位置中移除不会从服务端删除物品
                                    [lib_goods_api:notify_client_num(PlayerId, [GoodsInfo#goods{num=0}]) || GoodsInfo <- TakeOffGoodsInfos],
                                    lib_goods_api:notify_client(PlayerId, GoodsL),
                                    NewPlayer = updata_seal_status(Player, [{chang_equip, {NewGoodsStatus}}]),
                                    pack(PlayerId, 65404, []),
                                    LastPlayer= lib_player:count_player_attribute(NewPlayer),
                                    lib_player:send_attribute_change_notify(LastPlayer, ?NOTIFY_ATTR),
                                    send_seal_info(LastPlayer),
                                    {ok, battle_attr, LastPlayer};
                                _ ->
                                    send_error(PlayerId, ?FAIL)
                            end
                    end
            end
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 圣魂丹界面信息(影装影魂)
%% -----------------------------------------------------------------
send_seal_bead_info(Player) ->
    #player_status{
        seal_status = #seal_status{pill_map = PillMap}, figure = #figure{lv = PlayerLv}, id = PlayerId
    } = Player,
    PillList = maps:to_list(PillMap),
    F = fun({GoodsTypeId, SealPill}, Acc) ->
        case SealPill of
            #seal_pill{goods_id = GoodsTypeId, total_num = TotalNum}->
                case data_seal:get_seal_pill_limit(GoodsTypeId, PlayerLv) of
                    Limit when is_integer(Limit) ->
                        Limit;
                    _ ->
                        Limit = 0
                end,
                [{GoodsTypeId, TotalNum, Limit}|Acc];
            _ ->
                Acc
        end
    end,
    SendList = lists:foldl(F, [], PillList),
    pack(PlayerId, 65405, [SendList]).

%% -----------------------------------------------------------------
%% @desc    功能描述 使用圣魂丹(影装影魂)
%% -----------------------------------------------------------------
apply_seal_bead(Player, GoodsTypeId, Num) ->
    #player_status{
        seal_status = SealStatus, id = PlayerId, figure = #figure{lv = PlayerLv, name = PlayerName}
    } = Player,
    #seal_status{pill_map = PillMap} = SealStatus,
    Limit = case data_seal:get_seal_pill_limit(GoodsTypeId, PlayerLv) of
                Limit0 when is_integer(Limit0) -> Limit0;
                _ -> 0
            end,
    ListCfg = case data_seal:get_per_add_attr(GoodsTypeId) of
                  ListCfg0 when is_list(ListCfg0) -> ListCfg0;
                  _ -> []
              end,
    Type = case data_goods_type:get(GoodsTypeId) of
               #ets_goods_type{ type = Type0 } -> Type0;
               _ -> 38
           end,
    case maps:get(GoodsTypeId, PillMap, []) of
        #seal_pill{total_num = TotalNum, attr = Attr} = Pill ->
            if
                TotalNum + Num =< Limit ->
                    F = fun({AttrKey, Value}) ->
                        {AttrKey, Value * Num}
                    end,
                    AddAttr = lists:map(F, ListCfg),
                    Code = 0,
                    %% 日志
                    lib_log_api:log_seal_pill(PlayerId, PlayerName, GoodsTypeId, TotalNum, TotalNum + Num, [{Type, GoodsTypeId, Num}]),
                    Cost = [{Type, GoodsTypeId, Num}],
                    NewPill = Pill#seal_pill{total_num = TotalNum+Num, attr = AddAttr ++ Attr};
                TotalNum + Num > Limit andalso Limit - TotalNum > 0  ->
                    F = fun({AttrKey, Value}) ->
                        {AttrKey, Value * (Limit - TotalNum)}
                    end,
                    AddAttr = lists:map(F, ListCfg),
                    Code = 0,
                    Cost = [{Type, GoodsTypeId, Limit - TotalNum}],
                    %% 日志
                    lib_log_api:log_seal_pill(PlayerId, PlayerName, GoodsTypeId, TotalNum, Limit, [{Type, GoodsTypeId, Limit - TotalNum}]),
                    NewPill = Pill#seal_pill{total_num = Limit, attr = AddAttr ++ Attr};
                true ->
                    Code = ?ERRCODE(err654_pill_lv_limit),
                    Cost = [],
                    NewPill = Pill
            end;
        _ ->
            if
                Num =< Limit ->
                    F = fun({AttrKey, Value}) ->
                        {AttrKey, Value * Num}
                        end,
                    AddAttr = lists:map(F, ListCfg),
                    Code = 0,
                    Cost = [{Type, GoodsTypeId, Num}],
                    %% 日志
                    lib_log_api:log_seal_pill(PlayerId, PlayerName, GoodsTypeId, 0, Num, [{Type, GoodsTypeId, Num}]),
                    NewPill = #seal_pill{goods_id = GoodsTypeId, total_num = Num, attr = AddAttr};
                Num > Limit ->
                    F = fun({AttrKey, Value}) ->
                        {AttrKey, Value * Num}
                        end,
                    AddAttr = lists:map(F, ListCfg),
                    %% 日志
                    lib_log_api:log_seal_pill(PlayerId, PlayerName, GoodsTypeId, 0, Limit, [{Type, GoodsTypeId, Limit}]),
                    Code = 0,
                    Cost = [{Type, GoodsTypeId, Limit}],
                    NewPill = #seal_pill{goods_id = GoodsTypeId, total_num = Limit, attr = AddAttr}
            end
    end,
    if
        Code == 0 andalso Cost =/= [] ->
            [{_, GoodsTypeId, CostNum}|_] = Cost,
            case lib_goods_api:cost_object_list_with_check(Player, [{0, GoodsTypeId, CostNum}], seal_pill, "") of
                {true, NewPs} ->
                    db:execute(io_lib:format(?seal_replace, [PlayerId, GoodsTypeId, NewPill#seal_pill.total_num])),
                    NewPillMap = maps:put(GoodsTypeId, NewPill, PillMap),
                    TotalPillAttr = get_pill_total_attr(NewPillMap),
                    NewSealS = SealStatus#seal_status{pill_map = NewPillMap, pill_attr = TotalPillAttr},
                    NewPS = NewPs#player_status{seal_status = NewSealS},
                    NewPS2 = lib_player:count_player_attribute(NewPS),
                    lib_player:send_attribute_change_notify(NewPS2, ?NOTIFY_ATTR),
                    pack(PlayerId, 65406, [GoodsTypeId, CostNum, Code]),
                    {ok, battle_attr, NewPS2};
                {false, Code1, _NewPs} ->
                    pack(PlayerId, 65406, [GoodsTypeId, 0, Code1])
            end;
        true ->
            pack(PlayerId, 65406, [GoodsTypeId, 0, Code])
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 获取总评分
%% -----------------------------------------------------------------
send_rating(Player) ->
    #player_status{id = PlayerId, seal_status = SealStatus} = Player,
    #seal_status{rating = Rating} = SealStatus,
    pack(PlayerId, 65407, [Rating]).

%% -----------------------------------------------------------------
%% @desc    功能描述 套装预览
%% -----------------------------------------------------------------
look_over_suit_info(Player, GoodsTypeId) ->
    #player_status{ id = PlayerId } = Player,
    GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
    case GoodsTypeInfo of
        #ets_goods_type{type = ?GOODS_TYPE_SEAL, subtype = Subtype} ->
            GoodsStatus = lib_goods_do:get_goods_status(),
            {SendList, Code} = calc_suit_info_preview(Player, GoodsStatus, GoodsTypeId, Subtype),
            pack(PlayerId, 65408, [SendList, Code]);
        _ ->
            pack(PlayerId, 65408, [[], ?ERRCODE(err654_wrong_data)])
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 计算获取圣印装备的套装数量
%% -----------------------------------------------------------------
get_seal_equip_num(Player) ->
    #player_status{id = PlayerId, seal_status = SealStatus} = Player,
    #seal_status{suit_info = NSuitInfo} = SealStatus,
    Fun = fun({SuitId, _, _, RealNum, _, _, _}, Acc) ->
        {SuitId, OldRealNum} = ulists:keyfind(SuitId, 1, Acc, {SuitId, 0}),
        case RealNum >= OldRealNum of
            true ->
                lists:keystore(SuitId, 1, Acc, {SuitId, RealNum});
            _ ->
                Acc
        end
    end,
    SendList = lists:foldl(Fun, [], NSuitInfo),
    pack(PlayerId, 65409, [SendList]).


%% -----------------------------------------------------------------
%% @desc    功能描述 物品生成时，计算物品的极品属性
%% -----------------------------------------------------------------
calc_equip_dynamic_attr(GoodsTypeInfo, GoodsOther) ->
    #ets_goods_type{goods_id = GoodsId} = GoodsTypeInfo,
    case data_seal:get_seal_equip_info(GoodsId) of
        #base_seal_equip{base_attr = BaseAttr, extra_attr = ExtraAttrCfg} ->
            ExtraAttr = BaseAttr ++ ExtraAttrCfg,
            BaseRating = cal_equip_rating(GoodsTypeInfo, ExtraAttr),
            GoodsOther#goods_other{rating = BaseRating, extra_attr = []};
        _ ->
            GoodsOther
    end.

%% -----------------------------------------------------------------
%% @desc    功能描述 登录初始化
%% -----------------------------------------------------------------
login(RoleId, _RoleLv, GoodsStatus) ->
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SEAL_EQUIP, GoodsDict),
    {EquipList, AllEquipAttr} = calc_equip_list(EquipGoodsList),
    List = db:get_all(io_lib:format(?seal_select, [RoleId])),
    Fun = fun([GoodsTypeId, Num], {TemMap, TemAllAttr}) ->
        case data_seal:get_per_add_attr(GoodsTypeId) of
            ListCfg when is_list(ListCfg) ->skip;
            _ -> ListCfg = []
        end,
        F = fun({AttrKey, Value}) ->
            {AttrKey, Value * Num}
            end,
        PerAttrList = lists:map(F, ListCfg),
        Spill = #seal_pill{goods_id = GoodsTypeId, total_num = Num, attr = PerAttrList},
        NewAttrList = ulists:kv_list_plus_extra([TemAllAttr, PerAttrList]),
        {maps:put(GoodsTypeId, Spill, TemMap), NewAttrList}
    end,
    {PillMap, PillAttr} = lists:foldl(Fun, {#{}, []}, List),
    Fun1 = fun({Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr}, {TemMaps, TemList, TemStrenAttr, TemSuitInfo, TemRating}) ->
        PosItem = #seal_pos{pos = Pos, type_id = GoodsTypeId, goods_id = Id, strong = Strength, rating = BaseRating, attr = ExtraAttr},
        NewTemMaps = maps:put(Pos, PosItem, TemMaps),
        case data_seal:get_seal_strong_info(Pos, Strength) of
            #base_seal_strong{add_attr = StrenAttrCfg} ->
                StrenAttrCfg;
            _ ->
                StrenAttrCfg = []
        end,
        %% 统计每件装备的套装信息
        SuitInfo = calc_suit_info_2(GoodsTypeId, TemSuitInfo),
        NewAttrList = ulists:kv_list_plus_extra([StrenAttrCfg, TemStrenAttr]),
        {NewTemMaps, [{Pos, Id, Strength}|TemList], NewAttrList, SuitInfo, TemRating + BaseRating}
    end,
    {PosMap, NEquipList, StrenAttr, NSuitInfo, EquipRating} = lists:foldl(Fun1, {#{}, [], [], [], 0}, EquipList),
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    {SuitAttr, SuitRating} = calc_suit_attr_rating(RealSuitInfo),
    #seal_status{	pos_map = PosMap,
        pill_map = PillMap,
        equip_list = NEquipList,
        stren_attr = StrenAttr,
        equip_attr = AllEquipAttr,
        pill_attr = PillAttr,
        suit_info = RealSuitInfo, %% {color,stage,num}
        suit_attr = SuitAttr,
        rating = EquipRating + SuitRating}.

%% -----------------------------------------------------------------
%% @desc    功能描述 合成装备
%% -----------------------------------------------------------------
up_equip_list_af_compose(PS, GoodsStatus) ->
    #player_status{seal_status = SealStatus, id = RoleId} = PS,
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SEAL_EQUIP, GoodsDict),
    {EquipList, AllEquipAttr} = calc_equip_list(EquipGoodsList),
    Fun1 = fun({Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr}, {TemMaps, TemList, TemStrenAttr, TemSuitInfo, TemRating}) ->
        PosItem = #seal_pos{pos = Pos, type_id = GoodsTypeId, goods_id = Id, strong = Strength, rating = BaseRating, attr = ExtraAttr},
        NewTemMaps = maps:put(Pos, PosItem, TemMaps),
        case data_seal:get_seal_strong_info(Pos, Strength) of
            #base_seal_strong{add_attr = StrenAttrCfg} ->
                StrenAttrCfg;
            _ ->
                StrenAttrCfg = []
        end,
        SuitInfo = calc_suit_info_2(GoodsTypeId, TemSuitInfo),
        NewAttrList = ulists:kv_list_plus_extra([StrenAttrCfg, TemStrenAttr]),
        {NewTemMaps, [{Pos, Id, Strength}|TemList], NewAttrList, SuitInfo, TemRating + BaseRating}
    end,
    {PosMap, NEquipList, StrenAttr, NSuitInfo, EquipRating} = lists:foldl(Fun1, {#{}, [], [], [], 0}, EquipList),
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    {SuitAttr, SuitRating} = calc_suit_attr_rating(RealSuitInfo),
    NewSealStatus = SealStatus#seal_status{
        pos_map = PosMap,
        equip_list = NEquipList,
        stren_attr = StrenAttr,
        equip_attr = AllEquipAttr,
        suit_info = RealSuitInfo, %% {color,stage,num}
        suit_attr = SuitAttr,
        rating = EquipRating + SuitRating},
    PS#player_status{seal_status = NewSealStatus}.

%% -----------------------------------------------------------------
%% @desc    功能描述 计算装备的评分
%% -----------------------------------------------------------------
cal_equip_rating(GoodsTypeInfo, _EquipExtraAttr) when is_record(GoodsTypeInfo, ets_goods_type) ->
    #ets_goods_type{goods_id = GoodsTypeId, base_attrlist = BaseAttr, level = Level} = GoodsTypeInfo,
    case data_seal:get_seal_equip_info(GoodsTypeId) of
        #base_seal_equip{base_attr = BaseAttrCfg, extra_attr = ExtraAttrCfg} ->
            ExtraAttr = BaseAttrCfg ++ ExtraAttrCfg;
        _ ->
            ExtraAttr = []
    end,
    cal_equip_rating_core(BaseAttr ++ ExtraAttr, Level);
cal_equip_rating(_, _) ->
    0.

cal_equip_rating_core(AttrList, Level) ->
    Fun = fun(OneExtraAttr, RatingTmp) ->
        case OneExtraAttr of
            {OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrVal} ->
                %% 策划说这里固定写死按5阶来算百分比属性
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                RatingTmp + OneAttrRating * OneAttrVal;
            {_Color, OneAttrId, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus} ->
                %%chenyiming  成长属性公式 =  附属属性推算战力——成长类属性=(装备穿戴等级/X*Y+基础值)*单位属性战力
                OneAttrRating = data_attr:get_attr_base_rating(OneAttrId, 10),
                GrowthAttrRealVal = data_attr:growth_attr2real_val(Level, OneAttrBaseVal, OneAttrPlusInterval, OneAttrPlus),
                RatingTmp + OneAttrRating * GrowthAttrRealVal;
            _ ->
                RatingTmp
        end
    end,
    Rating = lists:foldl(Fun, 0, AttrList),
    round(Rating).

%% -----------------------------------------------------------------
%% @desc    功能描述 计算总评分
%% -----------------------------------------------------------------
calc_over_all_rating(GoodsInfo) ->
    #goods_other{
        stren = Stren, rating = Rating
    } = GoodsInfo#goods.other,
    case data_seal:get_seal_equip_info(GoodsInfo#goods.goods_id) of
        #base_seal_equip{ strong = StrenLimit } ->
            FixStrenLv = ?IF( Stren =< StrenLimit, Stren, StrenLimit),
            case data_seal:get_seal_strong_info(GoodsInfo#goods.subtype, FixStrenLv) of
                #base_seal_strong{add_attr = StrenAttr} ->
                    TempInfo = data_goods_type:get(GoodsInfo#goods.goods_id),
                    Rating + cal_equip_rating(TempInfo, StrenAttr);
                _ ->
                    Rating
            end;
        _ ->
            Rating
    end.

%% 强化信息保存数据库
change_goods_other(#goods{id = Id} = GoodsInfo) ->
    lib_goods_util:change_goods_other(Id, format_other_data(GoodsInfo)).

%% 物品other_data的保存格式
format_other_data(#goods{type = ?GOODS_TYPE_SEAL, other = Other}) ->
    #goods_other{stren = Strength} = Other,
    [?GOODS_OTHER_KEY_SEAL, Strength];
format_other_data(_) -> [].

%% 物品将数据库里other_data的数据转化到#goods_other里面
make_goods_other(Other, [Strength|_]) ->
    Other#goods_other{stren = Strength}.

%% 脱下装备处理强化等级
takeoff_equips(EquipGoodsList) ->
    [GoodsInfo#goods{other = Other#goods_other{stren = 0}} || #goods{other = Other} = GoodsInfo <- EquipGoodsList].

%%更新ps里的圣印信息
updata_seal_status(PS, []) ->
    PS;
updata_seal_status(PlayerStatus, [{chang_equip, {GoodsStatus}}|T]) ->
    #player_status{id = RoleId, seal_status = SealStatus} = PlayerStatus,
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SEAL_EQUIP, GoodsDict),
    {EquipList, AllEquipAttr} = calc_equip_list(EquipGoodsList),
    Fun1 = fun({Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr}, {TemMaps, TemList, TemStrenAttr, TemSuitInfo, TemRating, TemGtypes}) ->
        PosItem = #seal_pos{pos = Pos, type_id = GoodsTypeId, goods_id = Id, strong = Strength, rating = BaseRating, attr = ExtraAttr},
        NewTemMaps = maps:put(Pos, PosItem, TemMaps),
        case data_seal:get_seal_strong_info(Pos, Strength) of
            #base_seal_strong{add_attr = StrenAttrCfg} ->
                StrenAttrCfg;
            _ ->
                StrenAttrCfg = []
        end,
        %% 统计每件装备的套装信息
        SuitInfo = calc_suit_info_2(GoodsTypeId, TemSuitInfo),
        NewAttrList = ulists:kv_list_plus_extra([TemStrenAttr, StrenAttrCfg]),
        {NewTemMaps, [{Pos, Id, Strength}|TemList], NewAttrList, SuitInfo, TemRating + BaseRating, [GoodsTypeId|TemGtypes]}
    end,
    {PosMap, NEquipList, StrenAttr, NSuitInfo, EquipRating, GoodsTypeIds} = lists:foldl(Fun1, {#{}, [], [], [], 0, []}, EquipList),
    Fun2 = fun(GoodsTypeId, Acc) ->
        case data_seal:get_seal_equip_info(GoodsTypeId) of
            #base_seal_equip{stage = Stage,color = Color} ->
                [{Color, Stage}|Acc];
            _ ->
                Acc
        end
    end,
    AchivList = lists:foldl(Fun2, [], GoodsTypeIds),
    lib_achievement_api:async_event(RoleId, lib_achievement_api, seal_equip_event, AchivList),
    %% 每件装备按照基础属性评分排序由大到小
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    %% 套装计算
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    {SuitAttr, SuitRating} = calc_suit_attr_rating(RealSuitInfo),
    NewSealStatus = SealStatus#seal_status{
        pos_map = PosMap,
        equip_list = NEquipList,
        stren_attr = StrenAttr,
        equip_attr = AllEquipAttr,
        suit_info = RealSuitInfo, %% {color,stage,num}
        suit_attr = SuitAttr,
        rating = EquipRating + SuitRating},
    NewPs = PlayerStatus#player_status{seal_status = NewSealStatus},
    updata_seal_status(NewPs, T);
updata_seal_status(PlayerStatus, [{stren, {Pos, NewStren}}|T]) ->
    #player_status{seal_status = SealStatus} = PlayerStatus,
    #seal_status{equip_list = EquipList, stren_attr = StrenAttr} = SealStatus,
    case lists:keyfind(Pos, 1, EquipList) of
        {Pos, GoodsAutoId, Stren} ->
            case data_seal:get_seal_strong_info(Pos, Stren) of
                #base_seal_strong{add_attr = StrenAttrCfg} ->
                    StrenAttrCfg;
                _ ->
                    StrenAttrCfg = []
            end,
            case data_seal:get_seal_strong_info(Pos, NewStren) of
                #base_seal_strong{add_attr = NewStrenAttrCfg} ->
                    NewStrenAttrCfg;
                _ ->
                    NewStrenAttrCfg = []
            end,
            NewEquipList = lists:keystore(Pos, 1, EquipList, {Pos, GoodsAutoId, NewStren}),
            AddAttr = calc_stren_attr(StrenAttrCfg, NewStrenAttrCfg),
            NewStrenAttr = ulists:kv_list_plus_extra([StrenAttr, AddAttr]),
            NewSealStatus = SealStatus#seal_status{equip_list = NewEquipList, stren_attr = NewStrenAttr};
        _ ->
            NewSealStatus = SealStatus
    end,
    NewPs = PlayerStatus#player_status{seal_status = NewSealStatus},
    updata_seal_status(NewPs, T).

%%普通强化，强化一次
calc_stren_core(PlayerStatus, Pos, Stren, _StrenLimit, StrenType) when StrenType == 0 ->
    case data_seal:get_seal_strong_info(Pos, Stren+1) of
        #base_seal_strong{cost = Cost} ->
            case lib_goods_api:cost_object_list_with_check(PlayerStatus, Cost,  seal_stren, "") of
                {false, _Code, _NewPs} ->
                    {false, _Code, _NewPs, Stren};
                {true, NewPs} ->
                    {true, NewPs, Stren+1}
            end;
        _ ->
            {false, ?ERRCODE(err654_strength_level_limit), PlayerStatus, Stren}
    end;
%自动强化，强化到强化材料不足
calc_stren_core(PlayerStatus, Pos, Stren, StrenLimit, _StrenType) when Stren < StrenLimit ->
    case data_seal:get_seal_strong_info(Pos, Stren+1) of
        #base_seal_strong{cost = Cost} ->
            case lib_goods_api:cost_object_list_with_check(PlayerStatus, Cost, seal_stren, "") of
                {false, _Code, _NewPs} ->
                    {false, _Code, _NewPs, Stren};
                {true, NewPs} ->
                    calc_stren_core(NewPs, Pos, Stren+1, StrenLimit, _StrenType)
            end;
        _ ->
            {false, ?ERRCODE(err654_strength_level_limit), PlayerStatus, Stren}
    end;
calc_stren_core(PlayerStatus, _Pos, StrenLimit, StrenLimit, _StrenType) ->
    {true, PlayerStatus, StrenLimit}.

%%依据穿戴装备列表计算数据
calc_equip_list(EquipGoodsList) ->
    Fun = fun(GoodsInfo, {Acc, TemEquipAttr}) ->
        #goods{
            id = Id, goods_id = GoodsTypeId, other = #goods_other{stren = Strength, rating = BaseRating, extra_attr = _ExtraAttr}, subtype = Pos
        } = GoodsInfo,
        case data_seal:get_seal_equip_info(GoodsTypeId) of
            #base_seal_equip{base_attr = BaseAttr, extra_attr = ExtraAttrCfg} ->
                ExtraAttr = BaseAttr ++ ExtraAttrCfg;
            _ ->
                ExtraAttr = []
        end,
        NewAttr = ulists:kv_list_plus_extra([TemEquipAttr, ExtraAttr]),
        {[{Pos, Id, GoodsTypeId, Strength, BaseRating, ExtraAttr}|Acc], NewAttr}
    end,
    lists:foldl(Fun, {[], []}, EquipGoodsList).

%% 统计每件装备的套装信息
calc_suit_info_2(GoodsTypeId, TemSuitInfo) ->
    case data_seal:get_seal_equip_info(GoodsTypeId) of
        #base_seal_equip{pos = Pos, suit = SuitId, base_attr = Attr, stage = Stage, color = Color} when SuitId =/= 0 ->
            GoodsTypeInfo = data_goods_type:get(GoodsTypeId),
            #ets_goods_type{level = Level} = GoodsTypeInfo,
            %% 计算每一件装备的基础属性评分
            Rating = cal_equip_rating_core(Attr, Level),
            case data_seal:get_seal_suit_info(SuitId) of
                #base_seal_suit{suit_type = SuitType} ->
                    [{Rating, SuitId, SuitType, GoodsTypeId, Stage, Color, Pos}|TemSuitInfo];
                _ ->
                    SuitType = case data_seal:get_seal_value(5) of
                                   [List] when is_list(List) -> calc_suit_type(Pos, List);
                                   _ -> false
                               end,
                    case SuitType of
                        Integer when is_integer(Integer) ->
                            %% 尽管这件装备没有套装id配置（没套装）也要计算。套装可以兼容
                            [{Rating, 0, SuitType, GoodsTypeId, Stage, Color, Pos}|TemSuitInfo];
                        _ ->
                            TemSuitInfo
                    end
            end;
        _ ->
            TemSuitInfo
    end.

calc_suit_type(_, []) ->
    false;
calc_suit_type(Pos, [{SuitType, PosList}|List]) ->
    case lists:member(Pos, PosList) of
        true -> SuitType;
        _ -> calc_suit_type(Pos, List)
    end.

hand_suit_info_2(SuitInfo) ->
    %% 按套装类型分类
    {RatingSuitInfo1, RatingSuitInfo2} = sort_diff_suit(SuitInfo, {[],[]}),
    %% 2类套装分别计算
    SuitInfoList1 = hand_suit_info_2_helper(RatingSuitInfo1, []),
    hand_suit_info_2_helper(RatingSuitInfo2, SuitInfoList1).

%% 套装计算核心逻辑
%% {Rating, SuitId, SuitType, GoodsTypeId, Stage, Color, Pos}
%% 这里可以做下优化，定义一个record比较好
hand_suit_info_2_helper([], Return) -> Return;
hand_suit_info_2_helper(List, Return) ->
    [{_,_,SuitType,_,_,_, _}|_] = List,
    %% 每个套装类型有不同数量的套装（eg:2/4/6件套）属性
    NumList = get_suit_num_cfg(SuitType),
    % 之前的排序代码并非全排列，可能是考虑性能问题，因此会有漏掉的组合
    % 将评分最高的装备放在前面可以避免这个问题，保证取到的一定是当前最高评分的套装
    SortedList = lists:reverse(lists:keysort(1, List)),
    AllSuitList = [
        begin
        %% 每个数量类型的套装计算所有的排列组合
            CombinationList = combinations(SortedList, Num),
            case calc_suit_core(CombinationList, Num, 0, []) of
                SuitId when is_integer(SuitId) ->
                    {0, Num};
                Tem ->
                    Tem
            end
        end
        || Num <- NumList
    ],
    NewList = lists:filter(
        fun
            ({_, _}) -> false;
            (_) -> true
        end, AllSuitList),
    NewList ++ Return.

calc_suit_core([], Num, SuitId, GoodsIdList) ->
    case data_seal:get_seal_suit_info(SuitId) of
        #base_seal_suit{suit_type = SuitType, attr = Attr, stage = Stage, color = Color} ->
            {SuitId, Color, Stage, Num, Attr, SuitType, GoodsIdList};
        _ ->
            0
    end;
calc_suit_core([H|CombinationList], Num, ResSuitId, OldGoodsIdList) when H =/= [] ->
    SuitId = calc_suit_id(H),   %% 其中最大的
    GoodsTypeIdList = [GoodsTypeId || {_, _, _, GoodsTypeId, _, _, _} <- H],
    case data_seal:get_seal_suit_info(SuitId) of
        #base_seal_suit{attr = Attr} when is_list(Attr) andalso Attr =/= [] ->
            %% 每个计算出来的套装都比较下属性
            case data_seal:get_seal_suit_info(ResSuitId) of
                #base_seal_suit{attr = OldAttr} when is_list(OldAttr) andalso OldAttr =/= [] ->
                    {_, AttrList} = ulists:keyfind(Num, 1, Attr, {Num, [{1,0}]}),
                    {_, OldAttrList} = ulists:keyfind(Num, 1, OldAttr, {Num, [{1,0}]}),
                    %% 筛选出属性数值大的套装
                    {NewSuitId, NewGoodsIdList} = compare_attr(ResSuitId, OldAttrList, OldGoodsIdList, SuitId, AttrList, GoodsTypeIdList),
                    calc_suit_core(CombinationList, Num, NewSuitId, NewGoodsIdList);
                _ ->
                    calc_suit_core(CombinationList, Num, SuitId, GoodsTypeIdList)
            end;
        _ ->
            calc_suit_core(CombinationList, Num, ResSuitId, OldGoodsIdList)
    end.

%% 计算当前组合能激活的套装id
calc_suit_id(List) ->
    %% 先尽量选出一个不为0的套装id
    Val = calc_suit_id_help(List),
    {_, SuitId, _, _, Stage, Color, _} = Val,
    T = lists:delete(Val, List),
    calc_suit_id_core(Stage, Color, SuitId, T).

calc_suit_id_help([{_Rating, SuitId, _SuitType, _GoodsTypeId, _Stage, _Color, _Pos} = Val|_]) when SuitId =/= 0 ->
    Val;
calc_suit_id_help([_|T]) -> calc_suit_id_help(T);
calc_suit_id_help([]) -> {0, 0, 0, 0, 0, 0, 0}.

%% 套装id为0说明这个组合所有部件都不满足套装计算，直接跳过
calc_suit_id_core(_, _, 0, _) -> 0;
calc_suit_id_core(Stage, Color, SuitId, T) ->
    %% 遍历组合中剩下的部件
    Fun = fun({Rating, SuitId1, _, _, _, _, Pos}, TemVal) ->
        %% 套装计算必须是与决定套装部位相同 Stage, Color，对应位置（Pos）的物品
        case data_seal:get_same_pos_equip(Stage, Color, Pos) of
            [TemGoodsTypeId|_] ->
                %% 计算改物品的基础属性评分
                case data_seal:get_seal_equip_info(TemGoodsTypeId) of
                    #base_seal_equip{base_attr = Attr} ->
                        GoodsTypeInfo = data_goods_type:get(TemGoodsTypeId),
                        #ets_goods_type{level = Level} = GoodsTypeInfo,
                        TemRating = cal_equip_rating_core(Attr, Level),
                        if
                            Rating < TemRating -> SuitId1; %% 评分大的决定套装id
                            true -> TemVal
                        end;
                    _ -> 0
                end;
            _ -> 0
        end
    end,
    lists:foldl(Fun, SuitId, T).

%% 只要比较一项属性就行
compare_attr(OldSuitId, OldAttr, OldGoodsIdList, SuitId, Attr, GoodsTypeIdList) ->
    [{_, OldAttrVal}|_] = OldAttr,
    [{_, AttrVal}|_] = Attr,
    if
        OldAttrVal >= AttrVal ->
            {OldSuitId, OldGoodsIdList};
        true ->
            {SuitId, GoodsTypeIdList}
    end.

get_suit_num_cfg(SuitType) ->
    case data_seal:get_seal_value(4) of
        [NumList] ->
            case lists:keyfind(SuitType, 1, NumList) of
                {_, CfgNumList} -> CfgNumList;
                _ -> []
            end;
        _ -> []
    end.

%% 套装分类，11件套装依据配置分成2类套装
sort_diff_suit([], {Acc1, Acc2}) -> {Acc1, Acc2};
sort_diff_suit([{_, _, SuitType, _, _, _, _} = H|T], {Acc1, Acc2}) ->
    Res = if
              SuitType == 0 ->
                  {[H|Acc1], Acc2};
              true ->
                  {Acc1, [H|Acc2]}
          end,
    sort_diff_suit(T, Res).

%计算所有套装的属性及评分
calc_suit_attr_rating(RealSuitInfo) ->
    Fun = fun({SuitId, _Color, _Stage, Num, _, _, _}, {TemAttr, TemScore}) ->
        {Attr, Score} = hand_suit_cfg(SuitId, Num),
        NewAttr = ulists:kv_list_plus_extra([TemAttr, Attr]),
        {NewAttr, Score + TemScore}
          end,
    lists:foldl(Fun, {[], 0}, RealSuitInfo).

%计算单个套装的属性及评分
hand_suit_cfg(SuitId, Num) ->
    case data_seal:get_seal_suit_info(SuitId) of
        #base_seal_suit{attr = AttrCfg, score = _ScoreCfg} ->
            case lists:keyfind(Num, 1, AttrCfg) of
                {_, Attr} -> skip;
                _ -> ?ERR("seal cfg lost, rating lost, Num:~p~n", [Num]), Attr = []
            end,
            Score = cal_equip_rating_core(Attr, 0),
            {Attr, Score};
        _ ->
            ?ERR("seal cfg lost, SuitId:~p~n", [SuitId]),
            {[], 0}
    end.

%汇总圣印总属性
get_total_attr(SealStatus) when is_record(SealStatus, seal_status) ->
    #seal_status{	stren_attr = StrenAttr,
        equip_attr = AllEquipAttr,
        pill_attr = AllPillAttr,
        suit_attr = SuitAttr} = SealStatus,
    StrenAttr ++ AllEquipAttr ++ AllPillAttr ++ SuitAttr;
get_total_attr(Player) ->
    SealStatus = Player#player_status.seal_status,
    get_total_attr(SealStatus).

get_pill_total_attr(PillMap) ->
    PillMapList = maps:to_list(PillMap),
    Fun = fun({GoodsTypeId, #seal_pill{total_num = TotalNum}}, TemAllAttr) ->
        case data_seal:get_per_add_attr(GoodsTypeId) of
            ListCfg when is_list(ListCfg) ->skip;
            _ -> ListCfg = []
        end,
        F = fun({AttrKey, Value}) ->
            {AttrKey, Value * TotalNum}
        end,
        PerAttrList = lists:map(F, ListCfg),
        ulists:kv_list_plus_extra([TemAllAttr, PerAttrList])
    end,
    lists:foldl(Fun, [], PillMapList).

%% 秘籍
gm_add_equip(Status, Stage, Color) ->
    case data_seal:get_all_equip(Stage, Color) of
        GoodsTypeIds when is_list(GoodsTypeIds) andalso GoodsTypeIds =/= [] ->
            Fun = fun(GoodsTypeId, Acc) ->
                [{?TYPE_GOODS, GoodsTypeId, 1}|Acc]
                  end,
            Reward = lists:foldl(Fun, [], GoodsTypeIds),
            lib_goods_api:send_reward_by_id(Reward, gm, Status#player_status.id);
        _->
            skip
    end.

%% StrenAttrCfg1：前一阶强化配置属性，StrenAttrCfg2：当前阶强化配置属性
calc_stren_attr([], StrenAttr) -> StrenAttr;
calc_stren_attr([{Key, Value}|T], StrenAttrCfg2) ->
    case lists:keyfind(Key, 1, StrenAttrCfg2) of
        {Key, Value2} when Value2 >= Value ->
            NewList = lists:keystore(Key, 1, StrenAttrCfg2, {Key, Value2 - Value}),
            calc_stren_attr(T, NewList);
        _ ->
            calc_stren_attr(T, StrenAttrCfg2)
    end.

%% 套装预览
calc_suit_info_preview(PlayerStatus, GoodsStatus, GoodsTypeId, Pos) ->
    #player_status{id = RoleId} = PlayerStatus,
    #goods_status{dict = GoodsDict} = GoodsStatus,
    EquipGoodsList = lib_goods_util:get_goods_list(RoleId, ?GOODS_LOC_SEAL_EQUIP, GoodsDict),
    {EquipList, _AllEquipAttr} = calc_equip_list(EquipGoodsList),
    case lists:keyfind(GoodsTypeId, 3, EquipList) of
        {_, _, GoodsTypeId, _, _, _} ->
            NewEquipList = EquipList;
        _ ->
            NewEquipList1 = lists:keydelete(Pos, 1, EquipList),
            NewEquipList = [{Pos, 0, GoodsTypeId, 0, 0, []}|NewEquipList1]
    end,
    Fun1 = fun({_, _Id, TGoodsTypeId, _Strength, _BaseRating, _ExtraAttr}, TemSuitInfo) ->
        calc_suit_info_2(TGoodsTypeId, TemSuitInfo)
    end,
    NSuitInfo = lists:foldl(Fun1, [], NewEquipList),
    RNSuitInfo = lists:reverse(lists:keysort(1, NSuitInfo)),
    RealSuitInfo = hand_suit_info_2(RNSuitInfo),
    ClientData = make_data_for_client(RNSuitInfo, GoodsTypeId),
    handle_suitinfo_1(RealSuitInfo, ClientData, GoodsTypeId).

make_data_for_client(RNSuitInfo, GoodsTypeId) ->
    case data_seal:get_seal_equip_info(GoodsTypeId) of
        #base_seal_equip{suit = SuitId} ->
            F = fun({_, TemSuitId, _, _, _, _, _}, Num) ->
                case TemSuitId == SuitId of
                    true -> Num+1;
                    _ -> Num
                end
            end,
            Sum = lists:foldl(F, 0, RNSuitInfo),
            [{SuitId, Sum}];
        _ ->
            []
    end.
%% 处理套装信息发送给客户端
handle_suitinfo_1(RealSuitInfo, ClientData, GoodsTypeId) ->
    case data_seal:get_seal_equip_info(GoodsTypeId) of
        #base_seal_equip{suit = SuitId} ->
            case data_seal:get_seal_suit_info(SuitId) of
                #base_seal_suit{suit_type = SuitType} ->
                    Fun = fun({TemSuitId, _Color, _Stage, _Num, _, TemSuitType, GoodsTypeIdList}, {Acc, Code, Tem}) when SuitType == TemSuitType ->
                                  case lists:keyfind(TemSuitId, 1, ClientData) of
                                      {_, Total} when Total > _Num ->
                                          skip;
                                      _ ->
                                          Total = _Num
                                  end,
                                  case lists:member(GoodsTypeId, GoodsTypeIdList) of
                                      true ->
                                          if
                                              TemSuitId == SuitId ->
                                                  {Acc, 1, {TemSuitId, Total}};
                                              true ->
                                                  {[{TemSuitId, Total}|Acc], 1, Tem}
                                          end;
                                      _ ->
                                          if
                                              TemSuitId == SuitId ->
                                                  {Acc, 1, {TemSuitId, Total}};
                                              true ->
                                                  {Acc, Code, Tem}
                                          end
                                  end;
                              ({_SuitId, _Color, _Stage, _Num, _, _, _}, {Acc, Code, Tem}) ->
                                  {Acc, Code, Tem}
                    end,
                    {List, ErrorCode, T} = lists:foldl(Fun, {[], 0, {0, 0}}, RealSuitInfo),
                    case T of
                        {SuitId, _} ->
                            {[T|lists:delete(T, List)], ErrorCode};
                        _ ->
                            {List, ErrorCode}
                    end;
                _ ->
                    {[], ?ERRCODE(missing_config)}
            end;
        _ ->
            {[], ?ERRCODE(missing_config)}
    end.


%% -----------------------------------------------------------------
%% @desc 排列组合，计算列表中选取Num个成员的所有不同组合（各个组合的排序不考虑）
%% @param List 需要排列组合的列表
%% @param Num 选取的元素个数
%% @return ResultList
%% -----------------------------------------------------------------
combinations(List, Num) ->
    Length = length(List),
    if
        Length < Num -> [];
        Length == Num -> [List];
        true -> back_track(List, Num, [], [], 1)
    end.

back_track(_ListA, Num, ResultList, TempList, _Index) when length(TempList) =:= Num ->
    ResultList ++ [TempList];
back_track(ListA, Num, ResultList, TempList, Index) ->
    for(Index, ListA, ResultList, TempList, Num).

for(I, ListA, ResultList, TempList, Num) when I =< length(ListA) ->
    NewTempListA = TempList ++ [lists:nth(I, ListA)],
    NewResultList = back_track(ListA, Num, ResultList, NewTempListA, I + 1),
    NewTempListB = lists:delete(hd(lists:reverse(NewTempListA)), NewTempListA),
    for(I + 1, ListA, NewResultList, NewTempListB, Num);
for(_I, _ListA, ResultList, _TempList, _Num) ->
    ResultList.

%% 发送操作错误码
send_error(PlayerId, Code) ->
    {CodeInt, CodeArgs} = util:parse_error_code(Code),
    {ok, BinData} = pt_654:write(65400, [CodeInt, CodeArgs]),
    lib_server_send:send_to_uid(PlayerId, BinData).

pack(PlayerId, Cmd, Args) ->
    {ok, BinData} = pt_654:write(Cmd, Args),
    lib_server_send:send_to_uid(PlayerId, BinData).

log_strength(RoleId, RoleName, GoodsInfo, NewGoodsInfo, Sealbl) ->
    #goods{id = _AutoId, goods_id = EquipTypeId, other = #goods_other{stren = Stren0}, cell = Pos} = GoodsInfo,
    #goods{other = #goods_other{stren = Stren1}} = NewGoodsInfo,
    Cost = [{?TYPE_CURRENCY, ?GOODS_ID_SEAL, Sealbl}],
    lib_log_api:log_seal_stren(RoleId, RoleName, Pos, EquipTypeId, Stren0, Stren1, Cost).

%% 计算获取脱下的装备物品信息
calc_takeoff_equips(Pos, EquipList, GoodsDict) ->
    F = fun({Position, GoodsAutoId, _Stren}, TakeoffGoods) ->
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
    lists:foldl(F, [], EquipList).

%% 穿戴装备的事务控制流程
do_seal_equip_dress_on(TakeOffGoods, TransGoodsStatus, DressGoodsInfo, DressPosStrenLvl, DressPos) ->
    %% 脱下原来的装备
    if
        TakeOffGoods =/= [] ->
            F2 = fun(GoodsInfo1, GoodsStatusAcc) ->
                [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo1, ?GOODS_LOC_SEAL, 0, GoodsStatusAcc),
                NewGoodsStatusAcc
            end,
            TakeoffEndGoods = takeoff_equips(TakeOffGoods),
            GoodsStatusTmp = lists:foldl(F2, TransGoodsStatus, TakeoffEndGoods);
        true ->
            GoodsStatusTmp = TransGoodsStatus
    end,
    Other = DressGoodsInfo#goods.other,
    DressGoodsInfo2 = DressGoodsInfo#goods{other = Other#goods_other{stren = DressPosStrenLvl}},
    [_GoodsInfo2, GoodsStatus2] = lib_goods:change_goods_cell(DressGoodsInfo2, ?GOODS_LOC_SEAL_EQUIP, DressPos, GoodsStatusTmp),
    #goods_status{dict = OldGoodsDict} = GoodsStatus2,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    NewGoodsStatus = GoodsStatus2#goods_status{dict = GoodsDict},
    {ok, GoodsL, NewGoodsStatus}.



do_dress_off(TakeOffGoodsInfos, TransGoodsStatus) ->
    Fun = fun(GoodsInfo, GoodsStatusAcc) ->
        [_GoodsInfo1, NewGoodsStatusAcc] = lib_goods:change_goods_cell(GoodsInfo, ?GOODS_LOC_SEAL, 0, GoodsStatusAcc),
        NewGoodsStatusAcc
    end,
    TakeoffEndGoods = takeoff_equips(TakeOffGoodsInfos),
    GoodsStatusTmp = lists:foldl(Fun, TransGoodsStatus, TakeoffEndGoods),
    #goods_status{dict = OldGoodsDict} = GoodsStatusTmp,
    {GoodsDict, GoodsL} = lib_goods_dict:handle_dict_and_notify(OldGoodsDict),
    NewGoodsStatus = GoodsStatusTmp#goods_status{dict = GoodsDict},
    {ok, GoodsL, NewGoodsStatus}.
