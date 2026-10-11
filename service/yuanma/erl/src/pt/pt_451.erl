-module(pt_451).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(45101, _) ->
    {ok, []};
read(45102, _) ->
    {ok, []};
read(45103, Bin0) ->
    <<TaskId:16, _Bin1/binary>> = Bin0, 
    {ok, [TaskId]};
read(45104, _) ->
    {ok, []};
read(45105, Bin0) ->
    <<TaskId:16, _Bin1/binary>> = Bin0, 
    {ok, [TaskId]};
read(45106, _) ->
    {ok, []};
read(45107, _) ->
    {ok, []};
read(45108, Bin0) ->
    <<RightType:8, _Bin1/binary>> = Bin0, 
    {ok, [RightType]};
read(45112, _) ->
    {ok, []};
read(45120, _) ->
    {ok, []};
read(_Cmd, _R) -> {error, no_match}.

write (45101,[
    SupvipType,
    SupvipTime,
    RightList,
    ChargeDay,
    TodayGold,
    IsFreeProtect
]) ->
    BinList_RightList = [
        item_to_bin_0(RightList_Item) || RightList_Item <- RightList
    ], 

    RightList_Len = length(RightList), 
    Bin_RightList = list_to_binary(BinList_RightList),

    Data = <<
        SupvipType:8,
        SupvipTime:32,
        RightList_Len:16, Bin_RightList/binary,
        ChargeDay:8,
        TodayGold:32,
        IsFreeProtect:8
    >>,
    {ok, pt:pack(45101, Data)};

write (45102,[
    Stage,
    SubStage,
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_1(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        Stage:8,
        SubStage:8,
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(45102, Data)};

write (45103,[
    ErrorCode,
    TaskId,
    IsUp
]) ->
    Data = <<
        ErrorCode:32,
        TaskId:16,
        IsUp:8
    >>,
    {ok, pt:pack(45103, Data)};

write (45104,[
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_2(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(45104, Data)};

write (45105,[
    ErrorCode,
    TaskId
]) ->
    Data = <<
        ErrorCode:32,
        TaskId:16
    >>,
    {ok, pt:pack(45105, Data)};

write (45106,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(45106, Data)};

write (45107,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(45107, Data)};

write (45108,[
    ErrorCode,
    RightType
]) ->
    Data = <<
        ErrorCode:32,
        RightType:8
    >>,
    {ok, pt:pack(45108, Data)};

write (45109,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(45109, Data)};

write (45110,[
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_3(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(45110, Data)};

write (45111,[
    TaskList
]) ->
    BinList_TaskList = [
        item_to_bin_4(TaskList_Item) || TaskList_Item <- TaskList
    ], 

    TaskList_Len = length(TaskList), 
    Bin_TaskList = list_to_binary(BinList_TaskList),

    Data = <<
        TaskList_Len:16, Bin_TaskList/binary
    >>,
    {ok, pt:pack(45111, Data)};

write (45112,[
    IsFree
]) ->
    Data = <<
        IsFree:8
    >>,
    {ok, pt:pack(45112, Data)};

write (45120,[
    OpenActId,
    List
]) ->
    BinList_List = [
        item_to_bin_5(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        OpenActId:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(45120, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    RightType,
    DataStr,
    Utime
}) ->
    Bin_DataStr = pt:write_string(DataStr), 

    Data = <<
        RightType:8,
        Bin_DataStr/binary,
        Utime:32
    >>,
    Data.
item_to_bin_1 ({
    TaskId,
    IsFinish,
    IsCommit,
    Content
}) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        TaskId:16,
        IsFinish:8,
        IsCommit:8,
        Bin_Content/binary
    >>,
    Data.
item_to_bin_2 ({
    TaskId,
    IsFinish,
    IsCommit,
    Content
}) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        TaskId:16,
        IsFinish:8,
        IsCommit:8,
        Bin_Content/binary
    >>,
    Data.
item_to_bin_3 ({
    TaskId,
    IsFinish,
    IsCommit,
    Content
}) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        TaskId:16,
        IsFinish:8,
        IsCommit:8,
        Bin_Content/binary
    >>,
    Data.
item_to_bin_4 ({
    TaskId,
    IsFinish,
    IsCommit,
    Content
}) ->
    Bin_Content = pt:write_string(Content), 

    Data = <<
        TaskId:16,
        IsFinish:8,
        IsCommit:8,
        Bin_Content/binary
    >>,
    Data.
item_to_bin_5 ({
    Type,
    ContentList
}) ->
    BinList_ContentList = [
        item_to_bin_6(ContentList_Item) || ContentList_Item <- ContentList
    ], 

    ContentList_Len = length(ContentList), 
    Bin_ContentList = list_to_binary(BinList_ContentList),

    Data = <<
        Type:16,
        ContentList_Len:16, Bin_ContentList/binary
    >>,
    Data.
item_to_bin_6 (
    ContentId
) ->
    Data = <<
        ContentId:8
    >>,
    Data.
