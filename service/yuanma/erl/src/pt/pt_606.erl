-module(pt_606).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(60602, _) ->
    {ok, []};
read(60603, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(60604, Bin0) ->
    <<IlluId:32, _Bin1/binary>> = Bin0, 
    {ok, [IlluId]};
read(60605, _) ->
    {ok, []};
read(60606, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(60607, Bin0) ->
    <<Id:32, Bin1/binary>> = Bin0, 
    <<TypeId:32, _Bin2/binary>> = Bin1, 
    {ok, [Id, TypeId]};
read(60608, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(60609, Bin0) ->
    <<IlluId:32, _Bin1/binary>> = Bin0, 
    {ok, [IlluId]};
read(60611, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [Type, Id]};
read(60612, Bin0) ->
    <<TypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(60613, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(60614, _) ->
    {ok, []};
read(60615, Bin0) ->
    <<Location:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [Location, Id]};
read(60616, Bin0) ->
    <<Location:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [Location, Id]};
read(_Cmd, _R) -> {error, no_match}.

write (60600,[
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(60600, Data)};

write (60601,[
    RoleId,
    FigureId,
    Display
]) ->
    Data = <<
        RoleId:64,
        FigureId:32,
        Display:8
    >>,
    {ok, pt:pack(60601, Data)};

write (60602,[
    FightId,
    FightIlluId,
    GhostList,
    IlluList,
    Display
]) ->
    BinList_GhostList = [
        item_to_bin_0(GhostList_Item) || GhostList_Item <- GhostList
    ], 

    GhostList_Len = length(GhostList), 
    Bin_GhostList = list_to_binary(BinList_GhostList),

    BinList_IlluList = [
        item_to_bin_1(IlluList_Item) || IlluList_Item <- IlluList
    ], 

    IlluList_Len = length(IlluList), 
    Bin_IlluList = list_to_binary(BinList_IlluList),

    Data = <<
        FightId:32,
        FightIlluId:32,
        GhostList_Len:16, Bin_GhostList/binary,
        IlluList_Len:16, Bin_IlluList/binary,
        Display:8
    >>,
    {ok, pt:pack(60602, Data)};

write (60603,[
    Id,
    Stage,
    Exp,
    Lv,
    AttrList,
    Combat
]) ->
    BinList_AttrList = [
        item_to_bin_2(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Id:32,
        Stage:16,
        Exp:32,
        Lv:16,
        AttrList_Len:16, Bin_AttrList/binary,
        Combat:32
    >>,
    {ok, pt:pack(60603, Data)};

write (60604,[
    IlluId,
    EndTime,
    AttrList,
    Combat
]) ->
    BinList_AttrList = [
        item_to_bin_3(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        IlluId:32,
        EndTime:32,
        AttrList_Len:16, Bin_AttrList/binary,
        Combat:32
    >>,
    {ok, pt:pack(60604, Data)};

write (60605,[
    CounterList
]) ->
    BinList_CounterList = [
        item_to_bin_4(CounterList_Item) || CounterList_Item <- CounterList
    ], 

    CounterList_Len = length(CounterList), 
    Bin_CounterList = list_to_binary(BinList_CounterList),

    Data = <<
        CounterList_Len:16, Bin_CounterList/binary
    >>,
    {ok, pt:pack(60605, Data)};

write (60606,[
    Id
]) ->
    Data = <<
        Id:32
    >>,
    {ok, pt:pack(60606, Data)};

write (60607,[
    Id,
    Stage,
    Exp
]) ->
    Data = <<
        Id:32,
        Stage:16,
        Exp:32
    >>,
    {ok, pt:pack(60607, Data)};

write (60608,[
    Id,
    Lv
]) ->
    Data = <<
        Id:32,
        Lv:32
    >>,
    {ok, pt:pack(60608, Data)};

write (60609,[
    IlluId
]) ->
    Data = <<
        IlluId:32
    >>,
    {ok, pt:pack(60609, Data)};

write (60610,[
    IlluId
]) ->
    Data = <<
        IlluId:32
    >>,
    {ok, pt:pack(60610, Data)};

write (60611,[
    Type,
    Id
]) ->
    Data = <<
        Type:8,
        Id:32
    >>,
    {ok, pt:pack(60611, Data)};

write (60612,[
    TypeId
]) ->
    Data = <<
        TypeId:32
    >>,
    {ok, pt:pack(60612, Data)};

write (60613,[
    Type
]) ->
    Data = <<
        Type:8
    >>,
    {ok, pt:pack(60613, Data)};

write (60614,[
    BoundList
]) ->
    BinList_BoundList = [
        item_to_bin_5(BoundList_Item) || BoundList_Item <- BoundList
    ], 

    BoundList_Len = length(BoundList), 
    Bin_BoundList = list_to_binary(BinList_BoundList),

    Data = <<
        BoundList_Len:16, Bin_BoundList/binary
    >>,
    {ok, pt:pack(60614, Data)};

write (60615,[
    Location,
    Id
]) ->
    Data = <<
        Location:8,
        Id:32
    >>,
    {ok, pt:pack(60615, Data)};

write (60616,[
    Location,
    Id
]) ->
    Data = <<
        Location:8,
        Id:32
    >>,
    {ok, pt:pack(60616, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    Stage,
    Lv
}) ->
    Data = <<
        Id:32,
        Stage:16,
        Lv:16
    >>,
    Data.
item_to_bin_1 (
    IlluId
) ->
    Data = <<
        IlluId:32
    >>,
    Data.
item_to_bin_2 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_3 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_4 ({
    GoodsId,
    Id,
    Count,
    CountLim
}) ->
    Data = <<
        GoodsId:32,
        Id:32,
        Count:16,
        CountLim:16
    >>,
    Data.
item_to_bin_5 ({
    Location,
    Id
}) ->
    Data = <<
        Location:8,
        Id:32
    >>,
    Data.
