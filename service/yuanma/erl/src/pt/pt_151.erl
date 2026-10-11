-module(pt_151).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15101, Bin0) ->
    <<Type:32, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(15102, Bin0) ->
    <<Type:32, Bin1/binary>> = Bin0, 
    <<Subtype:32, Bin2/binary>> = Bin1, 
    <<Stage:8, Bin3/binary>> = Bin2, 
    <<Star:8, Bin4/binary>> = Bin3, 
    <<Color:8, _Bin5/binary>> = Bin4, 
    {ok, [Type, Subtype, Stage, Star, Color]};
read(15104, Bin0) ->
    {GoodsName, _Bin1} = pt:read_string(Bin0), 
    {ok, [GoodsName]};
read(15105, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<TypeId:32, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, TypeId]};
read(15106, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<GoodsNum:32, Bin2/binary>> = Bin1, 
    <<Price:32, Bin3/binary>> = Bin2, 
    <<IsShout:8, _Bin4/binary>> = Bin3, 
    {ok, [GoodsId, GoodsNum, Price, IsShout]};
read(15108, Bin0) ->
    <<SellType:8, Bin1/binary>> = Bin0, 
    <<Id:64, Bin2/binary>> = Bin1, 
    <<TypeId:32, Bin3/binary>> = Bin2, 
    <<GoodsNum:32, _Bin4/binary>> = Bin3, 
    {ok, [SellType, Id, TypeId, GoodsNum]};
read(15109, _) ->
    {ok, []};
read(15111, Bin0) ->
    <<SellType:8, Bin1/binary>> = Bin0, 
    <<Id:64, Bin2/binary>> = Bin1, 
    <<Type:32, Bin3/binary>> = Bin2, 
    <<Subtype:32, Bin4/binary>> = Bin3, 
    <<SellerId:64, Bin5/binary>> = Bin4, 
    <<TypeId:32, Bin6/binary>> = Bin5, 
    <<GoodsNum:32, Bin7/binary>> = Bin6, 
    <<UnitPrice:32, _Bin8/binary>> = Bin7, 
    {ok, [SellType, Id, Type, Subtype, SellerId, TypeId, GoodsNum, UnitPrice]};
read(15112, _) ->
    {ok, []};
read(15114, _) ->
    {ok, []};
read(15115, Bin0) ->
    <<TypeId:32, Bin1/binary>> = Bin0, 
    <<GoodsNum:32, Bin2/binary>> = Bin1, 
    <<UnitPrice:32, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, GoodsNum, UnitPrice]};
