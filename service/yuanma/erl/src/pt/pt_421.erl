-module(pt_421).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42101, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {GoodsList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsList]};
read(42103, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<PushId:64, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, PushId]};
read(42106, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<Status:8, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, Status]};
read(42107, _) ->
    {ok, []};
read(42108, Bin0) ->
    <<TeamId:32, _Bin1/binary>> = Bin0, 
    {ok, [TeamId]};
read(_Cmd, _R) -> {error, no_match}.

write (42101,[
    MapLists
]) ->
    BinList_MapLists = [
        item_to_bin_0(MapLists_Item) || MapLists_Item <- MapLists
    ], 

    MapLists_Len = length(MapLists), 
    Bin_MapLists = list_to_binary(BinList_MapLists),

    Data = <<
        MapLists_Len:16, Bin_MapLists/binary
    >>,
    {ok, pt:pack(42101, Data)};

write (42102,[
    RoleId,
    GoodsId,
    ProduceTime,
    Type,
    Scene,
    PosList
]) ->
    BinList_PosList = [
        item_to_bin_2(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        RoleId:64,
        GoodsId:64,
        ProduceTime:32,
        Type:8,
        Scene:32,
        PosList_Len:16, Bin_PosList/binary
    >>,
    {ok, pt:pack(42102, Data)};

write (42103,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(42103, Data)};

write (42104,[
    RoleId,
    GoodsId,
    ProduceTime,
    Type,
    Scene,
    PosList
]) ->
    BinList_PosList = [
        item_to_bin_3(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        RoleId:64,
        GoodsId:64,
        ProduceTime:32,
        Type:8,
        Scene:32,
        PosList_Len:16, Bin_PosList/binary
    >>,
    {ok, pt:pack(42104, Data)};

write (42106,[
    GoodsId,
    Status,
    Errcode
]) ->
    Data = <<
        GoodsId:64,
        Status:8,
        Errcode:32
    >>,
    {ok, pt:pack(42106, Data)};

write (42107,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(42107, Data)};

write (42108,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(42108, Data)};

write (42109,[
    Name,
    Errcode
]) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Bin_Name/binary,
        Errcode:32
    >>,
    {ok, pt:pack(42109, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RoleId,
    GoodsId,
    ProduceTime,
    Type,
    Scene,
    PosList
}) ->
    BinList_PosList = [
        item_to_bin_1(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        RoleId:64,
        GoodsId:64,
        ProduceTime:32,
        Type:8,
        Scene:32,
        PosList_Len:16, Bin_PosList/binary
    >>,
    Data.
item_to_bin_1 ({
    Pos,
    X,
    Y,
    Clue,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Pos:8,
        X:32,
        Y:32,
        Clue:64,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_2 ({
    Pos,
    X,
    Y,
    Clue,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Pos:8,
        X:32,
        Y:32,
        Clue:64,
        Bin_Name/binary
    >>,
    Data.
item_to_bin_3 ({
    Pos,
    X,
    Y,
    Clue,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Pos:8,
        X:32,
        Y:32,
        Clue:64,
        Bin_Name/binary
    >>,
    Data.
