-module(pt_167).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16700, _) ->
    {ok, []};
read(16701, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [PosId, GoodsId]};
read(16702, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(16703, Bin0) ->
    <<Id:16, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [Id, Num]};
read(16704, _) ->
    {ok, []};
read(16705, Bin0) ->
    <<RuleId:64, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodId:64, _Args1/binary>> = RestBin0, 
        {GoodId,_Args1}
        end,
    {RuneList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [RuleId, RuneList]};
read(16706, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodId:64, _Args1/binary>> = RestBin0, 
        {GoodId,_Args1}
        end,
    {RuneList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [RuneList]};
read(16707, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<AttrId:16, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<CostId:64, _Args1/binary>> = RestBin0, 
        {CostId,_Args1}
        end,
    {CostIdList, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [GoodsId, AttrId, CostIdList]};
read(16708, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {GoodsIdList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsIdList]};
read(16709, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodId:64, _Args1/binary>> = RestBin0, 
        {GoodId,_Args1}
        end,
    {RuneList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [RuneList]};
read(16710, _) ->
    {ok, []};
read(16711, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [PosId, GoodsId]};
read(_Cmd, _R) -> {error, no_match}.

write (16700,[
    RunePoint,
    RuneChip,
    SkillLv,
    RuneList,
    RuneSumPower
]) ->
    BinList_RuneList = [
        item_to_bin_0(RuneList_Item) || RuneList_Item <- RuneList
    ], 

    RuneList_Len = length(RuneList), 
    Bin_RuneList = list_to_binary(BinList_RuneList),

    Data = <<
        RunePoint:32,
        RuneChip:32,
        SkillLv:16,
        RuneList_Len:16, Bin_RuneList/binary,
        RuneSumPower:64
    >>,
    {ok, pt:pack(16700, Data)};

write (16701,[
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
    {ok, pt:pack(16701, Data)};

write (16702,[
    Code,
    RunePoint,
    GoodsId
]) ->
    Data = <<
        Code:32,
        RunePoint:32,
        GoodsId:64
    >>,
    {ok, pt:pack(16702, Data)};

write (16703,[
    Code,
    RuneChip,
    Id,
    Num
]) ->
    Data = <<
        Code:32,
        RuneChip:32,
        Id:16,
        Num:32
    >>,
    {ok, pt:pack(16703, Data)};

write (16704,[
    RuneDungeonLevel
]) ->
    Data = <<
        RuneDungeonLevel:16
    >>,
    {ok, pt:pack(16704, Data)};

write (16705,[
    Code,
    Lv
]) ->
    Data = <<
        Code:32,
        Lv:32
    >>,
    {ok, pt:pack(16705, Data)};

write (16706,[
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
    {ok, pt:pack(16706, Data)};

write (16707,[
    Code,
    GoodsId,
    AttrId,
    Lv,
    AwakeLv,
    Exp,
    NextPower,
    CurPower
]) ->
    Data = <<
        Code:32,
        GoodsId:64,
        AttrId:16,
        Lv:16,
        AwakeLv:32,
        Exp:32,
        NextPower:64,
        CurPower:64
    >>,
    {ok, pt:pack(16707, Data)};

write (16708,[
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
    {ok, pt:pack(16708, Data)};

write (16709,[
    Code,
    ResultList
]) ->
    Bin_ResultList = pt:write_object_list(ResultList), 

    Data = <<
        Code:32,
        Bin_ResultList/binary
    >>,
    {ok, pt:pack(16709, Data)};

write (16710,[
    Code,
    Lv
]) ->
    Data = <<
        Code:32,
        Lv:32
    >>,
    {ok, pt:pack(16710, Data)};

write (16711,[
    Code,
    PosId,
    GoodsId
]) ->
    Data = <<
        Code:32,
        PosId:8,
        GoodsId:64
    >>,
    {ok, pt:pack(16711, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PosId,
    IfOpen,
    GoodsId,
    GoodsTypeId,
    Color,
    Lv,
    AttrList
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
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    Data.
item_to_bin_1 ({
    AttrId,
    AttrNum,
    AwakeLv,
    AwakeExp,
    NextPower,
    CurPower
}) ->
    Data = <<
        AttrId:32,
        AttrNum:32,
        AwakeLv:32,
        AwakeExp:32,
        NextPower:64,
        CurPower:64
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
