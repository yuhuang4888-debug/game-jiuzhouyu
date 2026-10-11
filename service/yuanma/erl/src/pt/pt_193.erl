-module(pt_193).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(19302, _) ->
    {ok, []};
read(19303, Bin0) ->
    <<ModId:32, Bin1/binary>> = Bin0, 
    <<SubId:32, Bin2/binary>> = Bin1, 
    <<GradeId:32, _Bin3/binary>> = Bin2, 
    {ok, [ModId, SubId, GradeId]};
read(_Cmd, _R) -> {error, no_match}.

write (19301,[
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward), 

    Data = <<
        Bin_Reward/binary
    >>,
    {ok, pt:pack(19301, Data)};

write (19302,[
    AdList
]) ->
    BinList_AdList = [
        item_to_bin_0(AdList_Item) || AdList_Item <- AdList
    ], 

    AdList_Len = length(AdList), 
    Bin_AdList = list_to_binary(BinList_AdList),

    Data = <<
        AdList_Len:16, Bin_AdList/binary
    >>,
    {ok, pt:pack(19302, Data)};

write (19303,[
    ModId,
    SubId,
    GradeId,
    Code
]) ->
    Data = <<
        ModId:32,
        SubId:32,
        GradeId:32,
        Code:32
    >>,
    {ok, pt:pack(19303, Data)};

write (19304,[
    ModId,
    SubId,
    GradeId
]) ->
    Data = <<
        ModId:32,
        SubId:32,
        GradeId:32
    >>,
    {ok, pt:pack(19304, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ModId,
    SubId,
    Count
}) ->
    Data = <<
        ModId:32,
        SubId:32,
        Count:8
    >>,
    Data.
