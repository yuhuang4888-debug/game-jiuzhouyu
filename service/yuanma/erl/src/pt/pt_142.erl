-module(pt_142).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14201, Bin0) ->
    <<CompanionId:32, _Bin1/binary>> = Bin0, 
    {ok, [CompanionId]};
read(14202, _) ->
    {ok, []};
read(14203, Bin0) ->
    <<CompanionId:32, _Bin1/binary>> = Bin0, 
    {ok, [CompanionId]};
read(14204, Bin0) ->
    <<CompanionId:32, _Bin1/binary>> = Bin0, 
    {ok, [CompanionId]};
read(14205, Bin0) ->
    <<CompanionId:32, _Bin1/binary>> = Bin0, 
    {ok, [CompanionId]};
read(14206, Bin0) ->
    <<CompanionId:32, _Bin1/binary>> = Bin0, 
    {ok, [CompanionId]};
read(14207, Bin0) ->
    <<CompanionId:32, Bin1/binary>> = Bin0, 
    <<BiogLv:8, _Bin2/binary>> = Bin1, 
    {ok, [CompanionId, BiogLv]};
read(_Cmd, _R) -> {error, no_match}.

write (14200,[
    TypeId,
    RoleId,
    FigureId
]) ->
    Data = <<
        TypeId:8,
        RoleId:64,
        FigureId:32
    >>,
    {ok, pt:pack(14200, Data)};

write (14201,[
    SumAttr,
    CompanionId,
    Stage,
    Star,
    IsActive,
    Blessing,
    TrainNum,
    Attr,
    Combat,
    FightId
]) ->
    BinList_SumAttr = [
        item_to_bin_0(SumAttr_Item) || SumAttr_Item <- SumAttr
    ], 

    SumAttr_Len = length(SumAttr), 
    Bin_SumAttr = list_to_binary(BinList_SumAttr),

    BinList_Attr = [
        item_to_bin_1(Attr_Item) || Attr_Item <- Attr
    ], 

    Attr_Len = length(Attr), 
    Bin_Attr = list_to_binary(BinList_Attr),

    Data = <<
        SumAttr_Len:16, Bin_SumAttr/binary,
        CompanionId:32,
        Stage:16,
        Star:16,
        IsActive:8,
        Blessing:32,
        TrainNum:32,
        Attr_Len:16, Bin_Attr/binary,
        Combat:64,
        FightId:32
    >>,
    {ok, pt:pack(14201, Data)};

write (14202,[
    FightId,
    SumAttr,
    CompanionList
]) ->
    BinList_SumAttr = [
        item_to_bin_2(SumAttr_Item) || SumAttr_Item <- SumAttr
    ], 

    SumAttr_Len = length(SumAttr), 
    Bin_SumAttr = list_to_binary(BinList_SumAttr),

    BinList_CompanionList = [
        item_to_bin_3(CompanionList_Item) || CompanionList_Item <- CompanionList
    ], 

    CompanionList_Len = length(CompanionList), 
    Bin_CompanionList = list_to_binary(BinList_CompanionList),

    Data = <<
        FightId:32,
        SumAttr_Len:16, Bin_SumAttr/binary,
        CompanionList_Len:16, Bin_CompanionList/binary
    >>,
    {ok, pt:pack(14202, Data)};

write (14203,[
    Code,
    FightId,
    FigureId
]) ->
    Data = <<
        Code:32,
        FightId:32,
        FigureId:32
    >>,
    {ok, pt:pack(14203, Data)};

write (14204,[
    Errcode,
    CompanionId,
    Combat
]) ->
    Data = <<
        Errcode:32,
        CompanionId:32,
        Combat:64
    >>,
    {ok, pt:pack(14204, Data)};

write (14205,[
    Errcode,
    CompanionId,
    Stage,
    Star,
    Blessing
]) ->
    Data = <<
        Errcode:32,
        CompanionId:32,
        Stage:16,
        Star:16,
        Blessing:32
    >>,
    {ok, pt:pack(14205, Data)};

write (14206,[
    Errcode,
    CompanionId
]) ->
    Data = <<
        Errcode:32,
        CompanionId:32
    >>,
    {ok, pt:pack(14206, Data)};

write (14207,[
    Code,
    CompanionId,
    BiogLv
]) ->
    Data = <<
        Code:32,
        CompanionId:32,
        BiogLv:8
    >>,
    {ok, pt:pack(14207, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_1 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_2 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_3 ({
    CompanionId,
    Stage,
    Star,
    BiogList,
    IsActive,
    IsFight,
    FigureId,
    Blessing,
    TrainNum,
    Attr,
    Combat
}) ->
    BinList_BiogList = [
        item_to_bin_4(BiogList_Item) || BiogList_Item <- BiogList
    ], 

    BiogList_Len = length(BiogList), 
    Bin_BiogList = list_to_binary(BinList_BiogList),

    BinList_Attr = [
        item_to_bin_5(Attr_Item) || Attr_Item <- Attr
    ], 

    Attr_Len = length(Attr), 
    Bin_Attr = list_to_binary(BinList_Attr),

    Data = <<
        CompanionId:32,
        Stage:16,
        Star:16,
        BiogList_Len:16, Bin_BiogList/binary,
        IsActive:8,
        IsFight:8,
        FigureId:32,
        Blessing:32,
        TrainNum:32,
        Attr_Len:16, Bin_Attr/binary,
        Combat:64
    >>,
    Data.
item_to_bin_4 (
    Lv
) ->
    Data = <<
        Lv:8
    >>,
    Data.
item_to_bin_5 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
