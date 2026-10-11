-module(pt_153).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15301, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(15302, Bin0) ->
    <<KeyId:32, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [KeyId, Num]};
read(15303, Bin0) ->
    <<GoodsId:32, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, Num]};
read(15304, Bin0) ->
    <<GoodsId:32, Bin1/binary>> = Bin0, 
    <<Num:32, Bin2/binary>> = Bin1, 
    <<BuyType:8, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, Num, BuyType]};
read(15305, Bin0) ->
    <<Type:16, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(15306, Bin0) ->
    <<Type:16, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(15307, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<CfgId:16, Bin2/binary>> = Bin1, 
    <<Price:32, _Bin3/binary>> = Bin2, 
    {ok, [Type, CfgId, Price]};
read(_Cmd, _R) -> {error, no_match}.

write (15301,[
    Type,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_0(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Type:8,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15301, Data)};

write (15302,[
    Result,
    KeyId,
    Num
]) ->
    Data = <<
        Result:32,
        KeyId:32,
        Num:32
    >>,
    {ok, pt:pack(15302, Data)};

write (15303,[
    Res,
    GoodsId,
    Num
]) ->
    Data = <<
        Res:32,
        GoodsId:32,
        Num:32
    >>,
    {ok, pt:pack(15303, Data)};

write (15304,[
    Res,
    GoodsId,
    Num,
    BuyType
]) ->
    Data = <<
        Res:32,
        GoodsId:32,
        Num:32,
        BuyType:8
    >>,
    {ok, pt:pack(15304, Data)};

write (15305,[
    Type,
    RefreshTime,
    HitNum,
    GoodList
]) ->
    BinList_GoodList = [
        item_to_bin_1(GoodList_Item) || GoodList_Item <- GoodList
    ], 

    GoodList_Len = length(GoodList), 
    Bin_GoodList = list_to_binary(BinList_GoodList),

    Data = <<
        Type:16,
        RefreshTime:32,
        HitNum:16,
        GoodList_Len:16, Bin_GoodList/binary
    >>,
    {ok, pt:pack(15305, Data)};

write (15306,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15306, Data)};

write (15307,[
    Errcode,
    Type,
    CfgId
]) ->
    Data = <<
        Errcode:32,
        Type:16,
        CfgId:16
    >>,
    {ok, pt:pack(15307, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    KeyId,
    SubtypeList,
    Rank,
    GoodsId,
    Num,
    MoneyType,
    Price,
    Discount,
    QuotaType,
    QuotaNum,
    SoldOut,
    Condition,
    TriggerTaskId,
    Bind
}) ->
    Bin_SubtypeList = pt:write_string(SubtypeList), 

    Bin_Condition = pt:write_string(Condition), 

    Data = <<
        KeyId:32,
        Bin_SubtypeList/binary,
        Rank:32,
        GoodsId:32,
        Num:32,
        MoneyType:32,
        Price:32,
        Discount:16,
        QuotaType:8,
        QuotaNum:16,
        SoldOut:16,
        Bin_Condition/binary,
        TriggerTaskId:32,
        Bind:8
    >>,
    Data.
item_to_bin_1 ({
    CfgId,
    Discount,
    Price,
    BuyType,
    BuyNum
}) ->
    Data = <<
        CfgId:16,
        Discount:8,
        Price:32,
        BuyType:8,
        BuyNum:8
    >>,
    Data.
