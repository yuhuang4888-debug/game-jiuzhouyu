-module(pt_232).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(23201, _) ->
    {ok, []};
read(23202, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<Page:32, Bin2/binary>> = Bin1, 
    <<IsReplace:8, _Bin3/binary>> = Bin2, 
    {ok, [GoodsId, Page, IsReplace]};
read(23203, Bin0) ->
    <<Page:32, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [Page, Pos]};
read(23204, Bin0) ->
    <<Page:32, _Bin1/binary>> = Bin0, 
    {ok, [Page]};
read(23205, _) ->
    {ok, []};
read(23206, Bin0) ->
    <<Leve:16, _Bin1/binary>> = Bin0, 
    {ok, [Leve]};
read(23207, _) ->
    {ok, []};
read(23208, Bin0) ->
    <<Color:8, Bin1/binary>> = Bin0, 
    <<Star:8, _Bin2/binary>> = Bin1, 
    {ok, [Color, Star]};
read(23209, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args0_1/binary>> = RestBin0, 
        {GoodsId,_Args0_1}
        end,
    {GoodsList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsList]};
read(23210, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23211, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Pos:8, Bin2/binary>> = Bin1, 
    <<Type:8, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, Pos, Type]};
read(23212, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23213, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23220, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23221, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<EquipId:64, Bin2/binary>> = Bin1, 
    <<Pos:8, Bin3/binary>> = Bin2, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<CequipId:64, _Args0_1/binary>> = RestBin0, 
        {CequipId,_Args0_1}
        end,
    {EquipList, _Bin4} = pt:read_array(FunArray0, Bin3),

    {ok, [TypeId, EquipId, Pos, EquipList]};
read(23230, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23231, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Pos:8, Bin2/binary>> = Bin1, 
    <<Type:8, _Bin3/binary>> = Bin2, 
    {ok, [TypeId, Pos, Type]};
read(23232, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23233, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23240, Bin0) ->
    <<TypeId:8, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(23241, Bin0) ->
    <<TypeId:8, Bin1/binary>> = Bin0, 
    <<Pos:8, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Pos]};
read(23250, Bin0) ->
    <<RoleId:64, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [RoleId, GoodsId]};
read(23252, Bin0) ->
    <<RuleId:32, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args0_1/binary>> = RestBin0, 
        {GoodsId,_Args0_1}
        end,
    {IrregularGlist, Bin2} = pt:read_array(FunArray0, Bin1),

    FunArray1 = fun(<<RestBin1/binary>>) -> 
        <<GoodsId:64, _Args1_1/binary>> = RestBin1, 
        {GoodsId,_Args1_1}
        end,
    {RegularGlist, Bin3} = pt:read_array(FunArray1, Bin2),

    FunArray2 = fun(<<RestBin2/binary>>) -> 
        <<GoodsId:64, _Args2_1/binary>> = RestBin2, 
        {GoodsId,_Args2_1}
        end,
    {RatioGlist, _Bin4} = pt:read_array(FunArray2, Bin3),

    {ok, [RuleId, IrregularGlist, RegularGlist, RatioGlist]};
read(23253, Bin0) ->
    <<Page:32, _Bin1/binary>> = Bin0, 
    {ok, [Page]};
read(23254, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<TargetId:64, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, TargetId]};
read(23255, Bin0) ->
    <<GoodsId:32, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(23256, Bin0) ->
    <<ComposeId:32, _Bin1/binary>> = Bin0, 
    {ok, [ComposeId]};
read(23257, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<TargetId:64, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, TargetId]};
read(_Cmd, _R) -> {error, no_match}.

write (23200,[
    ErrorCode,
    ErrorCodeArgs
]) ->
    Bin_ErrorCodeArgs = pt:write_string(ErrorCodeArgs), 

    Data = <<
        ErrorCode:32,
        Bin_ErrorCodeArgs/binary
    >>,
    {ok, pt:pack(23200, Data)};

