-module(pt_169).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(16902, _) ->
    {ok, []};
read(16903, Bin0) ->
    <<IllusionId:32, _Bin1/binary>> = Bin0, 
    {ok, [IllusionId]};
read(16904, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(16905, Bin0) ->
    <<TypeId:32, Bin1/binary>> = Bin0, 
    <<Auto:8, _Bin2/binary>> = Bin1, 
    {ok, [TypeId, Auto]};
read(16906, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(16907, _) ->
    {ok, []};
read(16908, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(16909, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(16910, Bin0) ->
    <<TypeId:32, _Bin1/binary>> = Bin0, 
    {ok, [TypeId]};
read(16911, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (16900,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(16900, Data)};

write (16901,[
    RoleId,
    EquipList
]) ->
    BinList_EquipList = [
        item_to_bin_0(EquipList_Item) || EquipList_Item <- EquipList
    ], 

    EquipList_Len = length(EquipList), 
    Bin_EquipList = list_to_binary(BinList_EquipList),

    Data = <<
        RoleId:64,
        EquipList_Len:16, Bin_EquipList/binary
    >>,
    {ok, pt:pack(16901, Data)};

write (16902,[
    Lv,
    Exp,
    IllusionId,
    AttrList,
    Combat,
    DisplayStatus,
    SkillList
]) ->
    BinList_AttrList = [
        item_to_bin_1(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    BinList_SkillList = [
        item_to_bin_2(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        Lv:8,
        Exp:32,
        IllusionId:32,
        AttrList_Len:16, Bin_AttrList/binary,
        Combat:32,
        DisplayStatus:8,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(16902, Data)};

write (16903,[
    Errcode,
    IllusionId
]) ->
    Data = <<
        Errcode:32,
        IllusionId:32
    >>,
    {ok, pt:pack(16903, Data)};

write (16904,[
    Errcode,
    Type
]) ->
    Data = <<
        Errcode:32,
        Type:8
    >>,
    {ok, pt:pack(16904, Data)};

write (16905,[
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
    {ok, pt:pack(16905, Data)};

write (16906,[
    Errcode,
    Star,
    Id
]) ->
    Data = <<
        Errcode:32,
        Star:8,
        Id:32
    >>,
    {ok, pt:pack(16906, Data)};

write (16907,[
    Errcode,
    FigureId,
    FigureList
]) ->
    BinList_FigureList = [
        item_to_bin_3(FigureList_Item) || FigureList_Item <- FigureList
    ], 

    FigureList_Len = length(FigureList), 
    Bin_FigureList = list_to_binary(BinList_FigureList),

    Data = <<
        Errcode:32,
        FigureId:32,
        FigureList_Len:16, Bin_FigureList/binary
    >>,
    {ok, pt:pack(16907, Data)};

write (16908,[
    Errcode,
    Id
]) ->
    Data = <<
        Errcode:32,
        Id:32
    >>,
    {ok, pt:pack(16908, Data)};

write (16909,[
    Errcode,
    Id,
    Star,
    AttrList,
    Combat
]) ->
    BinList_AttrList = [
        item_to_bin_4(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Errcode:32,
        Id:32,
        Star:8,
        AttrList_Len:16, Bin_AttrList/binary,
        Combat:32
    >>,
    {ok, pt:pack(16909, Data)};

write (16910,[
    Errcode,
    TypeId
]) ->
    Data = <<
        Errcode:32,
        TypeId:32
    >>,
    {ok, pt:pack(16910, Data)};

write (16911,[
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
    {ok, pt:pack(16911, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PartId,
    FigureId
}) ->
    Data = <<
        PartId:8,
        FigureId:32
    >>,
    Data.
item_to_bin_1 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
    >>,
    Data.
item_to_bin_2 (
    SkillId
) ->
    Data = <<
        SkillId:32
    >>,
    Data.
item_to_bin_3 ({
    Id,
    Star
}) ->
    Data = <<
        Id:32,
        Star:8
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
