-module(pt_401).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(40101, _) ->
    {ok, []};
read(40102, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        <<Num:32, _Args2/binary>> = _Args1, 
        {{GoodsId, Num},_Args2}
        end,
    {DonateList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [DonateList]};
read(40103, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<TypeId:32, Bin2/binary>> = Bin1, 
    <<Num:32, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, TypeId, Num]};
read(40104, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {DepotGids, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [DepotGids]};
read(40109, Bin0) ->
    <<Stage:8, Bin1/binary>> = Bin0, 
    <<Color:8, Bin2/binary>> = Bin1, 
    <<Star:8, _Bin3/binary>> = Bin2, 
    {ok, [Stage, Color, Star]};
read(40110, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (40100,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(40100, Data)};

write (40101,[
    DepotScore,
    ExchangeRecords,
    DepotGoods
]) ->
    BinList_ExchangeRecords = [
        item_to_bin_0(ExchangeRecords_Item) || ExchangeRecords_Item <- ExchangeRecords
    ], 

    ExchangeRecords_Len = length(ExchangeRecords), 
    Bin_ExchangeRecords = list_to_binary(BinList_ExchangeRecords),

    BinList_DepotGoods = [
        item_to_bin_5(DepotGoods_Item) || DepotGoods_Item <- DepotGoods
    ], 

    DepotGoods_Len = length(DepotGoods), 
    Bin_DepotGoods = list_to_binary(BinList_DepotGoods),

    Data = <<
        DepotScore:32,
        ExchangeRecords_Len:16, Bin_ExchangeRecords/binary,
        DepotGoods_Len:16, Bin_DepotGoods/binary
    >>,
    {ok, pt:pack(40101, Data)};

write (40102,[
    ErrorCode,
    DepotScore
]) ->
    Data = <<
        ErrorCode:32,
        DepotScore:32
    >>,
    {ok, pt:pack(40102, Data)};

write (40103,[
    ErrorCode,
    DepotScore
]) ->
    Data = <<
        ErrorCode:32,
        DepotScore:32
    >>,
    {ok, pt:pack(40103, Data)};

write (40104,[
    ErrorCode,
    OpType,
    DepotNum
]) ->
    Data = <<
        ErrorCode:32,
        OpType:8,
        DepotNum:32
    >>,
    {ok, pt:pack(40104, Data)};

write (40105,[
    DepotGoods
]) ->
    BinList_DepotGoods = [
        item_to_bin_10(DepotGoods_Item) || DepotGoods_Item <- DepotGoods
    ], 

    DepotGoods_Len = length(DepotGoods), 
    Bin_DepotGoods = list_to_binary(BinList_DepotGoods),

    Data = <<
        DepotGoods_Len:16, Bin_DepotGoods/binary
    >>,
    {ok, pt:pack(40105, Data)};

write (40106,[
    DepotGoods
]) ->
    BinList_DepotGoods = [
        item_to_bin_15(DepotGoods_Item) || DepotGoods_Item <- DepotGoods
    ], 

    DepotGoods_Len = length(DepotGoods), 
    Bin_DepotGoods = list_to_binary(BinList_DepotGoods),

    Data = <<
        DepotGoods_Len:16, Bin_DepotGoods/binary
    >>,
    {ok, pt:pack(40106, Data)};

write (40107,[
    ExchangeRecords
]) ->
    BinList_ExchangeRecords = [
        item_to_bin_16(ExchangeRecords_Item) || ExchangeRecords_Item <- ExchangeRecords
    ], 

    ExchangeRecords_Len = length(ExchangeRecords), 
    Bin_ExchangeRecords = list_to_binary(BinList_ExchangeRecords),

    Data = <<
        ExchangeRecords_Len:16, Bin_ExchangeRecords/binary
    >>,
    {ok, pt:pack(40107, Data)};

write (40108,[
    Change
]) ->
    Data = <<
        Change:8
    >>,
    {ok, pt:pack(40108, Data)};



write (40110,[
    Stage,
    Color,
    Star
]) ->
    Data = <<
        Stage:8,
        Color:8,
        Star:8
    >>,
    {ok, pt:pack(40110, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    RoleName,
    ExchangeType,
    GoodsId,
    TypeId,
    Color,
    Rating,
    OverallRating,
    AdditionAttrlist,
    EquipExtraAttr,
    StoneList,
    WashAttr,
    SuitLv,
    SuitSlv,
    SuitCount,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    BinList_AdditionAttrlist = [
        item_to_bin_1(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_EquipExtraAttr = [
        item_to_bin_2(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_StoneList = [
        item_to_bin_3(StoneList_Item) || StoneList_Item <- StoneList
    ], 

    StoneList_Len = length(StoneList), 
    Bin_StoneList = list_to_binary(BinList_StoneList),

    BinList_WashAttr = [
        item_to_bin_4(WashAttr_Item) || WashAttr_Item <- WashAttr
    ], 

    WashAttr_Len = length(WashAttr), 
    Bin_WashAttr = list_to_binary(BinList_WashAttr),

    Data = <<
        Id:32,
        Bin_RoleName/binary,
        ExchangeType:8,
        GoodsId:64,
        TypeId:32,
        Color:8,
        Rating:32,
        OverallRating:32,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        StoneList_Len:16, Bin_StoneList/binary,
        WashAttr_Len:16, Bin_WashAttr/binary,
        SuitLv:8,
        SuitSlv:16,
        SuitCount:8,
        Time:32
    >>,
    Data.
item_to_bin_1 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_2 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
item_to_bin_3 ({
    Pos,
    TypeId
}) ->
    Data = <<
        Pos:8,
        TypeId:32
    >>,
    Data.
item_to_bin_4 ({
    Index,
    Color,
    AttrId,
    AttrVal
}) ->
    Data = <<
        Index:8,
        Color:8,
        AttrId:16,
        AttrVal:32
    >>,
    Data.
item_to_bin_5 ({
    GoodsId,
    TypeId,
    GoodsNum,
    Color,
    Rating,
    OverallRating,
    AdditionAttrlist,
    EquipExtraAttr,
    StoneList,
    WashAttr,
    SuitLv,
    SuitSlv,
    SuitCount
}) ->
    BinList_AdditionAttrlist = [
        item_to_bin_6(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_EquipExtraAttr = [
        item_to_bin_7(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_StoneList = [
        item_to_bin_8(StoneList_Item) || StoneList_Item <- StoneList
    ], 

    StoneList_Len = length(StoneList), 
    Bin_StoneList = list_to_binary(BinList_StoneList),

    BinList_WashAttr = [
        item_to_bin_9(WashAttr_Item) || WashAttr_Item <- WashAttr
    ], 

    WashAttr_Len = length(WashAttr), 
    Bin_WashAttr = list_to_binary(BinList_WashAttr),

    Data = <<
        GoodsId:64,
        TypeId:32,
        GoodsNum:32,
        Color:8,
        Rating:32,
        OverallRating:32,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        StoneList_Len:16, Bin_StoneList/binary,
        WashAttr_Len:16, Bin_WashAttr/binary,
        SuitLv:8,
        SuitSlv:16,
        SuitCount:8
    >>,
    Data.
item_to_bin_6 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_7 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
item_to_bin_8 ({
    Pos,
    TypeId
}) ->
    Data = <<
        Pos:8,
        TypeId:32
    >>,
    Data.
item_to_bin_9 ({
    Index,
    Color,
    AttrId,
    AttrVal
}) ->
    Data = <<
        Index:8,
        Color:8,
        AttrId:16,
        AttrVal:32
    >>,
    Data.
item_to_bin_10 ({
    GoodsId,
    TypeId,
    GoodsNum,
    Color,
    Rating,
    OverallRating,
    AdditionAttrlist,
    EquipExtraAttr,
    StoneList,
    WashAttr,
    SuitLv,
    SuitSlv,
    SuitCount
}) ->
    BinList_AdditionAttrlist = [
        item_to_bin_11(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_EquipExtraAttr = [
        item_to_bin_12(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_StoneList = [
        item_to_bin_13(StoneList_Item) || StoneList_Item <- StoneList
    ], 

    StoneList_Len = length(StoneList), 
    Bin_StoneList = list_to_binary(BinList_StoneList),

    BinList_WashAttr = [
        item_to_bin_14(WashAttr_Item) || WashAttr_Item <- WashAttr
    ], 

    WashAttr_Len = length(WashAttr), 
    Bin_WashAttr = list_to_binary(BinList_WashAttr),

    Data = <<
        GoodsId:64,
        TypeId:32,
        GoodsNum:32,
        Color:8,
        Rating:32,
        OverallRating:32,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        StoneList_Len:16, Bin_StoneList/binary,
        WashAttr_Len:16, Bin_WashAttr/binary,
        SuitLv:8,
        SuitSlv:16,
        SuitCount:8
    >>,
    Data.
item_to_bin_11 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_12 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
item_to_bin_13 ({
    Pos,
    TypeId
}) ->
    Data = <<
        Pos:8,
        TypeId:32
    >>,
    Data.
item_to_bin_14 ({
    Index,
    Color,
    AttrId,
    AttrVal
}) ->
    Data = <<
        Index:8,
        Color:8,
        AttrId:16,
        AttrVal:32
    >>,
    Data.
item_to_bin_15 ({
    GoodsId,
    Num
}) ->
    Data = <<
        GoodsId:64,
        Num:32
    >>,
    Data.
item_to_bin_16 ({
    Id,
    RoleName,
    ExchangeType,
    GoodsId,
    TypeId,
    Color,
    Rating,
    OverallRating,
    AdditionAttrlist,
    EquipExtraAttr,
    StoneList,
    WashAttr,
    SuitLv,
    SuitSlv,
    SuitCount,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    BinList_AdditionAttrlist = [
        item_to_bin_17(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_EquipExtraAttr = [
        item_to_bin_18(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_StoneList = [
        item_to_bin_19(StoneList_Item) || StoneList_Item <- StoneList
    ], 

    StoneList_Len = length(StoneList), 
    Bin_StoneList = list_to_binary(BinList_StoneList),

    BinList_WashAttr = [
        item_to_bin_20(WashAttr_Item) || WashAttr_Item <- WashAttr
    ], 

    WashAttr_Len = length(WashAttr), 
    Bin_WashAttr = list_to_binary(BinList_WashAttr),

    Data = <<
        Id:32,
        Bin_RoleName/binary,
        ExchangeType:8,
        GoodsId:64,
        TypeId:32,
        Color:8,
        Rating:32,
        OverallRating:32,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        StoneList_Len:16, Bin_StoneList/binary,
        WashAttr_Len:16, Bin_WashAttr/binary,
        SuitLv:8,
        SuitSlv:16,
        SuitCount:8,
        Time:32
    >>,
    Data.
item_to_bin_17 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_18 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
item_to_bin_19 ({
    Pos,
    TypeId
}) ->
    Data = <<
        Pos:8,
        TypeId:32
    >>,
    Data.
item_to_bin_20 ({
    Index,
    Color,
    AttrId,
    AttrVal
}) ->
    Data = <<
        Index:8,
        Color:8,
        AttrId:16,
        AttrVal:32
    >>,
    Data.
