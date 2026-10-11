-module(pt_175).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17500, _) ->
    {ok, []};
read(17501, Bin0) ->
    <<DayId:8, _Bin1/binary>> = Bin0, 
    {ok, [DayId]};
read(17502, _) ->
    {ok, []};
read(17503, Bin0) ->
    <<DayId:8, _Bin1/binary>> = Bin0, 
    {ok, [DayId]};
read(_Cmd, _R) -> {error, no_match}.

write (17500,[
    Errcode,
    CurrentDay,
    RewardStatus
]) ->
    BinList_RewardStatus = [
        item_to_bin_0(RewardStatus_Item) || RewardStatus_Item <- RewardStatus
    ], 

    RewardStatus_Len = length(RewardStatus), 
    Bin_RewardStatus = list_to_binary(BinList_RewardStatus),

    Data = <<
        Errcode:32,
        CurrentDay:8,
        RewardStatus_Len:16, Bin_RewardStatus/binary
    >>,
    {ok, pt:pack(17500, Data)};

write (17501,[
    Errcode,
    DayId,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Errcode:32,
        DayId:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(17501, Data)};

write (17502,[
    Errcode,
    CurrentDay,
    MergeWlv,
    RewardStatus
]) ->
    BinList_RewardStatus = [
        item_to_bin_2(RewardStatus_Item) || RewardStatus_Item <- RewardStatus
    ], 

    RewardStatus_Len = length(RewardStatus), 
    Bin_RewardStatus = list_to_binary(BinList_RewardStatus),

    Data = <<
        Errcode:32,
        CurrentDay:8,
        MergeWlv:16,
        RewardStatus_Len:16, Bin_RewardStatus/binary
    >>,
    {ok, pt:pack(17502, Data)};

write (17503,[
    Errcode,
    DayId,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_3(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Errcode:32,
        DayId:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(17503, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    DayId,
    Status
}) ->
    Data = <<
        DayId:16,
        Status:16
    >>,
    Data.
item_to_bin_1 ({
    GoodType,
    GoodId,
    GoodNum,
    GoodAutoId
}) ->
    Data = <<
        GoodType:8,
        GoodId:32,
        GoodNum:32,
        GoodAutoId:64
    >>,
    Data.
item_to_bin_2 ({
    DayId,
    Status
}) ->
    Data = <<
        DayId:16,
        Status:16
    >>,
    Data.
item_to_bin_3 ({
    GoodType,
    GoodId,
    GoodNum,
    GoodAutoId
}) ->
    Data = <<
        GoodType:8,
        GoodId:32,
        GoodNum:32,
        GoodAutoId:64
    >>,
    Data.
