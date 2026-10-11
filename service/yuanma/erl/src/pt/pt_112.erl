-module(pt_112).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(11200, Bin0) ->
    <<DressType:8, _Bin1/binary>> = Bin0, 
    {ok, [DressType]};
read(11201, Bin0) ->
    <<DressType:8, Bin1/binary>> = Bin0, 
    <<DressId:32, _Bin2/binary>> = Bin1, 
    {ok, [DressType, DressId]};
read(11202, Bin0) ->
    <<DressType:8, Bin1/binary>> = Bin0, 
    <<DressId:32, _Bin2/binary>> = Bin1, 
    {ok, [DressType, DressId]};
read(11203, Bin0) ->
    <<DressType:8, Bin1/binary>> = Bin0, 
    <<DressId:32, _Bin2/binary>> = Bin1, 
    {ok, [DressType, DressId]};
read(11205, Bin0) ->
    <<DressType:8, Bin1/binary>> = Bin0, 
    <<DressId:32, _Bin2/binary>> = Bin1, 
    {ok, [DressType, DressId]};
read(_Cmd, _R) -> {error, no_match}.

write (11200,[
    DressType,
    UseDressId,
    EnableList
]) ->
    BinList_EnableList = [
        item_to_bin_0(EnableList_Item) || EnableList_Item <- EnableList
    ], 

    EnableList_Len = length(EnableList), 
    Bin_EnableList = list_to_binary(BinList_EnableList),

    Data = <<
        DressType:8,
        UseDressId:32,
        EnableList_Len:16, Bin_EnableList/binary
    >>,
    {ok, pt:pack(11200, Data)};

write (11201,[
    Res,
    DressType,
    DressId,
    DressLv,
    CurPower,
    NextPower
]) ->
    Data = <<
        Res:32,
        DressType:8,
        DressId:32,
        DressLv:16,
        CurPower:64,
        NextPower:64
    >>,
    {ok, pt:pack(11201, Data)};

write (11202,[
    Res,
    DressType,
    DressId
]) ->
    Data = <<
        Res:32,
        DressType:8,
        DressId:32
    >>,
    {ok, pt:pack(11202, Data)};

write (11203,[
    Res,
    DressType,
    DressId
]) ->
    Data = <<
        Res:32,
        DressType:8,
        DressId:32
    >>,
    {ok, pt:pack(11203, Data)};

write (11204,[
    RoleId,
    DressList
]) ->
    BinList_DressList = [
        item_to_bin_1(DressList_Item) || DressList_Item <- DressList
    ], 

    DressList_Len = length(DressList), 
    Bin_DressList = list_to_binary(BinList_DressList),

    Data = <<
        RoleId:64,
        DressList_Len:16, Bin_DressList/binary
    >>,
    {ok, pt:pack(11204, Data)};

write (11205,[
    DressType,
    DressId,
    ActivePower
]) ->
    Data = <<
        DressType:8,
        DressId:32,
        ActivePower:64
    >>,
    {ok, pt:pack(11205, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    DressId,
    DressLv,
    CurPower,
    NextPower
}) ->
    Data = <<
        DressId:32,
        DressLv:16,
        CurPower:64,
        NextPower:64
    >>,
    Data.
item_to_bin_1 ({
    DressType,
    DressId
}) ->
    Data = <<
        DressType:8,
        DressId:32
    >>,
    Data.
