-module(pt_177).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17701, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<PutNum:16, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, PutNum]};
read(17702, _) ->
    {ok, []};
read(17703, Bin0) ->
    <<BlockId:32, _Bin1/binary>> = Bin0, 
    {ok, [BlockId]};
read(17704, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, _Bin2/binary>> = Bin1, 
    {ok, [BlockId, HouseId]};
read(17705, _) ->
    {ok, []};
read(17706, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, _Bin2/binary>> = Bin1, 
    {ok, [BlockId, HouseId]};
read(17707, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, Bin2/binary>> = Bin1, 
    <<Type:8, _Bin3/binary>> = Bin2, 
    {ok, [BlockId, HouseId, Type]};
read(17708, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, Bin2/binary>> = Bin1, 
    <<Type:8, _Bin3/binary>> = Bin2, 
    {ok, [BlockId, HouseId, Type]};
read(17710, Bin0) ->
    <<AnswerType:8, _Bin1/binary>> = Bin0, 
    {ok, [AnswerType]};
read(17712, _) ->
    {ok, []};
read(17713, Bin0) ->
    <<LocId:64, Bin1/binary>> = Bin0, 
    <<GoodsTypeId:32, Bin2/binary>> = Bin1, 
    <<Type:8, Bin3/binary>> = Bin2, 
    <<X:16, Bin4/binary>> = Bin3, 
    <<Y:16, Bin5/binary>> = Bin4, 
    <<Face:8, Bin6/binary>> = Bin5, 
    <<MapId:8, Bin7/binary>> = Bin6, 
    <<InsId:64, _Bin8/binary>> = Bin7, 
    {ok, [LocId, GoodsTypeId, Type, X, Y, Face, MapId, InsId]};
read(17714, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, _Bin2/binary>> = Bin1, 
    {ok, [BlockId, HouseId]};
read(17715, _) ->
    {ok, []};
read(17716, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, _Bin2/binary>> = Bin1, 
    {ok, [BlockId, HouseId]};
read(17717, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, _Bin2/binary>> = Bin1, 
    {ok, [BlockId, HouseId]};
read(17719, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, Bin2/binary>> = Bin1, 
    {Text, _Bin3} = pt:read_string(Bin2), 
    {ok, [BlockId, HouseId, Text]};
read(17720, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, Bin2/binary>> = Bin1, 
    <<ThemeId:16, Bin3/binary>> = Bin2, 
    <<FurnitureType:16, _Bin4/binary>> = Bin3, 
    {ok, [BlockId, HouseId, ThemeId, FurnitureType]};
read(17722, _) ->
    {ok, []};
read(17723, _) ->
    {ok, []};
read(17724, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, Bin2/binary>> = Bin1, 
    <<GiftId:32, Bin3/binary>> = Bin2, 
    {WishWord, _Bin4} = pt:read_string(Bin3), 
    {ok, [BlockId, HouseId, GiftId, WishWord]};
read(17726, Bin0) ->
    <<BlockId:32, Bin1/binary>> = Bin0, 
    <<HouseId:32, _Bin2/binary>> = Bin1, 
    {ok, [BlockId, HouseId]};
read(_Cmd, _R) -> {error, no_match}.

write (17701,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17701, Data)};

write (17702,[
    Errcode,
    OwnBlockId,
    OwnHouseId,
    BlockList
]) ->
    BinList_BlockList = [
        item_to_bin_0(BlockList_Item) || BlockList_Item <- BlockList
    ], 

    BlockList_Len = length(BlockList), 
    Bin_BlockList = list_to_binary(BinList_BlockList),

    Data = <<
        Errcode:32,
        OwnBlockId:32,
        OwnHouseId:32,
        BlockList_Len:16, Bin_BlockList/binary
    >>,
    {ok, pt:pack(17702, Data)};

write (17703,[
    Errcode,
    BlockId,
    HouseList
]) ->
    BinList_HouseList = [
        item_to_bin_1(HouseList_Item) || HouseList_Item <- HouseList
    ], 

    HouseList_Len = length(HouseList), 
    Bin_HouseList = list_to_binary(BinList_HouseList),

    Data = <<
        Errcode:32,
        BlockId:32,
        HouseList_Len:16, Bin_HouseList/binary
    >>,
    {ok, pt:pack(17703, Data)};

write (17704,[
    Errcode,
    BlockId,
    HouseId,
    RoleId1,
    Name1,
    RoleId2,
    Name2
]) ->
    Bin_Name1 = pt:write_string(Name1), 

    Bin_Name2 = pt:write_string(Name2), 

    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        RoleId1:64,
        Bin_Name1/binary,
        RoleId2:64,
        Bin_Name2/binary
    >>,
    {ok, pt:pack(17704, Data)};

write (17705,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17705, Data)};

write (17706,[
    Errcode,
    BlockId,
    HouseId,
    Lv,
    Point
]) ->
    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        Lv:16,
        Point:32
    >>,
    {ok, pt:pack(17706, Data)};

write (17707,[
    Errcode,
    BlockId,
    HouseId,
    Type
]) ->
    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        Type:8
    >>,
    {ok, pt:pack(17707, Data)};

write (17708,[
    Errcode,
    BlockId,
    HouseId,
    Type
]) ->
    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        Type:8
    >>,
    {ok, pt:pack(17708, Data)};

write (17709,[
    BlockId,
    HouseId,
    HouseLv,
    RoleId,
    Type,
    CostList,
    FurnitureInsideList
]) ->
    BinList_CostList = [
        item_to_bin_2(CostList_Item) || CostList_Item <- CostList
    ], 

    CostList_Len = length(CostList), 
    Bin_CostList = list_to_binary(BinList_CostList),

    BinList_FurnitureInsideList = [
        item_to_bin_3(FurnitureInsideList_Item) || FurnitureInsideList_Item <- FurnitureInsideList
    ], 

    FurnitureInsideList_Len = length(FurnitureInsideList), 
    Bin_FurnitureInsideList = list_to_binary(BinList_FurnitureInsideList),

    Data = <<
        BlockId:32,
        HouseId:32,
        HouseLv:16,
        RoleId:64,
        Type:8,
        CostList_Len:16, Bin_CostList/binary,
        FurnitureInsideList_Len:16, Bin_FurnitureInsideList/binary
    >>,
    {ok, pt:pack(17709, Data)};

write (17710,[
    Errcode,
    Type
]) ->
    Data = <<
        Errcode:32,
        Type:8
    >>,
    {ok, pt:pack(17710, Data)};

write (17711,[
    BlockId,
    HouseId,
    HouseLv,
    Type,
    AnswerType
]) ->
    Data = <<
        BlockId:32,
        HouseId:32,
        HouseLv:16,
        Type:8,
        AnswerType:8
    >>,
    {ok, pt:pack(17711, Data)};

write (17712,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17712, Data)};

write (17713,[
    Errcode,
    NewLocId,
    GoodsTypeId,
    Type,
    RoleId,
    X,
    Y,
    Face,
    MapId,
    InsId
]) ->
    Data = <<
        Errcode:32,
        NewLocId:64,
        GoodsTypeId:32,
        Type:8,
        RoleId:64,
        X:16,
        Y:16,
        Face:8,
        MapId:8,
        InsId:64
    >>,
    {ok, pt:pack(17713, Data)};

write (17714,[
    Errcode,
    BlockId,
    HouseId,
    FurnitureInsideList
]) ->
    BinList_FurnitureInsideList = [
        item_to_bin_4(FurnitureInsideList_Item) || FurnitureInsideList_Item <- FurnitureInsideList
    ], 

    FurnitureInsideList_Len = length(FurnitureInsideList), 
    Bin_FurnitureInsideList = list_to_binary(BinList_FurnitureInsideList),

    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        FurnitureInsideList_Len:16, Bin_FurnitureInsideList/binary
    >>,
    {ok, pt:pack(17714, Data)};



write (17716,[
    Errcode,
    SendList
]) ->
    BinList_SendList = [
        item_to_bin_5(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    Data = <<
        Errcode:32,
        SendList_Len:16, Bin_SendList/binary
    >>,
    {ok, pt:pack(17716, Data)};

write (17717,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17717, Data)};

write (17718,[
    RoleId,
    BlockId,
    HouseId,
    HouseLv
]) ->
    Data = <<
        RoleId:64,
        BlockId:32,
        HouseId:32,
        HouseLv:16
    >>,
    {ok, pt:pack(17718, Data)};

write (17719,[
    Errcode,
    BlockId,
    HouseId,
    Text
]) ->
    Bin_Text = pt:write_string(Text), 

    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        Bin_Text/binary
    >>,
    {ok, pt:pack(17719, Data)};

write (17720,[
    Errcode,
    BlockId,
    HouseId,
    ThemeId,
    FurnitureType,
    FurnitureList
]) ->
    BinList_FurnitureList = [
        item_to_bin_7(FurnitureList_Item) || FurnitureList_Item <- FurnitureList
    ], 

    FurnitureList_Len = length(FurnitureList), 
    Bin_FurnitureList = list_to_binary(BinList_FurnitureList),

    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        ThemeId:16,
        FurnitureType:16,
        FurnitureList_Len:16, Bin_FurnitureList/binary
    >>,
    {ok, pt:pack(17720, Data)};

write (17721,[
    Errcode,
    BlockId,
    HouseId,
    Type
]) ->
    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        Type:8
    >>,
    {ok, pt:pack(17721, Data)};

write (17722,[
    Errcode,
    HouseList
]) ->
    BinList_HouseList = [
        item_to_bin_8(HouseList_Item) || HouseList_Item <- HouseList
    ], 

    HouseList_Len = length(HouseList), 
    Bin_HouseList = list_to_binary(BinList_HouseList),

    Data = <<
        Errcode:32,
        HouseList_Len:16, Bin_HouseList/binary
    >>,
    {ok, pt:pack(17722, Data)};

write (17723,[
    Errcode,
    HouseGiftList
]) ->
    BinList_HouseGiftList = [
        item_to_bin_9(HouseGiftList_Item) || HouseGiftList_Item <- HouseGiftList
    ], 

    HouseGiftList_Len = length(HouseGiftList), 
    Bin_HouseGiftList = list_to_binary(BinList_HouseGiftList),

    Data = <<
        Errcode:32,
        HouseGiftList_Len:16, Bin_HouseGiftList/binary
    >>,
    {ok, pt:pack(17723, Data)};

write (17724,[
    Errcode,
    BlockId,
    HouseId,
    GiftId
]) ->
    Data = <<
        Errcode:32,
        BlockId:32,
        HouseId:32,
        GiftId:32
    >>,
    {ok, pt:pack(17724, Data)};

write (17725,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17725, Data)};

write (17726,[
    Errcode,
    Popularity,
    GiftPlayerList
]) ->
    BinList_GiftPlayerList = [
        item_to_bin_10(GiftPlayerList_Item) || GiftPlayerList_Item <- GiftPlayerList
    ], 

    GiftPlayerList_Len = length(GiftPlayerList), 
    Bin_GiftPlayerList = list_to_binary(BinList_GiftPlayerList),

    Data = <<
        Errcode:32,
        Popularity:32,
        GiftPlayerList_Len:16, Bin_GiftPlayerList/binary
    >>,
    {ok, pt:pack(17726, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    BlockId,
    HouseNum
}) ->
    Data = <<
        BlockId:32,
        HouseNum:16
    >>,
    Data.
item_to_bin_1 ({
    BlockId,
    HouseId,
    RoleId1,
    Name1,
    RoleId2,
    Name2,
    Lv,
    Lock,
    BuyTime,
    Text,
    IfChoose
}) ->
    Bin_Name1 = pt:write_string(Name1), 

    Bin_Name2 = pt:write_string(Name2), 

    Bin_Text = pt:write_string(Text), 

    Data = <<
        BlockId:32,
        HouseId:32,
        RoleId1:64,
        Bin_Name1/binary,
        RoleId2:64,
        Bin_Name2/binary,
        Lv:16,
        Lock:8,
        BuyTime:32,
        Bin_Text/binary,
        IfChoose:8
    >>,
    Data.
item_to_bin_2 ({
    GoodsType,
    GoodsTypeId,
    GoodsNum
}) ->
    Data = <<
        GoodsType:16,
        GoodsTypeId:32,
        GoodsNum:16
    >>,
    Data.
item_to_bin_3 (
    GoodsTypeId
) ->
    Data = <<
        GoodsTypeId:32
    >>,
    Data.
item_to_bin_4 ({
    LocId,
    RoleId,
    GoodsTypeId,
    X,
    Y,
    Face,
    MapId
}) ->
    Data = <<
        LocId:64,
        RoleId:64,
        GoodsTypeId:32,
        X:16,
        Y:16,
        Face:8,
        MapId:8
    >>,
    Data.
item_to_bin_5 ({
    BlockId,
    HouseId,
    HouseLv,
    FurnitureInsideList
}) ->
    BinList_FurnitureInsideList = [
        item_to_bin_6(FurnitureInsideList_Item) || FurnitureInsideList_Item <- FurnitureInsideList
    ], 

    FurnitureInsideList_Len = length(FurnitureInsideList), 
    Bin_FurnitureInsideList = list_to_binary(BinList_FurnitureInsideList),

    Data = <<
        BlockId:32,
        HouseId:32,
        HouseLv:16,
        FurnitureInsideList_Len:16, Bin_FurnitureInsideList/binary
    >>,
    Data.
item_to_bin_6 (
    GoodsTypeId
) ->
    Data = <<
        GoodsTypeId:32
    >>,
    Data.
item_to_bin_7 ({
    GoodsTypeId,
    Num
}) ->
    Data = <<
        GoodsTypeId:32,
        Num:16
    >>,
    Data.
item_to_bin_8 ({
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Lv,
    BlockId,
    HouseId,
    HouseLv
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Lv:16,
        BlockId:32,
        HouseId:32,
        HouseLv:16
    >>,
    Data.
item_to_bin_9 ({
    GiftId,
    SendNum
}) ->
    Data = <<
        GiftId:32,
        SendNum:16
    >>,
    Data.
item_to_bin_10 ({
    RoleId,
    RoleName,
    Career,
    Sex,
    Turn,
    Lv,
    GiftId,
    WishWord,
    Time
}) ->
    Bin_RoleName = pt:write_string(RoleName), 

    Bin_WishWord = pt:write_string(WishWord), 

    Data = <<
        RoleId:64,
        Bin_RoleName/binary,
        Career:8,
        Sex:8,
        Turn:8,
        Lv:16,
        GiftId:32,
        Bin_WishWord/binary,
        Time:32
    >>,
    Data.
