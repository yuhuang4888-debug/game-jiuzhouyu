-module(pt_159).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15901, _) ->
    {ok, []};
read(15902, Bin0) ->
    <<ProductId:32, _Bin1/binary>> = Bin0, 
    {ok, [ProductId]};
read(15903, _) ->
    {ok, []};
read(15904, Bin0) ->
    <<ProductId:32, Bin1/binary>> = Bin0, 
    <<Rank:32, _Bin2/binary>> = Bin1, 
    {ok, [ProductId, Rank]};
read(15905, _) ->
    {ok, []};
read(15906, Bin0) ->
    <<Index:8, _Bin1/binary>> = Bin0, 
    {ok, [Index]};
read(15907, _) ->
    {ok, []};
read(15908, _) ->
    {ok, []};
read(15951, _) ->
    {ok, []};
read(15952, Bin0) ->
    <<ProductId:32, _Bin1/binary>> = Bin0, 
    {ok, [ProductId]};
read(15953, Bin0) ->
    <<ProductId:32, _Bin1/binary>> = Bin0, 
    {ok, [ProductId]};
read(15954, Bin0) ->
    <<ProductType:8, _Bin1/binary>> = Bin0, 
    {ok, [ProductType]};
read(15955, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(15956, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0, 
    {ok, [SubType]};
read(15957, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<StartTime:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, StartTime]};
read(15958, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(15959, _) ->
    {ok, []};
read(15960, Bin0) ->
    <<Day:16, _Bin1/binary>> = Bin0, 
    {ok, [Day]};
read(_Cmd, _R) -> {error, no_match}.

write (15901,[
    ProductList
]) ->
    BinList_ProductList = [
        item_to_bin_0(ProductList_Item) || ProductList_Item <- ProductList
    ], 

    ProductList_Len = length(ProductList), 
    Bin_ProductList = list_to_binary(BinList_ProductList),

    Data = <<
        ProductList_Len:16, Bin_ProductList/binary
    >>,
    {ok, pt:pack(15901, Data)};

write (15902,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15902, Data)};

write (15903,[
    ProductList
]) ->
    BinList_ProductList = [
        item_to_bin_1(ProductList_Item) || ProductList_Item <- ProductList
    ], 

    ProductList_Len = length(ProductList), 
    Bin_ProductList = list_to_binary(BinList_ProductList),

    Data = <<
        ProductList_Len:16, Bin_ProductList/binary
    >>,
    {ok, pt:pack(15903, Data)};

write (15904,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15904, Data)};

write (15905,[
    RewardList,
    ProductId,
    IsNotify
]) ->
    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary,
        ProductId:32,
        IsNotify:8
    >>,
    {ok, pt:pack(15905, Data)};

write (15906,[
    Errcode,
    Index
]) ->
    Data = <<
        Errcode:32,
        Index:8
    >>,
    {ok, pt:pack(15906, Data)};



write (15908,[
    IsBuy
]) ->
    Data = <<
        IsBuy:8
    >>,
    {ok, pt:pack(15908, Data)};

write (15951,[
    Product
]) ->
    BinList_Product = [
        item_to_bin_4(Product_Item) || Product_Item <- Product
    ], 

    Product_Len = length(Product), 
    Bin_Product = list_to_binary(BinList_Product),

    Data = <<
        Product_Len:16, Bin_Product/binary
    >>,
    {ok, pt:pack(15951, Data)};

write (15952,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15952, Data)};

write (15953,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15953, Data)};

write (15954,[
    ProductList
]) ->
    BinList_ProductList = [
        item_to_bin_5(ProductList_Item) || ProductList_Item <- ProductList
    ], 

    ProductList_Len = length(ProductList), 
    Bin_ProductList = list_to_binary(BinList_ProductList),

    Data = <<
        ProductList_Len:16, Bin_ProductList/binary
    >>,
    {ok, pt:pack(15954, Data)};

