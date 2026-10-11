-module(pt_211).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(21101, _) ->
    {ok, []};
read(21102, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(21103, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(21104, Bin0) ->
    <<CoreType:8, _Bin1/binary>> = Bin0, 
    {ok, [CoreType]};
read(_Cmd, _R) -> {error, no_match}.

write (21101,[
    CoreType,
    ArcanaList
]) ->
    BinList_ArcanaList = [
        item_to_bin_0(ArcanaList_Item) || ArcanaList_Item <- ArcanaList
    ], 

    ArcanaList_Len = length(ArcanaList), 
    Bin_ArcanaList = list_to_binary(BinList_ArcanaList),

    Data = <<
        CoreType:8,
        ArcanaList_Len:16, Bin_ArcanaList/binary
    >>,
    {ok, pt:pack(21101, Data)};

write (21102,[
    ErrorCode,
    Id
]) ->
    Data = <<
        ErrorCode:32,
        Id:32
    >>,
    {ok, pt:pack(21102, Data)};

write (21103,[
    ErrorCode,
    Id,
    BreakLv
]) ->
    Data = <<
        ErrorCode:32,
        Id:32,
        BreakLv:16
    >>,
    {ok, pt:pack(21103, Data)};

write (21104,[
    ErrorCode,
    CoreType
]) ->
    Data = <<
        ErrorCode:32,
        CoreType:8
    >>,
    {ok, pt:pack(21104, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    Lv,
    BreakLv
}) ->
    Data = <<
        Id:32,
        Lv:16,
        BreakLv:16
    >>,
    Data.
