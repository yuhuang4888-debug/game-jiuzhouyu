-module(pt_121).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(12100, Bin0) ->
    <<SceneId:32, _Bin1/binary>> = Bin0, 
    {ok, [SceneId]};
read(12101, Bin0) ->
    <<NpcId:32, _Bin1/binary>> = Bin0, 
    {ok, [NpcId]};
read(12102, Bin0) ->
    <<NpcId:32, Bin1/binary>> = Bin0, 
    <<TaskId:32, _Bin2/binary>> = Bin1, 
    {ok, [NpcId, TaskId]};
read(_Cmd, _R) -> {error, no_match}.

write (12100,[
    SceneId,
    NpcList
]) ->
    BinList_NpcList = [
        item_to_bin_0(NpcList_Item) || NpcList_Item <- NpcList
    ], 

    NpcList_Len = length(NpcList), 
    Bin_NpcList = list_to_binary(BinList_NpcList),

    Data = <<
        SceneId:32,
        NpcList_Len:16, Bin_NpcList/binary
    >>,
    {ok, pt:pack(12100, Data)};

write (12101,[
    NpcId,
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_1(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        NpcId:32,
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(12101, Data)};

write (12102,[
    NpcId,
    TaskId,
    TalkId
]) ->
    Data = <<
        NpcId:32,
        TaskId:32,
        TalkId:32
    >>,
    {ok, pt:pack(12102, Data)};

write (12103,[
    NpcList
]) ->
    BinList_NpcList = [
        item_to_bin_2(NpcList_Item) || NpcList_Item <- NpcList
    ], 

    NpcList_Len = length(NpcList), 
    Bin_NpcList = list_to_binary(BinList_NpcList),

    Data = <<
        NpcList_Len:16, Bin_NpcList/binary
    >>,
    {ok, pt:pack(12103, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    NpcId,
    IsShow,
    SceneId,
    X,
    Y,
    Args
}) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        NpcId:32,
        IsShow:8,
        SceneId:32,
        X:16,
        Y:16,
        Bin_Args/binary
    >>,
    Data.
item_to_bin_1 ({
    TaskId,
    TaskState,
    TaskName,
    TaskType
}) ->
    Bin_TaskName = pt:write_string(TaskName), 

    Data = <<
        TaskId:32,
        TaskState:8,
        Bin_TaskName/binary,
        TaskType:8
    >>,
    Data.
item_to_bin_2 ({
    NpcId,
    IsShow,
    SceneId,
    X,
    Y,
    Args
}) ->
    Bin_Args = pt:write_string(Args), 

    Data = <<
        NpcId:32,
        IsShow:8,
        SceneId:32,
        X:16,
        Y:16,
        Bin_Args/binary
    >>,
    Data.
