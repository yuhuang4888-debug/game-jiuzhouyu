-module(pt_425).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(42501, _) ->
    {ok, []};
read(42502, Bin0) ->
    <<Type:8, _Bin1/binary>> = Bin0,
    {ok, [Type]};
read(42503, Bin0) ->
    <<Type:8, Bin1/binary>> = Bin0,
    <<Subtype:8, _Bin2/binary>> = Bin1,
    {ok, [Type, Subtype]};
read(_Cmd, _R) -> {error, no_match}.

write (42500,[
    ErrorCode,
    Args
]) ->
    Bin_Args = pt:write_string(Args),

    Data = <<
        ErrorCode:32,
        Bin_Args/binary
    >>,
    {ok, pt:pack(42500, Data)};

write (42501,[
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
    {ok, pt:pack(42501, Data)};

write (42502,[
    Type,
    BookList
]) ->
    BinList_BookList = [
        item_to_bin_1(BookList_Item) || BookList_Item <- BookList
    ],

    BookList_Len = length(BookList),
    Bin_BookList = list_to_binary(BinList_BookList),

    Data = <<
        Type:8,
        BookList_Len:16, Bin_BookList/binary
    >>,
    {ok, pt:pack(42502, Data)};

write (42503,[
    ErrorCode,
    Type,
    Subtype
]) ->
    Data = <<
        ErrorCode:32,
        Type:8,
        Subtype:8
    >>,
    {ok, pt:pack(42503, Data)};

write (42504,[
    UpdateList
]) ->
    BinList_UpdateList = [
        item_to_bin_2(UpdateList_Item) || UpdateList_Item <- UpdateList
    ],

    UpdateList_Len = length(UpdateList),
    Bin_UpdateList = list_to_binary(BinList_UpdateList),

    Data = <<
        UpdateList_Len:16, Bin_UpdateList/binary
    >>,

    {ok, pt:pack(42504, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    Type,
    Subtype
}) ->
    Data = <<
        Type:8,
        Subtype:8
    >>,
    Data.
item_to_bin_1 ({
    Subtype,
    Progress,
    Status
}) ->
    Data = <<
        Subtype:8,
        Progress:32,
        Status:8
    >>,
    Data.
item_to_bin_2 ({
    Type,
    Subtype,
    Progress,
    Status
}) ->
    Data = <<
        Type:8,
        Subtype:8,
        Progress:32,
        Status:8
    >>,
    Data.
