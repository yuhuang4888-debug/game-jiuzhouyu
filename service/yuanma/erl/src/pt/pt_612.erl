-module(pt_612).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(61200, _) ->
    {ok, []};
read(61201, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, Grade]};
read(61202, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, Subtype]};
read(61203, Bin0) ->
    <<Type:16, Bin1/binary>> = Bin0, 
    <<Subtype:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [Type, Subtype, Grade]};
read(_Cmd, _R) -> {error, no_match}.

write (61200,[
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(61200, Data)};

write (61201,[
    Type,
    Subtype,
    Grade,
    Code
]) ->
    Data = <<
        Type:16,
        Subtype:16,
        Grade:16,
        Code:32
    >>,
    {ok, pt:pack(61201, Data)};

write (61202,[
    Type,
    Subtype,
    ActName,
    OpenLv,
    ContinueTime,
    Condition,
    Circuit,
    ClearType
]) ->
    Bin_ActName = pt:write_string(ActName), 

    Bin_Condition = pt:write_string(Condition), 

    Data = <<
        Type:16,
        Subtype:16,
        Bin_ActName/binary,
        OpenLv:16,
        ContinueTime:16,
        Bin_Condition/binary,
        Circuit:8,
        ClearType:8
    >>,
    {ok, pt:pack(61202, Data)};

write (61203,[
    Type,
    Subtype,
    GradeCfg
]) ->
    BinList_GradeCfg = [
        item_to_bin_3(GradeCfg_Item) || GradeCfg_Item <- GradeCfg
    ], 

    GradeCfg_Len = length(GradeCfg), 
    Bin_GradeCfg = list_to_binary(BinList_GradeCfg),

    Data = <<
        Type:16,
        Subtype:16,
        GradeCfg_Len:16, Bin_GradeCfg/binary
    >>,
    {ok, pt:pack(61203, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    Subtype,
    EndTime,
    GradeState,
    OldGradeState,
    ActCondition,
    OpenTimes
}) ->
    BinList_GradeState = [
        item_to_bin_1(GradeState_Item) || GradeState_Item <- GradeState
    ], 

    GradeState_Len = length(GradeState), 
    Bin_GradeState = list_to_binary(BinList_GradeState),

    BinList_OldGradeState = [
        item_to_bin_2(OldGradeState_Item) || OldGradeState_Item <- OldGradeState
    ], 

    OldGradeState_Len = length(OldGradeState), 
    Bin_OldGradeState = list_to_binary(BinList_OldGradeState),

    Bin_ActCondition = pt:write_string(ActCondition), 

    Data = <<
        Type:16,
        Subtype:16,
        EndTime:32,
        GradeState_Len:16, Bin_GradeState/binary,
        OldGradeState_Len:16, Bin_OldGradeState/binary,
        Bin_ActCondition/binary,
        OpenTimes:16
    >>,
    Data.
item_to_bin_1 ({
    Grade,
    State
}) ->
    Data = <<
        Grade:16,
        State:8
    >>,
    Data.
item_to_bin_2 ({
    Grade,
    State
}) ->
    Data = <<
        Grade:16,
        State:8
    >>,
    Data.
item_to_bin_3 ({
    Grade,
    NormalCost,
    Cost,
    Show,
    PageString,
    Reward,
    Condition,
    RechargeId,
    Discount
}) ->
    Bin_NormalCost = pt:write_string(NormalCost), 

    Bin_Cost = pt:write_string(Cost), 

    Bin_Show = pt:write_string(Show), 

    Bin_PageString = pt:write_string(PageString), 

    Bin_Reward = pt:write_string(Reward), 

    Bin_Condition = pt:write_string(Condition), 

    Data = <<
        Grade:16,
        Bin_NormalCost/binary,
        Bin_Cost/binary,
        Bin_Show/binary,
        Bin_PageString/binary,
        Bin_Reward/binary,
        Bin_Condition/binary,
        RechargeId:16,
        Discount:16
    >>,
    Data.
