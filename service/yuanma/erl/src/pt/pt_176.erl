-module(pt_176).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17600, _) ->
    {ok, []};
read(17601, Bin0) ->
    <<SellId:32, Bin1/binary>> = Bin0, 
    <<BuyNum:16, _Bin2/binary>> = Bin1, 
    {ok, [SellId, BuyNum]};
read(_Cmd, _R) -> {error, no_match}.

write (17600,[
    Errcode,
    SellList
]) ->
    BinList_SellList = [
        item_to_bin_0(SellList_Item) || SellList_Item <- SellList
    ], 

    SellList_Len = length(SellList), 
    Bin_SellList = list_to_binary(BinList_SellList),

    Data = <<
        Errcode:32,
        SellList_Len:16, Bin_SellList/binary
    >>,
    {ok, pt:pack(17600, Data)};

write (17601,[
    Errcode,
    SellId,
    BuyNum
]) ->
    Data = <<
        Errcode:32,
        SellId:32,
        BuyNum:16
    >>,
    {ok, pt:pack(17601, Data)};

write (17602,[
    NewList
]) ->
    BinList_NewList = [
        item_to_bin_1(NewList_Item) || NewList_Item <- NewList
    ], 

    NewList_Len = length(NewList), 
    Bin_NewList = list_to_binary(BinList_NewList),

    Data = <<
        NewList_Len:16, Bin_NewList/binary
    >>,
    {ok, pt:pack(17602, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    SellId,
    StartTime,
    LessNum
}) ->
    Data = <<
        SellId:32,
        StartTime:32,
        LessNum:8
    >>,
    Data.
item_to_bin_1 (
    SellId
) ->
    Data = <<
        SellId:32
    >>,
    Data.
