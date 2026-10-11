-module(pt_141).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14101, _) ->
    {ok, []};
read(14102, Bin0) ->
    <<BackDecorationId:32, _Bin1/binary>> = Bin0, 
    {ok, [BackDecorationId]};
read(14103, Bin0) ->
    <<BackDecorationId:32, Bin1/binary>> = Bin0, 
    <<Stage:8, _Bin2/binary>> = Bin1, 
    {ok, [BackDecorationId, Stage]};
read(14104, Bin0) ->
    <<BackDecorationId:32, _Bin1/binary>> = Bin0, 
    {ok, [BackDecorationId]};
read(14105, Bin0) ->
    <<BackDecorationId:32, _Bin1/binary>> = Bin0, 
    {ok, [BackDecorationId]};
read(14106, Bin0) ->
    <<BackDecorationId:32, _Bin1/binary>> = Bin0, 
    {ok, [BackDecorationId]};
read(14107, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (14100,[
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
    {ok, pt:pack(14100, Data)};

write (14101,[
    BackDecorationList
]) ->
    BinList_BackDecorationList = [
        item_to_bin_0(BackDecorationList_Item) || BackDecorationList_Item <- BackDecorationList
    ], 

    BackDecorationList_Len = length(BackDecorationList), 
    Bin_BackDecorationList = list_to_binary(BinList_BackDecorationList),

    Data = <<
        BackDecorationList_Len:16, Bin_BackDecorationList/binary
    >>,
    {ok, pt:pack(14101, Data)};

write (14102,[
    Code,
    BackDecorationId,
    Stage,
    State,
    FigureId,
    SkillList,
    AttrList,
    Combat
]) ->
    BinList_SkillList = [
        item_to_bin_1(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    BinList_AttrList = [
        item_to_bin_2(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Code:32,
        BackDecorationId:32,
        Stage:16,
        State:8,
        FigureId:32,
        SkillList_Len:16, Bin_SkillList/binary,
        AttrList_Len:16, Bin_AttrList/binary,
        Combat:32
    >>,
    {ok, pt:pack(14102, Data)};

write (14103,[
    Errcode,
    BackDecorationId,
    Stage
]) ->
    Data = <<
        Errcode:32,
        BackDecorationId:32,
        Stage:8
    >>,
    {ok, pt:pack(14103, Data)};

write (14104,[
    Errcode,
    BackDecorationId
]) ->
    Data = <<
        Errcode:32,
        BackDecorationId:32
    >>,
    {ok, pt:pack(14104, Data)};

write (14105,[
    Errcode,
    BackDecorationId,
    Stage,
    State,
    SkillList,
    AttrList,
    Combat
]) ->
    BinList_SkillList = [
        item_to_bin_3(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    BinList_AttrList = [
        item_to_bin_4(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Errcode:32,
        BackDecorationId:32,
        Stage:8,
        State:8,
        SkillList_Len:16, Bin_SkillList/binary,
        AttrList_Len:16, Bin_AttrList/binary,
        Combat:32
    >>,
    {ok, pt:pack(14105, Data)};

write (14106,[
    BackDecorationId,
    Power
]) ->
    Data = <<
        BackDecorationId:32,
        Power:32
    >>,
    {ok, pt:pack(14106, Data)};

write (14107,[
    Errcode
]) ->
    Data = <<
        Errcode:32
    >>,
    {ok, pt:pack(14107, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    BackDecorationId,
    Stage,
    State
}) ->
    Data = <<
        BackDecorationId:32,
        Stage:16,
        State:8
    >>,
    Data.
item_to_bin_1 ({
    SkillId,
    SkillLv
}) ->
    Data = <<
        SkillId:32,
        SkillLv:32
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
    SkillId
) ->
    Data = <<
        SkillId:32
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
