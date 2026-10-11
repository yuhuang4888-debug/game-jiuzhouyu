-module(pt_150).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15000, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15001, Bin0) ->
    <<PlayerId:64, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [PlayerId, GoodsId]};
read(15002, Bin0) ->
    <<Pos:16, Bin1/binary>> = Bin0, 
    <<CellNum:16, _Bin2/binary>> = Bin1, 
    {ok, [Pos, CellNum]};
read(15003, Bin0) ->
    <<GoodId:64, Bin1/binary>> = Bin0, 
    <<FromPos:16, Bin2/binary>> = Bin1, 
    <<ToPos:16, _Bin3/binary>> = Bin2, 
    {ok, [GoodId, FromPos, ToPos]};
read(15004, Bin0) ->
    <<Pos:16, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(15005, Bin0) ->
    <<GoodId:64, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [GoodId, Num]};
read(15006, Bin0) ->
    <<GoodId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodId]};
read(15008, Bin0) ->
    <<CurrencyId:32, _Bin1/binary>> = Bin0, 
    {ok, [CurrencyId]};
read(15009, _) ->
    {ok, []};
read(15010, Bin0) ->
    <<Pos:16, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(15011, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(15012, Bin0) ->
    <<ServerId:16, Bin1/binary>> = Bin0, 
    <<RoleId:64, _Bin2/binary>> = Bin1, 
    {ok, [ServerId, RoleId]};
read(15013, Bin0) ->
    <<ServerId:16, Bin1/binary>> = Bin0, 
    <<PlayerId:64, Bin2/binary>> = Bin1, 
    <<GoodsId:64, _Bin3/binary>> = Bin2, 
    {ok, [ServerId, PlayerId, GoodsId]};
read(15014, Bin0) ->
    <<RoleId:64, _Bin1/binary>> = Bin0, 
    {ok, [RoleId]};
read(15015, Bin0) ->
    <<ServerId:16, Bin1/binary>> = Bin0, 
    <<RoleId:64, _Bin2/binary>> = Bin1, 
    {ok, [ServerId, RoleId]};
read(15019, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        <<GoodsNum:32, _Args2/binary>> = _Args1, 
        {{GoodsId, GoodsNum},_Args2}
        end,
    {GoodsList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsList]};
read(15020, Bin0) ->
    <<RuleId:32, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {RegularGlist, Bin2} = pt:read_array(FunArray0, Bin1),

    FunArray1 = fun(<<RestBin1/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin1, 
        {GoodsId,_Args1}
        end,
    {SpecifyGlist, _Bin3} = pt:read_array(FunArray1, Bin2),

    {ok, [RuleId, RegularGlist, SpecifyGlist]};
read(15021, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        <<Num:32, _Args2/binary>> = _Args1, 
        {{GoodsId, Num},_Args2}
        end,
    {GoodsList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsList]};
read(15022, Bin0) ->
    <<Id:64, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [Id, Num]};
read(15023, Bin0) ->
    <<Id:64, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(15024, _) ->
    {ok, []};
read(15025, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        <<GoodsNum:32, _Args2/binary>> = _Args1, 
        {{GoodsId, GoodsNum},_Args2}
        end,
    {GoodsList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsList]};
read(15026, Bin0) ->
    <<Type:16, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(15027, Bin0) ->
    <<Opr:8, _Bin1/binary>> = Bin0, 
    {ok, [Opr]};
read(15028, Bin0) ->
    <<RuleId:32, Bin1/binary>> = Bin0, 
    <<ComposeNum:32, Bin2/binary>> = Bin1, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Pos:8, _Args1/binary>> = RestBin0, 
        <<GoodsId:32, _Args2/binary>> = _Args1, 
        <<GoodsNum:32, _Args3/binary>> = _Args2, 
        {{Pos, GoodsId, GoodsNum},_Args3}
        end,
    {RegularGlist, Bin3} = pt:read_array(FunArray0, Bin2),

    FunArray1 = fun(<<RestBin1/binary>>) -> 
        <<Pos:8, _Args1/binary>> = RestBin1, 
        <<GoodsId:32, _Args2/binary>> = _Args1, 
        <<GoodsNum:32, _Args3/binary>> = _Args2, 
        {{Pos, GoodsId, GoodsNum},_Args3}
        end,
    {IrregularGlist, _Bin4} = pt:read_array(FunArray1, Bin3),

    {ok, [RuleId, ComposeNum, RegularGlist, IrregularGlist]};
read(15050, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<Num:32, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, Num]};
read(15053, Bin0) ->
    <<DropId:64, _Bin1/binary>> = Bin0, 
    {ok, [DropId]};
