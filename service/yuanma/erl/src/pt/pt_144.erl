-module(pt_144).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14401, Bin0) ->
    <<Stage:8, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [Stage, Type]};
read(14402, Bin0) ->
    <<Stage:8, Bin1/binary>> = Bin0, 
    <<Type:8, Bin2/binary>> = Bin1, 
    <<Pos:8, _Bin3/binary>> = Bin2, 
    {ok, [Stage, Type, Pos]};
read(_Cmd, _R) -> {error, no_match}.

write (14401,[
    StageList
]) ->
    BinList_StageList = [
        item_to_bin_0(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        StageList_Len:16, Bin_StageList/binary
    >>,
    {ok, pt:pack(14401, Data)};

write (14402,[
    Code,
    StageList
]) ->
    BinList_StageList = [
        item_to_bin_3(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        Code:32,
        StageList_Len:16, Bin_StageList/binary
    >>,
    {ok, pt:pack(14402, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Stage,
    TypeList
}) ->
    BinList_TypeList = [
        item_to_bin_1(TypeList_Item) || TypeList_Item <- TypeList
    ], 

    TypeList_Len = length(TypeList), 
    Bin_TypeList = list_to_binary(BinList_TypeList),

    Data = <<
        Stage:8,
        TypeList_Len:16, Bin_TypeList/binary
    >>,
    Data.
item_to_bin_1 ({
    Type,
    Status,
    PosList
}) ->
    BinList_PosList = [
        item_to_bin_2(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        Type:8,
        Status:8,
        PosList_Len:16, Bin_PosList/binary
    >>,
    Data.
item_to_bin_2 ({
    GtypeId,
    Pos,
    Status
}) ->
    Data = <<
        GtypeId:32,
        Pos:8,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
    Stage,
    TypeList
}) ->
    BinList_TypeList = [
        item_to_bin_4(TypeList_Item) || TypeList_Item <- TypeList
    ], 

    TypeList_Len = length(TypeList), 
    Bin_TypeList = list_to_binary(BinList_TypeList),

    Data = <<
        Stage:8,
        TypeList_Len:16, Bin_TypeList/binary
    >>,
    Data.
item_to_bin_4 ({
    Type,
    Status,
    PosList
}) ->
    BinList_PosList = [
        item_to_bin_5(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        Type:8,
        Status:8,
        PosList_Len:16, Bin_PosList/binary
    >>,
    Data.
item_to_bin_5 ({
    GtypeId,
    Pos,
    Status
}) ->
    Data = <<
        GtypeId:32,
        Pos:8,
        Status:8
    >>,
    Data.
