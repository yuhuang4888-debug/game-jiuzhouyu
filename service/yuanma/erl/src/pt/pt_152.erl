-module(pt_152).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(15201, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15202, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15204, Bin0) ->
    <<EquipType:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipType]};
read(15205, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [EquipType, Type]};
read(15206, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15207, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15208, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<Pos:8, Bin2/binary>> = Bin1, 
    <<TypeId:64, _Bin3/binary>> = Bin2, 
    {ok, [EquipType, Pos, TypeId]};
read(15209, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [EquipType, Pos]};
read(15210, Bin0) ->
    <<EquipType:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipType]};
read(15211, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<TypeId:32, Bin2/binary>> = Bin1, 
    <<OneKey:8, _Bin3/binary>> = Bin2, 
    {ok, [EquipType, TypeId, OneKey]};
read(15212, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<Index:8, _Bin2/binary>> = Bin1, 
    {ok, [EquipType, Index]};
read(15213, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Index:8, _Args1/binary>> = RestBin0, 
        {Index,_Args1}
        end,
    {LockList, Bin2} = pt:read_array(FunArray0, Bin1),

    <<RatioPlus:8, _Bin3/binary>> = Bin2, 
    {ok, [EquipType, LockList, RatioPlus]};
read(15214, _) ->
    {ok, []};
read(15215, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<Pos:8, Bin2/binary>> = Bin1, 
    <<UpgradeType:8, _Bin3/binary>> = Bin2, 
    {ok, [EquipType, Pos, UpgradeType]};
read(15216, Bin0) ->
    <<TypeId:32, Bin1/binary>> = Bin0, 
    <<IsOneKey:8, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, IsOneKey]};
read(15217, _) ->
    {ok, []};
read(15218, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(15219, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(15220, _) ->
    {ok, []};
read(15221, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<EquipType:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, EquipType]};
read(15222, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<EquipType:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, EquipType]};
read(15223, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<EquipType:8, _Bin2/binary>> = Bin1, 
    {ok, [Type, EquipType]};
read(15230, _) ->
    {ok, []};
read(15231, Bin0) ->
    <<EquipType:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipType]};
read(15232, _) ->
    {ok, []};
read(15233, _) ->
    {ok, []};
read(15241, Bin0) ->
    <<EquipType:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipType]};
read(15244, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<Type:8, Bin2/binary>> = Bin1, 
    <<SkillId:32, _Bin3/binary>> = Bin2, 
    {ok, [EquipType, Type, SkillId]};
read(15245, Bin0) ->
    <<EquipType:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipType]};
read(15250, Bin0) ->
    <<EquipType:8, _Bin1/binary>> = Bin0, 
    {ok, [EquipType]};
read(15251, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [EquipType, Type]};
read(15252, Bin0) ->
    <<EquipType:8, Bin1/binary>> = Bin0, 
    <<IsBuy:8, _Bin2/binary>> = Bin1, 
    {ok, [EquipType, IsBuy]};
