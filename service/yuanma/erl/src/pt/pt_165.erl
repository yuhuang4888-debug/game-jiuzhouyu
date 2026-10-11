-module(pt_165).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16502, _) ->
    {ok, []};
read(16503, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<Args:32, _Bin2/binary>> = Bin1, 
    {ok, [Type, Args]};
read(16504, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(16505, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(16506, Bin0) ->
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<Id:64, _Args1/binary>> = RestBin0, 
        <<Num:32, _Args2/binary>> = _Args1, 
        {{Id, Num},_Args2}
        end,
    {SpecifyGoods, _Bin1} = pt:read_array(FunArray0, Bin0),

    {ok, [SpecifyGoods]};
read(16507, _) ->
    {ok, []};
read(16508, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(16509, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(16510, Bin0) ->
    <<Id:32, Bin1/binary>> = Bin0, 
    <<Type:8, _Bin2/binary>> = Bin1, 
    {ok, [Id, Type]};
read(16511, Bin0) ->
    <<TypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16512, _) ->
    {ok, []};
read(16520, _) ->
    {ok, []};
read(16521, Bin0) ->
    <<AircraftId:32, _Bin1/binary>> = Bin0, 
    {ok, [AircraftId]};
read(16522, Bin0) ->
    <<AircraftId:32, _Bin1/binary>> = Bin0, 
    {ok, [AircraftId]};
read(16523, _) ->
    {ok, []};
read(16530, _) ->
    {ok, []};
read(16531, Bin0) ->
    <<WingId:32, _Bin1/binary>> = Bin0, 
    {ok, [WingId]};
read(16532, Bin0) ->
    <<WingId:32, _Bin1/binary>> = Bin0, 
    {ok, [WingId]};
read(16533, _) ->
    {ok, []};
read(16540, _) ->
    {ok, []};
read(16541, Bin0) ->
    <<PosId:8, Bin1/binary>> = Bin0, 
    <<GoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [PosId, GoodsId]};
read(16542, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    FunArray0 = fun(<<RestBin0/binary>>) -> 
        <<CostGoodsId:64, _Args1/binary>> = RestBin0, 
        {CostGoodsId,_Args1}
        end,
    {CostList, _Bin2} = pt:read_array(FunArray0, Bin1),

    {ok, [GoodsId, CostList]};
read(16543, Bin0) ->
    <<GoodsId:64, Bin1/binary>> = Bin0, 
    <<CostGoodsId:64, _Bin2/binary>> = Bin1, 
    {ok, [GoodsId, CostGoodsId]};
read(_Cmd, _R) -> {error, no_match}.

write (16500,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(16500, Data)};

write (16501,[
    RoleId,
    FigureId,
    HideStatus,
    PetAircraft,
    PetWing
]) ->
    Data = <<
        RoleId:64,
        FigureId:32,
        HideStatus:8,
        PetAircraft:32,
        PetWing:32
    >>,
    {ok, pt:pack(16501, Data)};

write (16502,[
    Stage,
    Star,
    Lv,
    Blessing,
    Exp,
    FigureStage,
    Combat,
    HideStatus,
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
        Stage:8,
        Star:8,
        Lv:16,
        Blessing:32,
        Exp:32,
        FigureStage:32,
        Combat:32,
        HideStatus:8,
        AttrList_Len:16, Bin_AttrList/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(16502, Data)};

write (16503,[
    Errcode,
    Type,
    Args
]) ->
    Data = <<
        Errcode:32,
        Type:8,
        Args:32
    >>,
    {ok, pt:pack(16503, Data)};

write (16504,[
    Errcode,
    Type
]) ->
    Data = <<
        Errcode:32,
        Type:8
    >>,
    {ok, pt:pack(16504, Data)};

write (16505,[
    Errcode,
    Stage,
    Star,
    Blessing,
    BlessingPlus
]) ->
    Data = <<
        Errcode:32,
        Stage:8,
        Star:8,
        Blessing:32,
        BlessingPlus:32
    >>,
    {ok, pt:pack(16505, Data)};

write (16506,[
    Errcode,
    Lv,
    Exp,
    ExpPlus
]) ->
    Data = <<
        Errcode:32,
        Lv:16,
        Exp:32,
        ExpPlus:32
    >>,
    {ok, pt:pack(16506, Data)};

write (16507,[
    Errcode,
    IllusionId,
    FigureList
]) ->
    BinList_FigureList = [
        item_to_bin_2(FigureList_Item) || FigureList_Item <- FigureList
    ], 

    FigureList_Len = length(FigureList), 
    Bin_FigureList = list_to_binary(BinList_FigureList),

    Data = <<
        Errcode:32,
        IllusionId:32,
        FigureList_Len:16, Bin_FigureList/binary
    >>,
    {ok, pt:pack(16507, Data)};

write (16508,[
    Errcode,
    Id,
    Stage,
    Blessing,
    Combat,
    AttrList,
    SkillList
]) ->
    BinList_AttrList = [
        item_to_bin_3(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    BinList_SkillList = [
        item_to_bin_4(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        Errcode:32,
        Id:32,
        Stage:8,
        Blessing:32,
        Combat:32,
        AttrList_Len:16, Bin_AttrList/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(16508, Data)};

write (16509,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(16509, Data)};

write (16510,[
    Errcode,
    Stage,
    Blessing,
    BlessingPlus
]) ->
    Data = <<
        Errcode:32,
        Stage:8,
        Blessing:32,
        BlessingPlus:32
    >>,
    {ok, pt:pack(16510, Data)};

write (16511,[
    Errcode,
    TypeId
]) ->
    Data = <<
        Errcode:32,
        TypeId:32
    >>,
    {ok, pt:pack(16511, Data)};

write (16512,[
    CounterList
]) ->
    BinList_CounterList = [
        item_to_bin_5(CounterList_Item) || CounterList_Item <- CounterList
    ], 

    CounterList_Len = length(CounterList), 
    Bin_CounterList = list_to_binary(BinList_CounterList),

    Data = <<
        CounterList_Len:16, Bin_CounterList/binary
    >>,
    {ok, pt:pack(16512, Data)};

write (16520,[
    Errcode,
    ShowId,
    IfShow,
    AircraftList
]) ->
    BinList_AircraftList = [
        item_to_bin_6(AircraftList_Item) || AircraftList_Item <- AircraftList
    ], 

    AircraftList_Len = length(AircraftList), 
    Bin_AircraftList = list_to_binary(BinList_AircraftList),

    Data = <<
        Errcode:32,
        ShowId:32,
        IfShow:8,
        AircraftList_Len:16, Bin_AircraftList/binary
    >>,
    {ok, pt:pack(16520, Data)};

write (16521,[
    Errcode,
    AircraftId
]) ->
    Data = <<
        Errcode:32,
        AircraftId:32
    >>,
    {ok, pt:pack(16521, Data)};

write (16522,[
    Errcode,
    AircraftId
]) ->
    Data = <<
        Errcode:32,
        AircraftId:32
    >>,
    {ok, pt:pack(16522, Data)};

write (16523,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(16523, Data)};

write (16530,[
    Errcode,
    ShowId,
    IfShow,
    WingList
]) ->
    BinList_WingList = [
        item_to_bin_7(WingList_Item) || WingList_Item <- WingList
    ], 

    WingList_Len = length(WingList), 
    Bin_WingList = list_to_binary(BinList_WingList),

    Data = <<
        Errcode:32,
        ShowId:32,
        IfShow:8,
        WingList_Len:16, Bin_WingList/binary
    >>,
    {ok, pt:pack(16530, Data)};

write (16531,[
    Errcode,
    WingId,
    EndTime
]) ->
    Data = <<
        Errcode:32,
        WingId:32,
        EndTime:32
    >>,
    {ok, pt:pack(16531, Data)};

write (16532,[
    Errcode,
    WingId
]) ->
    Data = <<
        Errcode:32,
        WingId:32
    >>,
    {ok, pt:pack(16532, Data)};

write (16533,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(16533, Data)};

write (16534,[
    Errcode,
    WingId
]) ->
    Data = <<
        Errcode:32,
        WingId:32
    >>,
    {ok, pt:pack(16534, Data)};

write (16540,[
    Errcode,
    CombatPower,
    PetEquipList
]) ->
    BinList_PetEquipList = [
        item_to_bin_8(PetEquipList_Item) || PetEquipList_Item <- PetEquipList
    ], 

    PetEquipList_Len = length(PetEquipList), 
    Bin_PetEquipList = list_to_binary(BinList_PetEquipList),

    Data = <<
        Errcode:32,
        CombatPower:32,
        PetEquipList_Len:16, Bin_PetEquipList/binary
    >>,
    {ok, pt:pack(16540, Data)};

write (16541,[
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
    {ok, pt:pack(16541, Data)};

write (16542,[
    Code,
    GoodsId
]) ->
    Data = <<
        Code:32,
        GoodsId:64
    >>,
    {ok, pt:pack(16542, Data)};

write (16543,[
    Code,
    GoodsId,
    CostGoodsId
]) ->
    Data = <<
        Code:32,
        GoodsId:64,
        CostGoodsId:64
    >>,
    {ok, pt:pack(16543, Data)};

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
    Id,
    Stage
}) ->
    Data = <<
        Id:32,
        Stage:8
    >>,
    Data.
item_to_bin_3 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_4 (
    SkillId
) ->
    Data = <<
        SkillId:32
    >>,
    Data.
item_to_bin_5 ({
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
item_to_bin_6 ({
    AircraftId,
    Stage
}) ->
    Data = <<
        AircraftId:32,
        Stage:32
    >>,
    Data.
item_to_bin_7 ({
    WingId,
    Stage,
    EndTime
}) ->
    Data = <<
        WingId:32,
        Stage:32,
        EndTime:32
    >>,
    Data.
item_to_bin_8 ({
    PosId,
    PosLv,
    PosPoint,
    GoodsId,
    GoodsTypeId
}) ->
    Data = <<
        PosId:8,
        PosLv:32,
        PosPoint:32,
        GoodsId:64,
        GoodsTypeId:32
    >>,
    Data.
