-module(pt_143).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14300, _) ->
    {ok, []};
read(14301, Bin0) ->
    <<DragonId:32, _Bin1/binary>> = Bin0, 
    {ok, [DragonId]};
read(14302, Bin0) ->
    <<DragonId:32, _Bin1/binary>> = Bin0, 
    {ok, [DragonId]};
read(14303, _) ->
    {ok, []};
read(14304, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Op:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Op]};
read(14305, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Lv:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, Lv]};
read(14306, _) ->
    {ok, []};
read(14310, _) ->
    {ok, []};
read(14311, _) ->
    {ok, []};
read(14312, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (14300,[
    DragonList
]) ->
    BinList_DragonList = [
        item_to_bin_0(DragonList_Item) || DragonList_Item <- DragonList
    ], 

    DragonList_Len = length(DragonList), 
    Bin_DragonList = list_to_binary(BinList_DragonList),

    Data = <<
        DragonList_Len:16, Bin_DragonList/binary
    >>,
    {ok, pt:pack(14300, Data)};

write (14301,[
    Errcode,
    DragonId,
    Power,
    NextPower
]) ->
    Data = <<
        Errcode:32,
        DragonId:32,
        Power:64,
        NextPower:64
    >>,
    {ok, pt:pack(14301, Data)};

write (14302,[
    Errcode,
    DragonId,
    DragonLv,
    Power,
    NextPower
]) ->
    Data = <<
        Errcode:32,
        DragonId:32,
        DragonLv:16,
        Power:64,
        NextPower:64
    >>,
    {ok, pt:pack(14302, Data)};

write (14303,[
    WearType,
    FigureList
]) ->
    BinList_FigureList = [
        item_to_bin_1(FigureList_Item) || FigureList_Item <- FigureList
    ], 

    FigureList_Len = length(FigureList), 
    Bin_FigureList = list_to_binary(BinList_FigureList),

    Data = <<
        WearType:8,
        FigureList_Len:16, Bin_FigureList/binary
    >>,
    {ok, pt:pack(14303, Data)};

write (14304,[
    Code,
    Type,
    Op
]) ->
    Data = <<
        Code:32,
        Type:8,
        Op:8
    >>,
    {ok, pt:pack(14304, Data)};

write (14305,[
    Code,
    Type,
    Lv
]) ->
    Data = <<
        Code:32,
        Type:8,
        Lv:8
    >>,
    {ok, pt:pack(14305, Data)};

write (14306,[
    TotalPower
]) ->
    Data = <<
        TotalPower:64
    >>,
    {ok, pt:pack(14306, Data)};

write (14310,[
    Status,
    Power
]) ->
    Data = <<
        Status:8,
        Power:64
    >>,
    {ok, pt:pack(14310, Data)};

write (14311,[
    Id,
    BuyTimes
]) ->
    Data = <<
        Id:32,
        BuyTimes:16
    >>,
    {ok, pt:pack(14311, Data)};

write (14312,[
    Reward
]) ->
    BinList_Reward = [
        item_to_bin_2(Reward_Item) || Reward_Item <- Reward
    ], 

    Reward_Len = length(Reward), 
    Bin_Reward = list_to_binary(BinList_Reward),

    Data = <<
        Reward_Len:16, Bin_Reward/binary
    >>,
    {ok, pt:pack(14312, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    DragonId,
    DragonLv,
    Power,
    NextPower
}) ->
    Data = <<
        DragonId:32,
        DragonLv:16,
        Power:64,
        NextPower:64
    >>,
    Data.
item_to_bin_1 ({
    Type,
    Lv,
    Power,
    NextPower
}) ->
    Data = <<
        Type:8,
        Lv:8,
        Power:64,
        NextPower:64
    >>,
    Data.
item_to_bin_2 ({
    GoodType,
    GoodId,
    Num
}) ->
    Data = <<
        GoodType:32,
        GoodId:32,
        Num:32
    >>,
    Data.
