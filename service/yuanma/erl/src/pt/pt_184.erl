-module(pt_184).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18401, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (18401,[
    BuffList
]) ->
    BinList_BuffList = [
        item_to_bin_0(BuffList_Item) || BuffList_Item <- BuffList
    ], 

    BuffList_Len = length(BuffList), 
    Bin_BuffList = list_to_binary(BinList_BuffList),

    Data = <<
        BuffList_Len:16, Bin_BuffList/binary
    >>,
    {ok, pt:pack(18401, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Key,
    Values
}) ->
    Bin_Values = pt:write_string(Values), 

    Data = <<
        Key:32,
        Bin_Values/binary
    >>,
    Data.
