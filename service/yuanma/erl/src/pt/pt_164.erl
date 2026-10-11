-module(pt_164).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16400, _) ->
    {ok, []};
read(16401, Bin0) ->
    <<CellId:32, _Bin1/binary>> = Bin0,
    {ok, [CellId]};
read(_Cmd, _R) -> {error, no_match}.

write (16400,[
    ActiveIds
]) ->
    BinList_ActiveIds = [
        item_to_bin_0(ActiveIds_Item) || ActiveIds_Item <- ActiveIds
    ],

    ActiveIds_Len = length(ActiveIds),
    Bin_ActiveIds = list_to_binary(BinList_ActiveIds),

    Data = <<
        ActiveIds_Len:16, Bin_ActiveIds/binary
    >>,
    {ok, pt:pack(16400, Data)};

write (16401,[
    Code,
    CellId
]) ->
    Data = <<
        Code:32,
        CellId:32
    >>,
    {ok, pt:pack(16401, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    ActiveId
) ->
    Data = <<
        ActiveId:32
    >>,
    Data.
