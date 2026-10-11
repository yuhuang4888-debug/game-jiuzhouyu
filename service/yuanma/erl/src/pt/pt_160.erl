-module(pt_160).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16002, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16003, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Type:8, Bin2/binary>> = Bin1, 
    <<Args:32, Bin3/binary>> = Bin2, 
    <<Color:32, _Bin4/binary>> = Bin3, 
    {ok, [TypeId, Type, Args, Color]};
read(16004, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Type]};
read(16005, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16006, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16007, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Id]};
read(16008, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Id]};
read(16009, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Id:32, Bin2/binary>> = Bin1, 
    <<GoodsId:32, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, Id, GoodsId]};
read(16010, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:32, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, GoodsId]};
read(16011, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16013, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<SkillId:32, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, SkillId]};
read(16014, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16015, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<PosId:8, Bin2/binary>> = Bin1, 
    <<GoodsId:64, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, PosId, GoodsId]};
read(16016, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<CostGoodsId:64, _Args1/binary>> = RestBin0, 
        {CostGoodsId,_Args1}
        end,
    {CostList, _Bin3} = pt:read_array(FunArray0, Bin2),

    {ok, [TypeId, GoodsId, CostList]};
read(16017, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, Bin2/binary>> = Bin1, 
    <<CostGoodsId:64, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, GoodsId, CostGoodsId]};
read(16018, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        <<Num:32, _Args2/binary>> = _Args1, 
        {{GoodsId, Num},_Args2}
        end,
    {GoodsList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [TypeId, GoodsList]};
read(16019, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16020, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Id:32, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Id]};
read(16021, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16022, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Id:8, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Id]};
read(16023, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<AutoBuy:8, Bin2/binary>> = Bin1, 
    <<GoldType:8, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, AutoBuy, GoldType]};
read(16024, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<AutoBuy:8, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, AutoBuy]};
read(16026, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Id:8, Bin2/binary>> = Bin1, 
    <<ColorId:32, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, Id, ColorId]};
read(16027, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Id:8, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Id]};
read(16028, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16029, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16030, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<SkillId:32, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, SkillId]};
read(_Cmd, _R) -> {error, no_match}.

write (16000,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(16000, Data)};

write (16001,[
    TypeId,
    RoleId,
    IsRide,
    FigureId,
    Speed
]) ->
    Data = <<
        TypeId:8,
        RoleId:64,
        IsRide:8,
        FigureId:32,
        Speed:16
    >>,
    {ok, pt:pack(16001, Data)};

