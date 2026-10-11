-module(pt_651).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(65101, _) ->
    {ok, []};
read(65102, Bin0) ->
    <<MapId:8, Bin1/binary>> = Bin0, 
    <<MonId:32, Bin2/binary>> = Bin1, 
    <<Auto:8, _Bin3/binary>> = Bin2, 
    {ok, [MapId, MonId, Auto]};
read(65103, _) ->
    {ok, []};
read(65104, Bin0) ->
    <<Count:8, _Bin1/binary>> = Bin0, 
    {ok, [Count]};
read(65105, _) ->
    {ok, []};
read(65106, _) ->
    {ok, []};
read(65107, Bin0) ->
    <<MapId:8, Bin1/binary>> = Bin0, 
    <<Auto:8, _Bin2/binary>> = Bin1, 
    {ok, [MapId, Auto]};
read(_Cmd, _R) -> {error, no_match}.

write (65100,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(65100, Data)};

write (65101,[
    LeftCount,
    AllCount,
    MapLists
]) ->
    BinList_MapLists = [
        item_to_bin_0(MapLists_Item) || MapLists_Item <- MapLists
    ], 

    MapLists_Len = length(MapLists), 
    Bin_MapLists = list_to_binary(BinList_MapLists),

    Data = <<
        LeftCount:8,
        AllCount:8,
        MapLists_Len:16, Bin_MapLists/binary
    >>,
    {ok, pt:pack(65101, Data)};

write (65102,[
    MapId,
    MonId
]) ->
    Data = <<
        MapId:8,
        MonId:32
    >>,
    {ok, pt:pack(65102, Data)};



write (65104,[
    LeftCount,
    AllCount
]) ->
    Data = <<
        LeftCount:8,
        AllCount:8
    >>,
    {ok, pt:pack(65104, Data)};

write (65105,[
    MapId,
    MonList,
    RoleNum,
    Time
]) ->
    BinList_MonList = [
        item_to_bin_2(MonList_Item) || MonList_Item <- MonList
    ], 

    MonList_Len = length(MonList), 
    Bin_MonList = list_to_binary(BinList_MonList),

    Data = <<
        MapId:8,
        MonList_Len:16, Bin_MonList/binary,
        RoleNum:16,
        Time:32
    >>,
    {ok, pt:pack(65105, Data)};

write (65106,[
    DropLog
]) ->
    BinList_DropLog = [
        item_to_bin_3(DropLog_Item) || DropLog_Item <- DropLog
    ], 

    DropLog_Len = length(DropLog), 
    Bin_DropLog = list_to_binary(BinList_DropLog),

    Data = <<
        DropLog_Len:16, Bin_DropLog/binary
    >>,
    {ok, pt:pack(65106, Data)};

write (65107,[
    LeftCount,
    AllCount,
    LeftTime
]) ->
    Data = <<
        LeftCount:8,
        AllCount:8,
        LeftTime:32
    >>,
    {ok, pt:pack(65107, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    MapId,
    RoleNum,
    MonList
}) ->
    BinList_MonList = [
        item_to_bin_1(MonList_Item) || MonList_Item <- MonList
    ], 

    MonList_Len = length(MonList), 
    Bin_MonList = list_to_binary(BinList_MonList),

    Data = <<
        MapId:8,
        RoleNum:16,
        MonList_Len:16, Bin_MonList/binary
    >>,
    Data.
item_to_bin_1 ({
    MonId,
    RebornTime
}) ->
    Data = <<
        MonId:32,
        RebornTime:32
    >>,
    Data.
item_to_bin_2 ({
    MonId,
    RebornTime
}) ->
    Data = <<
        MonId:32,
        RebornTime:32
    >>,
    Data.
item_to_bin_3 ({
    Time,
    ServerId,
    ServerNum,
    RoleId,
    Name,
    BossId,
    GoodsId,
    Num,
    Rating,
    EquipExtraAttr,
    IsTop
}) ->
    Bin_Name = pt:write_string(Name), 

    BinList_EquipExtraAttr = [
        item_to_bin_4(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Time:32,
        ServerId:32,
        ServerNum:32,
        RoleId:64,
        Bin_Name/binary,
        BossId:32,
        GoodsId:32,
        Num:32,
        Rating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        IsTop:8
    >>,
    Data.
item_to_bin_4 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
