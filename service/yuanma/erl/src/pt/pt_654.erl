-module(pt_654).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(65401, _) ->
    {ok, []};
read(65402, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<StrenType:8, _Bin2/binary>> = Bin1, 
    {ok, [PosId, StrenType]};
read(65403, Bin0) ->
    <<Pos:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [Pos, GoodsId]};
read(65404, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(65405, _) ->
    {ok, []};
read(65406, Bin0) ->
    <<GoodsTypeId:32, Bin1/binary>> = Bin0, 
    <<Num:16, _Bin2/binary>> = Bin1, 
    {ok, [GoodsTypeId, Num]};
read(65407, _) ->
    {ok, []};
read(65408, Bin0) ->
    <<GoodsTypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsTypeId]};
read(65409, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (65400,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(65400, Data)};

write (65401,[
    EquipList
]) ->
    BinList_EquipList = [
        item_to_bin_0(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(65401, Data)};

write (65402,[
    PosId,
    StrenLv
]) ->
    Data = <<
        PosId:8,
        StrenLv:16
    >>,
    {ok, pt:pack(65402, Data)};

write (65403,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(65403, Data)};

write (65404,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(65404, Data)};

write (65405,[
    SealPill
]) ->
    BinList_SealPill = [
        item_to_bin_1(SealPill_Item) || SealPill_Item <- SealPill
    ], 

    SealPill_Len = length(SealPill), 
    Bin_SealPill = list_to_binary(BinList_SealPill),

    Data = <<
        SealPill_Len:16, Bin_SealPill/binary
    >>,
    {ok, pt:pack(65405, Data)};

write (65406,[
    GoodsTypeId,
    Num,
    Code
]) ->
    Data = <<
        GoodsTypeId:32,
        Num:16,
        Code:32
    >>,
    {ok, pt:pack(65406, Data)};

write (65407,[
    Rating
]) ->
    Data = <<
        Rating:32
    >>,
    {ok, pt:pack(65407, Data)};

write (65408,[
    Suit,
    Code
]) ->
    BinList_Suit = [
        item_to_bin_2(Suit_Item) || Suit_Item <- Suit
    ], 

    Suit_Len = length(Suit), 
    Bin_Suit = list_to_binary(BinList_Suit),

    Data = <<
        Suit_Len:16, Bin_Suit/binary,
        Code:32
    >>,
    {ok, pt:pack(65408, Data)};

write (65409,[
    Suit
]) ->
    BinList_Suit = [
        item_to_bin_3(Suit_Item) || Suit_Item <- Suit
    ], 

    Suit_Len = length(Suit), 
    Bin_Suit = list_to_binary(BinList_Suit),

    Data = <<
        Suit_Len:16, Bin_Suit/binary
    >>,
    {ok, pt:pack(65409, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Pos,
    GoodsId,
    Stren
}) ->
    Data = <<
        Pos:8,
        GoodsId:64,
        Stren:16
    >>,
    Data.
item_to_bin_1 ({
    GoodsTypeId,
    Num,
    Limit
}) ->
    Data = <<
        GoodsTypeId:32,
        Num:16,
        Limit:16
    >>,
    Data.
item_to_bin_2 ({
    SuitId,
    Num
}) ->
    Data = <<
        SuitId:32,
        Num:16
    >>,
    Data.
item_to_bin_3 ({
    SuitId,
    Num
}) ->
    Data = <<
        SuitId:32,
        Num:16
    >>,
    Data.
