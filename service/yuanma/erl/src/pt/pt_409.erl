-module(pt_409).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(40900, _) ->
    {ok, []};
read(40901, _) ->
    {ok, []};
read(40902, Bin0) ->
    <<TotalStar:32, _Bin1/binary>> = Bin0, 
    {ok, [TotalStar]};
read(40903, _) ->
    {ok, []};
read(40905, Bin0) ->
    <<Id:32, _Bin1/binary>> = Bin0, 
    {ok, [Id]};
read(40906, _) ->
    {ok, []};
read(40908, _) ->
    {ok, []};
read(40909, Bin0) ->
    <<Category:16, _Bin1/binary>> = Bin0, 
    {ok, [Category]};
read(_Cmd, _R) -> {error, no_match}.

write (40900,[
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
    {ok, pt:pack(40900, Data)};

write (40901,[
    CurStage,
    RewardList,
    NewCurStage
]) ->
    BinList_RewardList = [
        item_to_bin_1(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        CurStage:8,
        RewardList_Len:16, Bin_RewardList/binary,
        NewCurStage:16
    >>,
    {ok, pt:pack(40901, Data)};

write (40902,[
    CurStage,
    Resoult,
    Errcode,
    NewCurStage
]) ->
    Data = <<
        CurStage:8,
        Resoult:8,
        Errcode:32,
        NewCurStage:16
    >>,
    {ok, pt:pack(40902, Data)};

write (40903,[
    List
]) ->
    BinList_List = [
        item_to_bin_2(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40903, Data)};

write (40904,[
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
    {ok, pt:pack(40904, Data)};

write (40905,[
    Resoult,
    Errcode
]) ->
    Data = <<
        Resoult:8,
        Errcode:32
    >>,
    {ok, pt:pack(40905, Data)};

write (40906,[
    Star
]) ->
    Data = <<
        Star:32
    >>,
    {ok, pt:pack(40906, Data)};

write (40907,[
    RewardList,
    CurStage,
    NewCurStage
]) ->
    BinList_RewardList = [
        item_to_bin_4(RewardList_Item) || RewardList_Item <- RewardList
    ], 

    RewardList_Len = length(RewardList), 
    Bin_RewardList = list_to_binary(BinList_RewardList),

    Data = <<
        RewardList_Len:16, Bin_RewardList/binary,
        CurStage:8,
        NewCurStage:16
    >>,
    {ok, pt:pack(40907, Data)};

write (40908,[
    List
]) ->
    BinList_List = [
        item_to_bin_5(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40908, Data)};

write (40909,[
    Category,
    List
]) ->
    BinList_List = [
        item_to_bin_6(List_Item) || List_Item <- List
    ], 

    List_Len = length(List), 
    Bin_List = list_to_binary(BinList_List),

    Data = <<
        Category:8,
        List_Len:16, Bin_List/binary
    >>,
    {ok, pt:pack(40909, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 (
    Id
) ->
    Data = <<
        Id:32
    >>,
    Data.
item_to_bin_1 ({
    NeedStar,
    Status
}) ->
    Data = <<
        NeedStar:32,
        Status:8
    >>,
    Data.
item_to_bin_2 ({
    Category,
    Id,
    Progress,
    Status
}) ->
    Data = <<
        Category:8,
        Id:32,
        Progress:64,
        Status:8
    >>,
    Data.
item_to_bin_3 ({
    Id,
    Status,
    Progress
}) ->
    Data = <<
        Id:32,
        Status:8,
        Progress:64
    >>,
    Data.
item_to_bin_4 ({
    NeedStar,
    Status
}) ->
    Data = <<
        NeedStar:32,
        Status:8
    >>,
    Data.
item_to_bin_5 ({
    Type,
    TotalStar,
    NowStar
}) ->
    Data = <<
        Type:16,
        TotalStar:32,
        NowStar:32
    >>,
    Data.
item_to_bin_6 ({
    Id,
    Progress,
    Status
}) ->
    Data = <<
        Id:32,
        Progress:64,
        Status:8
    >>,
    Data.
