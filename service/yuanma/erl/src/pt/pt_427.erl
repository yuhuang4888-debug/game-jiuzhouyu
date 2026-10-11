-module(pt_427).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42700, _) ->
    {ok, []};
read(42701, _) ->
    {ok, []};
read(42702, Bin0) ->
    <<IsCheap:8, _Bin1/binary>> = Bin0, 
    {ok, [IsCheap]};
read(42703, _) ->
    {ok, []};
read(42704, _) ->
    {ok, []};
read(42705, Bin0) ->
    <<Id:16, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(42706, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (42700,[
    Stage,
    StartTime,
    EndTime
]) ->
    Data = <<
        Stage:16,
        StartTime:32,
        EndTime:32
    >>,
    {ok, pt:pack(42700, Data)};

write (42701,[
    Circle,
    Location,
    LeftTimes,
    ThrowTimes,
    FreeResetTimes,
    FreeThrowTimes
]) ->
    Data = <<
        Circle:16,
        Location:16,
        LeftTimes:16,
        ThrowTimes:16,
        FreeResetTimes:16,
        FreeThrowTimes:16
    >>,
    {ok, pt:pack(42701, Data)};

write (42702,[
    Errcode,
    Circle,
    Location,
    Steps,
    LuckyReward,
    GainGoodsList
]) ->
    BinList_LuckyReward = [
        item_to_bin_0(LuckyReward_Item) || LuckyReward_Item <- LuckyReward
    ], 

    LuckyReward_Len = length(LuckyReward), 
    Bin_LuckyReward = list_to_binary(BinList_LuckyReward),

    Bin_GainGoodsList = pt:write_object_list(GainGoodsList), 

    Data = <<
        Errcode:32,
        Circle:16,
        Location:16,
        Steps:8,
        LuckyReward_Len:16, Bin_LuckyReward/binary,
        Bin_GainGoodsList/binary
    >>,
    {ok, pt:pack(42702, Data)};

write (42703,[
    Errcode,
    Circle,
    Location
]) ->
    Data = <<
        Errcode:32,
        Circle:16,
        Location:16
    >>,
    {ok, pt:pack(42703, Data)};

write (42704,[
    Times,
    RefreshCost,
    GoodsList
]) ->
    Bin_RefreshCost = pt:write_object_list(RefreshCost), 

    BinList_GoodsList = [
        item_to_bin_1(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Times:32,
        Bin_RefreshCost/binary,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(42704, Data)};

write (42705,[
    Errcode,
    Id
]) ->
    Data = <<
        Errcode:32,
        Id:16
    >>,
    {ok, pt:pack(42705, Data)};

write (42706,[
    Errcode,
    Times,
    RefreshCost,
    GoodsList
]) ->
    Bin_RefreshCost = pt:write_object_list(RefreshCost), 

    BinList_GoodsList = [
        item_to_bin_2(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Errcode:32,
        Times:32,
        Bin_RefreshCost/binary,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(42706, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Loc,
    Crit,
    GetGoods
}) ->
    Bin_GetGoods = pt:write_object_list(GetGoods), 

    Data = <<
        Loc:16,
        Crit:8,
        Bin_GetGoods/binary
    >>,
    Data.
item_to_bin_1 ({
    Id,
    Type,
    Reward,
    ShowPrice,
    Price,
    Over,
    State
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Id:16,
        Type:8,
        Bin_Reward/binary,
        ShowPrice:32,
        Price:32,
        Over:8,
        State:8
    >>,
    Data.
item_to_bin_2 ({
    Id,
    Type,
    Reward,
    ShowPrice,
    Price,
    Over,
    State
}) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Id:16,
        Type:8,
        Bin_Reward/binary,
        ShowPrice:32,
        Price:32,
        Over:8,
        State:8
    >>,
    Data.