write (23201,[
    TotalStar,
    ItemList
]) ->
    BinList_ItemList = [
        item_to_bin_0(ItemList_Item) || ItemList_Item <- ItemList
    ], 

    ItemList_Len = length(ItemList), 
    Bin_ItemList = list_to_binary(BinList_ItemList),

    Data = <<
        TotalStar:16,
        ItemList_Len:16, Bin_ItemList/binary
    >>,
    {ok, pt:pack(23201, Data)};

write (23202,[
    GoodsId,
    GoodsTypeId
]) ->
    Data = <<
        GoodsId:64,
        GoodsTypeId:32
    >>,
    {ok, pt:pack(23202, Data)};

write (23203,[
    GoodsId,
    GoodsTypeId
]) ->
    Data = <<
        GoodsId:64,
        GoodsTypeId:32
    >>,
    {ok, pt:pack(23203, Data)};

write (23204,[
    Page,
    Attr
]) ->
    Bin_Attr = pt:write_attr_list(Attr), 

    Data = <<
        Page:32,
        Bin_Attr/binary
    >>,
    {ok, pt:pack(23204, Data)};

write (23205,[
    Level,
    MaxLevel,
    Star,
    Power
]) ->
    Data = <<
        Level:16,
        MaxLevel:16,
        Star:16,
        Power:32
    >>,
    {ok, pt:pack(23205, Data)};

write (23206,[
    Code,
    Level,
    Power
]) ->
    Data = <<
        Code:32,
        Level:16,
        Power:32
    >>,
    {ok, pt:pack(23206, Data)};

write (23207,[
    Level,
    Exp,
    Power,
    Color,
    Star
]) ->
    Data = <<
        Level:16,
        Exp:32,
        Power:32,
        Color:8,
        Star:8
    >>,
    {ok, pt:pack(23207, Data)};

write (23208,[
    Color,
    Star,
    Code
]) ->
    Data = <<
        Color:8,
        Star:8,
        Code:32
    >>,
    {ok, pt:pack(23208, Data)};

write (23209,[
    Level,
    Exp,
    Power
]) ->
    Data = <<
        Level:16,
        Exp:32,
        Power:32
    >>,
    {ok, pt:pack(23209, Data)};