read(15253, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(15254, Bin0) ->
    <<SubMod:8, _Bin1/binary>> = Bin0, 
    {ok, [SubMod]};
read(15255, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(15256, _) ->
    {ok, []};
read(15257, Bin0) ->
    <<SuitId:8, Bin1/binary>> = Bin0, 
    <<Stage:8, _Bin2/binary>> = Bin1, 
    {ok, [SuitId, Stage]};
read(15258, _) ->
    {ok, []};
read(15259, Bin0) ->
    <<SuitId:8, Bin1/binary>> = Bin0, 
    <<IsWear:8, _Bin2/binary>> = Bin1, 
    {ok, [SuitId, IsWear]};
read(15260, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(15261, _) ->
    {ok, []};
read(15262, Bin0) ->
    <<Pos:8, Bin1/binary>> = Bin0, 
    <<Type:8, Bin2/binary>> = Bin1, 
    <<Lv:16, _Bin3/binary>> = Bin2, 
    {ok, [Pos, Type, Lv]};
read(_Cmd, _R) -> {error, no_match}.

write (15200,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(15200, Data)};

write (15201,[
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
    {ok, pt:pack(15201, Data)};

write (15202,[
    Res,
    GoodsId,
    Cell
]) ->
    Data = <<
        Res:32,
        GoodsId:64,
        Cell:16
    >>,
    {ok, pt:pack(15202, Data)};

write (15204,[
    Res,
    EquipType,
    Stren
]) ->
    Data = <<
        Res:32,
        EquipType:8,
        Stren:16
    >>,
    {ok, pt:pack(15204, Data)};

write (15205,[
    Res,
    Res1,
    Type,
    StrenInfo
]) ->
    BinList_StrenInfo = [
        item_to_bin_0(StrenInfo_Item) || StrenInfo_Item <- StrenInfo
    ], 

    StrenInfo_Len = length(StrenInfo), 
    Bin_StrenInfo = list_to_binary(BinList_StrenInfo),

    Data = <<
        Res:32,
        Res1:8,
        Type:8,
        StrenInfo_Len:16, Bin_StrenInfo/binary
    >>,
    {ok, pt:pack(15205, Data)};

write (15206,[
    Res,
    GoodsId
]) ->
    Data = <<
        Res:32,
        GoodsId:64
    >>,
    {ok, pt:pack(15206, Data)};

write (15207,[
    TypeId,
    Rating,
    OverallRating,
    EquipExtraAttr
]) ->
    BinList_EquipExtraAttr = [
        item_to_bin_1(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

    Data = <<
        TypeId:32,
        Rating:32,
        OverallRating:32,
        EquipExtraAttr_Len:16, Bin_EquipExtraAttr/binary
    >>,
    {ok, pt:pack(15207, Data)};

write (15208,[
    Res,
    EquipType,
    Pos,
    TypeId
]) ->
    Data = <<
        Res:32,
        EquipType:8,
        Pos:8,
        TypeId:32
    >>,
    {ok, pt:pack(15208, Data)};

write (15209,[
    Res,
    EquipType,
    Pos
]) ->
    Data = <<
        Res:32,
        EquipType:8,
        Pos:8
    >>,
    {ok, pt:pack(15209, Data)};

write (15210,[
    Res,
    EquipType,
    RefineLv,
    Exp,
    AttrList
]) ->
    BinList_AttrList = [
        item_to_bin_2(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Res:32,
        EquipType:8,
        RefineLv:8,
        Exp:32,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    {ok, pt:pack(15210, Data)};

write (15211,[
    Res,
    EquipType,
    IsUp,
    OneKey
]) ->
    Data = <<
        Res:32,
        EquipType:8,
        IsUp:8,
        OneKey:8
    >>,
    {ok, pt:pack(15211, Data)};

write (15212,[
    Res,
    GoodsId,
    Index
]) ->
    Data = <<
        Res:32,
        GoodsId:64,
        Index:8
    >>,
    {ok, pt:pack(15212, Data)};

write (15213,[
    Res,
    GoodsId,
    AttrList
]) ->
    BinList_AttrList = [
        item_to_bin_3(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Res:32,
        GoodsId:64,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    {ok, pt:pack(15213, Data)};

write (15214,[
    FreeTimes
]) ->
    Data = <<
        FreeTimes:8
    >>,
    {ok, pt:pack(15214, Data)};

write (15215,[
    Res,
    EquipType,
    Pos,
    TypeId
]) ->
    Data = <<
        Res:32,
        EquipType:8,
        Pos:8,
        TypeId:32
    >>,
    {ok, pt:pack(15215, Data)};

write (15216,[
    Res,
    TypeId,
    IsOneKey
]) ->
    Data = <<
        Res:32,
        TypeId:32,
        IsOneKey:8
    >>,
    {ok, pt:pack(15216, Data)};

write (15217,[
    TotalPower,
    GodInfo
]) ->
    BinList_GodInfo = [
        item_to_bin_4(GodInfo_Item) || GodInfo_Item <- GodInfo
    ], 

    GodInfo_Len = length(GodInfo), 
    Bin_GodInfo = list_to_binary(BinList_GodInfo),

    Data = <<
        TotalPower:32,
        GodInfo_Len:16, Bin_GodInfo/binary
    >>,
    {ok, pt:pack(15217, Data)};

write (15218,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(15218, Data)};

write (15219,[
    Power
]) ->
    Data = <<
        Power:32
    >>,
    {ok, pt:pack(15219, Data)};

write (15220,[
    SuitList
]) ->
    BinList_SuitList = [
        item_to_bin_5(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    Data = <<
        SuitList_Len:16, Bin_SuitList/binary
    >>,
    {ok, pt:pack(15220, Data)};

write (15221,[
    EquipType,
    Type,
    Slv,
    SuitList
]) ->
    BinList_SuitList = [
        item_to_bin_6(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    Data = <<
        EquipType:8,
        Type:8,
        Slv:16,
        SuitList_Len:16, Bin_SuitList/binary
    >>,
    {ok, pt:pack(15221, Data)};

write (15222,[
    EquipType,
    MakeType,
    Slv,
    RewardList,
    SuitList
]) ->
    BinList_RewardList = [
        item_to_bin_7(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    BinList_SuitList = [
        item_to_bin_8(SuitList_Item) || SuitList_Item <- SuitList
    ], 

    SuitList_Len = length(SuitList), 
    Bin_SuitList = list_to_binary(BinList_SuitList),

    Data = <<
        EquipType:8,
        MakeType:8,
        Slv:16,
        RewardList_Len:16, Bin_RewardList/binary,
        SuitList_Len:16, Bin_SuitList/binary
    >>,
    {ok, pt:pack(15222, Data)};

write (15223,[
    EquipType,
    MakeType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_9(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        EquipType:8,
        MakeType:8,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(15223, Data)};

write (15230,[
    Score,
    List
]) ->
    BinList_List = [
        item_to_bin_10(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Score:32,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(15230, Data)};

write (15231,[
    Errcode,
    EquipType,
    Stage,
    Lv
]) ->
    Data = <<
        Errcode:32,
        EquipType:8,
        Stage:16,
        Lv:16
    >>,
    {ok, pt:pack(15231, Data)};

write (15232,[
    Lv
]) ->
    Data = <<
        Lv:16
    >>,
    {ok, pt:pack(15232, Data)};

write (15233,[
    Errcode,
    Lv
]) ->
    Data = <<
        Errcode:32,
        Lv:16
    >>,
    {ok, pt:pack(15233, Data)};

write (15241,[
    Errcode,
    EquipType
]) ->
    Data = <<
        Errcode:32,
        EquipType:8
    >>,
    {ok, pt:pack(15241, Data)};

write (15244,[
    Errcode,
    EquipType,
    Type
]) ->
    Data = <<
        Errcode:32,
        EquipType:8,
        Type:8
    >>,
    {ok, pt:pack(15244, Data)};

write (15245,[
    Errcode,
    EquipType
]) ->
    Data = <<
        Errcode:32,
        EquipType:8
    >>,
    {ok, pt:pack(15245, Data)};

write (15250,[
    Res,
    EquipType,
    Refine,
    RefineHigh
]) ->
    Data = <<
        Res:32,
        EquipType:8,
        Refine:16,
        RefineHigh:16
    >>,
    {ok, pt:pack(15250, Data)};

write (15251,[
    Res,
    Res1,
    Type,
    RefineInfo
]) ->
    BinList_RefineInfo = [
        item_to_bin_11(RefineInfo_Item) || RefineInfo_Item <- RefineInfo
    ], 

    RefineInfo_Len = length(RefineInfo), 
    Bin_RefineInfo = list_to_binary(BinList_RefineInfo),

    Data = <<
        Res:32,
        Res1:8,
        Type:8,
        RefineInfo_Len:16, Bin_RefineInfo/binary
    >>,
    {ok, pt:pack(15251, Data)};

write (15252,[
    Res,
    GoodsId
]) ->
    Data = <<
        Res:32,
        GoodsId:64
    >>,
    {ok, pt:pack(15252, Data)};

write (15253,[
    Code
]) ->
    Data = <<
        Code:32
    >>,
    {ok, pt:pack(15253, Data)};

write (15254,[
    SubMod,
    Power
]) ->
    Data = <<
        SubMod:8,
        Power:32
    >>,
    {ok, pt:pack(15254, Data)};

write (15255,[
    Code,
    GoodsId,
    RefineLv
]) ->
    Data = <<
        Code:32,
        GoodsId:64,
        RefineLv:32
    >>,
    {ok, pt:pack(15255, Data)};

write (15256,[
    CltList,
    SuitId
]) ->
    BinList_CltList = [
        item_to_bin_12(CltList_Item) || CltList_Item <- CltList
    ], 

    CltList_Len = length(CltList), 
    Bin_CltList = list_to_binary(BinList_CltList),

    Data = <<
        CltList_Len:16, Bin_CltList/binary,
        SuitId:8
    >>,
    {ok, pt:pack(15256, Data)};

write (15257,[
    Code,
    SuitId,
    CurStage,
    CurPosList
]) ->
    BinList_CurPosList = [
        item_to_bin_14(CurPosList_Item) || CurPosList_Item <- CurPosList
    ], 

    CurPosList_Len = length(CurPosList), 
    Bin_CurPosList = list_to_binary(BinList_CurPosList),

    Data = <<
        Code:32,
        SuitId:8,
        CurStage:8,
        CurPosList_Len:16, Bin_CurPosList/binary
    >>,
    {ok, pt:pack(15257, Data)};

write (15258,[
    SuitIdList,
    EquipType
]) ->
    BinList_SuitIdList = [
        item_to_bin_15(SuitIdList_Item) || SuitIdList_Item <- SuitIdList
    ], 

    SuitIdList_Len = length(SuitIdList), 
    Bin_SuitIdList = list_to_binary(BinList_SuitIdList),

    Data = <<
        SuitIdList_Len:16, Bin_SuitIdList/binary,
        EquipType:8
    >>,
    {ok, pt:pack(15258, Data)};

write (15259,[
    Code,
    SuitId,
    IsWear
]) ->
    Data = <<
        Code:32,
        SuitId:8,
        IsWear:8
    >>,
    {ok, pt:pack(15259, Data)};

write (15260,[
    Errcode,
    Type,
    WholeLv
]) ->
    Data = <<
        Errcode:32,
        Type:8,
        WholeLv:16
    >>,
    {ok, pt:pack(15260, Data)};

write (15261,[
    List
]) ->
    BinList_List = [
        item_to_bin_16(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(15261, Data)};

write (15262,[
    Pos,
    Type,
    Lv,
    List
]) ->
    BinList_List = [
        item_to_bin_17(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Pos:8,
        Type:8,
        Lv:16,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(15262, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    EquipType,
    Stren
}) ->
    Data = <<
        EquipType:8,
        Stren:16
    >>,
    Data.
item_to_bin_1 ({
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
item_to_bin_2 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_3 (
    Index
) ->
    Data = <<
        Index:8
    >>,
    Data.
item_to_bin_4 ({
    Pos,
    Level
}) ->
    Data = <<
        Pos:8,
        Level:16
    >>,
    Data.
item_to_bin_5 ({
    EquipType,
    Type,
    Slv
}) ->
    Data = <<
        EquipType:8,
        Type:8,
        Slv:16
    >>,
    Data.
item_to_bin_6 ({
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
item_to_bin_7 ({
    Type,
    Id,
    Num,
    AttrList
}) ->
    Bin_AttrList = pt:write_string(AttrList), 

    Data = <<
        Type:8,
        Id:32,
        Num:16,
        Bin_AttrList/binary
    >>,
    Data.
item_to_bin_8 ({
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
item_to_bin_9 ({
    Type,
    Id,
    Num,
    AttrList
}) ->
    Bin_AttrList = pt:write_string(AttrList), 

    Data = <<
        Type:8,
        Id:32,
        Num:16,
        Bin_AttrList/binary
    >>,
    Data.
item_to_bin_10 ({
    EquipType,
    Stage,
    Lv
}) ->
    Data = <<
        EquipType:8,
        Stage:16,
        Lv:16
    >>,
    Data.
item_to_bin_11 ({
    EquipType,
    RefineHigh
}) ->
    Data = <<
        EquipType:8,
        RefineHigh:16
    >>,
    Data.
item_to_bin_12 ({
    SuitId,
    CurStage,
    CurPosList
}) ->
    BinList_CurPosList = [
        item_to_bin_13(CurPosList_Item) || CurPosList_Item <- CurPosList
    ], 

    CurPosList_Len = length(CurPosList), 
    Bin_CurPosList = list_to_binary(BinList_CurPosList),

    Data = <<
        SuitId:8,
        CurStage:8,
        CurPosList_Len:16, Bin_CurPosList/binary
    >>,
    Data.
item_to_bin_13 (
    EquipType
) ->
    Data = <<
        EquipType:8
    >>,
    Data.
item_to_bin_14 (
    EquipType
) ->
    Data = <<
        EquipType:8
    >>,
    Data.
item_to_bin_15 (
    SuitId
) ->
    Data = <<
        SuitId:8
    >>,
    Data.
item_to_bin_16 ({
    Type,
    WholeLv
}) ->
    Data = <<
        Type:8,
        WholeLv:16
    >>,
    Data.
item_to_bin_17 ({
    Num,
    Combat
}) ->
    Data = <<
        Num:8,
        Combat:64
    >>,
    Data.
