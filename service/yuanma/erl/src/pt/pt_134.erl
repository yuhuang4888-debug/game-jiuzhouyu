-module(pt_134).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(13400, _) ->
    {ok, []};
read(13401, _) ->
    {ok, []};
read(13402, _) ->
    {ok, []};
read(13403, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(13404, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(13405, _) ->
    {ok, []};
read(13406, _) ->
    {ok, []};
read(13407, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        <<Num:32, _Args2/binary>> = _Args1, 
        {{GoodsId, Num},_Args2}
        end,
    {CostList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [CostList]};
read(_Cmd, _R) -> {error, no_match}.

write (13400,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(13400, Data)};

write (13401,[
    Id,
    StrenLv,
    StrenExp,
    Honour,
    Power,
    PassLayers
]) ->
    Data = <<
        Id:32,
        StrenLv:32,
        StrenExp:32,
        Honour:64,
        Power:32,
        PassLayers:32
    >>,
    {ok, pt:pack(13401, Data)};

write (13402,[
    Id,
    Honour
]) ->
    Data = <<
        Id:32,
        Honour:64
    >>,
    {ok, pt:pack(13402, Data)};

write (13403,[
    Code,
    Id,
    Level,
    Power,
    IsEquip
]) ->
    Data = <<
        Code:32,
        Id:32,
        Level:16,
        Power:32,
        IsEquip:8
    >>,
    {ok, pt:pack(13403, Data)};

write (13404,[
    Id,
    Code
]) ->
    Data = <<
        Id:32,
        Code:32
    >>,
    {ok, pt:pack(13404, Data)};

write (13405,[
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(13405, Data)};

write (13406,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(13406, Data)};

write (13407,[
    Lv,
    Exp,
    Power
]) ->
    Data = <<
        Lv:32,
        Exp:32,
        Power:32
    >>,
    {ok, pt:pack(13407, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    Level,
    Power,
    IsEquip
}) ->
    Data = <<
        Id:32,
        Level:16,
        Power:32,
        IsEquip:8
    >>,
    Data.
