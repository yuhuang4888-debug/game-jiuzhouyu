-module(pt_149).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14901, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(14902, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(14903, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(14904, Bin0) ->
    <<Cell:8, _Bin1/binary>> = Bin0, 
    {ok, [Cell]};
read(14905, Bin0) ->
    <<Cell:8, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [Cell, Type]};
read(14906, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(14907, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(14908, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (14900,[
    CodeInt,
    CodeMsg
]) ->
    Bin_CodeMsg = pt:write_string(CodeMsg), 

    Data = <<
        CodeInt:32,
        Bin_CodeMsg/binary
    >>,
    {ok, pt:pack(14900, Data)};

write (14901,[
    Res,
    GoodsId,
    OldGoodsId,
    CellPos
]) ->
    Data = <<
        Res:32,
        GoodsId:64,
        OldGoodsId:64,
        CellPos:8
    >>,
    {ok, pt:pack(14901, Data)};

write (14902,[
    Res,
    GoodsId,
    Cell
]) ->
    Data = <<
        Res:32,
        GoodsId:64,
        Cell:16
    >>,
    {ok, pt:pack(14902, Data)};

write (14903,[
    Res,
    NewGoodsId,
    Cell,
    Stage
]) ->
    Data = <<
        Res:32,
        NewGoodsId:64,
        Cell:16,
        Stage:16
    >>,
    {ok, pt:pack(14903, Data)};

write (14904,[
    Res,
    Cell,
    Level,
    Point
]) ->
    Data = <<
        Res:32,
        Cell:8,
        Level:16,
        Point:32
    >>,
    {ok, pt:pack(14904, Data)};

write (14905,[
    Res,
    Res1,
    Type,
    LevelInfo
]) ->
    BinList_LevelInfo = [
        item_to_bin_0(LevelInfo_Item) || LevelInfo_Item <- LevelInfo
    ], 

    LevelInfo_Len = length(LevelInfo), 
    Bin_LevelInfo = list_to_binary(BinList_LevelInfo),

    Data = <<
        Res:32,
        Res1:8,
        Type:8,
        LevelInfo_Len:16, Bin_LevelInfo/binary
    >>,
    {ok, pt:pack(14905, Data)};

write (14906,[
    GoodsId,
    OverallRating,
    EquipExtraAttr
]) ->
    BinList_EquipExtraAttr = [
        item_to_bin_1(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        GoodsId:64,
        OverallRating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    {ok, pt:pack(14906, Data)};

write (14907,[
    GoodsId,
    OverallRating,
    EquipExtraAttr
]) ->
    BinList_EquipExtraAttr = [
        item_to_bin_2(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        GoodsId:64,
        OverallRating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    {ok, pt:pack(14907, Data)};

write (14908,[
    CellList
]) ->
    BinList_CellList = [
        item_to_bin_3(CellList_Item) || CellList_Item <- CellList
    ], 

    CellList_Len = length(CellList), 
    Bin_CellList = list_to_binary(BinList_CellList),

    Data = <<
        CellList_Len:16, Bin_CellList/binary
    >>,
    {ok, pt:pack(14908, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Cell,
    Level,
    Point
}) ->
    Data = <<
        Cell:8,
        Level:16,
        Point:32
    >>,
    Data.
item_to_bin_1 ({
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
item_to_bin_3 (
    Cell
) ->
    Data = <<
        Cell:8
    >>,
    Data.