read(15116, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(15117, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<BuyerId:64, Bin2/binary>> = Bin1, 
    <<TypeId:32, Bin3/binary>> = Bin2, 
    <<GoodsNum:32, Bin4/binary>> = Bin3, 
    <<Price:32, _Bin5/binary>> = Bin4, 
    {ok, [Id, BuyerId, TypeId, GoodsNum, Price]};
read(15118, Bin0) ->
    <<PageNo:16, Bin1/binary>> = Bin0, 
    <<PageSize:16, _Bin2/binary>> = Bin1, 
    {ok, [PageNo, PageSize]};
read(15119, _) ->
    {ok, []};
read(15121, _) ->
    {ok, []};
read(15122, Bin0) ->
    <<SellId:64, _Bin1/binary>> = Bin0, 
    {ok, [SellId]};
read(_Cmd, _R) -> {error, no_match}.

write (15100,[
    Errcode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Errcode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(15100, Data)};

write (15101,[
    Type,
    SellList
]) ->
    BinList_SellList = [
        item_to_bin_0(SellList_Item) || SellList_Item <- SellList
    ], 

    SellList_Len = length(SellList), 
    Bin_SellList = list_to_binary(BinList_SellList),

    Data = <<
        Type:32,
        SellList_Len:16, Bin_SellList/binary
    >>,
    {ok, pt:pack(15101, Data)};

write (15102,[
    Type,
    Subtype,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_1(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Type:32,
        Subtype:32,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15102, Data)};

write (15104,[
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_3(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15104, Data)};

write (15105,[
    GoodsId,
    Type,
    RecommendPrice
]) ->
    Data = <<
        GoodsId:64,
        Type:8,
        RecommendPrice:32
    >>,
    {ok, pt:pack(15105, Data)};

write (15106,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15106, Data)};

write (15108,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15108, Data)};

write (15109,[
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_5(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15109, Data)};

write (15111,[
    Errcode,
    SellType,
    Id,
    Type,
    Subtype
]) ->
    Data = <<
        Errcode:32,
        SellType:8,
        Id:64,
        Type:32,
        Subtype:32
    >>,
    {ok, pt:pack(15111, Data)};

write (15112,[
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_7(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(15112, Data)};

write (15114,[
    TimesList
]) ->
    BinList_TimesList = [
        item_to_bin_9(TimesList_Item) || TimesList_Item <- TimesList
    ], 

    TimesList_Len = length(TimesList), 
    Bin_TimesList = list_to_binary(BinList_TimesList),

    Data = <<
        TimesList_Len:16, Bin_TimesList/binary
    >>,
    {ok, pt:pack(15114, Data)};

write (15115,[
    Errcode,
    Id,
    PlayerId,
    RoleName,
    TypeId,
    GoodsNum,
    UnitPrice,
    Time
]) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Errcode:32,
        Id:64,
        PlayerId:64,
        Bin_RoleName/binary,
        TypeId:32,
        GoodsNum:16,
        UnitPrice:32,
        Time:32
    >>,
    {ok, pt:pack(15115, Data)};

write (15116,[
    Errcode,
    Id
]) ->
    Data = <<
        Errcode:32,
        Id:64
    >>,
    {ok, pt:pack(15116, Data)};

write (15117,[
    Errcode,
    Id,
    GoodsNum
]) ->
    Data = <<
        Errcode:32,
        Id:64,
        GoodsNum:32
    >>,
    {ok, pt:pack(15117, Data)};

write (15118,[
    PageTotal,
    PageNo,
    PageSize,
    SeekList
]) ->
    BinList_SeekList = [
        item_to_bin_10(SeekList_Item) || SeekList_Item <- SeekList
    ], 

    SeekList_Len = length(SeekList), 
    Bin_SeekList = list_to_binary(BinList_SeekList),

    Data = <<
        PageTotal:16,
        PageNo:16,
        PageSize:16,
        SeekList_Len:16, Bin_SeekList/binary
    >>,
    {ok, pt:pack(15118, Data)};

write (15119,[
    SeekList
]) ->
    BinList_SeekList = [
        item_to_bin_11(SeekList_Item) || SeekList_Item <- SeekList
    ], 

    SeekList_Len = length(SeekList), 
    Bin_SeekList = list_to_binary(BinList_SeekList),

    Data = <<
        SeekList_Len:16, Bin_SeekList/binary
    >>,
    {ok, pt:pack(15119, Data)};

write (15120,[
    SellType,
    Type,
    Subtype,
    Id
]) ->
    Data = <<
        SellType:8,
        Type:32,
        Subtype:32,
        Id:64
    >>,
    {ok, pt:pack(15120, Data)};

write (15121,[
    OpenTime
]) ->
    Data = <<
        OpenTime:32
    >>,
    {ok, pt:pack(15121, Data)};

write (15122,[
    Errcode,
    SellId,
    CdTime
]) ->
    Data = <<
        Errcode:32,
        SellId:64,
        CdTime:32
    >>,
    {ok, pt:pack(15122, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Subtype,
    SellNum
}) ->
    Data = <<
        Subtype:32,
        SellNum:32
    >>,
    Data.
item_to_bin_1 ({
    Id,
    PlayerId,
    TypeId,
    GoodsNum,
    Rating,
    OverallRating,
    UnitPrice,
    SellType,
    EquipExtraAttr
}) ->
    BinList_EquipExtraAttr = [
        item_to_bin_2(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Id:64,
        PlayerId:64,
        TypeId:32,
        GoodsNum:32,
        Rating:32,
        OverallRating:32,
        UnitPrice:32,
        SellType:8,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
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
    Id,
    PlayerId,
    TypeId,
    GoodsNum,
    Rating,
    OverallRating,
    UnitPrice,
    SellType,
    EquipExtraAttr
}) ->
    BinList_EquipExtraAttr = [
        item_to_bin_4(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Id:64,
        PlayerId:64,
        TypeId:32,
        GoodsNum:32,
        Rating:32,
        OverallRating:32,
        UnitPrice:32,
        SellType:8,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    Data.
item_to_bin_4 ({
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
item_to_bin_5 ({
    Id,
    PlayerId,
    TypeId,
    GoodsNum,
    Rating,
    OverallRating,
    UnitPrice,
    SellType,
    EquipExtraAttr
}) ->
    BinList_EquipExtraAttr = [
        item_to_bin_6(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Id:64,
        PlayerId:64,
        TypeId:32,
        GoodsNum:32,
        Rating:32,
        OverallRating:32,
        UnitPrice:32,
        SellType:8,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    Data.
item_to_bin_6 ({
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
item_to_bin_7 ({
    TypeId,
    GoodsNum,
    Rating,
    OverallRating,
    Type,
    Tax,
    Price,
    Time,
    EquipExtraAttr
}) ->
    BinList_EquipExtraAttr = [
        item_to_bin_8(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        TypeId:32,
        GoodsNum:32,
        Rating:32,
        OverallRating:32,
        Type:8,
        Tax:32,
        Price:32,
        Time:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    Data.
item_to_bin_8 ({
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
item_to_bin_9 ({
    Type,
    Times,
    TimesLimit
}) ->
    Data = <<
        Type:8,
        Times:8,
        TimesLimit:8
    >>,
    Data.
item_to_bin_10 ({
    Id,
    SerId,
    ServerNum,
    PlayerId,
    RoleName,
    TypeId,
    GoodsNum,
    UnitPrice,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        Id:64,
        SerId:64,
        ServerNum:64,
        PlayerId:64,
        Bin_RoleName/binary,
        TypeId:32,
        GoodsNum:16,
        UnitPrice:32,
        Time:32
    >>,
    Data.
item_to_bin_11 ({
    Id,
    TypeId,
    GoodsNum,
    UnitPrice,
    Time
}) ->
    Data = <<
        Id:64,
        TypeId:32,
        GoodsNum:16,
        UnitPrice:32,
        Time:32
    >>,
    Data.
