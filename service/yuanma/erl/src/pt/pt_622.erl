-module(pt_622).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(62201, _) ->
    {ok, []};
read(62202, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<StrenType:8, _Bin2/binary>> = Bin1, 
    {ok, [PosId, StrenType]};
read(62203, Bin0) ->
    <<Pos:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [Pos, GoodsId]};
read(62204, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(62207, _) ->
    {ok, []};
read(62208, Bin0) ->
    <<GoodsTypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsTypeId]};
read(62209, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (62200,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(62200, Data)};

write (62201,[
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
    {ok, pt:pack(62201, Data)};

write (62202,[
    PosId,
    StrenLv
]) ->
    Data = <<
        PosId:8,
        StrenLv:16
    >>,
    {ok, pt:pack(62202, Data)};

write (62203,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(62203, Data)};

write (62204,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(62204, Data)};

write (62207,[
    Rating
]) ->
    Data = <<
        Rating:32
    >>,
    {ok, pt:pack(62207, Data)};

write (62208,[
    Suit,
    Code
]) ->
    BinList_Suit = [
        item_to_bin_1(Suit_Item) || Suit_Item <- Suit
    ], 

    Suit_Len = length(Suit), 
    Bin_Suit = list_to_binary(BinList_Suit),

    Data = <<
        Suit_Len:16, Bin_Suit/binary,
        Code:32
    >>,
    {ok, pt:pack(62208, Data)};

write (62209,[
    Suit
]) ->
    BinList_Suit = [
        item_to_bin_2(Suit_Item) || Suit_Item <- Suit
    ], 

    Suit_Len = length(Suit), 
    Bin_Suit = list_to_binary(BinList_Suit),

    Data = <<
        Suit_Len:16, Bin_Suit/binary
    >>,
    {ok, pt:pack(62209, Data)};

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
    SuitId,
    Num
}) ->
    Data = <<
        SuitId:32,
        Num:16
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
