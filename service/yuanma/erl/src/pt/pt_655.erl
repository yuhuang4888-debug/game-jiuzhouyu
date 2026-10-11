-module(pt_655).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(65500, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Id:32, _Args1/binary>> = RestBin0, 
        {Name, _Args2} = pt:read_string(_Args1), 

        FunArray1 = fun(<<RestBin1/binary>>) -> 
        <<Id:64, _Args1/binary>> = RestBin1, 
        <<Time:32, _Args2/binary>> = _Args1, 
        {{Id, Time},_Args2}
        end,
        {PlayerList2, _Args3} = pt:read_array(FunArray1, _Args2),
        {{Id, Name, PlayerList2},_Args3}
        end,
    {PlayerList, Bin1} = pt:read_array(FunArray0, Bin0),

    FunArray2 = fun(<<RestBin2/binary>>) -> 
        <<Id:64, _Args1/binary>> = RestBin2, 
        <<Time:32, _Args2/binary>> = _Args1, 
        {{Id, Time},_Args2}
        end,
    {PlayerList3, _Bin2} = pt:read_array(FunArray2, Bin1),

    {ok, [PlayerList, PlayerList3]};
read(65502, Bin0) ->
    <<PlayerId:64, _Bin1/binary>> = Bin0, 
    {ok, [PlayerId]};
read(_Cmd, _R) -> {error, no_match}.

write (65500,[
    Index,
    AllList,
    Time
]) ->
    BinList_AllList = [
        item_to_bin_0(AllList_Item) || AllList_Item <- AllList
    ], 

    AllList_Len = length(AllList), 
    Bin_AllList = list_to_binary(BinList_AllList),

    Data = <<
        Index:8,
        AllList_Len:16, Bin_AllList/binary,
        Time:64
    >>,
    {ok, pt:pack(65500, Data)};

write (65501,[
    FigureA,
    BattleAttr,
    BaseAttr,
    AttrList,
    ObjectList
]) ->
    Bin_FigureA = pt:write_figure(FigureA), 

    Bin_BattleAttr = pt:write_battle_attr(BattleAttr), 

    Bin_BaseAttr = pt:write_attr(BaseAttr), 

    Bin_AttrList = pt:write_attr_list(AttrList), 

    Bin_ObjectList = pt:write_object_list(ObjectList), 

    Data = <<
        Bin_FigureA/binary,
        Bin_BattleAttr/binary,
        Bin_BaseAttr/binary,
        Bin_AttrList/binary,
        Bin_ObjectList/binary
    >>,
    {ok, pt:pack(65501, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Id,
    Name
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        Id:32,
        Bin_Name/binary
    >>,
    Data.