write (15955,[
    SubType,
    Num,
    RewardInfos
]) ->
    BinList_RewardInfos = [
        item_to_bin_6(RewardInfos_Item) || RewardInfos_Item <- RewardInfos
    ], 

    RewardInfos_Len = length(RewardInfos), 
    Bin_RewardInfos = list_to_binary(BinList_RewardInfos),

    Data = <<
        SubType:16,
        Num:32,
        RewardInfos_Len:16, Bin_RewardInfos/binary
    >>,
    {ok, pt:pack(15955, Data)};

write (15956,[
    SubType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_7(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        SubType:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(15956, Data)};

write (15957,[
    Type,
    Subtype,
    TotalGold
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        TotalGold:32
    >>,
    {ok, pt:pack(15957, Data)};

write (15958,[
    Type,
    Subtype,
    TotalGold
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        TotalGold:32
    >>,
    {ok, pt:pack(15958, Data)};

write (15959,[
    TotalGold
]) ->
    Data = <<
        TotalGold:32
    >>,
    {ok, pt:pack(15959, Data)};

write (15960,[
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_8(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(15960, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ProductType,
    ProductSubtype,
    ProductId,
    State,
    LeftCount
}) ->
    Data = <<
        ProductType:32,
        ProductSubtype:32,
        ProductId:32,
        State:8,
        LeftCount:16
    >>,
    Data.
item_to_bin_1 ({
    ProductType,
    ProductSubtype,
    ProductId,
    NumList
}) ->
    BinList_NumList = [
        item_to_bin_2(NumList_Item) || NumList_Item <- NumList
    ], 

    NumList_Len = length(NumList), 
    Bin_NumList = list_to_binary(BinList_NumList),

    Data = <<
        ProductType:32,
        ProductSubtype:32,
        ProductId:32,
        NumList_Len:16, Bin_NumList/binary
    >>,
    Data.
item_to_bin_2 ({
    Rank,
    State
}) ->
    Data = <<
        Rank:32,
        State:8
    >>,
    Data.
item_to_bin_3 ({
    Open,
    Index
}) ->
    Data = <<
        Open:8,
        Index:8
    >>,
    Data.
item_to_bin_4 ({
    ProductId,
    State
}) ->
    Data = <<
        ProductId:32,
        State:8
    >>,
    Data.
item_to_bin_5 ({
    ProductId,
    StartTime,
    EndTime,
    WeekTimeList,
    MonthTimeList,
    OpenBegin,
    OpenEnd,
    MergeBegin,
    MergeEnd,
    Condition
}) ->
    Bin_WeekTimeList = pt:write_string(WeekTimeList), 

    Bin_MonthTimeList = pt:write_string(MonthTimeList), 

    Bin_Condition = pt:write_string(Condition), 

    Data = <<
        ProductId:32,
        StartTime:32,
        EndTime:32,
        Bin_WeekTimeList/binary,
        Bin_MonthTimeList/binary,
        OpenBegin:32,
        OpenEnd:32,
        MergeBegin:32,
        MergeEnd:32,
        Bin_Condition/binary
    >>,
    Data.
item_to_bin_6 ({
    Id,
    State,
    Val,
    Max,
    RewardList,
    Condition,
    Desc
}) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Desc = pt:write_string(Desc), 

    Data = <<
        Id:16,
        State:8,
        Val:32,
        Max:32,
        Bin_RewardList/binary,
        Bin_Condition/binary,
        Bin_Desc/binary
    >>,
    Data.
item_to_bin_7 ({
    Id,
    State,
    Val,
    Max,
    GoldNum,
    RewardList,
    Condition,
    Desc
}) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Desc = pt:write_string(Desc), 

    Data = <<
        Id:16,
        State:8,
        Val:32,
        Max:32,
        GoldNum:64,
        Bin_RewardList/binary,
        Bin_Condition/binary,
        Bin_Desc/binary
    >>,
    Data.
item_to_bin_8 ({
    Time,
    TotalGold
}) ->
    Data = <<
        Time:32,
        TotalGold:32
    >>,
    Data.
