-module(pt_226).
-include("common.hrl").
-export([
    read/2,
    write/2
]).

read(22601, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0,
    {ok, [SubType]};
read(22602, Bin0) ->
    <<SubType:16, _Bin1/binary>> = Bin0,
    {ok, [SubType]};
read(22603, Bin0) ->
    <<SubType:16, Bin1/binary>> = Bin0,
    <<StageId:8, _Bin2/binary>> = Bin1,
    {ok, [SubType, StageId]};
read(_Cmd, _R) -> {error, no_match}.

write (22600,[
    ErrorCode
]) ->
    Data = <<
        ErrorCode:32
    >>,
    {ok, pt:pack(22600, Data)};

write (22601,[
    SubType,
    SelRank,
    SelVal,
    RankList
]) ->
    BinList_RankList = [
        item_to_bin_0(RankList_Item) || RankList_Item <- RankList
    ],
    
    RankList_Len = length(RankList),
    Bin_RankList = list_to_binary(BinList_RankList),
    
    Data = <<
        SubType:16,
        SelRank:32,
        SelVal:64,
        RankList_Len:16, Bin_RankList/binary
    >>,
    {ok, pt:pack(22601, Data)};

write (22602,[
    SubType,
    GoalList
]) ->
    BinList_GoalList = [
        item_to_bin_1(GoalList_Item) || GoalList_Item <- GoalList
    ],
    
    GoalList_Len = length(GoalList),
    Bin_GoalList = list_to_binary(BinList_GoalList),
    
    Data = <<
        SubType:32,
        GoalList_Len:16, Bin_GoalList/binary
    >>,
    {ok, pt:pack(22602, Data)};

write (22603,[
    Code,
    SubType,
    StageId,
    Reward
]) ->
    Bin_Reward = pt:write_object_list(Reward),
    
    Data = <<
        Code:32,
        SubType:16,
        StageId:8,
        Bin_Reward/binary
    >>,
    {ok, pt:pack(22603, Data)};

write(_Cmd, _R) -> ?DEBUG("no_match:~p,~p~n", [_Cmd, _R]), {ok, pt:pack(0, <<>>)}.


item_to_bin_0 ({
    PlayerId,
    Name,
    FirstValue,
    Rank
}) ->
    Bin_Name = pt:write_string(Name),
    
    Data = <<
        PlayerId:64,
        Bin_Name/binary,
        FirstValue:64,
        Rank:32
    >>,
    Data.
item_to_bin_1 ({
    StageId,
    MyPower,
    Power,
    Status
}) ->
    Data = <<
        StageId:8,
        MyPower:64,
        Power:64,
        Status:8
    >>,
    Data.
