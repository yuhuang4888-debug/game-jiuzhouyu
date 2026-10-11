-module(pt_162).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16202, _) ->
    {ok, []};
read(16203, Bin0) ->
    <<FigureId:32, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [FigureId, Type]};
read(16205, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (16200,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(16200, Data)};

write (16201,[
    RoleId,
    FigureId
]) ->
    Data = <<
        RoleId:64,
        FigureId:32
    >>,
    {ok, pt:pack(16201, Data)};

write (16202,[
    Lv,
    Star,
    Exp,
    FigureId,
    Status,
    Combat,
    WingList
]) ->
    BinList_WingList = [
        item_to_bin_0(WingList_Item) || WingList_Item <- WingList
    ], 

    WingList_Len = length(WingList), 
    Bin_WingList = list_to_binary(BinList_WingList),

    Data = <<
        Lv:8,
        Star:8,
        Exp:32,
        FigureId:32,
        Status:8,
        Combat:32,
        WingList_Len:16, Bin_WingList/binary
    >>,
    {ok, pt:pack(16202, Data)};

write (16203,[
    NewFigure,
    Type,
    Result
]) ->
    Data = <<
        NewFigure:32,
        Type:8,
        Result:32
    >>,
    {ok, pt:pack(16203, Data)};

write (16205,[
    Result
]) ->
    Data = <<
        Result:32
    >>,
    {ok, pt:pack(16205, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Figure,
    EndTime
}) ->
    Data = <<
        Figure:32,
        EndTime:32
    >>,
    Data.
