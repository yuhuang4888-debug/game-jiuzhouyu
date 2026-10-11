-module(pt_223).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(22301, Bin0) ->
    <<ReceiveId:64, Bin1/binary>> = Bin0, 
    <<ReceiveServerId:16, Bin2/binary>> = Bin1, 
    <<GoodsId:32, Bin3/binary>> = Bin2, 
    <<GoodsNum:16, Bin4/binary>> = Bin3, 
    <<Anonymous:8, _Bin5/binary>> = Bin4, 
    {ok, [ReceiveId, ReceiveServerId, GoodsId, GoodsNum, Anonymous]};
read(22302, _) ->
    {ok, []};
read(22303, _) ->
    {ok, []};
read(22304, _) ->
    {ok, []};
read(22305, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(_Cmd, _R) -> {error, no_match}.

write (22300,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(22300, Data)};

write (22301,[
    Code,
    ReceiveId,
    ReceiveServerId,
    GoodsId,
    GoodsNum
]) ->
    Data = <<
        Code:32,
        ReceiveId:64,
        ReceiveServerId:16,
        GoodsId:32,
        GoodsNum:16
    >>,
    {ok, pt:pack(22301, Data)};

write (22302,[
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_0(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(22302, Data)};

write (22303,[
    FlowerNum,
    Charm,
    Fame
]) ->
    Data = <<
        FlowerNum:32,
        Charm:32,
        Fame:32
    >>,
    {ok, pt:pack(22303, Data)};

write (22304,[
    SenderId,
    SenderFigure,
    ServerId,
    ServerNum,
    GoodsId,
    GoodsNum
]) ->
    Bin_SenderFigure = pt:write_figure(SenderFigure), 

    Data = <<
        SenderId:64,
        Bin_SenderFigure/binary,
        ServerId:16,
        ServerNum:16,
        GoodsId:32,
        GoodsNum:16
    >>,
    {ok, pt:pack(22304, Data)};

write (22305,[
    Code,
    Id
]) ->
    Data = <<
        Code:32,
        Id:64
    >>,
    {ok, pt:pack(22305, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    SenderId,
    SenderName,
    ServerId,
    ServerNum,
    GoodsId,
    GoodsNum,
    Anonymous,
    IsThanks,
    Time
}) ->
    Bin_SenderName = pt:write_string(SenderName), 

    Data = <<
        Id:64,
        SenderId:64,
        Bin_SenderName/binary,
        ServerId:16,
        ServerNum:16,
        GoodsId:32,
        GoodsNum:16,
        Anonymous:8,
        IsThanks:8,
        Time:32
    >>,
    Data.
