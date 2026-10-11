-module(pt_154).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15400, _) ->
    {ok, []};
read(15401, Bin0) ->
    <<AuctionType:32, Bin1/binary>> = Bin0, 
    <<Type:32, Bin2/binary>> = Bin1, 
    <<ModuleId:32, _Bin3/binary>> = Bin2, 
    {ok, [AuctionType, Type, ModuleId]};
read(15403, Bin0) ->
    <<AuctionType:32, Bin1/binary>> = Bin0, 
    <<GoodsId:64, Bin2/binary>> = Bin1, 
    <<PriceType:8, Bin3/binary>> = Bin2, 
    <<Bgold:32, Bin4/binary>> = Bin3, 
    <<Gold:32, _Bin5/binary>> = Bin4, 
    {ok, [AuctionType, GoodsId, PriceType, Bgold, Gold]};
read(15405, _) ->
    {ok, []};
read(15406, Bin0) ->
    <<AuctionType:32, _Bin1/binary>> = Bin0, 
    {ok, [AuctionType]};
read(15407, Bin0) ->
    <<AuctionType:32, Bin1/binary>> = Bin0, 
    <<ModuleId:32, _Bin2/binary>> = Bin1, 
    {ok, [AuctionType, ModuleId]};
read(15409, _) ->
    {ok, []};
