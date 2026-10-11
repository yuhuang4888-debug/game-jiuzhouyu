-module(pt_171).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17102, _) ->
    {ok, []};
read(17103, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(17104, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(17105, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(17106, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(_Cmd, _R) -> {error, no_match}.

write (17100,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(17100, Data)};

write (17102,[
    Errcode,
    IdList,
    PointsList
]) ->
    BinList_IdList = [
        item_to_bin_0(IdList_Item) || IdList_Item <- IdList
    ], 

    IdList_Len = length(IdList), 
    Bin_IdList = list_to_binary(BinList_IdList),

    BinList_PointsList = [
        item_to_bin_1(PointsList_Item) || PointsList_Item <- PointsList
    ], 

    PointsList_Len = length(PointsList), 
    Bin_PointsList = list_to_binary(BinList_PointsList),

    Data = <<
        Errcode:32,
        IdList_Len:16, Bin_IdList/binary,
        PointsList_Len:16, Bin_PointsList/binary
    >>,
    {ok, pt:pack(17102, Data)};

write (17103,[
    Errcode,
    Id,
    Lv,
    Combat,
    PercentList
]) ->
    BinList_PercentList = [
        item_to_bin_2(PercentList_Item) || PercentList_Item <- PercentList
    ], 

    PercentList_Len = length(PercentList), 
    Bin_PercentList = list_to_binary(BinList_PercentList),

    Data = <<
        Errcode:32,
        Id:32,
        Lv:16,
        Combat:32,
        PercentList_Len:16, Bin_PercentList/binary
    >>,
    {ok, pt:pack(17103, Data)};

write (17104,[
    Errcode,
    Id
]) ->
    Data = <<
        Errcode:32,
        Id:32
    >>,
    {ok, pt:pack(17104, Data)};

write (17105,[
    Errcode,
    Id,
    Lv,
    Combat
]) ->
    Data = <<
        Errcode:32,
        Id:32,
        Lv:16,
        Combat:32
    >>,
    {ok, pt:pack(17105, Data)};

write (17106,[
    Errcode,
    Id,
    PercentList,
    Combat
]) ->
    BinList_PercentList = [
        item_to_bin_3(PercentList_Item) || PercentList_Item <- PercentList
    ], 

    PercentList_Len = length(PercentList), 
    Bin_PercentList = list_to_binary(BinList_PercentList),

    Data = <<
        Errcode:32,
        Id:32,
        PercentList_Len:16, Bin_PercentList/binary,
        Combat:32
    >>,
    {ok, pt:pack(17106, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    Id
) ->
    Data = <<
        Id:32
    >>,
    Data.
item_to_bin_1 ({
    TypeId,
    Num
}) ->
    Data = <<
        TypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_2 ({
    AttrId,
    Percent
}) ->
    Data = <<
        AttrId:8,
        Percent:8
    >>,
    Data.
item_to_bin_3 ({
    AttrId,
    Percent
}) ->
    Data = <<
        AttrId:8,
        Percent:8
    >>,
    Data.
