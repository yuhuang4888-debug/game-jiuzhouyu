-module(pt_210).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(21001, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(21002, _) ->
    {ok, []};
read(21003, _) ->
    {ok, []};
read(21004, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(21005, _) ->
    {ok, []};
read(21010, _) ->
    {ok, []};
read(21011, Bin0) ->
    <<SkillId:32, _Bin1/binary>> = Bin0, 
    {ok, [SkillId]};
read(21012, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (21001,[
    Errcode,
    SkillId
]) ->
    Data = <<
        Errcode:32,
        SkillId:32
    >>,
    {ok, pt:pack(21001, Data)};

write (21002,[
    SkillList
]) ->
    BinList_SkillList = [
        item_to_bin_0(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(21002, Data)};

write (21003,[
    SumOnekeyCost,
    OnekeyCost,
    SkillList
]) ->
    Bin_SumOnekeyCost = pt:write_object_list(SumOnekeyCost), 

    Bin_OnekeyCost = pt:write_object_list(OnekeyCost), 

    BinList_SkillList = [
        item_to_bin_1(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        Bin_SumOnekeyCost/binary,
        Bin_OnekeyCost/binary,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(21003, Data)};

write (21004,[
    Errcode,
    SkillId
]) ->
    Data = <<
        Errcode:32,
        SkillId:32
    >>,
    {ok, pt:pack(21004, Data)};

write (21005,[
    Errcode,
    SkillList
]) ->
    BinList_SkillList = [
        item_to_bin_2(SkillList_Item) || SkillList_Item <- SkillList
    ], 

    SkillList_Len = length(SkillList), 
    Bin_SkillList = list_to_binary(BinList_SkillList),

    Data = <<
        Errcode:32,
        SkillList_Len:16, Bin_SkillList/binary
    >>,
    {ok, pt:pack(21005, Data)};

write (21010,[
    LessPoint,
    TalentSkills
]) ->
    BinList_TalentSkills = [
        item_to_bin_3(TalentSkills_Item) || TalentSkills_Item <- TalentSkills
    ], 

    TalentSkills_Len = length(TalentSkills), 
    Bin_TalentSkills = list_to_binary(BinList_TalentSkills),

    Data = <<
        LessPoint:16,
        TalentSkills_Len:16, Bin_TalentSkills/binary
    >>,
    {ok, pt:pack(21010, Data)};

write (21011,[
    Errcode,
    SkillId,
    SkillLv,
    LessPoint
]) ->
    Data = <<
        Errcode:32,
        SkillId:32,
        SkillLv:16,
        LessPoint:16
    >>,
    {ok, pt:pack(21011, Data)};

write (21012,[
    Errcode,
    AllPoint
]) ->
    Data = <<
        Errcode:32,
        AllPoint:16
    >>,
    {ok, pt:pack(21012, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    SkillId,
    SkillLv
}) ->
    Data = <<
        SkillId:32,
        SkillLv:16
    >>,
    Data.
item_to_bin_1 ({
    SkillId,
    Stren
}) ->
    Data = <<
        SkillId:32,
        Stren:16
    >>,
    Data.
item_to_bin_2 ({
    SkillId,
    Stren
}) ->
    Data = <<
        SkillId:32,
        Stren:16
    >>,
    Data.
item_to_bin_3 ({
    SkillType,
    Point,
    Skills
}) ->
    BinList_Skills = [
        item_to_bin_4(Skills_Item) || Skills_Item <- Skills
    ], 

    Skills_Len = length(Skills), 
    Bin_Skills = list_to_binary(BinList_Skills),

    Data = <<
        SkillType:8,
        Point:16,
        Skills_Len:16, Bin_Skills/binary
    >>,
    Data.
item_to_bin_4 ({
    SkillId,
    SkillLv
}) ->
    Data = <<
        SkillId:32,
        SkillLv:16
    >>,
    Data.
