-module(pt_424).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42401, _) ->
    {ok, []};
read(42402, Bin0) ->
    <<Chapter:8, _Bin1/binary>> = Bin0, 
    {ok, [Chapter]};
read(42404, Bin0) ->
    <<Chapter:8, Bin1/binary>> = Bin0, 
    <<Stage:8, _Bin2/binary>> = Bin1, 
    {ok, [Chapter, Stage]};
read(_Cmd, _R) -> {error, no_match}.

write (42400,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(42400, Data)};

write (42401,[
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
    {ok, pt:pack(42401, Data)};

write (42402,[
    Chapter,
    Status,
    StageList
]) ->
    BinList_StageList = [
        item_to_bin_2(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        Chapter:8,
        Status:8,
        StageList_Len:16, Bin_StageList/binary
    >>,
    {ok, pt:pack(42402, Data)};

write (42403,[
    List
]) ->
    BinList_List = [
        item_to_bin_3(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(42403, Data)};

write (42404,[
    ErrorCode,
    Chapter,
    Stage
]) ->
    Data = <<
        ErrorCode:32,
        Chapter:8,
        Stage:8
    >>,
    {ok, pt:pack(42404, Data)};

write (42405,[
    Chapter
]) ->
    Data = <<
        Chapter:8
    >>,
    {ok, pt:pack(42405, Data)};

write (42406,[
    Chapter,
    Stage,
    Progress,
    Status
]) ->
    Data = <<
        Chapter:8,
        Stage:8,
        Progress:32,
        Status:8
    >>,
    {ok, pt:pack(42406, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Chapter,
    Status,
    StageList
}) ->
    BinList_StageList = [
        item_to_bin_1(StageList_Item) || StageList_Item <- StageList
    ], 

    StageList_Len = length(StageList), 
    Bin_StageList = list_to_binary(BinList_StageList),

    Data = <<
        Chapter:8,
        Status:8,
        StageList_Len:16, Bin_StageList/binary
    >>,
    Data.
item_to_bin_1 ({
    Stage,
    Progress,
    Status,
    Extra
}) ->
    Bin_Extra = pt:write_string(Extra), 

    Data = <<
        Stage:8,
        Progress:32,
        Status:8,
        Bin_Extra/binary
    >>,
    Data.
item_to_bin_2 ({
    Stage,
    Progress,
    Status,
    Extra
}) ->
    Bin_Extra = pt:write_string(Extra), 

    Data = <<
        Stage:8,
        Progress:32,
        Status:8,
        Bin_Extra/binary
    >>,
    Data.
item_to_bin_3 (
    Chapter
) ->
    Data = <<
        Chapter:8
    >>,
    Data.
