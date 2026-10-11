-module(pt_158).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15800, _) ->
    {ok, []};
read(15803, _) ->
    {ok, []};
read(15804, Bin0) ->
    <<ProductId:32, _Bin1/binary>> = Bin0, 
    {ok, [ProductId]};
read(15899, Bin0) ->
    <<ProductId:32, _Bin1/binary>> = Bin0, 
    {ok, [ProductId]};
read(_Cmd, _R) -> {error, no_match}.

write (15800,[
    ProductList
]) ->
    BinList_ProductList = [
        item_to_bin_0(ProductList_Item) || ProductList_Item <- ProductList
    ], 

    ProductList_Len = length(ProductList), 
    Bin_ProductList = list_to_binary(BinList_ProductList),

    Data = <<
        ProductList_Len:16, Bin_ProductList/binary
    >>,
    {ok, pt:pack(15800, Data)};

write (15801,[
    ProductId,
    ReturnType
]) ->
    Data = <<
        ProductId:32,
        ReturnType:8
    >>,
    {ok, pt:pack(15801, Data)};

write (15802,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15802, Data)};

write (15803,[
    Gold
]) ->
    Data = <<
        Gold:32
    >>,
    {ok, pt:pack(15803, Data)};

write (15804,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(15804, Data)};

write (15899,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(15899, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ProductId,
    ReturnType
}) ->
    Data = <<
        ProductId:32,
        ReturnType:8
    >>,
    Data.
