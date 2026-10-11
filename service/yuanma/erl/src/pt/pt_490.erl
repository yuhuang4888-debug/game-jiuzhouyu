-module(pt_490).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(49000, _) ->
    {ok, []};
read(49001, Bin0) ->
    <<GiftId:32, _Bin1/binary>> = Bin0, 
    {ok, [GiftId]};
read(49002, _) ->
    {ok, []};
read(49003, Bin0) ->
    <<GiftId:32, _Bin1/binary>> = Bin0, 
    {ok, [GiftId]};
read(_Cmd, _R) -> {error, no_match}.

write (49000,[
    Code,
    FreeDrawTimes,
    AddDrawTimes,
    UseFreeTimes,
    DrawTimes,
    TurnId,
    DrawList,
    GiftList,
    DayTaskList
]) ->
    BinList_DrawList = [
        item_to_bin_0(DrawList_Item) || DrawList_Item <- DrawList
    ], 

    DrawList_Len = length(DrawList), 
    Bin_DrawList = list_to_binary(BinList_DrawList),

    BinList_GiftList = [
        item_to_bin_1(GiftList_Item) || GiftList_Item <- GiftList
    ], 

    GiftList_Len = length(GiftList), 
    Bin_GiftList = list_to_binary(BinList_GiftList),

    BinList_DayTaskList = [
        item_to_bin_2(DayTaskList_Item) || DayTaskList_Item <- DayTaskList
    ], 

    DayTaskList_Len = length(DayTaskList), 
    Bin_DayTaskList = list_to_binary(BinList_DayTaskList),

    Data = <<
        Code:32,
        FreeDrawTimes:32,
        AddDrawTimes:32,
        UseFreeTimes:32,
        DrawTimes:32,
        TurnId:32,
        DrawList_Len:16, Bin_DrawList/binary,
        GiftList_Len:16, Bin_GiftList/binary,
        DayTaskList_Len:16, Bin_DayTaskList/binary
    >>,
    {ok, pt:pack(49000, Data)};

write (49001,[
    Code,
    GiftId
]) ->
    Data = <<
        Code:32,
        GiftId:32
    >>,
    {ok, pt:pack(49001, Data)};

write (49002,[
    Code,
    TurnId,
    GiftId,
    UseFreeTimes
]) ->
    Data = <<
        Code:32,
        TurnId:16,
        GiftId:16,
        UseFreeTimes:32
    >>,
    {ok, pt:pack(49002, Data)};

write (49003,[
    Code,
    GiftId
]) ->
    Data = <<
        Code:32,
        GiftId:32
    >>,
    {ok, pt:pack(49003, Data)};

write (49004,[
    FreeDrawTimes,
    AddDrawTimes,
    UseFreeTimes,
    DayTaskList
]) ->
    BinList_DayTaskList = [
        item_to_bin_3(DayTaskList_Item) || DayTaskList_Item <- DayTaskList
    ], 

    DayTaskList_Len = length(DayTaskList), 
    Bin_DayTaskList = list_to_binary(BinList_DayTaskList),

    Data = <<
        FreeDrawTimes:32,
        AddDrawTimes:32,
        UseFreeTimes:32,
        DayTaskList_Len:16, Bin_DayTaskList/binary
    >>,
    {ok, pt:pack(49004, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    DrawId
) ->
    Data = <<
        DrawId:32
    >>,
    Data.
item_to_bin_1 ({
    GiftId,
    BuyTime,
    BackDay
}) ->
    Data = <<
        GiftId:8,
        BuyTime:32,
        BackDay:16
    >>,
    Data.
item_to_bin_2 ({
    TaskId,
    TaskState
}) ->
    Data = <<
        TaskId:8,
        TaskState:8
    >>,
    Data.
item_to_bin_3 ({
    TaskId,
    TaskState
}) ->
    Data = <<
        TaskId:8,
        TaskState:8
    >>,
    Data.
