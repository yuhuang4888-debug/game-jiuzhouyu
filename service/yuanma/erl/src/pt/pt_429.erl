-module(pt_429).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42900, _) ->
    {ok, []};
read(42901, _) ->
    {ok, []};
read(42902, Bin0) ->
    <<Chapter:16, _Bin1/binary>> = Bin0, 
    {ok, [Chapter]};
read(42906, Bin0) ->
    <<Chapter:16, _Bin1/binary>> = Bin0, 
    {ok, [Chapter]};
read(42907, Bin0) ->
    <<Chapter:16, Bin1/binary>> = Bin0, 
    <<SubChapter:16, Bin2/binary>> = Bin1, 
    <<Stage:16, _Bin3/binary>> = Bin2, 
    {ok, [Chapter, SubChapter, Stage]};
read(42908, Bin0) ->
    <<Chapter:16, Bin1/binary>> = Bin0, 
    <<IsWear:8, _Bin2/binary>> = Bin1, 
    {ok, [Chapter, IsWear]};
read(42909, _) ->
    {ok, []};
read(42910, Bin0) ->
    <<IsEnter:8, Bin1/binary>> = Bin0, 
    <<SceneId:32, Bin2/binary>> = Bin1, 
    <<X:32, Bin3/binary>> = Bin2, 
    <<Y:32, _Bin4/binary>> = Bin3, 
    {ok, [IsEnter, SceneId, X, Y]};
read(_Cmd, _R) -> {error, no_match}.

write (42900,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(42900, Data)};

write (42901,[
    TaskComplete,
    List
]) ->
    BinList_List = [
        item_to_bin_0(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        TaskComplete:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(42901, Data)};

write (42902,[
    Chapter,
    Status,
    SubList
]) ->
    BinList_SubList = [
        item_to_bin_3(SubList_Item) || SubList_Item <- SubList
    ], 

    SubList_Len = length(SubList), 
    Bin_SubList = list_to_binary(BinList_SubList),

    Data = <<
        Chapter:16,
        Status:8,
        SubList_Len:16, Bin_SubList/binary
    >>,
    {ok, pt:pack(42902, Data)};

write (42903,[
    Chapter,
    Status
]) ->
    Data = <<
        Chapter:16,
        Status:8
    >>,
    {ok, pt:pack(42903, Data)};

write (42904,[
    Chapter,
    SubChapter,
    SubStatus
]) ->
    Data = <<
        Chapter:16,
        SubChapter:16,
        SubStatus:8
    >>,
    {ok, pt:pack(42904, Data)};

write (42905,[
    Chapter,
    SubChapter,
    Stage,
    Process,
    StageStatus
]) ->
    Data = <<
        Chapter:16,
        SubChapter:16,
        Stage:16,
        Process:64,
        StageStatus:8
    >>,
    {ok, pt:pack(42905, Data)};

write (42906,[
    ErrorCode,
    Chapter
]) ->
    Data = <<
        ErrorCode:32,
        Chapter:16
    >>,
    {ok, pt:pack(42906, Data)};

write (42907,[
    ErrorCode,
    Chapter,
    SubChapter,
    Stage
]) ->
    Data = <<
        ErrorCode:32,
        Chapter:16,
        SubChapter:16,
        Stage:16
    >>,
    {ok, pt:pack(42907, Data)};

write (42908,[
    Errcode,
    Chapter,
    IsWear
]) ->
    Data = <<
        Errcode:32,
        Chapter:16,
        IsWear:8
    >>,
    {ok, pt:pack(42908, Data)};

write (42909,[
    IsFinish
]) ->
    Data = <<
        IsFinish:8
    >>,
    {ok, pt:pack(42909, Data)};

write (42910,[
]) ->
    Data = <<
    >>,
    {ok, pt:pack(42910, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Chapter,
    Status,
    IsWear,
    SubList
}) ->
    BinList_SubList = [
        item_to_bin_1(SubList_Item) || SubList_Item <- SubList
    ], 

    SubList_Len = length(SubList), 
    Bin_SubList = list_to_binary(BinList_SubList),

    Data = <<
        Chapter:16,
        Status:8,
        IsWear:8,
        SubList_Len:16, Bin_SubList/binary
    >>,
    Data.
item_to_bin_1 ({
    SubChapter,
    SubStatus,
    StageList
}) ->
    BinList_StageList = [
        item_to_bin_2(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        SubChapter:16,
        SubStatus:8,
        StageList_Len:16, Bin_StageList/binary
    >>,
    Data.
item_to_bin_2 ({
    Stage,
    Status,
    Process
}) ->
    Data = <<
        Stage:16,
        Status:8,
        Process:64
    >>,
    Data.
item_to_bin_3 ({
    SubChapter,
    SubStatus,
    StageList
}) ->
    BinList_StageList = [
        item_to_bin_4(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        SubChapter:16,
        SubStatus:8,
        StageList_Len:16, Bin_StageList/binary
    >>,
    Data.
item_to_bin_4 ({
    Stage,
    Status,
    Process
}) ->
    Data = <<
        Stage:16,
        Status:8,
        Process:64
    >>,
    Data.
