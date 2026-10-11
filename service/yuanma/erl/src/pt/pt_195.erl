-module(pt_195).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(19501, Bin0) ->
    <<ServerId:16, Bin1/binary>> = Bin0, 
    <<RoleId:64, Bin2/binary>> = Bin1, 
    <<ModuleId:16, _Bin3/binary>> = Bin2, 
    {ok, [ServerId, RoleId, ModuleId]};
read(_Cmd, _R) -> {error, no_match}.

write (19501,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(19501, Data)};

write (19502,[
    ServerId,
    RoleId,
    Combat,
    AchvStage,
    Figure,
    EquipList,
    MagicCircle,
    FairyList
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    BinList_EquipList = [
        item_to_bin_0(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    BinList_MagicCircle = [
        item_to_bin_1(MagicCircle_Item) || MagicCircle_Item <- MagicCircle
    ], 

    MagicCircle_Len = length(MagicCircle), 
    Bin_MagicCircle = list_to_binary(BinList_MagicCircle),

    BinList_FairyList = [
        item_to_bin_2(FairyList_Item) || FairyList_Item <- FairyList
    ], 

    FairyList_Len = length(FairyList), 
    Bin_FairyList = list_to_binary(BinList_FairyList),

    Data = <<
        ServerId:16,
        RoleId:64,
        Combat:64,
        AchvStage:16,
        Bin_Figure/binary,
        EquipList_Len:16, Bin_EquipList/binary,
        MagicCircle_Len:16, Bin_MagicCircle/binary,
        FairyList_Len:16, Bin_FairyList/binary
    >>,
    {ok, pt:pack(19502, Data)};

write (19503,[
    SumPower,
    IsActive,
    BallList,
    FigureList
]) ->
    BinList_BallList = [
        item_to_bin_3(BallList_Item) || BallList_Item <- BallList
    ], 

    BallList_Len = length(BallList), 
    Bin_BallList = list_to_binary(BinList_BallList),

    BinList_FigureList = [
        item_to_bin_4(FigureList_Item) || FigureList_Item <- FigureList
    ], 

    FigureList_Len = length(FigureList), 
    Bin_FigureList = list_to_binary(BinList_FigureList),

    Data = <<
        SumPower:64,
        IsActive:8,
        BallList_Len:16, Bin_BallList/binary,
        FigureList_Len:16, Bin_FigureList/binary
    >>,
    {ok, pt:pack(19503, Data)};

write (19504,[
    SysType,
    Rating,
    SumPower,
    PosList,
    PillList,
    StrenAttr,
    EquipAttr,
    PillAttr,
    SuitAttr,
    SuitList
]) ->
    BinList_PosList = [
        item_to_bin_5(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    BinList_PillList = [
        item_to_bin_7(PillList_Item) || PillList_Item <- PillList
    ], 

    PillList_Len = length(PillList), 
    Bin_PillList = list_to_binary(BinList_PillList),

    BinList_StrenAttr = [
        item_to_bin_9(StrenAttr_Item) || StrenAttr_Item <- StrenAttr
    ], 

    StrenAttr_Len = length(StrenAttr), 
    Bin_StrenAttr = list_to_binary(BinList_StrenAttr),

    BinList_EquipAttr = [
        item_to_bin_10(EquipAttr_Item) || EquipAttr_Item <- EquipAttr
    ], 

    EquipAttr_Len = length(EquipAttr), 
    Bin_EquipAttr = list_to_binary(BinList_EquipAttr),

    BinList_PillAttr = [
        item_to_bin_11(PillAttr_Item) || PillAttr_Item <- PillAttr
    ], 

    PillAttr_Len = length(PillAttr), 
    Bin_PillAttr = list_to_binary(BinList_PillAttr),

    BinList_SuitAttr = [
        item_to_bin_12(SuitAttr_Item) || SuitAttr_Item <- SuitAttr
    ], 

    SuitAttr_Len = length(SuitAttr), 
    Bin_SuitAttr = list_to_binary(BinList_SuitAttr),

    BinList_SuitList = [
        item_to_bin_13(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    Data = <<
        SysType:8,
        Rating:64,
        SumPower:64,
        PosList_Len:16, Bin_PosList/binary,
        PillList_Len:16, Bin_PillList/binary,
        StrenAttr_Len:16, Bin_StrenAttr/binary,
        EquipAttr_Len:16, Bin_EquipAttr/binary,
        PillAttr_Len:16, Bin_PillAttr/binary,
        SuitAttr_Len:16, Bin_SuitAttr/binary,
        SuitList_Len:16, Bin_SuitList/binary
    >>,
    {ok, pt:pack(19504, Data)};

write (19505,[
    MaxFigureId,
    CurrentFigureId,
    Power,
    AllScore,
    Gathering,
    Suit,
    SkillList
]) ->
    BinList_Gathering = [
        item_to_bin_14(Gathering_Item) || Gathering_Item <- Gathering
    ], 

    Gathering_Len = length(Gathering), 
    Bin_Gathering = list_to_binary(BinList_Gathering),

    BinList_Suit = [
        item_to_bin_15(Suit_Item) || Suit_Item <- Suit
    ], 

    Suit_Len = length(Suit), 
    Bin_Suit = list_to_binary(BinList_Suit),

    BinList_SkillList = [
        item_to_bin_16(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        MaxFigureId:16,
        CurrentFigureId:16,
        Power:64,
        AllScore:64,
        Gathering_Len:16, Bin_Gathering/binary,
        Suit_Len:16, Bin_Suit/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(19505, Data)};

write (19506,[
    SumPower,
    IllusionNum,
    IllusionList,
    FashionPos,
    SelfPower,
    OthersPower
]) ->
    BinList_IllusionList = [
        item_to_bin_17(IllusionList_Item) || IllusionList_Item <- IllusionList
    ], 

    IllusionList_Len = length(IllusionList), 
    Bin_IllusionList = list_to_binary(BinList_IllusionList),

    BinList_FashionPos = [
        item_to_bin_22(FashionPos_Item) || FashionPos_Item <- FashionPos
    ], 

    FashionPos_Len = length(FashionPos), 
    Bin_FashionPos = list_to_binary(BinList_FashionPos),

    BinList_SelfPower = [
        item_to_bin_25(SelfPower_Item) || SelfPower_Item <- SelfPower
    ], 

    SelfPower_Len = length(SelfPower), 
    Bin_SelfPower = list_to_binary(BinList_SelfPower),

    BinList_OthersPower = [
        item_to_bin_26(OthersPower_Item) || OthersPower_Item <- OthersPower
    ], 

    OthersPower_Len = length(OthersPower), 
    Bin_OthersPower = list_to_binary(BinList_OthersPower),

    Data = <<
        SumPower:64,
        IllusionNum:16,
        IllusionList_Len:16, Bin_IllusionList/binary,
        FashionPos_Len:16, Bin_FashionPos/binary,
        SelfPower_Len:16, Bin_SelfPower/binary,
        OthersPower_Len:16, Bin_OthersPower/binary
    >>,
    {ok, pt:pack(19506, Data)};

write (19507,[
    GodSumPower,
    GodBattleInfo
]) ->
    BinList_GodBattleInfo = [
        item_to_bin_27(GodBattleInfo_Item) || GodBattleInfo_Item <- GodBattleInfo
    ], 

    GodBattleInfo_Len = length(GodBattleInfo), 
    Bin_GodBattleInfo = list_to_binary(BinList_GodBattleInfo),

    Data = <<
        GodSumPower:64,
        GodBattleInfo_Len:16, Bin_GodBattleInfo/binary
    >>,
    {ok, pt:pack(19507, Data)};

write (19508,[
    Score,
    DecorationList
]) ->
    BinList_DecorationList = [
        item_to_bin_29(DecorationList_Item) || DecorationList_Item <- DecorationList
    ], 

    DecorationList_Len = length(DecorationList), 
    Bin_DecorationList = list_to_binary(BinList_DecorationList),

    Data = <<
        Score:64,
        DecorationList_Len:16, Bin_DecorationList/binary
    >>,
    {ok, pt:pack(19508, Data)};

write (19509,[
    AllPower,
    AllLevel,
    DragonEquipList
]) ->
    BinList_DragonEquipList = [
        item_to_bin_31(DragonEquipList_Item) || DragonEquipList_Item <- DragonEquipList
    ], 

    DragonEquipList_Len = length(DragonEquipList), 
    Bin_DragonEquipList = list_to_binary(BinList_DragonEquipList),

    Data = <<
        AllPower:64,
        AllLevel:16,
        DragonEquipList_Len:16, Bin_DragonEquipList/binary
    >>,
    {ok, pt:pack(19509, Data)};

write (19510,[
    AllScore,
    MaxNum,
    BattleNum,
    EudemonsList
]) ->
    BinList_EudemonsList = [
        item_to_bin_32(EudemonsList_Item) || EudemonsList_Item <- EudemonsList
    ], 

    EudemonsList_Len = length(EudemonsList), 
    Bin_EudemonsList = list_to_binary(BinList_EudemonsList),

    Data = <<
        AllScore:64,
        MaxNum:8,
        BattleNum:8,
        EudemonsList_Len:16, Bin_EudemonsList/binary
    >>,
    {ok, pt:pack(19510, Data)};

write (19511,[
    CompanionPower,
    CompanionList,
    DemonsPower,
    BattleDemons,
    DemonsList
]) ->
    BinList_CompanionList = [
        item_to_bin_35(CompanionList_Item) || CompanionList_Item <- CompanionList
    ], 

    CompanionList_Len = length(CompanionList), 
    Bin_CompanionList = list_to_binary(BinList_CompanionList),

    BinList_DemonsList = [
        item_to_bin_37(DemonsList_Item) || DemonsList_Item <- DemonsList
    ], 

    DemonsList_Len = length(DemonsList), 
    Bin_DemonsList = list_to_binary(BinList_DemonsList),

    Data = <<
        CompanionPower:64,
        CompanionList_Len:16, Bin_CompanionList/binary,
        DemonsPower:64,
        BattleDemons:32,
        DemonsList_Len:16, Bin_DemonsList/binary
    >>,
    {ok, pt:pack(19511, Data)};

write (19512,[
    AllPower,
    SkillLevel,
    RuneList
]) ->
    BinList_RuneList = [
        item_to_bin_40(RuneList_Item) || RuneList_Item <- RuneList
    ], 

    RuneList_Len = length(RuneList), 
    Bin_RuneList = list_to_binary(BinList_RuneList),

    Data = <<
        AllPower:64,
        SkillLevel:8,
        RuneList_Len:16, Bin_RuneList/binary
    >>,
    {ok, pt:pack(19512, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    GoodsId,
    TypeId,
    Cell,
    Color,
    Stren,
    Star,
    Stage,
    Level,
    GodLevel
}) ->
    Data = <<
        GoodsId:64,
        TypeId:32,
        Cell:16,
        Color:8,
        Stren:16,
        Star:8,
        Stage:16,
        Level:16,
        GodLevel:16
    >>,
    Data.
item_to_bin_1 ({
    Lv,
    IsOpen,
    FreeFlag,
    EndTime
}) ->
    Data = <<
        Lv:8,
        IsOpen:8,
        FreeFlag:8,
        EndTime:32
    >>,
    Data.
item_to_bin_2 ({
    Type,
    IsActive
}) ->
    Data = <<
        Type:16,
        IsActive:8
    >>,
    Data.
item_to_bin_3 ({
    DragonBallId,
    Level
}) ->
    Data = <<
        DragonBallId:32,
        Level:16
    >>,
    Data.
item_to_bin_4 ({
    Type,
    Lv
}) ->
    Data = <<
        Type:8,
        Lv:8
    >>,
    Data.
item_to_bin_5 ({
    Pos,
    TypeId,
    GoodsId,
    AttrList,
    Rating,
    Strong,
    Cell
}) ->
    BinList_AttrList = [
        item_to_bin_6(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Pos:8,
        TypeId:32,
        GoodsId:32,
        AttrList_Len:16, Bin_AttrList/binary,
        Rating:32,
        Strong:32,
        Cell:16
    >>,
    Data.
item_to_bin_6 ({
    Attr,
    Value
}) ->
    Data = <<
        Attr:8,
        Value:32
    >>,
    Data.
item_to_bin_7 ({
    GoodsId,
    TotalNum,
    AttrList
}) ->
    BinList_AttrList = [
        item_to_bin_8(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        GoodsId:32,
        TotalNum:16,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    Data.
item_to_bin_8 ({
    Attr,
    Value
}) ->
    Data = <<
        Attr:8,
        Value:32
    >>,
    Data.
item_to_bin_9 ({
    Attr,
    Value
}) ->
    Data = <<
        Attr:8,
        Value:32
    >>,
    Data.
item_to_bin_10 ({
    Attr,
    Value
}) ->
    Data = <<
        Attr:8,
        Value:32
    >>,
    Data.
item_to_bin_11 ({
    Attr,
    Value
}) ->
    Data = <<
        Attr:8,
        Value:32
    >>,
    Data.
item_to_bin_12 ({
    Attr,
    Value
}) ->
    Data = <<
        Attr:8,
        Value:32
    >>,
    Data.
item_to_bin_13 ({
    SuitId,
    Num
}) ->
    Data = <<
        SuitId:16,
        Num:32
    >>,
    Data.
item_to_bin_14 ({
    Pos,
    Lv,
    Exp,
    Flag,
    EquipId,
    ItemId,
    Score
}) ->
    Data = <<
        Pos:8,
        Lv:16,
        Exp:32,
        Flag:8,
        EquipId:32,
        ItemId:32,
        Score:64
    >>,
    Data.
item_to_bin_15 ({
    Star,
    Num
}) ->
    Data = <<
        Star:32,
        Num:32
    >>,
    Data.
item_to_bin_16 ({
    SkillId,
    Lv
}) ->
    Data = <<
        SkillId:32,
        Lv:16
    >>,
    Data.
item_to_bin_17 ({
    Type,
    Num,
    Power,
    FigureList
}) ->
    BinList_FigureList = [
        item_to_bin_18(FigureList_Item) || FigureList_Item <- FigureList
    ], 

    FigureList_Len = length(FigureList), 
    Bin_FigureList = list_to_binary(BinList_FigureList),

    Data = <<
        Type:8,
        Num:8,
        Power:64,
        FigureList_Len:16, Bin_FigureList/binary
    >>,
    Data.
item_to_bin_18 ({
    FigureType,
    Id,
    Stage,
    Star,
    Combat,
    EndTime,
    AttrList,
    StarAttrList,
    SkillList
}) ->
    BinList_AttrList = [
        item_to_bin_19(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    BinList_StarAttrList = [
        item_to_bin_20(StarAttrList_Item) || StarAttrList_Item <- StarAttrList
    ], 

    StarAttrList_Len = length(StarAttrList), 
    Bin_StarAttrList = list_to_binary(BinList_StarAttrList),

    BinList_SkillList = [
        item_to_bin_21(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        FigureType:8,
        Id:16,
        Stage:16,
        Star:16,
        Combat:64,
        EndTime:32,
        AttrList_Len:16, Bin_AttrList/binary,
        StarAttrList_Len:16, Bin_StarAttrList/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    Data.
item_to_bin_19 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_20 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_21 (
    SkillId
) ->
    Data = <<
        SkillId:32
    >>,
    Data.
item_to_bin_22 ({
    PosId,
    PosLv,
    WearFashionId,
    FashionList
}) ->
    BinList_FashionList = [
        item_to_bin_23(FashionList_Item) || FashionList_Item <- FashionList
    ], 

    FashionList_Len = length(FashionList), 
    Bin_FashionList = list_to_binary(BinList_FashionList),

    Data = <<
        PosId:8,
        PosLv:8,
        WearFashionId:32,
        FashionList_Len:16, Bin_FashionList/binary
    >>,
    Data.
item_to_bin_23 ({
    FashionId,
    StarLv,
    Combat,
    NowColorId,
    ColorList
}) ->
    BinList_ColorList = [
        item_to_bin_24(ColorList_Item) || ColorList_Item <- ColorList
    ], 

    ColorList_Len = length(ColorList), 
    Bin_ColorList = list_to_binary(BinList_ColorList),

    Data = <<
        FashionId:32,
        StarLv:16,
        Combat:64,
        NowColorId:8,
        ColorList_Len:16, Bin_ColorList/binary
    >>,
    Data.
item_to_bin_24 ({
    ColorId,
    StarLv
}) ->
    Data = <<
        ColorId:32,
        StarLv:32
    >>,
    Data.
item_to_bin_25 ({
    Type,
    Combat
}) ->
    Data = <<
        Type:8,
        Combat:64
    >>,
    Data.
item_to_bin_26 ({
    Type,
    Combat
}) ->
    Data = <<
        Type:8,
        Combat:64
    >>,
    Data.
item_to_bin_27 ({
    BattlePos,
    GodId,
    Lv,
    Grade,
    Star,
    Power,
    GodStren,
    EquipList
}) ->
    BinList_EquipList = [
        item_to_bin_28(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        BattlePos:8,
        GodId:32,
        Lv:16,
        Grade:16,
        Star:32,
        Power:64,
        GodStren:16,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    Data.
item_to_bin_28 ({
    Pos,
    GoodsId
}) ->
    Data = <<
        Pos:8,
        GoodsId:64
    >>,
    Data.
item_to_bin_29 ({
    Pos,
    GoodsId,
    Lv,
    StrenScore,
    EquipExtraAttr
}) ->
    BinList_EquipExtraAttr = [
        item_to_bin_30(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Pos:8,
        GoodsId:64,
        Lv:16,
        StrenScore:64,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    Data.
item_to_bin_30 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
item_to_bin_31 ({
    Pos,
    PosLv,
    GoodsId,
    StrenLv,
    AwakeLv,
    Combat
}) ->
    Data = <<
        Pos:8,
        PosLv:16,
        GoodsId:64,
        StrenLv:16,
        AwakeLv:16,
        Combat:64
    >>,
    Data.
item_to_bin_32 ({
    Id,
    State,
    Score,
    EquipList
}) ->
    BinList_EquipList = [
        item_to_bin_33(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        Id:8,
        State:16,
        Score:64,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    Data.
item_to_bin_33 ({
    Pos,
    GoodsId,
    Stren,
    EquipScore,
    EquipExtraAttr
}) ->
    BinList_EquipExtraAttr = [
        item_to_bin_34(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        Pos:8,
        GoodsId:64,
        Stren:16,
        EquipScore:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    Data.
item_to_bin_34 ({
    Color,
    TypeId,
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit
}) ->
    Data = <<
        Color:8,
        TypeId:8,
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32
    >>,
    Data.
item_to_bin_35 ({
    Id,
    Stage,
    Star,
    IsFight,
    TrainNum,
    Combat,
    SkillList
}) ->
    BinList_SkillList = [
        item_to_bin_36(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        Id:8,
        Stage:16,
        Star:16,
        IsFight:8,
        TrainNum:16,
        Combat:64,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    Data.
item_to_bin_36 ({
    SkillId,
    Level
}) ->
    Data = <<
        SkillId:32,
        Level:16
    >>,
    Data.
item_to_bin_37 ({
    Id,
    Level,
    Star,
    SlotNum,
    Combat,
    SkillList,
    SlotSkill
}) ->
    BinList_SkillList = [
        item_to_bin_38(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    BinList_SlotSkill = [
        item_to_bin_39(SlotSkill_Item) || SlotSkill_Item <- SlotSkill
    ], 

    SlotSkill_Len = length(SlotSkill), 
    Bin_SlotSkill = list_to_binary(BinList_SlotSkill),

    Data = <<
        Id:32,
        Level:16,
        Star:8,
        SlotNum:8,
        Combat:64,
        SkillList_Len:16, Bin_SkillList/binary,
        SlotSkill_Len:16, Bin_SlotSkill/binary
    >>,
    Data.
item_to_bin_38 ({
    SkillId,
    SkillLv,
    Process,
    IsActive
}) ->
    Data = <<
        SkillId:32,
        SkillLv:16,
        Process:32,
        IsActive:8
    >>,
    Data.
item_to_bin_39 ({
    SkId,
    SkLv,
    Slot,
    Quality,
    Sort
}) ->
    Data = <<
        SkId:32,
        SkLv:16,
        Slot:8,
        Quality:8,
        Sort:16
    >>,
    Data.
item_to_bin_40 ({
    PosId,
    GoodsId,
    GoodsTypeId,
    Color,
    Lv,
    SumAwakeLv,
    AttrList
}) ->
    BinList_AttrList = [
        item_to_bin_41(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        PosId:8,
        GoodsId:64,
        GoodsTypeId:32,
        Color:8,
        Lv:16,
        SumAwakeLv:16,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    Data.
item_to_bin_41 ({
    AttrId,
    AttrNum,
    AwakeLv
}) ->
    Data = <<
        AttrId:32,
        AttrNum:32,
        AwakeLv:16
    >>,
    Data.
