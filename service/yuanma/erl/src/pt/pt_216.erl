-module(pt_216).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(21601, _) ->
    {ok, []};
read(21602, Bin0) ->
    <<Lv:8, Bin1/binary>> = Bin0, 
    <<Type:8, Bin2/binary>> = Bin1, 
    <<Auto:8, _Bin3/binary>> = Bin2, 
    {ok, [Lv, Type, Auto]};
read(21605, Bin0) ->
    <<Lv:8, Bin1/binary>> = Bin0, 
    <<Show:8, _Bin2/binary>> = Bin1, 
    {ok, [Lv, Show]};
read(21606, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (21600,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(21600, Data)};

write (21601,[
    MagicCircle
]) ->
    BinList_MagicCircle = [
        item_to_bin_0(MagicCircle_Item) || MagicCircle_Item <- MagicCircle
    ], 

    MagicCircle_Len = length(MagicCircle), 
    Bin_MagicCircle = list_to_binary(BinList_MagicCircle),

    Data = <<
        MagicCircle_Len:16, Bin_MagicCircle/binary
    >>,
    {ok, pt:pack(21601, Data)};

write (21602,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(21602, Data)};

write (21603,[
    Lv
]) ->
    Data = <<
        Lv:8
    >>,
    {ok, pt:pack(21603, Data)};

write (21604,[
    RoleId,
    MagicCircleId
]) ->
    Data = <<
        RoleId:64,
        MagicCircleId:32
    >>,
    {ok, pt:pack(21604, Data)};



write (21606,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(21606, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Status,
    Lv,
    EndTime,
    Show,
    FreeFlag
}) ->
    Data = <<
        Status:8,
        Lv:8,
        EndTime:32,
        Show:8,
        FreeFlag:8
    >>,
    Data.
