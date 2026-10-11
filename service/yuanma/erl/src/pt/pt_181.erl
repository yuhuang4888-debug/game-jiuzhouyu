-module(pt_181).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18100, _) ->
    {ok, []};
read(18101, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(18102, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<CellPos:8, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, CellPos]};
read(18103, Bin0) ->
    <<GoodsId:64, _Bin1/binary>> = Bin0, 
    {ok, [GoodsId]};
read(18104, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<GoodsId:64, _Args1/binary>> = RestBin0, 
        {GoodsId,_Args1}
        end,
    {GoodsIdList, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [GoodsIdList]};
read(18105, _) ->
    {ok, []};
read(18106, Bin0) ->
    <<Count:8, Bin1/binary>> = Bin0, 
    <<Autobuy:8, _Bin2/binary>> = Bin1, 
    {ok, [Count, Autobuy]};
read(18107, Bin0) ->
    <<Count:32, _Bin1/binary>> = Bin0, 
    {ok, [Count]};
read(18108, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(18109, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(18110, Bin0) ->
    <<Pos:8, _Bin1/binary>> = Bin0, 
    {ok, [Pos]};
read(18111, _) ->
    {ok, []};
read(18112, _) ->
    {ok, []};
read(18113, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<Location:16, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, Location]};
read(_Cmd, _R) -> {error, no_match}.

write (18100,[
    AttrList,
    PosList,
    CombatPower
]) ->
    BinList_AttrList = [
        item_to_bin_0(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    BinList_PosList = [
        item_to_bin_1(PosList_Item) || PosList_Item <- PosList
    ], 

    PosList_Len = length(PosList), 
    Bin_PosList = list_to_binary(BinList_PosList),

    Data = <<
        AttrList_Len:16, Bin_AttrList/binary,
        PosList_Len:16, Bin_PosList/binary,
        CombatPower:32
    >>,
    {ok, pt:pack(18100, Data)};

write (18101,[
    ErrorCode,
    GoodsId,
    Lv
]) ->
    Data = <<
        ErrorCode:32,
        GoodsId:64,
        Lv:16
    >>,
    {ok, pt:pack(18101, Data)};

write (18102,[
    ErrorCode,
    GoodsId,
    CellPos
]) ->
    Data = <<
        ErrorCode:32,
        GoodsId:64,
        CellPos:8
    >>,
    {ok, pt:pack(18102, Data)};

write (18103,[
    ErrorCode,
    GoodsId,
    Cell
]) ->
    Data = <<
        ErrorCode:32,
        GoodsId:64,
        Cell:16
    >>,
    {ok, pt:pack(18103, Data)};

write (18104,[
    ErrorCode,
    DecomposeList
]) ->
    Bin_DecomposeList = pt:write_object_list(DecomposeList), 

    Data = <<
        ErrorCode:32,
        Bin_DecomposeList/binary
    >>,
    {ok, pt:pack(18104, Data)};

write (18105,[
    CrucibleId,
    StartTime,
    EndTime,
    Count,
    StatusList,
    FreeTimes,
    NextFreeTime
]) ->
    BinList_StatusList = [
        item_to_bin_2(StatusList_Item) || StatusList_Item <- StatusList
    ], 

    StatusList_Len = length(StatusList), 
    Bin_StatusList = list_to_binary(BinList_StatusList),

    Data = <<
        CrucibleId:16,
        StartTime:32,
        EndTime:32,
        Count:32,
        StatusList_Len:16, Bin_StatusList/binary,
        FreeTimes:16,
        NextFreeTime:32
    >>,
    {ok, pt:pack(18105, Data)};

write (18106,[
    ErrorCode,
    Count,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        ErrorCode:32,
        Count:8,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(18106, Data)};

write (18107,[
    ErrorCode,
    Count,
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        ErrorCode:32,
        Count:32,
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(18107, Data)};

write (18108,[
    ErrorCode,
    Pos,
    Lv
]) ->
    Data = <<
        ErrorCode:32,
        Pos:8,
        Lv:16
    >>,
    {ok, pt:pack(18108, Data)};

write (18109,[
    ErrorCode,
    Pos,
    Lv
]) ->
    Data = <<
        ErrorCode:32,
        Pos:8,
        Lv:16
    >>,
    {ok, pt:pack(18109, Data)};

write (18110,[
    ErrorCode,
    Pos,
    Lv
]) ->
    Data = <<
        ErrorCode:32,
        Pos:8,
        Lv:16
    >>,
    {ok, pt:pack(18110, Data)};

write (18111,[
    CombatPower
]) ->
    Data = <<
        CombatPower:32
    >>,
    {ok, pt:pack(18111, Data)};

write (18112,[
    CrucibleId,
    StartTime
]) ->
    Data = <<
        CrucibleId:16,
        StartTime:32
    >>,
    {ok, pt:pack(18112, Data)};

write (18113,[
    Location,
    GoodsList
]) ->
    BinList_GoodsList = [
        item_to_bin_3(GoodsList_Item) || GoodsList_Item <- GoodsList
    ], 

    GoodsList_Len = length(GoodsList), 
    Bin_GoodsList = list_to_binary(BinList_GoodsList),

    Data = <<
        Location:16,
        GoodsList_Len:16, Bin_GoodsList/binary
    >>,
    {ok, pt:pack(18113, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    AttrId,
    AttrValue
}) ->
    Data = <<
        AttrId:8,
        AttrValue:32
    >>,
    Data.
item_to_bin_1 ({
    Pos,
    Lv,
    NextPower
}) ->
    Data = <<
        Pos:8,
        Lv:16,
        NextPower:64
    >>,
    Data.
item_to_bin_2 ({
    Count,
    Status
}) ->
    Data = <<
        Count:32,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
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
    AwakeList,
    NextPower
}) ->
    BinList_AdditionAttrlist = [
        item_to_bin_4(AdditionAttrlist_Item) || AdditionAttrlist_Item <- AdditionAttrlist
    ], 

    AdditionAttrlist_Len = length(AdditionAttrlist), 
    Bin_AdditionAttrlist = list_to_binary(BinList_AdditionAttrlist),

    BinList_EquipExtraAttr = [
        item_to_bin_5(EquipExtraAttr_Item) || EquipExtraAttr_Item <- EquipExtraAttr
    ], 

    EquipExtraAttr_Len = length(EquipExtraAttr), 
    Bin_EquipExtraAttr = list_to_binary(BinList_EquipExtraAttr),

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
        AwakeList_Len:16, Bin_AwakeList/binary,
        NextPower:64
    >>,
    Data.
item_to_bin_4 ({
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
item_to_bin_5 ({
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
item_to_bin_6 ({
    AttrType,
    AwakeLv
}) ->
    Data = <<
        AttrType:16,
        AwakeLv:32
    >>,
    Data.
