-module(pt_217).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(21701, Bin0) ->
    <<Lv:8, _Bin1/binary>> = Bin0, 
    {ok, [Lv]};
read(21702, Bin0) ->
    <<GoodsId:32, Bin1/binary>> = Bin0, 
    <<Num:32, Bin2/binary>> = Bin1, 
    <<Lv:8, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, Num, Lv]};
read(21703, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (21700,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(21700, Data)};

write (21701,[
    CountList
]) ->
    BinList_CountList = [
        item_to_bin_0(CountList_Item) || CountList_Item <- CountList
    ], 

    CountList_Len = length(CountList), 
    Bin_CountList = list_to_binary(BinList_CountList),

    Data = <<
        CountList_Len:16, Bin_CountList/binary
    >>,
    {ok, pt:pack(21701, Data)};



write (21703,[
    CountList
]) ->
    BinList_CountList = [
        item_to_bin_1(CountList_Item) || CountList_Item <- CountList
    ], 

    CountList_Len = length(CountList), 
    Bin_CountList = list_to_binary(BinList_CountList),

    Data = <<
        CountList_Len:16, Bin_CountList/binary
    >>,
    {ok, pt:pack(21703, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GoodsId,
    Lv,
    CurrentDayCount,
    CurrentCount
}) ->
    Data = <<
        GoodsId:32,
        Lv:8,
        CurrentDayCount:32,
        CurrentCount:64
    >>,
    Data.
item_to_bin_1 ({
    GoodsId,
    Lv,
    CurrentDayCount,
    CurrentCount
}) ->
    Data = <<
        GoodsId:32,
        Lv:8,
        CurrentDayCount:32,
        CurrentCount:64
    >>,
    Data.
