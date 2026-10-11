-module(pt_138).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13800, _) ->
    {ok, []};
read(13801, Bin0) ->
    <<Id:16, Bin1/binary>> = Bin0, 
    <<State:8, _Bin2/binary>> = Bin1, 
    {ok, [Id, State]};
read(_Cmd, _R) -> {error, no_match}.

write (13800,[
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
    {ok, pt:pack(13800, Data)};

write (13801,[
    Code,
    Id,
    State
]) ->
    Data = <<
        Code:32,
        Id:16,
        State:8
    >>,
    {ok, pt:pack(13801, Data)};

write (13802,[
    List
]) ->
    BinList_List = [
        item_to_bin_1(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(13802, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    State
}) ->
    Data = <<
        Id:16,
        State:8
    >>,
    Data.
item_to_bin_1 (
    Id
) ->
    Data = <<
        Id:16
    >>,
    Data.
