-module(pt_183).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(18301, _) ->
    {ok, []};
read(18302, Bin0) ->
    <<DemonsId:32, _Bin1/binary>> = Bin0, 
    {ok, [DemonsId]};
read(18303, _) ->
    {ok, []};
read(18304, Bin0) ->
    <<DemonsId:32, _Bin1/binary>> = Bin0, 
    {ok, [DemonsId]};
read(18305, Bin0) ->
    <<DemonsId:32, _Bin1/binary>> = Bin0, 
    {ok, [DemonsId]};
read(18306, Bin0) ->
    <<DemonsId:32, _Bin1/binary>> = Bin0, 
    {ok, [DemonsId]};
read(18307, _) ->
    {ok, []};
read(18308, Bin0) ->
    <<PaintingId:8, _Bin1/binary>> = Bin0, 
    {ok, [PaintingId]};
read(18309, Bin0) ->
    <<DemonsId:32, Bin1/binary>> = Bin0, 
    <<SkillId:32, _Bin2/binary>> = Bin1, 
    {ok, [DemonsId, SkillId]};
read(18310, Bin0) ->
    <<DemonsId:32, Bin1/binary>> = Bin0, 
    <<Slot:8, Bin2/binary>> = Bin1, 
    <<GoodsId:32, _Bin3/binary>> = Bin2, 
    {ok, [DemonsId, Slot, GoodsId]};
read(18311, _) ->
    {ok, []};