write (16002,[
    TypeId,
    Stage,
    Star,
    Blessing,
    FigureStage,
    Combat,
    Etime,
    AutoBuy,
    AttrList,
    SkillList
]) ->
    BinList_AttrList = [
        item_to_bin_0(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    BinList_SkillList = [
        item_to_bin_1(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        TypeId:8,
        Stage:8,
        Star:16,
        Blessing:32,
        FigureStage:8,
        Combat:32,
        Etime:64,
        AutoBuy:8,
        AttrList_Len:16, Bin_AttrList/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(16002, Data)};

write (16003,[
    Errcode,
    TypeId,
    Type,
    Args,
    Color
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        Type:8,
        Args:32,
        Color:32
    >>,
    {ok, pt:pack(16003, Data)};

write (16004,[
    Errcode,
    TypeId,
    Type
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        Type:8
    >>,
    {ok, pt:pack(16004, Data)};

write (16005,[
    Errcode,
    TypeId,
    Stage,
    Star,
    Blessing,
    BlessingPlus,
    RatioList
]) ->
    BinList_RatioList = [
        item_to_bin_2(RatioList_Item) || RatioList_Item <- RatioList
    ], 

    RatioList_Len = length(RatioList), 
    Bin_RatioList = list_to_binary(BinList_RatioList),

    Data = <<
        Errcode:32,
        TypeId:8,
        Stage:8,
        Star:16,
        Blessing:32,
        BlessingPlus:32,
        RatioList_Len:16, Bin_RatioList/binary
    >>,
    {ok, pt:pack(16005, Data)};

write (16006,[
    Errcode,
    TypeId,
    IllusionId,
    ColorId,
    FigureList
]) ->
    BinList_FigureList = [
        item_to_bin_3(FigureList_Item) || FigureList_Item <- FigureList
    ], 

    FigureList_Len = length(FigureList), 
    Bin_FigureList = list_to_binary(BinList_FigureList),

    Data = <<
        Errcode:32,
        TypeId:8,
        IllusionId:32,
        ColorId:16,
        FigureList_Len:16, Bin_FigureList/binary
    >>,
    {ok, pt:pack(16006, Data)};

write (16007,[
    Errcode,
    TypeId,
    Id,
    Stage,
    Star,
    Blessing,
    Combat,
    StarCombat,
    Time,
    AttrList,
    SkillList,
    ColorList,
    NextStarPower
]) ->
    BinList_AttrList = [
        item_to_bin_4(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    BinList_SkillList = [
        item_to_bin_5(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    BinList_ColorList = [
        item_to_bin_6(ColorList_Item) || ColorList_Item <- ColorList
    ], 

    ColorList_Len = length(ColorList), 
    Bin_ColorList = list_to_binary(BinList_ColorList),

    Data = <<
        Errcode:32,
        TypeId:8,
        Id:32,
        Stage:8,
        Star:16,
        Blessing:32,
        Combat:32,
        StarCombat:32,
        Time:32,
        AttrList_Len:16, Bin_AttrList/binary,
        SkillList_Len:16, Bin_SkillList/binary,
        ColorList_Len:16, Bin_ColorList/binary,
        NextStarPower:64
    >>,
    {ok, pt:pack(16007, Data)};

write (16008,[
    Errcode,
    TypeId,
    Id,
    Combat
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        Id:32,
        Combat:32
    >>,
    {ok, pt:pack(16008, Data)};

write (16009,[
    Errcode,
    TypeId,
    Id,
    Stage,
    Blessing,
    BlessingPlus,
    RatioList,
    GoodsId
]) ->
    BinList_RatioList = [
        item_to_bin_7(RatioList_Item) || RatioList_Item <- RatioList
    ], 

    RatioList_Len = length(RatioList), 
    Bin_RatioList = list_to_binary(BinList_RatioList),

    Data = <<
        Errcode:32,
        TypeId:8,
        Id:32,
        Stage:8,
        Blessing:32,
        BlessingPlus:32,
        RatioList_Len:16, Bin_RatioList/binary,
        GoodsId:32
    >>,
    {ok, pt:pack(16009, Data)};

write (16010,[
    Errcode,
    TypeId,
    GoodsId
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        GoodsId:32
    >>,
    {ok, pt:pack(16010, Data)};

write (16011,[
    TypeId,
    CounterList
]) ->
    BinList_CounterList = [
        item_to_bin_8(CounterList_Item) || CounterList_Item <- CounterList
    ], 

    CounterList_Len = length(CounterList), 
    Bin_CounterList = list_to_binary(BinList_CounterList),

    Data = <<
        TypeId:8,
        CounterList_Len:16, Bin_CounterList/binary
    >>,
    {ok, pt:pack(16011, Data)};

write (16012,[
    TypeId,
    Id
]) ->
    Data = <<
        TypeId:8,
        Id:8
    >>,
    {ok, pt:pack(16012, Data)};

write (16013,[
    SkillId,
    Power
]) ->
    Data = <<
        SkillId:32,
        Power:32
    >>,
    {ok, pt:pack(16013, Data)};

write (16014,[
    TypeId,
    Errcode,
    CombatPower,
    PetEquipList
]) ->
    BinList_PetEquipList = [
        item_to_bin_9(PetEquipList_Item) || PetEquipList_Item <- PetEquipList
    ], 

    PetEquipList_Len = length(PetEquipList), 
    Bin_PetEquipList = list_to_binary(BinList_PetEquipList),

    Data = <<
        TypeId:8,
        Errcode:32,
        CombatPower:32,
        PetEquipList_Len:16, Bin_PetEquipList/binary
    >>,
    {ok, pt:pack(16014, Data)};

write (16015,[
    TypeId,
    Code,
    PosId,
    NewGoodsId,
    OldGoodsId,
    NewGoodsTypeId,
    CombatPower
]) ->
    Data = <<
        TypeId:8,
        Code:32,
        PosId:8,
        NewGoodsId:64,
        OldGoodsId:64,
        NewGoodsTypeId:32,
        CombatPower:32
    >>,
    {ok, pt:pack(16015, Data)};

write (16016,[
    TypeId,
    Code,
    Exp,
    Level,
    GoodsId,
    CombatPower
]) ->
    Data = <<
        TypeId:8,
        Code:32,
        Exp:32,
        Level:16,
        GoodsId:64,
        CombatPower:32
    >>,
    {ok, pt:pack(16016, Data)};

write (16017,[
    TypeId,
    Code,
    Stage,
    Star,
    GoodsId,
    CostGoodsId,
    CombatPower,
    Exp,
    Level
]) ->
    Data = <<
        TypeId:8,
        Code:32,
        Stage:16,
        Star:16,
        GoodsId:64,
        CostGoodsId:64,
        CombatPower:32,
        Exp:32,
        Level:16
    >>,
    {ok, pt:pack(16017, Data)};

write (16018,[
    Errcode,
    TypeId,
    Lv,
    Exp
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        Lv:16,
        Exp:32
    >>,
    {ok, pt:pack(16018, Data)};

write (16019,[
    Errcode,
    TypeId,
    Lv,
    Exp
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        Lv:16,
        Exp:32
    >>,
    {ok, pt:pack(16019, Data)};

write (16020,[
    Errcode,
    TypeId,
    Id,
    Star
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        Id:32,
        Star:16
    >>,
    {ok, pt:pack(16020, Data)};

write (16021,[
    RoleId
]) ->
    Data = <<
        RoleId:64
    >>,
    {ok, pt:pack(16021, Data)};

write (16022,[
    TypeId,
    Id,
    Power,
    StarCombat,
    NextStarPower
]) ->
    Data = <<
        TypeId:8,
        Id:8,
        Power:64,
        StarCombat:64,
        NextStarPower:64
    >>,
    {ok, pt:pack(16022, Data)};

write (16023,[
    Errcode,
    TypeId,
    Stage,
    Star,
    Blessing,
    BlessingPlus,
    Etime,
    AutoBuy,
    RatioList
]) ->
    BinList_RatioList = [
        item_to_bin_10(RatioList_Item) || RatioList_Item <- RatioList
    ], 

    RatioList_Len = length(RatioList), 
    Bin_RatioList = list_to_binary(BinList_RatioList),

    Data = <<
        Errcode:32,
        TypeId:8,
        Stage:8,
        Star:16,
        Blessing:32,
        BlessingPlus:32,
        Etime:64,
        AutoBuy:8,
        RatioList_Len:16, Bin_RatioList/binary
    >>,
    {ok, pt:pack(16023, Data)};

write (16024,[
    Errcode,
    TypeId,
    AutoBuy
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        AutoBuy:8
    >>,
    {ok, pt:pack(16024, Data)};

write (16026,[
    TypeId,
    Id,
    ColorId,
    Code
]) ->
    Data = <<
        TypeId:8,
        Id:8,
        ColorId:32,
        Code:32
    >>,
    {ok, pt:pack(16026, Data)};

write (16027,[
    TypeId,
    Id,
    Power,
    NextStarPower
]) ->
    Data = <<
        TypeId:8,
        Id:8,
        Power:64,
        NextStarPower:64
    >>,
    {ok, pt:pack(16027, Data)};

write (16028,[
    TypeId,
    Level,
    CurExp,
    Combat,
    AttrList,
    SkillList
]) ->
    BinList_AttrList = [
        item_to_bin_11(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    BinList_SkillList = [
        item_to_bin_12(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        TypeId:8,
        Level:16,
        CurExp:32,
        Combat:32,
        AttrList_Len:16, Bin_AttrList/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(16028, Data)};

write (16029,[
    Errcode,
    TypeId,
    Level,
    CurExp,
    AddExp,
    Combat,
    SkillList,
    RatioList
]) ->
    BinList_SkillList = [
        item_to_bin_13(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    BinList_RatioList = [
        item_to_bin_14(RatioList_Item) || RatioList_Item <- RatioList
    ], 

    RatioList_Len = length(RatioList), 
    Bin_RatioList = list_to_binary(BinList_RatioList),

    Data = <<
        Errcode:32,
        TypeId:8,
        Level:16,
        CurExp:32,
        AddExp:32,
        Combat:32,
        SkillList_Len:16, Bin_SkillList/binary,
        RatioList_Len:16, Bin_RatioList/binary
    >>,
    {ok, pt:pack(16029, Data)};

write (16030,[
    Errcode,
    TypeId,
    SkillId,
    Level
]) ->
    Data = <<
        Errcode:32,
        TypeId:8,
        SkillId:32,
        Level:8
    >>,
    {ok, pt:pack(16030, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_1 (
    SkillId
) ->
    Data = <<
        SkillId:32
    >>,
    Data.
item_to_bin_2 ({
    Rate,
    RateNum
}) ->
    Data = <<
        Rate:8,
        RateNum:16
    >>,
    Data.
item_to_bin_3 ({
    Id,
    Stage,
    Star,
    Time
}) ->
    Data = <<
        Id:32,
        Stage:8,
        Star:16,
        Time:32
    >>,
    Data.
item_to_bin_4 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_5 (
    SkillId
) ->
    Data = <<
        SkillId:32
    >>,
    Data.
item_to_bin_6 ({
    ColorId,
    ColorLv
}) ->
    Data = <<
        ColorId:16,
        ColorLv:32
    >>,
    Data.
item_to_bin_7 ({
    Rate,
    RateNum
}) ->
    Data = <<
        Rate:8,
        RateNum:16
    >>,
    Data.
item_to_bin_8 ({
    GoodsId,
    Times,
    TimesLim
}) ->
    Data = <<
        GoodsId:32,
        Times:16,
        TimesLim:16
    >>,
    Data.
item_to_bin_9 ({
    PosId,
    PosLv,
    Stage,
    Star,
    PosPoint,
    GoodsId,
    GoodsTypeId
}) ->
    Data = <<
        PosId:8,
        PosLv:32,
        Stage:32,
        Star:16,
        PosPoint:32,
        GoodsId:64,
        GoodsTypeId:32
    >>,
    Data.
item_to_bin_10 ({
    Rate,
    RateNum
}) ->
    Data = <<
        Rate:8,
        RateNum:16
    >>,
    Data.
item_to_bin_11 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_12 ({
    SkillId,
    SkillLevel
}) ->
    Data = <<
        SkillId:32,
        SkillLevel:8
    >>,
    Data.
item_to_bin_13 ({
    SkillId,
    SkillLevel
}) ->
    Data = <<
        SkillId:32,
        SkillLevel:8
    >>,
    Data.
item_to_bin_14 ({
    Rate,
    RateNum
}) ->
    Data = <<
        Rate:8,
        RateNum:16
    >>,
    Data.
