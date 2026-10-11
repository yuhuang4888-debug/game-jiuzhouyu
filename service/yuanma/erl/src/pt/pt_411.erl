-module(pt_411).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41101, _) ->
    {ok, []};
read(41102, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41103, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41104, _) ->
    {ok, []};
read(41105, _) ->
    {ok, []};
read(41106, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41107, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(41108, _) ->
    {ok, []};
read(41109, Bin0) ->
    <<Dsgtid:32, _Bin1/binary>> = Bin0, 
    {ok, [Dsgtid]};
read(41110, Bin0) ->
    <<Dsgtid:32, _Bin1/binary>> = Bin0,
    {ok, [Dsgtid]};
read(_Cmd, _R) -> {error, no_match}.

write (41101,[
    Currentused,
    DsgtList
]) ->
    BinList_DsgtList = [
        item_to_bin_0(DsgtList_Item) || DsgtList_Item <- DsgtList
    ], 

    DsgtList_Len = length(DsgtList), 
    Bin_DsgtList = list_to_binary(BinList_DsgtList),

    Data = <<
        Currentused:32,
        DsgtList_Len:16, Bin_DsgtList/binary
    >>,
    {ok, pt:pack(41101, Data)};

write (41102,[
    Code,
    Id
]) ->
    Data = <<
        Code:32,
        Id:32
    >>,
    {ok, pt:pack(41102, Data)};

write (41103,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(41103, Data)};

write (41104,[
    Code,
    Id,
    EndTime
]) ->
    Data = <<
        Code:32,
        Id:32,
        EndTime:32
    >>,
    {ok, pt:pack(41104, Data)};

write (41105,[
    PlayerId,
    Id
]) ->
    Data = <<
        PlayerId:64,
        Id:32
    >>,
    {ok, pt:pack(41105, Data)};

write (41106,[
    Errcode,
    Order,
    Power,
    Currentused,
    Dsgtid
]) ->
    Data = <<
        Errcode:32,
        Order:8,
        Power:32,
        Currentused:32,
        Dsgtid:32
    >>,
    {ok, pt:pack(41106, Data)};

write (41107,[
    Errcode,
    Power
]) ->
    Data = <<
        Errcode:32,
        Power:32
    >>,
    {ok, pt:pack(41107, Data)};

write (41108,[
    Dsgtid
]) ->
    Data = <<
        Dsgtid:32
    >>,
    {ok, pt:pack(41108, Data)};

write (41109,[
    Errcode,
    Power,
    Currentused,
    Dsgtid
]) ->
    Data = <<
        Errcode:32,
        Power:32,
        Currentused:32,
        Dsgtid:32
    >>,
    {ok, pt:pack(41109, Data)};

write (41110,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(41110, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    Order,
    EndTime
}) ->
    Data = <<
        Id:32,
        Order:8,
        EndTime:32
    >>,
    Data.
