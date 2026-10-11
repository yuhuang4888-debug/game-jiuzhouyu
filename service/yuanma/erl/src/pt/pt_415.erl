-module(pt_415).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41501, _) ->
    {ok, []};
read(41502, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(_Cmd, _R) -> {error, no_match}.

write (41500,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(41500, Data)};

write (41501,[
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(41501, Data)};

write (41502,[
    Type,
    Crit,
    Reward
]) ->
    Data = <<
        Type:8,
        Crit:8,
        Reward:64
    >>,
    {ok, pt:pack(41502, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    RemainTimes,
    FreeTimes,
    Endtime
}) ->
    Data = <<
        Type:8,
        RemainTimes:8,
        FreeTimes:8,
        Endtime:32
    >>,
    Data.
