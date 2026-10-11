-module(pt_132).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13211, _) ->
    {ok, []};
read(13212, _) ->
    {ok, []};
read(13213, Bin0) ->
    <<Count:32, _Bin1/binary>> = Bin0, 
    {ok, [Count]};
read(13214, _) ->
    {ok, []};
read(13215, _) ->
    {ok, []};
read(13216, _) ->
    {ok, []};
read(13217, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (13211,[
    ErrorCode,
    NextTime,
    HadAfkTime
]) ->
    Data = <<
        ErrorCode:32,
        NextTime:32,
        HadAfkTime:32
    >>,
    {ok, pt:pack(13211, Data)};

write (13212,[
    LoginType,
    OffLv,
    CostAfkTime,
    GoodsList,
    BackCount,
    BackExp,
    AfkTime,
    NextTime,
    ExpEffect,
    HadAfkTime
]) ->
    BinList_GoodsList = [
        item_to_bin_0(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        LoginType:8,
        OffLv:16,
        CostAfkTime:32,
        GoodsList_Len:16, Bin_GoodsList/binary,
        BackCount:32,
        BackExp:64,
        AfkTime:32,
        NextTime:32,
        ExpEffect:64,
        HadAfkTime:32
    >>,
    {ok, pt:pack(13212, Data)};

write (13213,[
    Code,
    Count,
    Exp
]) ->
    Data = <<
        Code:32,
        Count:32,
        Exp:64
    >>,
    {ok, pt:pack(13213, Data)};

write (13214,[
    AfkTime,
    NextTime
]) ->
    Data = <<
        AfkTime:32,
        NextTime:32
    >>,
    {ok, pt:pack(13214, Data)};

write (13215,[
    ExpEffect
]) ->
    Data = <<
        ExpEffect:64
    >>,
    {ok, pt:pack(13215, Data)};

write (13216,[
    Errcode,
    OldLv,
    OldLvRatio,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_1(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Errcode:32,
        OldLv:16,
        OldLvRatio:16,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(13216, Data)};

write (13217,[
    ExpList
]) ->
    BinList_ExpList = [
        item_to_bin_2(ExpList_Item) || ExpList_Item <- ExpList
    ], 

    ExpList_Len = length(ExpList), 
    Bin_ExpList = list_to_binary(BinList_ExpList),

    Data = <<
        ExpList_Len:16, Bin_ExpList/binary
    >>,
    {ok, pt:pack(13217, Data)};

write (13218,[
    ExpList
]) ->
    BinList_ExpList = [
        item_to_bin_3(ExpList_Item) || ExpList_Item <- ExpList
    ], 

    ExpList_Len = length(ExpList), 
    Bin_ExpList = list_to_binary(BinList_ExpList),

    Data = <<
        ExpList_Len:16, Bin_ExpList/binary
    >>,
    {ok, pt:pack(13218, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    GoodsId,
    Num
}) ->
    Data = <<
        Type:8,
        GoodsId:32,
        Num:64
    >>,
    Data.
item_to_bin_1 ({
    Style,
    TypeId,
    Count
}) ->
    Data = <<
        Style:8,
        TypeId:32,
        Count:64
    >>,
    Data.
item_to_bin_2 ({
    Type,
    Ratio,
    EndTime
}) ->
    Data = <<
        Type:32,
        Ratio:64,
        EndTime:32
    >>,
    Data.
item_to_bin_3 ({
    AddExp,
    Ratio
}) ->
    Data = <<
        AddExp:16,
        Ratio:8
    >>,
    Data.
