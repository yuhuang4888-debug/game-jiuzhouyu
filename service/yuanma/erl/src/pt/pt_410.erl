-module(pt_410).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41001, _) ->
    {ok, []};
read(41002, Bin0) ->
    <<AchvType:16, Bin1/binary>> = Bin0, 
    <<Label:8, _Bin2/binary>> = Bin1, 
    {ok, [AchvType, Label]};
read(41003, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Num:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Num]};
read(41004, Bin0) ->
    <<AchvId:32, _Bin1/binary>> = Bin0, 
    {ok, [AchvId]};
read(41006, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (41001,[
    Ids
]) ->
    BinList_Ids = [
        item_to_bin_0(Ids_Item) || Ids_Item <- Ids
    ], 

    Ids_Len = length(Ids), 
    Bin_Ids = list_to_binary(BinList_Ids),

    Data = <<
        Ids_Len:16, Bin_Ids/binary
    >>,
    {ok, pt:pack(41001, Data)};

write (41002,[
    AchvType,
    Label,
    AchvList
]) ->
    BinList_AchvList = [
        item_to_bin_1(AchvList_Item) || AchvList_Item <- AchvList
    ], 

    AchvList_Len = length(AchvList), 
    Bin_AchvList = list_to_binary(BinList_AchvList),

    Data = <<
        AchvType:16,
        Label:8,
        AchvList_Len:16, Bin_AchvList/binary
    >>,
    {ok, pt:pack(41002, Data)};

write (41003,[
    Label,
    AchvId,
    Status,
    CurStep,
    ShowStep
]) ->
    Data = <<
        Label:8,
        AchvId:32,
        Status:8,
        CurStep:64,
        ShowStep:8
    >>,
    {ok, pt:pack(41003, Data)};

write (41004,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(41004, Data)};

write (41005,[
    AchvId,
    Label
]) ->
    Data = <<
        AchvId:32,
        Label:8
    >>,
    {ok, pt:pack(41005, Data)};

write (41006,[
    CurAchv,
    TotalAchv,
    StarList
]) ->
    BinList_StarList = [
        item_to_bin_2(StarList_Item) || StarList_Item <- StarList
    ], 

    StarList_Len = length(StarList), 
    Bin_StarList = list_to_binary(BinList_StarList),

    Data = <<
        CurAchv:16,
        TotalAchv:16,
        StarList_Len:16, Bin_StarList/binary
    >>,
    {ok, pt:pack(41006, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    AchvId
) ->
    Data = <<
        AchvId:32
    >>,
    Data.
item_to_bin_1 ({
    AchvId,
    Status,
    CurStep,
    ShowStep
}) ->
    Data = <<
        AchvId:32,
        Status:8,
        CurStep:64,
        ShowStep:8
    >>,
    Data.
item_to_bin_2 ({
    AchvType,
    TotalStar,
    CurStar
}) ->
    Data = <<
        AchvType:32,
        TotalStar:32,
        CurStar:32
    >>,
    Data.