read(15055, _) ->
    {ok, []};
read(15083, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<TypeId:32, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, TypeId]};
read(15084, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15085, Bin0) ->
    <<GoodsId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15086, Bin0) ->
    <<GiftId:64, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Seqno:8, _Args1/binary>> = RestBin0, 
        <<Num:32, _Args2/binary>> = _Args1, 
        {{Seqno, Num},_Args2}
        end,
    {SeqList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [GiftId, SeqList]};
read(15087, Bin0) ->
    {CardNo, _Bin1} = pt:read_string(Bin0), 
    {ok, [CardNo]};
read(15089, Bin0) ->
    <<GoodsTypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsTypeId]};
read(15090, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (15000,[
    GoodsId,
    TypeId,
    SubPos,
    Cell,
    Num,
    Bind,
    Trade,
    Sell,
    Color,
    ExpireTime,
    CombatPower,
    EquipType,
    PriceType,
    SellPrice,
    Stren,
    StrenExp,
    Rating,
    OverallRating,
    Division,
    WashRating,
    AdditionAttrlist,
    StoneList,
    MagicList,
    EquipExtraAttr,
    WashAttr,
    SuitList,
    CspiritStage,
    CspiritLv,
    AwakeningLv,
    EquipSkillId,
    EquipSkillLv,
    MountEquipSkillId,
    MountEquipSkillLv,
    PetEquipStage,
    PetEquipStar,
    Level,
    AwakeList,
    RefinementLv
]) ->
    BinList_AdditionAttrlist = [
        item_to_bin_0(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_StoneList = [
        item_to_bin_1(StoneList_Item) || StoneList_Item <- StoneList
    ], 

    StoneList_Len = length(StoneList), 
    Bin_StoneList = list_to_binary(BinList_StoneList),

    BinList_MagicList = [
        item_to_bin_2(MagicList_Item) || MagicList_Item <- MagicList
    ], 

    MagicList_Len = length(MagicList), 
    Bin_MagicList = list_to_binary(BinList_MagicList),

    BinList_EquipExtraAttr = [
        item_to_bin_3(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_WashAttr = [
        item_to_bin_4(WashAttr_Item) || WashAttr_Item <- WashAttr
    ], 

    WashAttr_Len = length(WashAttr), 
    Bin_WashAttr = list_to_binary(BinList_WashAttr),

    BinList_SuitList = [
        item_to_bin_5(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    BinList_AwakeList = [
        item_to_bin_6(AwakeList_Item) || AwakeList_Item <- AwakeList
    ], 

    AwakeList_Len = length(AwakeList), 
    Bin_AwakeList = list_to_binary(BinList_AwakeList),

    Data = <<
        GoodsId:64,
        TypeId:32,
        SubPos:8,
        Cell:16,
        Num:32,
        Bind:8,
        Trade:8,
        Sell:8,
        Color:8,
        ExpireTime:32,
        CombatPower:32,
        EquipType:8,
        PriceType:8,
        SellPrice:32,
        Stren:16,
        StrenExp:32,
        Rating:32,
        OverallRating:32,
        Division:8,
        WashRating:32,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        StoneList_Len:16, Bin_StoneList/binary,
        MagicList_Len:16, Bin_MagicList/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        WashAttr_Len:16, Bin_WashAttr/binary,
        SuitList_Len:16, Bin_SuitList/binary,
        CspiritStage:16,
        CspiritLv:16,
        AwakeningLv:8,
        EquipSkillId:32,
        EquipSkillLv:8,
        MountEquipSkillId:32,
        MountEquipSkillLv:8,
        PetEquipStage:16,
        PetEquipStar:16,
        Level:16,
        AwakeList_Len:16, Bin_AwakeList/binary,
        RefinementLv:16
    >>,
    {ok, pt:pack(15000, Data)};

write (15001,[
    PlayerId,
    GoodsId,
    TypeId,
    SubPos,
    Cell,
    Num,
    Bind,
    Trade,
    Sell,
    Color,
    ExpireTime,
    CombatPower,
    EquipType,
    PriceType,
    SellPrice,
    Stren,
    Rating,
    OverallRating,
    Division,
    AdditionAttrlist,
    StoneList,
    MagicList,
    EquipExtraAttr,
    WashAttr,
    SuitList,
    CspiritStage,
    CspiritLv,
    AwakeningLv,
    EquipSkillId,
    EquipSkillLv,
    MountEquipSkillId,
    MountEquipSkillLv,
    PetEquipStage,
    PetEquipStar,
    Level,
    AwakeList,
    RefinementLv
]) ->
    BinList_AdditionAttrlist = [
        item_to_bin_7(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_StoneList = [
        item_to_bin_8(StoneList_Item) || StoneList_Item <- StoneList
    ], 

    StoneList_Len = length(StoneList), 
    Bin_StoneList = list_to_binary(BinList_StoneList),

    BinList_MagicList = [
        item_to_bin_9(MagicList_Item) || MagicList_Item <- MagicList
    ], 

    MagicList_Len = length(MagicList), 
    Bin_MagicList = list_to_binary(BinList_MagicList),

    BinList_EquipExtraAttr = [
        item_to_bin_10(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_WashAttr = [
        item_to_bin_11(WashAttr_Item) || WashAttr_Item <- WashAttr
    ], 

    WashAttr_Len = length(WashAttr), 
    Bin_WashAttr = list_to_binary(BinList_WashAttr),

    BinList_SuitList = [
        item_to_bin_12(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    BinList_AwakeList = [
        item_to_bin_13(AwakeList_Item) || AwakeList_Item <- AwakeList
    ], 

    AwakeList_Len = length(AwakeList), 
    Bin_AwakeList = list_to_binary(BinList_AwakeList),

    Data = <<
        PlayerId:64,
        GoodsId:64,
        TypeId:32,
        SubPos:8,
        Cell:16,
        Num:32,
        Bind:8,
        Trade:8,
        Sell:8,
        Color:8,
        ExpireTime:32,
        CombatPower:32,
        EquipType:8,
        PriceType:8,
        SellPrice:32,
        Stren:16,
        Rating:32,
        OverallRating:32,
        Division:8,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        StoneList_Len:16, Bin_StoneList/binary,
        MagicList_Len:16, Bin_MagicList/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        WashAttr_Len:16, Bin_WashAttr/binary,
        SuitList_Len:16, Bin_SuitList/binary,
        CspiritStage:16,
        CspiritLv:16,
        AwakeningLv:8,
        EquipSkillId:32,
        EquipSkillLv:8,
        MountEquipSkillId:32,
        MountEquipSkillLv:8,
        PetEquipStage:16,
        PetEquipStar:16,
        Level:16,
        AwakeList_Len:16, Bin_AwakeList/binary,
        RefinementLv:16
    >>,
    {ok, pt:pack(15001, Data)};

write (15002,[
    Code,
    Pos,
    CellNum
]) ->
    Data = <<
        Code:32,
        Pos:16,
        CellNum:16
    >>,
    {ok, pt:pack(15002, Data)};

write (15003,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(15003, Data)};

write (15004,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(15004, Data)};

write (15005,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(15005, Data)};

write (15006,[
    Code,
    GoodId,
    ExpireTime
]) ->
    Data = <<
        Code:32,
        GoodId:64,
        ExpireTime:32
    >>,
    {ok, pt:pack(15006, Data)};

write (15007,[
    GoodId
]) ->
    Data = <<
        GoodId:64
    >>,
    {ok, pt:pack(15007, Data)};

write (15008,[
    CurrencyId,
    Num
]) ->
    Data = <<
        CurrencyId:32,
        Num:32
    >>,
    {ok, pt:pack(15008, Data)};

write (15009,[
    CurrencyList
]) ->
    BinList_CurrencyList = [
        item_to_bin_14(CurrencyList_Item) || CurrencyList_Item <- CurrencyList
    ], 

    CurrencyList_Len = length(CurrencyList), 
    Bin_CurrencyList = list_to_binary(BinList_CurrencyList),

    Data = <<
        CurrencyList_Len:16, Bin_CurrencyList/binary
    >>,
    {ok, pt:pack(15009, Data)};

write (15010,[
    Pos,
    CellNum,
    MaxCell,
    CellGold,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_15(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Pos:16,
        CellNum:16,
        MaxCell:16,
        CellGold:8,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15010, Data)};

write (15011,[
    ServerId,
    ServerNum,
    RoleId,
    Combat,
    AchvStage,
    Figure,
    EquipList
]) ->
    Bin_Figure = pt:write_figure(Figure), 

    BinList_EquipList = [
        item_to_bin_19(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        ServerId:16,
        ServerNum:16,
        RoleId:64,
        Combat:64,
        AchvStage:16,
        Bin_Figure/binary,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(15011, Data)};

write (15012,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15012, Data)};

write (15013,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15013, Data)};

write (15014,[
    ServerId,
    RoleId,
    PowerList,
    SelfPowerList
]) ->
    BinList_PowerList = [
        item_to_bin_20(PowerList_Item) || PowerList_Item <- PowerList
    ], 

    PowerList_Len = length(PowerList), 
    Bin_PowerList = list_to_binary(BinList_PowerList),

    BinList_SelfPowerList = [
        item_to_bin_21(SelfPowerList_Item) || SelfPowerList_Item <- SelfPowerList
    ], 

    SelfPowerList_Len = length(SelfPowerList), 
    Bin_SelfPowerList = list_to_binary(BinList_SelfPowerList),

    Data = <<
        ServerId:16,
        RoleId:64,
        PowerList_Len:16, Bin_PowerList/binary,
        SelfPowerList_Len:16, Bin_SelfPowerList/binary
    >>,
    {ok, pt:pack(15014, Data)};

write (15015,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15015, Data)};

write (15017,[
    Pos,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_22(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Pos:16,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15017, Data)};

write (15018,[
    Pos,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_26(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Pos:16,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15018, Data)};

write (15019,[
    Code,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_27(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Code:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(15019, Data)};

write (15020,[
    Code,
    ComposeType,
    RuleId,
    GoodsId
]) ->
    Data = <<
        Code:32,
        ComposeType:8,
        RuleId:32,
        GoodsId:64
    >>,
    {ok, pt:pack(15020, Data)};

write (15021,[
    Res,
    TypeIdList
]) ->
    BinList_TypeIdList = [
        item_to_bin_28(TypeIdList_Item) || TypeIdList_Item <- TypeIdList
    ], 

    TypeIdList_Len = length(TypeIdList), 
    Bin_TypeIdList = list_to_binary(BinList_TypeIdList),

    Data = <<
        Res:32,
        TypeIdList_Len:16, Bin_TypeIdList/binary
    >>,
    {ok, pt:pack(15021, Data)};

write (15022,[
    Errcode,
    Id,
    Type
]) ->
    Data = <<
        Errcode:32,
        Id:64,
        Type:8
    >>,
    {ok, pt:pack(15022, Data)};

write (15023,[
    Errcode,
    Id,
    Pos,
    SubPos
]) ->
    Data = <<
        Errcode:32,
        Id:64,
        Pos:16,
        SubPos:8
    >>,
    {ok, pt:pack(15023, Data)};

write (15024,[
    Level,
    Exp
]) ->
    Data = <<
        Level:16,
        Exp:32
    >>,
    {ok, pt:pack(15024, Data)};

write (15025,[
    Code,
    ExpList
]) ->
    BinList_ExpList = [
        item_to_bin_29(ExpList_Item) || ExpList_Item <- ExpList
    ], 

    ExpList_Len = length(ExpList), 
    Bin_ExpList = list_to_binary(BinList_ExpList),

    Data = <<
        Code:32,
        ExpList_Len:16, Bin_ExpList/binary
    >>,
    {ok, pt:pack(15025, Data)};

write (15026,[
    Type,
    ExchangeList
]) ->
    BinList_ExchangeList = [
        item_to_bin_30(ExchangeList_Item) || ExchangeList_Item <- ExchangeList
    ], 

    ExchangeList_Len = length(ExchangeList), 
    Bin_ExchangeList = list_to_binary(BinList_ExchangeList),

    Data = <<
        Type:16,
        ExchangeList_Len:16, Bin_ExchangeList/binary
    >>,
    {ok, pt:pack(15026, Data)};

write (15027,[
    Opr,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_31(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Opr:8,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(15027, Data)};

write (15028,[
    Code,
    RuleId,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Code:32,
        RuleId:32,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(15028, Data)};

write (15029,[
    State,
    Location
]) ->
    Data = <<
        State:8,
        Location:16
    >>,
    {ok, pt:pack(15029, Data)};

write (15030,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(15030, Data)};

write (15050,[
    Res,
    Args,
    GoodsId,
    GoodsTypeId,
    GoodsNum,
    Hp,
    Num,
    ShowGoods
]) ->
    Bin_Args = pt:write_string(Args), 

    BinList_ShowGoods = [
        item_to_bin_32(ShowGoods_Item) || ShowGoods_Item <- ShowGoods
    ], 

    ShowGoods_Len = length(ShowGoods), 
    Bin_ShowGoods = list_to_binary(BinList_ShowGoods),

    Data = <<
        Res:32,
        Bin_Args/binary,
        GoodsId:64,
        GoodsTypeId:32,
        GoodsNum:32,
        Hp:32,
        Num:32,
        ShowGoods_Len:16, Bin_ShowGoods/binary
    >>,
    {ok, pt:pack(15050, Data)};

write (15053,[
    Res,
    Args,
    Status,
    DropId
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Res:32,
        Bin_Args/binary,
        Status:8,
        DropId:64
    >>,
    {ok, pt:pack(15053, Data)};

write (15055,[
    PlayerId,
    BuffList
]) ->
    BinList_BuffList = [
        item_to_bin_33(BuffList_Item) || BuffList_Item <- BuffList
    ], 

    BuffList_Len = length(BuffList), 
    Bin_BuffList = list_to_binary(BinList_BuffList),

    Data = <<
        PlayerId:64,
        BuffList_Len:16, Bin_BuffList/binary
    >>,
    {ok, pt:pack(15055, Data)};

write (15083,[
    GoodsId,
    TypeId,
    GiftLevel
]) ->
    Data = <<
        GoodsId:64,
        TypeId:32,
        GiftLevel:16
    >>,
    {ok, pt:pack(15083, Data)};

write (15084,[
    GoodsId,
    UseCount,
    TotalCount,
    FreezeEndtime
]) ->
    Data = <<
        GoodsId:64,
        UseCount:8,
        TotalCount:8,
        FreezeEndtime:32
    >>,
    {ok, pt:pack(15084, Data)};

write (15085,[
    GoodsId,
    Count
]) ->
    Data = <<
        GoodsId:32,
        Count:8
    >>,
    {ok, pt:pack(15085, Data)};

write (15086,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(15086, Data)};

write (15087,[
    Res,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Res:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(15087, Data)};

write (15088,[
    DropIdList
]) ->
    BinList_DropIdList = [
        item_to_bin_34(DropIdList_Item) || DropIdList_Item <- DropIdList
    ], 

    DropIdList_Len = length(DropIdList), 
    Bin_DropIdList = list_to_binary(BinList_DropIdList),

    Data = <<
        DropIdList_Len:16, Bin_DropIdList/binary
    >>,
    {ok, pt:pack(15088, Data)};

write (15089,[
    GoodsTypeId,
    ExpectPower
]) ->
    Data = <<
        GoodsTypeId:32,
        ExpectPower:32
    >>,
    {ok, pt:pack(15089, Data)};

write (15090,[
    Code,
    RewardList,
    GoodsBagType,
    UnderColor
]) ->
    BinList_RewardList = [
        item_to_bin_35(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Code:32,
        RewardList_Len:16, Bin_RewardList/binary,
        GoodsBagType:8,
        UnderColor:8
    >>,
    {ok, pt:pack(15090, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_1 ({
    Pos,
    TypeId
}) ->
    Data = <<
        Pos:8,
        TypeId:32
    >>,
    Data.
item_to_bin_2 ({
    GoodsId,
    EndTime
}) ->
    Data = <<
        GoodsId:32,
        EndTime:32
    >>,
    Data.
item_to_bin_3 ({
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
item_to_bin_4 ({
    Index,
    Color,
    AttrId,
    AttrVal
}) ->
    Data = <<
        Index:8,
        Color:8,
        AttrId:16,
        AttrVal:32
    >>,
    Data.
item_to_bin_5 ({
    SuitLv,
    SuitSlv,
    SuitCount
}) ->
    Data = <<
        SuitLv:8,
        SuitSlv:8,
        SuitCount:8
    >>,
    Data.
item_to_bin_6 ({
    AttrType,
    AwakeLv,
    AwakeExp
}) ->
    Data = <<
        AttrType:16,
        AwakeLv:32,
        AwakeExp:32
    >>,
    Data.
item_to_bin_7 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_8 ({
    Pos,
    TypeId
}) ->
    Data = <<
        Pos:8,
        TypeId:32
    >>,
    Data.
item_to_bin_9 ({
    GoodsId,
    EndTime
}) ->
    Data = <<
        GoodsId:32,
        EndTime:32
    >>,
    Data.
item_to_bin_10 ({
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
item_to_bin_11 ({
    Index,
    Color,
    AttrId,
    AttrVal
}) ->
    Data = <<
        Index:8,
        Color:8,
        AttrId:16,
        AttrVal:32
    >>,
    Data.
item_to_bin_12 ({
    SuitLv,
    SuitSlv,
    SuitCount
}) ->
    Data = <<
        SuitLv:8,
        SuitSlv:8,
        SuitCount:8
    >>,
    Data.
item_to_bin_13 ({
    AttrType,
    AwakeLv,
    AwakeExp
}) ->
    Data = <<
        AttrType:16,
        AwakeLv:32,
        AwakeExp:32
    >>,
    Data.
item_to_bin_14 ({
    CurrencyId,
    Num
}) ->
    Data = <<
        CurrencyId:32,
        Num:32
    >>,
    Data.
item_to_bin_15 ({
    GoodsId,
    TypeId,
    SubPos,
    Cell,
    GoodsNum,
    Bind,
    Trade,
    Sell,
    IsDrop,
    Color,
    ExpireTime,
    CombatPower,
    Stren,
    Level,
    Rating,
    OverallRating,
    AdditionAttrlist,
    EquipExtraAttr,
    EquipStage,
    EquipStar,
    SkillId,
    SkillLv,
    AwakeList
}) ->
    BinList_AdditionAttrlist = [
        item_to_bin_16(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_EquipExtraAttr = [
        item_to_bin_17(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_AwakeList = [
        item_to_bin_18(AwakeList_Item) || AwakeList_Item <- AwakeList
    ], 

    AwakeList_Len = length(AwakeList), 
    Bin_AwakeList = list_to_binary(BinList_AwakeList),

    Data = <<
        GoodsId:64,
        TypeId:32,
        SubPos:8,
        Cell:16,
        GoodsNum:32,
        Bind:8,
        Trade:8,
        Sell:8,
        IsDrop:8,
        Color:8,
        ExpireTime:32,
        CombatPower:32,
        Stren:16,
        Level:16,
        Rating:32,
        OverallRating:32,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        EquipStage:8,
        EquipStar:8,
        SkillId:32,
        SkillLv:8,
        AwakeList_Len:16, Bin_AwakeList/binary
    >>,
    Data.
item_to_bin_16 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_17 ({
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
item_to_bin_18 ({
    AttrType,
    AwakeLv,
    AwakeExp
}) ->
    Data = <<
        AttrType:16,
        AwakeLv:32,
        AwakeExp:32
    >>,
    Data.
item_to_bin_19 ({
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
item_to_bin_20 (
    Power
) ->
    Data = <<
        Power:32
    >>,
    Data.
item_to_bin_21 (
    Power
) ->
    Data = <<
        Power:32
    >>,
    Data.
item_to_bin_22 ({
    GoodsId,
    TypeId,
    SubPos,
    Cell,
    GoodsNum,
    Bind,
    Trade,
    Sell,
    IsDrop,
    Color,
    ExpireTime,
    CombatPower,
    Stren,
    Level,
    Rating,
    OverallRating,
    AdditionAttrlist,
    EquipExtraAttr,
    EquipStage,
    EquipStar,
    SkillId,
    SkillLv,
    AwakeList
}) ->
    BinList_AdditionAttrlist = [
        item_to_bin_23(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_EquipExtraAttr = [
        item_to_bin_24(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    BinList_AwakeList = [
        item_to_bin_25(AwakeList_Item) || AwakeList_Item <- AwakeList
    ], 

    AwakeList_Len = length(AwakeList), 
    Bin_AwakeList = list_to_binary(BinList_AwakeList),

    Data = <<
        GoodsId:64,
        TypeId:32,
        SubPos:8,
        Cell:16,
        GoodsNum:32,
        Bind:8,
        Trade:8,
        Sell:8,
        IsDrop:8,
        Color:8,
        ExpireTime:32,
        CombatPower:32,
        Stren:16,
        Level:16,
        Rating:32,
        OverallRating:32,
        AdditionAttrlist_Len:16, Bin_AdditionAttrlist/binary,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary,
        EquipStage:8,
        EquipStar:8,
        SkillId:32,
        SkillLv:8,
        AwakeList_Len:16, Bin_AwakeList/binary
    >>,
    Data.
item_to_bin_23 ({
    AttrType,
    AttrValue,
    Color,
    CombatPower
}) ->
    Data = <<
        AttrType:8,
        AttrValue:32,
        Color:8,
        CombatPower:32
    >>,
    Data.
item_to_bin_24 ({
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
item_to_bin_25 ({
    AttrType,
    AwakeLv,
    AwakeExp
}) ->
    Data = <<
        AttrType:16,
        AwakeLv:32,
        AwakeExp:32
    >>,
    Data.
item_to_bin_26 ({
    GoodsId,
    GoodsNum,
    TypeId
}) ->
    Data = <<
        GoodsId:64,
        GoodsNum:32,
        TypeId:32
    >>,
    Data.
item_to_bin_27 ({
    GoodsId,
    GoodsNum
}) ->
    Data = <<
        GoodsId:64,
        GoodsNum:32
    >>,
    Data.
item_to_bin_28 ({
    TypeId,
    Num
}) ->
    Data = <<
        TypeId:32,
        Num:32
    >>,
    Data.
item_to_bin_29 ({
    AddExp,
    Ratio
}) ->
    Data = <<
        AddExp:16,
        Ratio:8
    >>,
    Data.
item_to_bin_30 ({
    Id,
    Count,
    CanExchange
}) ->
    Data = <<
        Id:32,
        Count:16,
        CanExchange:8
    >>,
    Data.
item_to_bin_31 ({
    GoodsId,
    TypeId,
    GoodsNum
}) ->
    Data = <<
        GoodsId:64,
        TypeId:32,
        GoodsNum:16
    >>,
    Data.
item_to_bin_32 ({
    Gid,
    Type,
    Goodid,
    Gnum
}) ->
    Data = <<
        Gid:64,
        Type:8,
        Goodid:32,
        Gnum:32
    >>,
    Data.
item_to_bin_33 ({
    GoodsId,
    BuffType,
    EffectList,
    Time,
    SingleTime
}) ->
    Bin_EffectList = pt:write_string(EffectList), 

    Data = <<
        GoodsId:32,
        BuffType:8,
        Bin_EffectList/binary,
        Time:32,
        SingleTime:32
    >>,
    Data.
item_to_bin_34 (
    DropId
) ->
    Data = <<
        DropId:64
    >>,
    Data.
item_to_bin_35 ({
    GoodsId,
    GoodsNum
}) ->
    Data = <<
        GoodsId:64,
        GoodsNum:32
    >>,
    Data.
