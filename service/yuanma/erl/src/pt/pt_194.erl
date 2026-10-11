-module(pt_194).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(19401, _) ->
    {ok, []};
read(19402, Bin0) ->
    <<Lv:16, _Bin1/binary>> = Bin0, 
    {ok, [Lv]};
read(19403, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(19404, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0, 
    <<TaskId:16, _Bin2/binary>> = Bin1, 
    {ok, [Type, TaskId]};
read(19405, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0, 
    {ok, [Type]};
read(_Cmd, _R) -> {error, no_match}.

write (19400,[
    Code,
    Args
]) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        Code:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(19400, Data)};

write (19401,[
    Uid,
    ActId,
    Type,
    Lv,
    Exp,
    ExpiredTime,
    RewardList
]) ->
    BinList_RewardList = [
        item_to_bin_0(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        Uid:16,
        ActId:8,
        Type:8,
        Lv:16,
        Exp:32,
        ExpiredTime:32,
        RewardList_Len:16, Bin_RewardList/binary
    >>,
    {ok, pt:pack(19401, Data)};

write (19402,[
    RewardList
]) ->
    Bin_RewardList = pt:write_object_list(RewardList), 

    Data = <<
        Bin_RewardList/binary
    >>,
    {ok, pt:pack(19402, Data)};

write (19403,[
    TypeList
]) ->
    BinList_TypeList = [
        item_to_bin_1(TypeList_Item) || TypeList_Item <- TypeList
    ], 

    TypeList_Len = length(TypeList), 
    Bin_TypeList = list_to_binary(BinList_TypeList),

    Data = <<
        TypeList_Len:16, Bin_TypeList/binary
    >>,
    {ok, pt:pack(19403, Data)};

write (19404,[
    Exp
]) ->
    Data = <<
        Exp:32
    >>,
    {ok, pt:pack(19404, Data)};



write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Lv,
    Status1,
    Status2
}) ->
    Data = <<
        Lv:16,
        Status1:8,
        Status2:8
    >>,
    Data.
item_to_bin_1 ({
    Type,
    TaskList,
    RefreshTime
}) ->
    BinList_TaskList = [
        item_to_bin_2(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        Type:8,
        TaskList_Len:16, Bin_TaskList/binary,
        RefreshTime:32
    >>,
    Data.
item_to_bin_2 ({
    TaskId,
    FinishTimes,
    CurNum,
    Status
}) ->
    Data = <<
        TaskId:16,
        FinishTimes:8,
        CurNum:32,
        Status:8
    >>,
    Data.
