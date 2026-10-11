-module(pt_513).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(51300, Bin0) ->
    <<FairyId:32, _Bin1/binary>> = Bin0, 
    {ok, [FairyId]};
read(51301, Bin0) ->
    <<FairyId:32, Bin1/binary>> = Bin0, 
    <<NodeId:32, _Bin2/binary>> = Bin1, 
    {ok, [FairyId, NodeId]};
read(51302, Bin0) ->
    <<FairyId:32, _Bin1/binary>> = Bin0, 
    {ok, [FairyId]};
read(51303, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (51300,[
    FairyId,
    IsBuy,
    NodeList
]) ->
    BinList_NodeList = [
        item_to_bin_0(NodeList_Item) || NodeList_Item <- NodeList
    ], 

    NodeList_Len = length(NodeList), 
    Bin_NodeList = list_to_binary(BinList_NodeList),

    Data = <<
        FairyId:32,
        IsBuy:8,
        NodeList_Len:16, Bin_NodeList/binary
    >>,
    {ok, pt:pack(51300, Data)};

write (51301,[
    FairyId,
    NodeId,
    Code
]) ->
    Data = <<
        FairyId:32,
        NodeId:32,
        Code:32
    >>,
    {ok, pt:pack(51301, Data)};

write (51302,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(51302, Data)};

write (51303,[
    ClickList
]) ->
    BinList_ClickList = [
        item_to_bin_1(ClickList_Item) || ClickList_Item <- ClickList
    ], 

    ClickList_Len = length(ClickList), 
    Bin_ClickList = list_to_binary(BinList_ClickList),

    Data = <<
        ClickList_Len:16, Bin_ClickList/binary
    >>,
    {ok, pt:pack(51303, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    NodeId,
    IsActivate,
    Combat
}) ->
    Data = <<
        NodeId:32,
        IsActivate:8,
        Combat:32
    >>,
    Data.
item_to_bin_1 ({
    FairyId,
    Times
}) ->
    Data = <<
        FairyId:32,
        Times:8
    >>,
    Data.