read(15410, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (15400,[
    ModuleList,
    TypeList
]) ->
    BinList_ModuleList = [
        item_to_bin_0(ModuleList_Item) || ModuleList_Item <- ModuleList
    ], 

    ModuleList_Len = length(ModuleList), 
    Bin_ModuleList = list_to_binary(BinList_ModuleList),

    BinList_TypeList = [
        item_to_bin_1(TypeList_Item) || TypeList_Item <- TypeList
    ], 

    TypeList_Len = length(TypeList), 
    Bin_TypeList = list_to_binary(BinList_TypeList),

    Data = <<
        ModuleList_Len:16, Bin_ModuleList/binary,
        TypeList_Len:16, Bin_TypeList/binary
    >>,
    {ok, pt:pack(15400, Data)};

write (15401,[
    AuctionType,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_2(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        AuctionType:32,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15401, Data)};

write (15402,[
    GoodsId,
    ModuleId,
    AuctionType,
    NowPrice,
    NextPrice,
    Time,
    TopPlayerId,
    IsDelay,
    GoodsStatus
]) ->
    Data = <<
        GoodsId:64,
        ModuleId:32,
        AuctionType:32,
        NowPrice:32,
        NextPrice:32,
        Time:32,
        TopPlayerId:64,
        IsDelay:8,
        GoodsStatus:8
    >>,
    {ok, pt:pack(15402, Data)};

write (15403,[
    Res,
    PriceType
]) ->
    Data = <<
        Res:32,
        PriceType:8
    >>,
    {ok, pt:pack(15403, Data)};

write (15404,[
    AuctionType,
    Type,
    ModuleId,
    GoodsId,
    TypeId,
    Bgold,
    Gold
]) ->
    Data = <<
        AuctionType:32,
        Type:32,
        ModuleId:32,
        GoodsId:64,
        TypeId:32,
        Bgold:32,
        Gold:32
    >>,
    {ok, pt:pack(15404, Data)};

write (15405,[
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
    {ok, pt:pack(15405, Data)};

write (15406,[
    AuctionType,
    AuctionList
]) ->
    BinList_AuctionList = [
        item_to_bin_4(AuctionList_Item) || AuctionList_Item <- AuctionList
    ], 

    AuctionList_Len = length(AuctionList), 
    Bin_AuctionList = list_to_binary(BinList_AuctionList),

    Data = <<
        AuctionType:32,
        AuctionList_Len:16, Bin_AuctionList/binary
    >>,
    {ok, pt:pack(15406, Data)};

write (15407,[
    AuctionType,
    ModuleId,
    EstimateGold,
    EstimateBgold
]) ->
    Data = <<
        AuctionType:32,
        ModuleId:32,
        EstimateGold:32,
        EstimateBgold:32
    >>,
    {ok, pt:pack(15407, Data)};

write (15408,[
    AuctionType,
    ModuleId,
    Type
]) ->
    Data = <<
        AuctionType:32,
        ModuleId:32,
        Type:8
    >>,
    {ok, pt:pack(15408, Data)};

write (15409,[
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_5(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(15409, Data)};

write (15410,[
    BonusList,
    BonusInfo
]) ->
    BinList_BonusList = [
        item_to_bin_6(BonusList_Item) || BonusList_Item <- BonusList
    ], 

    BonusList_Len = length(BonusList), 
    Bin_BonusList = list_to_binary(BinList_BonusList),

    BinList_BonusInfo = [
        item_to_bin_7(BonusInfo_Item) || BonusInfo_Item <- BonusInfo
    ], 

    BonusInfo_Len = length(BonusInfo), 
    Bin_BonusInfo = list_to_binary(BinList_BonusInfo),

    Data = <<
        BonusList_Len:16, Bin_BonusList/binary,
        BonusInfo_Len:16, Bin_BonusInfo/binary
    >>,
    {ok, pt:pack(15410, Data)};

write (15411,[
    AllClose
]) ->
    Data = <<
        AllClose:8
    >>,
    {ok, pt:pack(15411, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ModuleId,
    Num
}) ->
    Data = <<
        ModuleId:32,
        Num:32
    >>,
    Data.
item_to_bin_1 ({
    Type,
    Num
}) ->
    Data = <<
        Type:32,
        Num:32
    >>,
    Data.
item_to_bin_2 ({
    GoodsId,
    ModuleId,
    TypeId,
    Wlv,
    NowPrice,
    NextPrice,
    Price,
    StartTime,
    Time,
    TopPlayerId,
    IsDelay,
    HadBonus
}) ->
    Data = <<
        GoodsId:64,
        ModuleId:32,
        TypeId:32,
        Wlv:16,
        NowPrice:32,
        NextPrice:32,
        Price:32,
        StartTime:32,
        Time:32,
        TopPlayerId:64,
        IsDelay:8,
        HadBonus:8
    >>,
    Data.
item_to_bin_3 ({
    GoodsId,
    ModuleId,
    TypeId,
    Wlv,
    NowPrice,
    NextPrice,
    Price,
    StartTime,
    Time,
    TopPlayerId,
    IsDelay,
    HadBonus
}) ->
    Data = <<
        GoodsId:64,
        ModuleId:32,
        TypeId:32,
        Wlv:16,
        NowPrice:32,
        NextPrice:32,
        Price:32,
        StartTime:32,
        Time:32,
        TopPlayerId:64,
        IsDelay:8,
        HadBonus:8
    >>,
    Data.
item_to_bin_4 ({
    ModuleId,
    Time,
    TypeId,
    Wlv,
    Price,
    ToWorld
}) ->
    Data = <<
        ModuleId:32,
        Time:32,
        TypeId:32,
        Wlv:16,
        Price:32,
        ToWorld:8
    >>,
    Data.
item_to_bin_5 ({
    OpType,
    ModuleId,
    PriceType,
    Gold,
    Bgold,
    TypeId,
    Wlv,
    Time
}) ->
    Data = <<
        OpType:8,
        ModuleId:32,
        PriceType:8,
        Gold:16,
        Bgold:16,
        TypeId:32,
        Wlv:16,
        Time:32
    >>,
    Data.
item_to_bin_6 ({
    ModuleId,
    Gold,
    Bgold,
    Time
}) ->
    Data = <<
        ModuleId:32,
        Gold:16,
        Bgold:16,
        Time:32
    >>,
    Data.
item_to_bin_7 ({
    ModuleId,
    GoldGot,
    BgoldGot
}) ->
    Data = <<
        ModuleId:32,
        GoldGot:16,
        BgoldGot:16
    >>,
    Data.
