-module(pt_618).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(61801, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (61801,[
    StateList
]) ->
    BinList_StateList = [
        item_to_bin_0(StateList_Item) || StateList_Item <- StateList
    ], 

    StateList_Len = length(StateList), 
    Bin_StateList = list_to_binary(BinList_StateList),

    Data = <<
        StateList_Len:16, Bin_StateList/binary
    >>,
    {ok, pt:pack(61801, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    State,
    Time
}) ->
    Data = <<
        Id:32,
        State:8,
        Time:64
    >>,
    Data.
