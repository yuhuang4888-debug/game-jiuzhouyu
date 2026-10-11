-module(pt_333).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(33300, _) ->
    {ok, []};
read(33302, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33303, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, _Bin2/binary>> = Bin1, 
    {ok, [BaseType, SubType]};
read(33304, Bin0) ->
    <<BaseType:16, Bin1/binary>> = Bin0, 
    <<SubType:16, Bin2/binary>> = Bin1, 
    <<Grade:16, _Bin3/binary>> = Bin2, 
    {ok, [BaseType, SubType, Grade]};
read(_Cmd, _R) -> {error, no_match}.

write (33300,[
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
    {ok, pt:pack(33300, Data)};

write (33302,[
    BaseType,
    SubType,
    SumPoints,
    ModList
]) ->
    BinList_ModList = [
        item_to_bin_1(ModList_Item) || ModList_Item <- ModList
    ], 

    ModList_Len = length(ModList), 
    Bin_ModList = list_to_binary(BinList_ModList),

    Data = <<
        BaseType:16,
        SubType:16,
        SumPoints:32,
        ModList_Len:16, Bin_ModList/binary
    >>,
    {ok, pt:pack(33302, Data)};

write (33303,[
    BaseType,
    SubType,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_2(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        BaseType:16,
        SubType:16,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(33303, Data)};

write (33304,[
    BaseType,
    SubType,
    Grade
]) ->
    Data = <<
        BaseType:16,
        SubType:16,
        Grade:16
    >>,
    {ok, pt:pack(33304, Data)};

write (33305,[
    BaseType,
    SubType,
    SumPoints,
    ModList
]) ->
    BinList_ModList = [
        item_to_bin_3(ModList_Item) || ModList_Item <- ModList
    ], 

    ModList_Len = length(ModList), 
    Bin_ModList = list_to_binary(BinList_ModList),

    Data = <<
        BaseType:16,
        SubType:16,
        SumPoints:32,
        ModList_Len:16, Bin_ModList/binary
    >>,
    {ok, pt:pack(33305, Data)};

write (33306,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(33306, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    BaseType,
    SubType,
    Name,
    Stime,
    Etime,
    ShowId
}) ->
    Bin_Name = pt:write_string(Name), 

    Data = <<
        BaseType:16,
        SubType:16,
        Bin_Name/binary,
        Stime:32,
        Etime:32,
        ShowId:32
    >>,
    Data.
item_to_bin_1 ({
    ModId,
    SubId,
    ConditionType,
    Name,
    OrderId,
    JumpId,
    SecValue,
    IconType,
    ProValue,
    IsPro,
    CondiVal,
    RewardPoint,
    Dec,
    IsCom
}) ->
    Bin_ConditionType = pt:write_string(ConditionType), 

    Bin_Name = pt:write_string(Name), 

    Bin_IconType = pt:write_string(IconType), 

    Bin_Dec = pt:write_string(Dec), 

    Data = <<
        ModId:32,
        SubId:32,
        Bin_ConditionType/binary,
        Bin_Name/binary,
        OrderId:16,
        JumpId:16,
        SecValue:32,
        Bin_IconType/binary,
        ProValue:64,
        IsPro:16,
        CondiVal:32,
        RewardPoint:32,
        Bin_Dec/binary,
        IsCom:16
    >>,
    Data.
item_to_bin_2 ({
    Grade,
    FormType,
    Status,
    ReceiveTimes,
    Name,
    Desc,
    Condition,
    Reward
}) ->
    Bin_Name = pt:write_string(Name), 

    Bin_Desc = pt:write_string(Desc), 

    Bin_Condition = pt:write_string(Condition), 

    Bin_Reward = pt:write_string(Reward), 

    Data = <<
        Grade:16,
        FormType:8,
        Status:8,
        ReceiveTimes:16,
        Bin_Name/binary,
        Bin_Desc/binary,
        Bin_Condition/binary,
        Bin_Reward/binary
    >>,
    Data.
item_to_bin_3 ({
    ModId,
    SubId,
    ConditionType,
    Name,
    ProValue,
    IsCom
}) ->
    Bin_ConditionType = pt:write_string(ConditionType), 

    Bin_Name = pt:write_string(Name), 

    Data = <<
        ModId:32,
        SubId:32,
        Bin_ConditionType/binary,
        Bin_Name/binary,
        ProValue:64,
        IsCom:16
    >>,
    Data.
