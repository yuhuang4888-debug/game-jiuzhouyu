-module(pt_148).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(14801, _) ->
    {ok, []};
read(14802, Bin0) ->
    <<FairyId:64, _Bin1/binary>> = Bin0, 
    {ok, [FairyId]};
read(14803, Bin0) ->
    <<FairyId:64, _Bin1/binary>> = Bin0, 
    {ok, [FairyId]};
read(14804, Bin0) ->
    <<FairyId:64, _Bin1/binary>> = Bin0, 
    {ok, [FairyId]};
read(14805, Bin0) ->
    <<FairyId:64, _Bin1/binary>> = Bin0, 
    {ok, [FairyId]};
read(14807, Bin0) ->
    <<FairyId:64, _Bin1/binary>> = Bin0, 
    {ok, [FairyId]};
read(_Cmd, _R) -> {error, no_match}.

write (14800,[
    Res
]) ->
    Data = <<
        Res:32
    >>,
    {ok, pt:pack(14800, Data)};

write (14801,[
    Res,
    FairyNow,
    FairyFigure
]) ->
    BinList_FairyFigure = [
        item_to_bin_0(FairyFigure_Item) || FairyFigure_Item <- FairyFigure
    ], 

    FairyFigure_Len = length(FairyFigure), 
    Bin_FairyFigure = list_to_binary(BinList_FairyFigure),

    Data = <<
        Res:32,
        FairyNow:64,
        FairyFigure_Len:16, Bin_FairyFigure/binary
    >>,
    {ok, pt:pack(14801, Data)};

write (14802,[
    Res,
    FairyId,
    Stage,
    Level,
    Exp,
    Combat,
    SkillList,
    AttrList
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
        Res:32,
        FairyId:64,
        Stage:16,
        Level:16,
        Exp:16,
        Combat:32,
        SkillList_Len:16, Bin_SkillList/binary,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    {ok, pt:pack(14802, Data)};

write (14803,[
    Res,
    FairyId,
    Stage,
    AttrList
]) ->
    BinList_AttrList = [
        item_to_bin_3(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Res:32,
        FairyId:64,
        Stage:16,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    {ok, pt:pack(14803, Data)};

write (14804,[
    Res,
    FairyId,
    Level,
    Exp,
    AttrList
]) ->
    BinList_AttrList = [
        item_to_bin_4(AttrList_Item) || AttrList_Item <- AttrList
    ], 

    AttrList_Len = length(AttrList), 
    Bin_AttrList = list_to_binary(BinList_AttrList),

    Data = <<
        Res:32,
        FairyId:64,
        Level:16,
        Exp:32,
        AttrList_Len:16, Bin_AttrList/binary
    >>,
    {ok, pt:pack(14804, Data)};

write (14805,[
    Res,
    FairyNow
]) ->
    Data = <<
        Res:32,
        FairyNow:64
    >>,
    {ok, pt:pack(14805, Data)};

write (14806,[
    RoleId,
    BattleId
]) ->
    Data = <<
        RoleId:64,
        BattleId:64
    >>,
    {ok, pt:pack(14806, Data)};

write (14807,[
    Res,
    FairyId,
    Combat
]) ->
    Data = <<
        Res:32,
        FairyId:64,
        Combat:32
    >>,
    {ok, pt:pack(14807, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    FairyId,
    Stage,
    Level
}) ->
    Data = <<
        FairyId:64,
        Stage:16,
        Level:16
    >>,
    Data.
item_to_bin_1 (
    Skill
) ->
    Data = <<
        Skill:32
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
item_to_bin_3 ({
    AttrId,
    AttrVal
}) ->
    Data = <<
        AttrId:8,
        AttrVal:32
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
