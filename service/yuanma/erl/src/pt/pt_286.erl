-module(pt_286).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(28601, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(28602, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(28603, Bin0) ->
    <<Pos:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args0_1/binary>> = RestBin0, 
        {GoodsId,_Args0_1}
        end,
    {GoodsList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [Pos, GoodsList]};
read(28604, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(28605, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(28606, _) ->
    {ok, []};
read(28607, Bin0) ->
    <<Figure:16, _Bin1/binary>> = Bin0, 
    {ok, [Figure]};
read(28608, _) ->
    {ok, []};
read(28609, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (28600,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(28600, Data)};

write (28601,[
    Res,
    GoodsId,
    OldGoodsId,
    TypeId,
    CellPos
]) ->
    Data = <<
        Res:32,
        GoodsId:64,
        OldGoodsId:64,
        TypeId:32,
        CellPos:8
    >>,
    {ok, pt:pack(28601, Data)};

write (28602,[
    Res,
    GoodsId,
    Cell
]) ->
    Data = <<
        Res:32,
        GoodsId:64,
        Cell:16
    >>,
    {ok, pt:pack(28602, Data)};

write (28603,[
    Pos,
    Lv,
    Exp
]) ->
    Data = <<
        Pos:8,
        Lv:8,
        Exp:32
    >>,
    {ok, pt:pack(28603, Data)};

write (28604,[
    Pos,
    Lv,
    Exp
]) ->
    Data = <<
        Pos:8,
        Lv:8,
        Exp:32
    >>,
    {ok, pt:pack(28604, Data)};

write (28605,[
    SkillId,
    Lv
]) ->
    Data = <<
        SkillId:32,
        Lv:16
    >>,
    {ok, pt:pack(28605, Data)};

write (28606,[
    MaxFigureId,
    CurrentFigureId,
    Power,
    Gathering,
    Suit,
    SkillList
]) ->
    BinList_Gathering = [
        item_to_bin_0(Gathering_Item) || Gathering_Item <- Gathering
    ], 

    Gathering_Len = length(Gathering), 
    Bin_Gathering = list_to_binary(BinList_Gathering),

    BinList_Suit = [
        item_to_bin_1(Suit_Item) || Suit_Item <- Suit
    ], 

    Suit_Len = length(Suit), 
    Bin_Suit = list_to_binary(BinList_Suit),

    BinList_SkillList = [
        item_to_bin_2(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        MaxFigureId:16,
        CurrentFigureId:16,
        Power:64,
        Gathering_Len:16, Bin_Gathering/binary,
        Suit_Len:16, Bin_Suit/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(28606, Data)};

write (28607,[
    MaxFigureId,
    CurrentFigureId
]) ->
    Data = <<
        MaxFigureId:16,
        CurrentFigureId:16
    >>,
    {ok, pt:pack(28607, Data)};

write (28608,[
    Suit
]) ->
    BinList_Suit = [
        item_to_bin_3(Suit_Item) || Suit_Item <- Suit
    ], 

    Suit_Len = length(Suit), 
    Bin_Suit = list_to_binary(BinList_Suit),

    Data = <<
        Suit_Len:16, Bin_Suit/binary
    >>,
    {ok, pt:pack(28608, Data)};

write (28609,[
    Power
]) ->
    Data = <<
        Power:64
    >>,
    {ok, pt:pack(28609, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Pos,
    Lv,
    Exp,
    Flag
}) ->
    Data = <<
        Pos:8,
        Lv:16,
        Exp:32,
        Flag:8
    >>,
    Data.
item_to_bin_1 ({
    Star,
    Num
}) ->
    Data = <<
        Star:32,
        Num:32
    >>,
    Data.
item_to_bin_2 ({
    SkillId,
    Lv
}) ->
    Data = <<
        SkillId:32,
        Lv:16
    >>,
    Data.
item_to_bin_3 ({
    Star,
    Num
}) ->
    Data = <<
        Star:32,
        Num:32
    >>,
    Data.
