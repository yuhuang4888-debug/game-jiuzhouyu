-module(pt_170).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(17000, _) ->
    {ok, []};
read(17001, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [PosId, GoodsId]};
read(17002, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(17003, Bin0) ->
    <<RuleId:64, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodId:64, _Args1/binary>> = RestBin0, 
        {GoodId,_Args1}
        end,
    {SoulList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [RuleId, SoulList]};
read(17004, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodId:64, _Args1/binary>> = RestBin0, 
        {GoodId,_Args1}
        end,
    {SoulList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [SoulList]};
read(17005, _) ->
    {ok, []};
read(17006, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<AttrId:16, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<CostId:64, _Args1/binary>> = RestBin0, 
        {CostId,_Args1}
        end,
    {CostIdList, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [GoodsId, AttrId, CostIdList]};
read(17007, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {GoodsIdList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsIdList]};
read(_Cmd, _R) -> {error, no_match}.

write (17000,[
    SoulPoint,
    SoulList
]) ->
    BinList_SoulList = [
        item_to_bin_0(SoulList_Item) || SoulList_Item <- SoulList
    ], 

    SoulList_Len = length(SoulList), 
    Bin_SoulList = list_to_binary(BinList_SoulList),

    Data = <<
        SoulPoint:32,
        SoulList_Len:16, Bin_SoulList/binary
    >>,
    {ok, pt:pack(17000, Data)};

write (17001,[
    Code,
    PosId,
    NewGoodsId,
    OldGoodsId,
    NewGoodsTypeId
]) ->
    Data = <<
        Code:32,
        PosId:8,
        NewGoodsId:64,
        OldGoodsId:64,
        NewGoodsTypeId:32
    >>,
    {ok, pt:pack(17001, Data)};

write (17002,[
    Code,
    GoodsId
]) ->
    Data = <<
        Code:32,
        GoodsId:64
    >>,
    {ok, pt:pack(17002, Data)};

write (17003,[
    Code,
    Lv
]) ->
    Data = <<
        Code:32,
        Lv:32
    >>,
    {ok, pt:pack(17003, Data)};

write (17004,[
    Code,
    Exp,
    ResultList
]) ->
    Bin_ResultList = pt:write_object_list(ResultList), 

    Data = <<
        Code:32,
        Exp:64,
        Bin_ResultList/binary
    >>,
    {ok, pt:pack(17004, Data)};

write (17005,[
    Exp
]) ->
    Data = <<
        Exp:64
    >>,
    {ok, pt:pack(17005, Data)};

write (17006,[
    Code,
    GoodsId,
    AttrId,
    AwakeLv,
    Level
]) ->
    Data = <<
        Code:32,
        GoodsId:64,
        AttrId:16,
        AwakeLv:32,
        Level:16
    >>,
    {ok, pt:pack(17006, Data)};

write (17007,[
    Code,
    GoodsIdList
]) ->
    BinList_GoodsIdList = [
        item_to_bin_2(GoodsIdList_Item) || GoodsIdList_Item <- GoodsIdList
    ], 

    GoodsIdList_Len = length(GoodsIdList), 
    Bin_GoodsIdList = list_to_binary(BinList_GoodsIdList),

    Data = <<
        Code:32,
        GoodsIdList_Len:16, Bin_GoodsIdList/binary
    >>,
    {ok, pt:pack(17007, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PosId,
    IfOpen,
    GoodsId,
    GoodsTypeId,
    Color,
    Lv,
    AttrList,
    Power
}) ->
    BinList_AttrList = [
        item_to_bin_1(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        PosId:8,
        IfOpen:8,
        GoodsId:64,
        GoodsTypeId:32,
        Color:8,
        Lv:16,
        AttrList_Len:16, Bin_AttrList/binary,
        Power:32
    >>,
    Data.
item_to_bin_1 ({
    AttrId,
    AttrNum,
    AwakeLv
}) ->
    Data = <<
        AttrId:32,
        AttrNum:32,
        AwakeLv:32
    >>,
    Data.
item_to_bin_2 ({
    GoodsId,
    GoodsList
}) ->
    Bin_GoodsList = pt:write_object_list(GoodsList), 

    Data = <<
        GoodsId:64,
        Bin_GoodsList/binary
    >>,
    Data.