read(18312, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(18313, _) ->
    {ok, []};
read(18314, Bin0) ->
    <<DemonsId:32, Bin1/binary>> = Bin0, 
    <<Sign:8, Bin2/binary>> = Bin1, 
    <<Id:32, Bin3/binary>> = Bin2, 
    <<SkLv:16, _Bin4/binary>> = Bin3, 
    {ok, [DemonsId, Sign, Id, SkLv]};
read(18315, _) ->
    {ok, []};
read(18316, Bin0) ->
    <<DemonsId:32, _Bin1/binary>> = Bin0, 
    {ok, [DemonsId]};
read(_Cmd, _R) -> {error, no_match}.

write (18300,[
    Cmd,
    ErrorCode,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Cmd:16,
        ErrorCode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(18300, Data)};

write (18301,[
    OpenState,
    DemonsList
]) ->
    BinList_DemonsList = [
        item_to_bin_0(DemonsList_Item) || DemonsList_Item <- DemonsList
    ], 

    DemonsList_Len = length(DemonsList), 
    Bin_DemonsList = list_to_binary(BinList_DemonsList),

    Data = <<
        OpenState:8,
        DemonsList_Len:16, Bin_DemonsList/binary
    >>,
    {ok, pt:pack(18301, Data)};

write (18302,[
    DemonsId,
    Power
]) ->
    Data = <<
        DemonsId:32,
        Power:32
    >>,
    {ok, pt:pack(18302, Data)};

write (18303,[
    FettersList
]) ->
    BinList_FettersList = [
        item_to_bin_3(FettersList_Item) || FettersList_Item <- FettersList
    ], 

    FettersList_Len = length(FettersList), 
    Bin_FettersList = list_to_binary(BinList_FettersList),

    Data = <<
        FettersList_Len:16, Bin_FettersList/binary
    >>,
    {ok, pt:pack(18303, Data)};

write (18304,[
    Code,
    DemonsId,
    Star,
    SkillList,
    Power,
    SlotNum
]) ->
    BinList_SkillList = [
        item_to_bin_4(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        Code:32,
        DemonsId:32,
        Star:8,
        SkillList_Len:16, Bin_SkillList/binary,
        Power:32,
        SlotNum:8
    >>,
    {ok, pt:pack(18304, Data)};

write (18305,[
    Code,
    DemonsId,
    Level,
    Exp,
    Power
]) ->
    Data = <<
        Code:32,
        DemonsId:32,
        Level:16,
        Exp:32,
        Power:32
    >>,
    {ok, pt:pack(18305, Data)};

write (18306,[
    Code,
    DemonsId
]) ->
    Data = <<
        Code:32,
        DemonsId:32
    >>,
    {ok, pt:pack(18306, Data)};

write (18307,[
    PaintingGet
]) ->
    BinList_PaintingGet = [
        item_to_bin_5(PaintingGet_Item) || PaintingGet_Item <- PaintingGet
    ], 

    PaintingGet_Len = length(PaintingGet), 
    Bin_PaintingGet = list_to_binary(BinList_PaintingGet),

    Data = <<
        PaintingGet_Len:16, Bin_PaintingGet/binary
    >>,
    {ok, pt:pack(18307, Data)};

write (18308,[
    Code,
    PaintingId,
    Rewards
]) ->
    Bin_Rewards = pt:write_object_list(Rewards), 

    Data = <<
        Code:32,
        PaintingId:8,
        Bin_Rewards/binary
    >>,
    {ok, pt:pack(18308, Data)};

write (18309,[
    Code,
    DemonsId,
    SkillId,
    NewLevel
]) ->
    Data = <<
        Code:32,
        DemonsId:32,
        SkillId:32,
        NewLevel:16
    >>,
    {ok, pt:pack(18309, Data)};

write (18310,[
    DemonsId,
    Slot,
    SkillId,
    Quality,
    Sort,
    Leve,
    Code
]) ->
    Data = <<
        DemonsId:32,
        Slot:8,
        SkillId:32,
        Quality:8,
        Sort:16,
        Leve:16,
        Code:32
    >>,
    {ok, pt:pack(18310, Data)};

write (18311,[
    RefreshTime,
    RefreshNum,
    Cost,
    Shop
]) ->
    Bin_Cost = pt:write_object_list(Cost), 

    BinList_Shop = [
        item_to_bin_6(Shop_Item) || Shop_Item <- Shop
    ], 

    Shop_Len = length(Shop), 
    Bin_Shop = list_to_binary(BinList_Shop),

    Data = <<
        RefreshTime:32,
        RefreshNum:16,
        Bin_Cost/binary,
        Shop_Len:16, Bin_Shop/binary
    >>,
    {ok, pt:pack(18311, Data)};

write (18312,[
    Id,
    BuyNum,
    Code
]) ->
    Data = <<
        Id:32,
        BuyNum:16,
        Code:32
    >>,
    {ok, pt:pack(18312, Data)};

write (18313,[
    Code,
    RefreshNum,
    Cost
]) ->
    Bin_Cost = pt:write_object_list(Cost), 

    Data = <<
        Code:32,
        RefreshNum:16,
        Bin_Cost/binary
    >>,
    {ok, pt:pack(18313, Data)};

write (18314,[
    Power,
    DemonsId,
    Sign,
    SkId,
    SkLv,
    Code
]) ->
    Data = <<
        Power:32,
        DemonsId:32,
        Sign:8,
        SkId:32,
        SkLv:16,
        Code:32
    >>,
    {ok, pt:pack(18314, Data)};

write (18315,[
    OpenState
]) ->
    Data = <<
        OpenState:8
    >>,
    {ok, pt:pack(18315, Data)};

write (18316,[
    Code,
    DemonsId
]) ->
    Data = <<
        Code:32,
        DemonsId:32
    >>,
    {ok, pt:pack(18316, Data)};

write (18317,[
    DemonsId,
    SkillId,
    SkillLv,
    Process,
    IsActive
]) ->
    Data = <<
        DemonsId:32,
        SkillId:32,
        SkillLv:16,
        Process:32,
        IsActive:8
    >>,
    {ok, pt:pack(18317, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    DemonsId,
    Level,
    Exp,
    Star,
    SlotNum,
    SkillList,
    SlotSkill
}) ->
    BinList_SkillList = [
        item_to_bin_1(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    BinList_SlotSkill = [
        item_to_bin_2(SlotSkill_Item) || SlotSkill_Item <- SlotSkill
    ], 

    SlotSkill_Len = length(SlotSkill), 
    Bin_SlotSkill = list_to_binary(BinList_SlotSkill),

    Data = <<
        DemonsId:32,
        Level:16,
        Exp:32,
        Star:8,
        SlotNum:8,
        SkillList_Len:16, Bin_SkillList/binary,
        SlotSkill_Len:16, Bin_SlotSkill/binary
    >>,
    Data.
item_to_bin_1 ({
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
item_to_bin_2 ({
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
item_to_bin_3 (
    FettersId
) ->
    Data = <<
        FettersId:32
    >>,
    Data.
item_to_bin_4 ({
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
item_to_bin_5 (
    PaintingId
) ->
    Data = <<
        PaintingId:8
    >>,
    Data.
item_to_bin_6 ({
    Id,
    GoodsId,
    Price,
    Num,
    CostNum,
    Discount,
    CanBuyNum,
    BuyNum
}) ->
    Data = <<
        Id:32,
        GoodsId:32,
        Price:32,
        Num:16,
        CostNum:16,
        Discount:8,
        CanBuyNum:16,
        BuyNum:16
    >>,
    Data.
