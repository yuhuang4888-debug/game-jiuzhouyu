-module(pt_192).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(19201, _) ->
    {ok, []};
read(19202, Bin0) ->
    <<ModuleId:16, Bin1/binary>> = Bin0, 
    <<SubModule:16, _Bin2/binary>> = Bin1, 
    {ok, [ModuleId, SubModule]};
read(19203, Bin0) ->
    <<ModuleId:16, Bin1/binary>> = Bin0, 
    <<SubModule:16, _Bin2/binary>> = Bin1, 
    {ok, [ModuleId, SubModule]};
read(19204, Bin0) ->
    <<ModuleId:16, Bin1/binary>> = Bin0, 
    <<SubModule:16, Bin2/binary>> = Bin1, 
    <<BehaviourId:16, Bin3/binary>> = Bin2, 
    <<Times:16, _Bin4/binary>> = Bin3, 
    {ok, [ModuleId, SubModule, BehaviourId, Times]};
read(19205, Bin0) ->
    <<ModuleId:16, Bin1/binary>> = Bin0, 
    <<SubModule:16, Bin2/binary>> = Bin1, 
    <<BehaviourId:16, _Bin3/binary>> = Bin2, 
    {ok, [ModuleId, SubModule, BehaviourId]};
read(19206, _) ->
    {ok, []};
read(19207, Bin0) ->
    <<ExchangeOnhookCoin:32, _Bin1/binary>> = Bin0, 
    {ok, [ExchangeOnhookCoin]};
read(_Cmd, _R) -> {error, no_match}.

write (19201,[
    DayCoin,
    OnhookCoin,
    ActivityList
]) ->
    BinList_ActivityList = [
        item_to_bin_0(ActivityList_Item) || ActivityList_Item <- ActivityList
    ], 

    ActivityList_Len = length(ActivityList), 
    Bin_ActivityList = list_to_binary(BinList_ActivityList),

    Data = <<
        DayCoin:32,
        OnhookCoin:32,
        ActivityList_Len:16, Bin_ActivityList/binary
    >>,
    {ok, pt:pack(19201, Data)};

write (19202,[
    Code,
    ModuleId,
    SubModule
]) ->
    Data = <<
        Code:32,
        ModuleId:16,
        SubModule:16
    >>,
    {ok, pt:pack(19202, Data)};

write (19203,[
    Code,
    ModuleId,
    SubModule
]) ->
    Data = <<
        Code:32,
        ModuleId:16,
        SubModule:16
    >>,
    {ok, pt:pack(19203, Data)};

write (19204,[
    Code,
    ModuleId,
    SubModule,
    BehaviourId,
    Times
]) ->
    Data = <<
        Code:32,
        ModuleId:16,
        SubModule:16,
        BehaviourId:16,
        Times:16
    >>,
    {ok, pt:pack(19204, Data)};

write (19205,[
    Code,
    ModuleId,
    SubModule,
    BehaviourId
]) ->
    Data = <<
        Code:32,
        ModuleId:16,
        SubModule:16,
        BehaviourId:16
    >>,
    {ok, pt:pack(19205, Data)};

write (19206,[
    RecordList
]) ->
    BinList_RecordList = [
        item_to_bin_2(RecordList_Item) || RecordList_Item <- RecordList
    ], 

    RecordList_Len = length(RecordList), 
    Bin_RecordList = list_to_binary(BinList_RecordList),

    Data = <<
        RecordList_Len:16, Bin_RecordList/binary
    >>,
    {ok, pt:pack(19206, Data)};

write (19207,[
    Code,
    OnhookCoin,
    Bgold
]) ->
    Data = <<
        Code:32,
        OnhookCoin:32,
        Bgold:32
    >>,
    {ok, pt:pack(19207, Data)};

write (19208,[
    DayCoin,
    OnhookCoin
]) ->
    Data = <<
        DayCoin:32,
        OnhookCoin:32
    >>,
    {ok, pt:pack(19208, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    ModuleId,
    SubModule,
    SelectTime,
    BehaviourList
}) ->
    BinList_BehaviourList = [
        item_to_bin_1(BehaviourList_Item) || BehaviourList_Item <- BehaviourList
    ], 

    BehaviourList_Len = length(BehaviourList), 
    Bin_BehaviourList = list_to_binary(BinList_BehaviourList),

    Data = <<
        ModuleId:16,
        SubModule:16,
        SelectTime:32,
        BehaviourList_Len:16, Bin_BehaviourList/binary
    >>,
    Data.
item_to_bin_1 ({
    BehaviourId,
    BSelectTime,
    Times
}) ->
    Data = <<
        BehaviourId:16,
        BSelectTime:32,
        Times:16
    >>,
    Data.
item_to_bin_2 ({
    ModuleId,
    SubModule,
    OnhookTime,
    Result,
    CostCoin,
    Time
}) ->
    Data = <<
        ModuleId:16,
        SubModule:16,
        OnhookTime:32,
        Result:32,
        CostCoin:16,
        Time:32
    >>,
    Data.