write (23210,[
    Code,
    TypeId,
    Stage,
    IsMax,
    Buff,
    EquipList
]) ->
    BinList_EquipList = [
        item_to_bin_1(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        Code:32,
        TypeId:8,
        Stage:32,
        IsMax:8,
        Buff:16,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(23210, Data)};

write (23211,[
    Code,
    TypeId,
    Pos,
    Type,
    Buff,
    Lv
]) ->
    Data = <<
        Code:32,
        TypeId:8,
        Pos:8,
        Type:8,
        Buff:16,
        Lv:32
    >>,
    {ok, pt:pack(23211, Data)};

write (23212,[
    Code,
    TypeId,
    MasterList
]) ->
    BinList_MasterList = [
        item_to_bin_2(MasterList_Item) || MasterList_Item <- MasterList
    ], 

    MasterList_Len = length(MasterList), 
    Bin_MasterList = list_to_binary(BinList_MasterList),

    Data = <<
        Code:32,
        TypeId:8,
        MasterList_Len:16, Bin_MasterList/binary
    >>,
    {ok, pt:pack(23212, Data)};

write (23213,[
    Code,
    TypeId,
    MasterLv
]) ->
    Data = <<
        Code:32,
        TypeId:8,
        MasterLv:32
    >>,
    {ok, pt:pack(23213, Data)};

write (23220,[
    Code,
    TypeId,
    EquipList
]) ->
    BinList_EquipList = [
        item_to_bin_3(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        Code:32,
        TypeId:8,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(23220, Data)};

write (23221,[
    Code,
    IsSuccess,
    TypeId,
    EquipId,
    Pos,
    Lv,
    AttrId
]) ->
    Data = <<
        Code:32,
        IsSuccess:8,
        TypeId:8,
        EquipId:64,
        Pos:8,
        Lv:32,
        AttrId:32
    >>,
    {ok, pt:pack(23221, Data)};

write (23230,[
    Code,
    TypeId,
    Stage,
    IsMax,
    EquipList
]) ->
    BinList_EquipList = [
        item_to_bin_4(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        Code:32,
        TypeId:8,
        Stage:32,
        IsMax:8,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(23230, Data)};

write (23231,[
    Code,
    TypeId,
    Pos,
    Type,
    Lv
]) ->
    Data = <<
        Code:32,
        TypeId:8,
        Pos:8,
        Type:32,
        Lv:32
    >>,
    {ok, pt:pack(23231, Data)};

write (23232,[
    Code,
    TypeId,
    MasterList
]) ->
    BinList_MasterList = [
        item_to_bin_5(MasterList_Item) || MasterList_Item <- MasterList
    ], 

    MasterList_Len = length(MasterList), 
    Bin_MasterList = list_to_binary(BinList_MasterList),

    Data = <<
        Code:32,
        TypeId:8,
        MasterList_Len:16, Bin_MasterList/binary
    >>,
    {ok, pt:pack(23232, Data)};

write (23233,[
    Code,
    TypeId,
    MasterLv
]) ->
    Data = <<
        Code:32,
        TypeId:8,
        MasterLv:32
    >>,
    {ok, pt:pack(23233, Data)};

write (23240,[
    Code,
    TypeId,
    EquipList
]) ->
    BinList_EquipList = [
        item_to_bin_6(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        Code:32,
        TypeId:8,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(23240, Data)};

write (23241,[
    Code,
    TypeId,
    Pos,
    IsSpirit
]) ->
    Data = <<
        Code:32,
        TypeId:8,
        Pos:8,
        IsSpirit:8
    >>,
    {ok, pt:pack(23241, Data)};

write (23250,[
    GoodsId,
    Score,
    SendDsgt,
    StarAttrCfg,
    StarAttr,
    SuitNum,
    SuitAttr,
    BaseAttr,
    ExtraAttr,
    StrenAttr,
    EvoluAttr,
    MasterAttr,
    SpiritAttr,
    BaseRating
]) ->
    BinList_SendDsgt = [
        item_to_bin_7(SendDsgt_Item) || SendDsgt_Item <- SendDsgt
    ], 

    SendDsgt_Len = length(SendDsgt), 
    Bin_SendDsgt = list_to_binary(BinList_SendDsgt),

    BinList_StarAttrCfg = [
        item_to_bin_8(StarAttrCfg_Item) || StarAttrCfg_Item <- StarAttrCfg
    ], 

    StarAttrCfg_Len = length(StarAttrCfg), 
    Bin_StarAttrCfg = list_to_binary(BinList_StarAttrCfg),

    Bin_StarAttr = pt:write_attr_list(StarAttr), 

    Bin_SuitAttr = pt:write_attr_list(SuitAttr), 

    Bin_BaseAttr = pt:write_attr_list(BaseAttr), 

    Bin_ExtraAttr = pt:write_attr_list(ExtraAttr), 

    Bin_StrenAttr = pt:write_attr_list(StrenAttr), 

    Bin_EvoluAttr = pt:write_attr_list(EvoluAttr), 

    Bin_MasterAttr = pt:write_attr_list(MasterAttr), 

    Bin_SpiritAttr = pt:write_attr_list(SpiritAttr), 

    Data = <<
        GoodsId:64,
        Score:32,
        SendDsgt_Len:16, Bin_SendDsgt/binary,
        StarAttrCfg_Len:16, Bin_StarAttrCfg/binary,
        Bin_StarAttr/binary,
        SuitNum:16,
        Bin_SuitAttr/binary,
        Bin_BaseAttr/binary,
        Bin_ExtraAttr/binary,
        Bin_StrenAttr/binary,
        Bin_EvoluAttr/binary,
        Bin_MasterAttr/binary,
        Bin_SpiritAttr/binary,
        BaseRating:32
    >>,
    {ok, pt:pack(23250, Data)};

write (23251,[
    Level,
    MaxLevel,
    Star,
    Power
]) ->
    Data = <<
        Level:16,
        MaxLevel:16,
        Star:16,
        Power:32
    >>,
    {ok, pt:pack(23251, Data)};

write (23252,[
    Code,
    RuleId,
    SendList
]) ->
    BinList_SendList = [
        item_to_bin_9(SendList_Item) || SendList_Item <- SendList
    ], 

    SendList_Len = length(SendList), 
    Bin_SendList = list_to_binary(BinList_SendList),

    Data = <<
        Code:32,
        RuleId:32,
        SendList_Len:16, Bin_SendList/binary
    >>,
    {ok, pt:pack(23252, Data)};

write (23253,[
    Page,
    Code
]) ->
    Data = <<
        Page:32,
        Code:32
    >>,
    {ok, pt:pack(23253, Data)};

write (23254,[
    GoodsId,
    TargetId,
    Score,
    SendDsgt,
    StarAttrCfg,
    StarAttr,
    SuitNum,
    SuitAttr,
    BaseAttr,
    ExtraAttr,
    StrenAttr,
    EvoluAttr,
    MasterAttr,
    SpiritAttr,
    BaseRating
]) ->
    BinList_SendDsgt = [
        item_to_bin_10(SendDsgt_Item) || SendDsgt_Item <- SendDsgt
    ], 

    SendDsgt_Len = length(SendDsgt), 
    Bin_SendDsgt = list_to_binary(BinList_SendDsgt),

    BinList_StarAttrCfg = [
        item_to_bin_11(StarAttrCfg_Item) || StarAttrCfg_Item <- StarAttrCfg
    ], 

    StarAttrCfg_Len = length(StarAttrCfg), 
    Bin_StarAttrCfg = list_to_binary(BinList_StarAttrCfg),

    Bin_StarAttr = pt:write_attr_list(StarAttr), 

    Bin_SuitAttr = pt:write_attr_list(SuitAttr), 

    Bin_BaseAttr = pt:write_attr_list(BaseAttr), 

    Bin_ExtraAttr = pt:write_attr_list(ExtraAttr), 

    Bin_StrenAttr = pt:write_attr_list(StrenAttr), 

    Bin_EvoluAttr = pt:write_attr_list(EvoluAttr), 

    Bin_MasterAttr = pt:write_attr_list(MasterAttr), 

    Bin_SpiritAttr = pt:write_attr_list(SpiritAttr), 

    Data = <<
        GoodsId:64,
        TargetId:64,
        Score:32,
        SendDsgt_Len:16, Bin_SendDsgt/binary,
        StarAttrCfg_Len:16, Bin_StarAttrCfg/binary,
        Bin_StarAttr/binary,
        SuitNum:16,
        Bin_SuitAttr/binary,
        Bin_BaseAttr/binary,
        Bin_ExtraAttr/binary,
        Bin_StrenAttr/binary,
        Bin_EvoluAttr/binary,
        Bin_MasterAttr/binary,
        Bin_SpiritAttr/binary,
        BaseRating:32
    >>,
    {ok, pt:pack(23254, Data)};

write (23255,[
    GoodsId,
    Score,
    SendDsgt,
    StarAttrCfg,
    StarAttr,
    SuitNum,
    BaseAttr,
    ExtraAttr,
    BaseRating
]) ->
    BinList_SendDsgt = [
        item_to_bin_12(SendDsgt_Item) || SendDsgt_Item <- SendDsgt
    ], 

    SendDsgt_Len = length(SendDsgt), 
    Bin_SendDsgt = list_to_binary(BinList_SendDsgt),

    BinList_StarAttrCfg = [
        item_to_bin_13(StarAttrCfg_Item) || StarAttrCfg_Item <- StarAttrCfg
    ], 

    StarAttrCfg_Len = length(StarAttrCfg), 
    Bin_StarAttrCfg = list_to_binary(BinList_StarAttrCfg),

    Bin_StarAttr = pt:write_attr_list(StarAttr), 

    Bin_BaseAttr = pt:write_attr_list(BaseAttr), 

    Bin_ExtraAttr = pt:write_attr_list(ExtraAttr), 

    Data = <<
        GoodsId:32,
        Score:32,
        SendDsgt_Len:16, Bin_SendDsgt/binary,
        StarAttrCfg_Len:16, Bin_StarAttrCfg/binary,
        Bin_StarAttr/binary,
        SuitNum:16,
        Bin_BaseAttr/binary,
        Bin_ExtraAttr/binary,
        BaseRating:32
    >>,
    {ok, pt:pack(23255, Data)};

write (23256,[
    ComposeId,
    Times,
    Index,
    Num
]) ->
    Data = <<
        ComposeId:32,
        Times:16,
        Index:16,
        Num:16
    >>,
    {ok, pt:pack(23256, Data)};

write (23257,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(23257, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Page,
    Power,
    NormalNum,
    SpecialNum,
    Attr,
    IsActive
}) ->
    Bin_Attr = pt:write_attr_list(Attr), 

    Data = <<
        Page:32,
        Power:64,
        NormalNum:8,
        SpecialNum:8,
        Bin_Attr/binary,
        IsActive:8
    >>,
    Data.
item_to_bin_1 ({
    EquipId,
    Pos,
    Lv
}) ->
    Data = <<
        EquipId:64,
        Pos:8,
        Lv:32
    >>,
    Data.
item_to_bin_2 ({
    MasterLv,
    Status
}) ->
    Data = <<
        MasterLv:32,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
    EquipId,
    Pos,
    Lv,
    AttrNum
}) ->
    Data = <<
        EquipId:64,
        Pos:8,
        Lv:32,
        AttrNum:16
    >>,
    Data.
item_to_bin_4 ({
    EquipId,
    Pos,
    Lv
}) ->
    Data = <<
        EquipId:64,
        Pos:8,
        Lv:32
    >>,
    Data.
item_to_bin_5 ({
    MasterLv,
    Status
}) ->
    Data = <<
        MasterLv:32,
        Status:8
    >>,
    Data.
item_to_bin_6 ({
    EquipId,
    Pos,
    IsSpirit
}) ->
    Data = <<
        EquipId:64,
        Pos:8,
        IsSpirit:8
    >>,
    Data.
item_to_bin_7 ({
    DsgtId,
    DsgtNum,
    DsgtSuit,
    DsgtAttr
}) ->
    Bin_DsgtSuit = pt:write_attr_list(DsgtSuit), 

    Bin_DsgtAttr = pt:write_attr_list(DsgtAttr), 

    Data = <<
        DsgtId:32,
        DsgtNum:16,
        Bin_DsgtSuit/binary,
        Bin_DsgtAttr/binary
    >>,
    Data.
item_to_bin_8 ({
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit,
    Color,
    TypeId
}) ->
    Data = <<
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32,
        Color:8,
        TypeId:8
    >>,
    Data.
item_to_bin_9 ({
    GoodsId,
    GoodsTypeId
}) ->
    Data = <<
        GoodsId:64,
        GoodsTypeId:32
    >>,
    Data.
item_to_bin_10 ({
    DsgtId,
    DsgtNum,
    DsgtSuit,
    DsgtAttr
}) ->
    Bin_DsgtSuit = pt:write_attr_list(DsgtSuit), 

    Bin_DsgtAttr = pt:write_attr_list(DsgtAttr), 

    Data = <<
        DsgtId:32,
        DsgtNum:16,
        Bin_DsgtSuit/binary,
        Bin_DsgtAttr/binary
    >>,
    Data.
item_to_bin_11 ({
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit,
    Color,
    TypeId
}) ->
    Data = <<
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32,
        Color:8,
        TypeId:8
    >>,
    Data.
item_to_bin_12 ({
    DsgtId,
    DsgtNum,
    DsgtSuit,
    DsgtAttr
}) ->
    Bin_DsgtSuit = pt:write_attr_list(DsgtSuit), 

    Bin_DsgtAttr = pt:write_attr_list(DsgtAttr), 

    Data = <<
        DsgtId:32,
        DsgtNum:16,
        Bin_DsgtSuit/binary,
        Bin_DsgtAttr/binary
    >>,
    Data.
item_to_bin_13 ({
    AttrId,
    AttrVal,
    PlusInterval,
    PlusUnit,
    Color,
    TypeId
}) ->
    Data = <<
        AttrId:16,
        AttrVal:32,
        PlusInterval:8,
        PlusUnit:32,
        Color:8,
        TypeId:8
    >>,
    Data.
