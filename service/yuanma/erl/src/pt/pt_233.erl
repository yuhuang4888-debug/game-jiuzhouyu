-module(pt_233).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(23301, _) ->
    {ok, []};
read(23302, Bin0) ->
    <<CourtId:32, _Bin1/binary>> = Bin0, 
    {ok, [CourtId]};
read(23303, Bin0) ->
    <<CourtId:32, Bin1/binary>> = Bin0, 
    <<Pos:8, Bin2/binary>> = Bin1, 
    <<EquipId:64, _Bin3/binary>> = Bin2, 
    {ok, [CourtId, Pos, EquipId]};
read(23304, Bin0) ->
    <<CourtId:32, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [CourtId, Pos]};
read(23305, Bin0) ->
    <<CourtId:32, _Bin1/binary>> = Bin0, 
    {ok, [CourtId]};
read(23306, _) ->
    {ok, []};
read(23307, _) ->
    {ok, []};
read(23308, _) ->
    {ok, []};
read(23309, Bin0) ->
    <<Times:16, _Bin1/binary>> = Bin0, 
    {ok, [Times]};
read(_Cmd, _R) -> {error, no_match}.

write (23300,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(23300, Data)};

write (23301,[
    ItemList
]) ->
    BinList_ItemList = [
        item_to_bin_0(ItemList_Item) || ItemList_Item <- ItemList
    ], 

    ItemList_Len = length(ItemList), 
    Bin_ItemList = list_to_binary(BinList_ItemList),

    Data = <<
        ItemList_Len:16, Bin_ItemList/binary
    >>,
    {ok, pt:pack(23301, Data)};

write (23302,[
    ErrorCode,
    CourtId,
    IsActive
]) ->
    Data = <<
        ErrorCode:32,
        CourtId:32,
        IsActive:8
    >>,
    {ok, pt:pack(23302, Data)};

write (23303,[
    ErrorCode,
    CourtId,
    Pos,
    EquipId
]) ->
    Data = <<
        ErrorCode:32,
        CourtId:32,
        Pos:8,
        EquipId:64
    >>,
    {ok, pt:pack(23303, Data)};

write (23304,[
    ErrorCode,
    CourtId,
    Pos,
    Stage
]) ->
    Data = <<
        ErrorCode:32,
        CourtId:32,
        Pos:8,
        Stage:8
    >>,
    {ok, pt:pack(23304, Data)};

write (23305,[
    ErrorCode,
    CourtId,
    CourtLv
]) ->
    Data = <<
        ErrorCode:32,
        CourtId:32,
        CourtLv:16
    >>,
    {ok, pt:pack(23305, Data)};

write (23306,[
    RewardLv,
    SumNum,
    CrystalColor,
    DailyNum,
    HouseLv,
    HouseExp,
    GrandStatus
]) ->
    BinList_GrandStatus = [
        item_to_bin_3(GrandStatus_Item) || GrandStatus_Item <- GrandStatus
    ], 

    GrandStatus_Len = length(GrandStatus), 
    Bin_GrandStatus = list_to_binary(BinList_GrandStatus),

    Data = <<
        RewardLv:16,
        SumNum:32,
        CrystalColor:8,
        DailyNum:32,
        HouseLv:16,
        HouseExp:16,
        GrandStatus_Len:16, Bin_GrandStatus/binary
    >>,
    {ok, pt:pack(23306, Data)};

write (23307,[
    ErrorCode,
    RewardLv,
    SumNum,
    CrystalColor,
    DailyNum,
    GrandStatus
]) ->
    BinList_GrandStatus = [
        item_to_bin_4(GrandStatus_Item) || GrandStatus_Item <- GrandStatus
    ], 

    GrandStatus_Len = length(GrandStatus), 
    Bin_GrandStatus = list_to_binary(BinList_GrandStatus),

    Data = <<
        ErrorCode:32,
        RewardLv:16,
        SumNum:32,
        CrystalColor:8,
        DailyNum:32,
        GrandStatus_Len:16, Bin_GrandStatus/binary
    >>,
    {ok, pt:pack(23307, Data)};

write (23308,[
    ErrorCode,
    CrystalColor,
    HouseLv,
    HouseExp,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_5(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        ErrorCode:32,
        CrystalColor:8,
        HouseLv:16,
        HouseExp:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(23308, Data)};

write (23309,[
    ErrorCode,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_6(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        ErrorCode:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(23309, Data)};

write (23310,[
    CourtId,
    CourtLv,
    Power,
    Attr,
    IsActive,
    EquipList,
    SuitList
]) ->
    Bin_Attr = pt:write_attr_list(Attr), 

    BinList_EquipList = [
        item_to_bin_7(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    BinList_SuitList = [
        item_to_bin_8(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    Data = <<
        CourtId:32,
        CourtLv:16,
        Power:64,
        Bin_Attr/binary,
        IsActive:8,
        EquipList_Len:16, Bin_EquipList/binary,
        SuitList_Len:16, Bin_SuitList/binary
    >>,
    {ok, pt:pack(23310, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    CourtId,
    CourtLv,
    Power,
    Attr,
    IsActive,
    EquipList,
    SuitList
}) ->
    Bin_Attr = pt:write_attr_list(Attr), 

    BinList_EquipList = [
        item_to_bin_1(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    BinList_SuitList = [
        item_to_bin_2(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    Data = <<
        CourtId:32,
        CourtLv:16,
        Power:64,
        Bin_Attr/binary,
        IsActive:8,
        EquipList_Len:16, Bin_EquipList/binary,
        SuitList_Len:16, Bin_SuitList/binary
    >>,
    Data.
item_to_bin_1 ({
    Pos,
    EquipId,
    Stage
}) ->
    Data = <<
        Pos:8,
        EquipId:64,
        Stage:8
    >>,
    Data.
item_to_bin_2 ({
    Stage,
    Num
}) ->
    Data = <<
        Stage:8,
        Num:16
    >>,
    Data.
item_to_bin_3 ({
    Times,
    Status
}) ->
    Data = <<
        Times:16,
        Status:8
    >>,
    Data.
item_to_bin_4 ({
    Times,
    Status
}) ->
    Data = <<
        Times:16,
        Status:8
    >>,
    Data.
item_to_bin_5 ({
    GoodsType,
    GoodsId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:32,
        GoodsId:64,
        GoodsNum:16
    >>,
    Data.
item_to_bin_6 ({
    GoodsType,
    GoodsId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:32,
        GoodsId:64,
        GoodsNum:16
    >>,
    Data.
item_to_bin_7 ({
    Pos,
    EquipId,
    Stage
}) ->
    Data = <<
        Pos:8,
        EquipId:64,
        Stage:8
    >>,
    Data.
item_to_bin_8 ({
    Stage,
    Num
}) ->
    Data = <<
        Stage:8,
        Num:16
    >>,
    Data.
