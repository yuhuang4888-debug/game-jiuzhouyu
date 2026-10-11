-module(pt_640).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(64000, _) ->
    {ok, []};
read(64001, Bin0) ->
    <<Id:32, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [Id, Num]};
read(_Cmd, _R) -> {error, no_match}.

write (64000,[
    IdList
]) ->
    BinList_IdList = [
        item_to_bin_0(IdList_Item) || IdList_Item <- IdList
    ], 

    IdList_Len = length(IdList), 
    Bin_IdList = list_to_binary(BinList_IdList),

    Data = <<
        IdList_Len:16, Bin_IdList/binary
    >>,
    {ok, pt:pack(64000, Data)};

write (64001,[
    Errcode,
    Id,
    SelfNum,
    LeftLimitNum
]) ->
    Data = <<
        Errcode:32,
        Id:32,
        SelfNum:32,
        LeftLimitNum:32
    >>,
    {ok, pt:pack(64001, Data)};

write (64002,[
    ChangeList
]) ->
    BinList_ChangeList = [
        item_to_bin_1(ChangeList_Item) || ChangeList_Item <- ChangeList
    ], 

    ChangeList_Len = length(ChangeList), 
    Bin_ChangeList = list_to_binary(BinList_ChangeList),

    Data = <<
        ChangeList_Len:16, Bin_ChangeList/binary
    >>,
    {ok, pt:pack(64002, Data)};

write (64003,[
    DelList
]) ->
    BinList_DelList = [
        item_to_bin_2(DelList_Item) || DelList_Item <- DelList
    ], 

    DelList_Len = length(DelList), 
    Bin_DelList = list_to_binary(BinList_DelList),

    Data = <<
        DelList_Len:16, Bin_DelList/binary
    >>,
    {ok, pt:pack(64003, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    GoodId,
    DefaultNum,
    PriceType,
    OldPrice,
    NewPrice,
    TotalLimitNum,
    LeftLimitNum,
    DailyLimitNum,
    BuyNum
}) ->
    Data = <<
        Id:32,
        GoodId:32,
        DefaultNum:32,
        PriceType:8,
        OldPrice:32,
        NewPrice:32,
        TotalLimitNum:32,
        LeftLimitNum:32,
        DailyLimitNum:32,
        BuyNum:32
    >>,
    Data.
item_to_bin_1 ({
    Id,
    LeftLimitNum
}) ->
    Data = <<
        Id:32,
        LeftLimitNum:32
    >>,
    Data.
item_to_bin_2 (
    Id
) ->
    Data = <<
        Id:32
    >>,
    Data.
