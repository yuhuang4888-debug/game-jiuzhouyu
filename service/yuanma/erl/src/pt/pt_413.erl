-module(pt_413).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(41300, _) ->
    {ok, []};
read(41301, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, Bin2/binary>> = Bin1, 
    <<ColorId:8, Bin3/binary>> = Bin2, 
    <<Type:8, _Bin4/binary>> = Bin3, 
    {ok, [PosId, FashionId, ColorId, Type]};
read(41302, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, Bin2/binary>> = Bin1, 
    <<ColorId:8, _Bin3/binary>> = Bin2, 
    {ok, [PosId, FashionId, ColorId]};
read(41303, Bin0) ->
    <<IposId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, _Bin2/binary>> = Bin1, 
    {ok, [IposId, FashionId]};
read(41304, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, _Bin2/binary>> = Bin1, 
    {ok, [PosId, FashionId]};
read(41305, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        <<GoodsNum:16, _Args2/binary>> = _Args1, 
        {{GoodsId, GoodsNum},_Args2}
        end,
    {GoodsList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [PosId, GoodsList]};
read(41306, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, Bin2/binary>> = Bin1, 
    <<ColorId:8, _Bin3/binary>> = Bin2, 
    {ok, [PosId, FashionId, ColorId]};
read(41307, _) ->
    {ok, []};
read(41310, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, _Bin2/binary>> = Bin1, 
    {ok, [PosId, FashionId]};
read(41311, _) ->
    {ok, []};
read(41312, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, _Bin2/binary>> = Bin1, 
    {ok, [PosId, FashionId]};
read(41313, _) ->
    {ok, []};
read(41314, Bin0) ->
    <<SuitId:8, Bin1/binary>> = Bin0, 
    <<ActiveNum:8, _Bin2/binary>> = Bin1, 
    {ok, [SuitId, ActiveNum]};
read(41315, Bin0) ->
    <<SuitId:8, _Bin1/binary>> = Bin0, 
    {ok, [SuitId]};
read(41316, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<FashionId:32, Bin2/binary>> = Bin1, 
    <<ColorId:8, _Bin3/binary>> = Bin2, 
    {ok, [PosId, FashionId, ColorId]};
read(_Cmd, _R) -> {error, no_match}.

write (41300,[
    Code,
    PosList
]) ->
    BinList_PosList = [
        item_to_bin_0(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        Code:32,
        PosList_Len:16, Bin_PosList/binary
    >>,
    {ok, pt:pack(41300, Data)};

write (41301,[
    Code,
    PosId,
    FashionId,
    ColorId,
    Type
]) ->
    Data = <<
        Code:32,
        PosId:8,
        FashionId:32,
        ColorId:8,
        Type:8
    >>,
    {ok, pt:pack(41301, Data)};

write (41302,[
    Code,
    PosId,
    FashionId,
    ColorId
]) ->
    Data = <<
        Code:32,
        PosId:8,
        FashionId:32,
        ColorId:8
    >>,
    {ok, pt:pack(41302, Data)};

write (41303,[
    Code,
    PosId,
    FashionId
]) ->
    Data = <<
        Code:32,
        PosId:8,
        FashionId:32
    >>,
    {ok, pt:pack(41303, Data)};

write (41304,[
    Code,
    PosId,
    FashionId
]) ->
    Data = <<
        Code:32,
        PosId:8,
        FashionId:32
    >>,
    {ok, pt:pack(41304, Data)};

write (41305,[
    Code,
    PosId,
    PosLv,
    PosUpgradeNum
]) ->
    Data = <<
        Code:32,
        PosId:8,
        PosLv:16,
        PosUpgradeNum:32
    >>,
    {ok, pt:pack(41305, Data)};

write (41306,[
    Code,
    PosId,
    FashionId,
    ColorId,
    FashionStarLv
]) ->
    Data = <<
        Code:32,
        PosId:8,
        FashionId:32,
        ColorId:8,
        FashionStarLv:16
    >>,
    {ok, pt:pack(41306, Data)};

write (41307,[
    PosId,
    PosUpgradeNum
]) ->
    Data = <<
        PosId:8,
        PosUpgradeNum:32
    >>,
    {ok, pt:pack(41307, Data)};

write (41310,[
    Code,
    PosId,
    FashionId,
    FashionStarLv,
    ColorId,
    ColorList
]) ->
    BinList_ColorList = [
        item_to_bin_3(ColorList_Item) || ColorList_Item <- ColorList
    ], 

    ColorList_Len = length(ColorList), 
    Bin_ColorList = list_to_binary(BinList_ColorList),

    Data = <<
        Code:32,
        PosId:8,
        FashionId:32,
        FashionStarLv:16,
        ColorId:8,
        ColorList_Len:16, Bin_ColorList/binary
    >>,
    {ok, pt:pack(41310, Data)};

write (41311,[
    RoleId,
    FashionEquip
]) ->
    BinList_FashionEquip = [
        item_to_bin_4(FashionEquip_Item) || FashionEquip_Item <- FashionEquip
    ], 

    FashionEquip_Len = length(FashionEquip), 
    Bin_FashionEquip = list_to_binary(BinList_FashionEquip),

    Data = <<
        RoleId:64,
        FashionEquip_Len:16, Bin_FashionEquip/binary
    >>,
    {ok, pt:pack(41311, Data)};

write (41312,[
    PosId,
    FashionId,
    ColorPowerList
]) ->
    BinList_ColorPowerList = [
        item_to_bin_5(ColorPowerList_Item) || ColorPowerList_Item <- ColorPowerList
    ], 

    ColorPowerList_Len = length(ColorPowerList), 
    Bin_ColorPowerList = list_to_binary(BinList_ColorPowerList),

    Data = <<
        PosId:8,
        FashionId:32,
        ColorPowerList_Len:16, Bin_ColorPowerList/binary
    >>,
    {ok, pt:pack(41312, Data)};

write (41313,[
    FashionSuit
]) ->
    BinList_FashionSuit = [
        item_to_bin_6(FashionSuit_Item) || FashionSuit_Item <- FashionSuit
    ], 

    FashionSuit_Len = length(FashionSuit), 
    Bin_FashionSuit = list_to_binary(BinList_FashionSuit),

    Data = <<
        FashionSuit_Len:16, Bin_FashionSuit/binary
    >>,
    {ok, pt:pack(41313, Data)};

write (41314,[
    SuitId,
    ActiveNum,
    Code,
    Power,
    NextPower
]) ->
    Data = <<
        SuitId:8,
        ActiveNum:8,
        Code:32,
        Power:32,
        NextPower:32
    >>,
    {ok, pt:pack(41314, Data)};

write (41315,[
    SuitId,
    Lv,
    Code,
    Power,
    NextPower
]) ->
    Data = <<
        SuitId:8,
        Lv:8,
        Code:32,
        Power:32,
        NextPower:32
    >>,
    {ok, pt:pack(41315, Data)};

write (41316,[
    PosId,
    FashionId,
    ColorId,
    Lv,
    Code
]) ->
    Data = <<
        PosId:8,
        FashionId:32,
        ColorId:8,
        Lv:8,
        Code:32
    >>,
    {ok, pt:pack(41316, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PosId,
    WearFashionId,
    PosLv,
    PosUpgradeNum,
    FashionList
}) ->
    BinList_FashionList = [
        item_to_bin_1(FashionList_Item) || FashionList_Item <- FashionList
    ], 

    FashionList_Len = length(FashionList), 
    Bin_FashionList = list_to_binary(BinList_FashionList),

    Data = <<
        PosId:8,
        WearFashionId:32,
        PosLv:16,
        PosUpgradeNum:32,
        FashionList_Len:16, Bin_FashionList/binary
    >>,
    Data.
item_to_bin_1 ({
    FashionId,
    FashionStarLv,
    NowColorId,
    ColorList
}) ->
    BinList_ColorList = [
        item_to_bin_2(ColorList_Item) || ColorList_Item <- ColorList
    ], 

    ColorList_Len = length(ColorList), 
    Bin_ColorList = list_to_binary(BinList_ColorList),

    Data = <<
        FashionId:32,
        FashionStarLv:16,
        NowColorId:8,
        ColorList_Len:16, Bin_ColorList/binary
    >>,
    Data.
item_to_bin_2 ({
    ColorId,
    FashionStarLv
}) ->
    Data = <<
        ColorId:8,
        FashionStarLv:16
    >>,
    Data.
item_to_bin_3 (
    ColorId
) ->
    Data = <<
        ColorId:8
    >>,
    Data.
item_to_bin_4 ({
    PartPos,
    FashionModelId,
    FashionChartletId
}) ->
    Data = <<
        PartPos:8,
        FashionModelId:32,
        FashionChartletId:8
    >>,
    Data.
item_to_bin_5 ({
    ColorId,
    ColorPower,
    NextColorPower
}) ->
    Data = <<
        ColorId:8,
        ColorPower:64,
        NextColorPower:64
    >>,
    Data.
item_to_bin_6 ({
    SuitId,
    Lv,
    ActiveNum,
    ConformNum,
    Power,
    NextPower
}) ->
    Data = <<
        SuitId:8,
        Lv:8,
        ActiveNum:8,
        ConformNum:8,
        Power:32,
        NextPower:32
    >>,
    Data.
