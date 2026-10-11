-module(pt_414).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41401, _) ->
    {ok, []};
read(41404, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (41400,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(41400, Data)};

write (41401,[
    Times,
    Lists
]) ->
    BinList_Lists = [
        item_to_bin_0(Lists_Item) || Lists_Item <- Lists
    ], 

    Lists_Len = length(Lists), 
    Bin_Lists = list_to_binary(BinList_Lists),

    Data = <<
        Times:16,
        Lists_Len:16, Bin_Lists/binary
    >>,
    {ok, pt:pack(41401, Data)};

write (41402,[
    Utime
]) ->
    Data = <<
        Utime:32
    >>,
    {ok, pt:pack(41402, Data)};

write (41404,[
    Status,
    Etime
]) ->
    Data = <<
        Status:8,
        Etime:32
    >>,
    {ok, pt:pack(41404, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    Times
) ->
    Data = <<
        Times:16
    >>,
    Data.
