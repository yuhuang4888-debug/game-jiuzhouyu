-module(pt_422).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42200, _) ->
    {ok, []};
read(42201, Bin0) ->
    <<StarMapId:32, _Bin1/binary>> = Bin0, 
    {ok, [StarMapId]};
read(_Cmd, _R) -> {error, no_match}.

write (42200,[
    StarMapId,
    StarPower,
    Attr
]) ->
    BinList_Attr = [
        item_to_bin_0(Attr_Item) || Attr_Item <- Attr
    ], 

    Attr_Len = length(Attr), 
    Bin_Attr = list_to_binary(BinList_Attr),

    Data = <<
        StarMapId:32,
        StarPower:32,
        Attr_Len:16, Bin_Attr/binary
    >>,
    {ok, pt:pack(42200, Data)};

write (42201,[
    ResCode
]) ->
    Data = <<
        ResCode:32
    >>,
    {ok, pt:pack(42201, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AttrType,
    AttrValue
}) ->
    Data = <<
        AttrType:32,
        AttrValue:32
    >>,
    Data.
